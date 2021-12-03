wm_gunslinger = {
	__stack = {},
	__guns = {},
	__types = {},
	__automatic = {},
	__scopes = {},
	__interval = {},
}

local config = {
	max_wear = 65530,
	wear = 64,
	projectile_speed = 500,
	base_dmg = 1,
	base_spread = 0.001,
	base_spread_mob = 0.003,
	base_recoil = 0.001,
	lite = minetest.settings:get_bool("wm_gunslinger.lite")
}

--
-- Internal API functions
--

local function rangelim(low, val, high)
	return math.max(low, math.min(val, high))
end

local function get_eye_pos(player)
	if not player then
		return
	end

	local pos = player:get_pos()
	pos.y = pos.y + player:get_properties().eye_height
	return pos
end

local function get_pointed_thing(pos, dir, def)
	if not pos or not dir or not def then
		error("wm_gunslinger: Invalid get_pointed_thing invocation" ..
		        " (missing params)", 2)
	end

	local pos2 = vector.add(pos, vector.multiply(dir, def.range))
	local ray = minetest.raycast(pos, pos2, true, true)
	return ray:next()
end

local function play_sound(sound, player)
	minetest.sound_play(sound, {
		object = player,
		max_hear_distance = 100,
		loop = false
	})
end

local function add_auto(name, def, stack)
	wm_gunslinger.__automatic[name] = {
		def   = def,
		stack = stack
	}
end

--------------------------------

local function show_scope(player, scope, zoom)
	if not player then
		return
	end

	-- Create HUD overlay element
	wm_gunslinger.__scopes[player:get_player_name()] = player:hud_add({
		hud_elem_type = "image",
		position = {x = 0.5, y = 0.5},
		alignment = {x = 0, y = 0},
		text = scope
	})
end

local function hide_scope(player)
	if not player then
		return
	end

	local name = player:get_player_name()
	player:hud_remove(wm_gunslinger.__scopes[name])
	wm_gunslinger.__scopes[name] = nil
end


--------------------------------
--special rounds
local function explosive(point, def)
	--local point = pointed.intersection_normal
	tnt.boom(point, {damage_radius= def.dmg_radius, radius= def.boom_radius, ignore_protection=false})
	minetest.sound_play("wm_gunslinger_explode",	{pos = point, gain = 1, max_hear_distance = 60, loop = false})
end

--
local function incendiary(point, def)
	if minetest.get_node(point).name == "air" then
		minetest.set_node(point, {name = "fire:basic_flame"})
	end
	local r = def.dmg_radius

	for i=0, def.fire_count,1 do
		local ranpos = {x = point.x + math.random(-r,r), y = point.y + math.random(-r,r), z = point.z + math.random(-r,r)}
		if minetest.get_node(ranpos).name == "air" then
			minetest.set_node(ranpos,{name = "fire:basic_flame"})
			minetest.sound_play("wm_gunslinger_flamethrower",	{pos =point, gain = 0.5, max_hear_distance = 60, loop = false})
		end

	end
end


--------------------------------
local function visuals(pos1, def, dir, config)
	-- Projectile particle
	minetest.add_particle({
		texture = def.bullet,
		pos = pos1,
		velocity = vector.multiply(dir, config.projectile_speed),
		acceleration = {x = 0, y = 0, z = 0},
		expirationtime = 3,
		size = 1,
		collisiondetection = true,
		collision_removal = true,
		object_collision = true,
		glow = 10,
	})
	--muzzle flash
	minetest.add_particle({
		texture = "wm_gunslinger_flash.png",
		pos = pos1,
		velocity = 0,
		acceleration = {x = 0, y = 0, z = 0},
		expirationtime = 0.02,
		size = 2,
		collisiondetection = false,
		collision_removal = false,
		object_collision = false,
		glow = 10,
	})

end

--------------------------------

local function fire(stack, player)
	if not stack then
		return
	end

	local def = wm_gunslinger.__guns[stack:get_name()]
	if not def then
		return stack
	end

	--Check has energy
	local inv = player:get_inventory()
	local pname = player:get_player_name()
	local ammo = inv:contains_item("main", def.ammo)
	--player has energy
	if ammo then
		--is it in the correct slot
		local ammo_slot = inv:get_stack("main", 8)
		local slot_name = ammo_slot:get_name()
		--has active power module
		if slot_name == def.ammo then
			local wear = ammo_slot:get_wear() + (def.efficiency + config.wear)
			if wear > config.max_wear then
				--no power...fail
				minetest.chat_send_player(pname, minetest.colorize("#cc0000", "POWER DEPLETED!"))
				play_sound(def.sounds.ooa, player)
				return stack
			else
				-- Update wear to energy module (ammo)..by replacing with worn
				local ammo_item = ItemStack(slot_name)
				ammo_item:set_wear(wear)
				inv:set_stack("main", 8, ammo_item)
				--minetest.chat_send_player(pname, minetest.colorize("#cc0000", "Power level= "..(config.max_wear - wear)))
			end
		else
			--not in right place
			--no power...fail...
			minetest.chat_send_player(pname, minetest.colorize("#cc0000", "POWER MODULE NOT INSERTED (SLOT 8)!"))
			play_sound(def.sounds.ooa, player)
			return stack
		end
	else
		--don't even have any ammo..
		minetest.chat_send_player(pname, minetest.colorize("#cc0000", "MISSING POWER MODULE!"))
		play_sound(def.sounds.ooa, player)
		return stack
	end

	-- Play gunshot sound
	play_sound(def.sounds.fire, player)

	--[[
		Perform "deferred raycasting" to mimic projectile entities, without
		actually using entities:
			- Perform initial raycast to get position of target if it exists
			- Calculate time taken for projectile to travel from gun to target
			- Perform actual raycast after the calculated time

		This process throws in a couple more calculations and an extra raycast,
		but the vastly improved realism at the cost of a negligible performance
		hit is always great to have.
	]]
	local time = 0.1 -- Default to 0.1s

	local dir = player:get_look_dir()

	local pos1 = get_eye_pos(player)
	pos1 = vector.add(pos1, dir)
	local initial_pthing = get_pointed_thing(pos1, dir, def)
	if initial_pthing then
		local pos2 = minetest.get_pointed_thing_position(initial_pthing)
		time = vector.distance(pos1, pos2) / config.projectile_speed
	end

	local random = PcgRandom(os.time())

	for i = 1, def.pellets do
		-- Mimic inaccuracy by applying randomised miniscule deviations
		if def.spread_mult ~= 0 then
			dir = vector.apply(dir, function(n)
				return n + random:next(-def.spread_mult, def.spread_mult) * config.base_spread
			end)
		end

		minetest.after(time, function(obj, pos, look_dir, gun_def)
			local pointed = get_pointed_thing(pos, look_dir, gun_def)

			if pointed and pointed.type == "object" then
				local target = pointed.ref
				--limit what types if can kill..make sure mobs armors are in here
				--tricky excluding blocks, but getting all types of mob
				--simply wont work for some people's mobs because they havn't used armor groups
				if target:get_player_name() ~= obj:get_player_name()
				and (target:get_armor_groups().fleshy ~= nil)
				then
					local point = pointed.intersection_point
					local dmg = config.base_dmg * gun_def.dmg_mult

					-- Add 20% more damage if player using scope
					if wm_gunslinger.__scopes[obj:get_player_name()] then
						dmg = dmg * 1.2
					end

					target:punch(obj, nil, {damage_groups = {fleshy = dmg}})

					--special rounds
					if def.round == "explosive" then
						explosive(point, def)
					elseif def.round == "incendiary" then
						incendiary(point, def)
					end
				end

			--not an object, hit a node
			elseif pointed and pointed.type == "node" then
				local point = pointed.intersection_point
				local node = minetest.get_node(point).name

				--minetest.get_item_group(newplace_create.name, "water") == 1

				--solid...add anything that needs to be shot through
				if node ~= "air" and node ~= "fire:basic_flame" then
					--minetest.chat_send_player(pname, minetest.colorize("#cc0000", "W NODE!"))
					if def.round == "explosive" then
						explosive(point, def)
					elseif def.round == "incendiary" then
						incendiary(point, def)
					else
						minetest.sound_play(def.ricochet,	{pos =point, gain = 1, max_hear_distance = 50, loop = false})
					end
				end
			end
		end, player, pos1, dir, def)

		--muzzle flash, bullet
		visuals(pos1, def, dir, config)

	end

	-- Simulate recoil
	local offset = config.base_recoil * def.recoil_mult
	local look_vertical = player:get_look_vertical() - offset
	look_vertical = rangelim(-math.pi / 2, look_vertical, math.pi / 2)
	player:set_look_vertical(look_vertical)

	return stack
end



-----------------------
--For use by mobs
--rate of fire controlled by the mob rather than here
wm_gunslinger.mob_fire = function(def,object, p1, p2)
	if not def or not object then
		return
	end


	--[[
		Perform "deferred raycasting" to mimic projectile entities, without
		actually using entities:
			- Perform initial raycast to get position of target if it exists
			- Calculate time taken for projectile to travel from gun to target
			- Perform actual raycast after the calculated time

		This process throws in a couple more calculations and an extra raycast,
		but the vastly improved realism at the cost of a negligible performance
		hit is always great to have.
	]]
	local time = 0.1 -- Default to 0.1s


	local dir = vector.direction(p1, p2)

	local pos1 = p1 --

	pos1 = vector.add(pos1, dir)
	local initial_pthing = get_pointed_thing(pos1, dir, def)
	if initial_pthing then
		local pos2 = minetest.get_pointed_thing_position(initial_pthing)
		time = vector.distance(pos1, pos2) / config.projectile_speed
	end

	local random = PcgRandom(os.time())

	for i = 1, def.pellets do
		-- Mimic inaccuracy by applying randomised miniscule deviations
		--mobs get extra innaccuracy... to make up for otherwise perfect aim.??
		if def.spread_mult ~= 0 then
			dir = vector.apply(dir, function(n)
				return n + random:next(-def.spread_mult, def.spread_mult) * (config.base_spread_mob)
			end)
		end

		-- Play gunshot sound
		minetest.sound_play(def.sounds.fire, {
			pos = pos1,
			 max_hear_distance = 100,
			loop = false
		})

		minetest.after(time, function(obj, pos, look_dir, gun_def)
			local pointed = get_pointed_thing(pos, look_dir, gun_def)

			if pointed and pointed.type == "object" then
				--not applying limits to what it shots
				local target = pointed.ref
				local point = pointed.intersection_point
				local dmg = config.base_dmg * gun_def.dmg_mult

				target:punch(obj.object, nil, {damage_groups = {fleshy = dmg}})


				--special rounds
				if def.round == "explosive" then
					explosive(point, def)
				elseif def.round == "incendiary" then
					incendiary(point, def)
				end



			--not an object, hit a node
			elseif pointed and pointed.type == "node" then
				local point = pointed.intersection_point
				local node = minetest.get_node(point).name

				--minetest.get_item_group(newplace_create.name, "water") == 1

				--solid...add anything that needs to be shot through
				if node ~= "air" and node ~= "fire:basic_flame" then
					--minetest.chat_send_player(pname, minetest.colorize("#cc0000", "W NODE!"))
					if def.round == "explosive" then
						explosive(point, def)
					elseif def.round == "incendiary" then
						incendiary(point, def)
					else
						minetest.sound_play(def.ricochet,	{pos =point, gain = 1, max_hear_distance = 50, loop = false})
					end
				end
			end
		end, object, pos1, dir, def)


		--muzzle flash, bullet
		visuals(pos1, def, dir, config)

	end

	return
end





--------------------------------
local function burst_fire(stack, player)
	local def = wm_gunslinger.__guns[stack:get_name()]
	for i = 1, def.burst do
		minetest.after(i / def.fire_rate, function(stack, player)
			-- Use global var to store stack, because the stack
			-- can't be directly accessed outside minetest.after
			wm_gunslinger.__stack[arg[2]:get_player_name()] = fire(arg[1], arg[2])
		end, stack, player)
	end

	return wm_gunslinger.__stack[player:get_player_name()]
end

--------------------------------
--Use gun
local function on_lclick(stack, player)
	if not stack or not player then
		return
	end

	local def = wm_gunslinger.__guns[stack:get_name()]
	if not def then
		return
	end

	local name = player:get_player_name()
	if wm_gunslinger.__interval[name] and wm_gunslinger.__interval[name] < def.unit_time then
		return
	end
	wm_gunslinger.__interval[name] = 0

	if def.mode == "automatic" and not wm_gunslinger.__automatic[name] then
		stack = fire(stack, player)
		add_auto(name, def, stack)
	elseif def.mode == "hybrid"
			and not wm_gunslinger.__automatic[name] then
		if wm_gunslinger.__scopes[name] then
			stack = burst_fire(stack, player)
		else
			add_auto(name, def)
		end
	elseif def.mode == "burst" then
		stack = burst_fire(stack, player)
	elseif def.mode == "semi-automatic" then
		stack = fire(stack, player)
	end
	return stack
end

--Scopes
local function on_rclick(stack, player)
	local def = wm_gunslinger.__guns[stack:get_name()]
	if wm_gunslinger.__scopes[player:get_player_name()] then
		hide_scope(player)
	else
		if def.scope then
			show_scope(player, def.scope, def.wm_gunslinger.__scopes)
		end
	end
end

--------------------------------

minetest.register_globalstep(function(dtime)
	for name in pairs(wm_gunslinger.__interval) do
		wm_gunslinger.__interval[name] = wm_gunslinger.__interval[name] + dtime
	end
	if not config.lite then
		for name, info in pairs(wm_gunslinger.__automatic) do
			local player = minetest.get_player_by_name(name)
			if not player or player:get_hp() <= 0 then
				wm_gunslinger.__automatic[name] = nil
			elseif wm_gunslinger.__interval[name] > info.def.unit_time then
				if player:get_player_control().LMB and
						player:get_wielded_item():get_name() ==
						info.stack:get_name() then
					-- If LMB pressed, fire
					info.stack = fire(info.stack, player)
					player:set_wielded_item(info.stack)
					if wm_gunslinger.__automatic[name] then
						wm_gunslinger.__automatic[name].stack = info.stack
					end
					wm_gunslinger.__interval[name] = 0
				else
					wm_gunslinger.__automatic[name] = nil
				end
			end
		end
	end
end)

--
-- External API functions
--

function wm_gunslinger.get_def(name)
	return wm_gunslinger.__guns[name]
end

--
function wm_gunslinger.register_type(name, def)
	assert(type(name) == "string" and type(def) == "table",
	      "wm_gunslinger.register_type: Invalid params!")
	assert(not wm_gunslinger.__types[name], "wm_gunslinger.register_type:" ..
	      " Attempt to register a type with an existing name!")

	wm_gunslinger.__types[name] = def
end


--
function wm_gunslinger.register_gun(name, def)
	assert(type(name) == "string" and type(def) == "table",
	      "wm_gunslinger.register_gun: Invalid params!")
	assert(not wm_gunslinger.__guns[name], "wm_gunslinger.register_gun: " ..
	      "Attempt to register a gun with an existing name!")

	-- Import type defaults if def.type specified
	if def.type then
		assert(wm_gunslinger.__types[def.type], "wm_gunslinger.register_gun: Invalid type!")

		for attr, val in pairs(wm_gunslinger.__types[def.type]) do
			def[attr] = val
		end
	end

	-- Abort when making use of unimplemented features
	if def.zoom then
		error("wm_gunslinger.register_gun: Unimplemented feature!", 2)
	end

	if def.zoom and not def.scope then
		error("wm_gunslinger.register_gun: zoom requires scope to be defined!", 2)
	end

	if (def.mode == "automatic" or def.mode == "hybrid")
			and config.lite then
		error("wm_gunslinger.register_gun: Attempting to register gun of " ..
				"type '" .. def.mode .. "' when lite mode is enabled", 2)
	end

	-- Initialize sounds
	do
		if not def.sounds then
			def.sounds = {}
		end

		if not def.sounds.fire then
			def.sounds.fire = "wm_gunslinger_fire"
		end

		if not def.sounds.ricochet then
			def.sounds.ricochet = "wm_gunslinger_ricochet"
		end

		if not def.sounds.ooa then
			def.sounds.ooa = "wm_gunslinger_ooa"
		end
	end

	-- Convert points into values
	--set any missing values.
	if not def.fire_rate then
		def.fire_rate = 1
	end
	def.fire_rate = def.fire_rate * 2

	if not def.dmg_mult then
		def.dmg_mult = 1
	end
	--def.dmg_mult = def.dmg_mult

	if not def.range then
		def.range = 5
	end
	def.range = def.range * 10

	if not def.pellets then
		def.pellets = 1
	end
	--def.pellets = def.pellets

	if not def.efficiency then
		def.efficiency = 0
	end
	def.efficiency = math.floor(((def.fire_rate + def.range + def.dmg_mult)*def.pellets) / ((1 + def.efficiency) * 10))

	if not def.spread_mult then
		def.spread_mult = 0
	end
	def.spread_mult = math.floor((def.fire_rate + (6 * def.pellets))/ (1 + def.spread_mult))

	if not def.recoil_mult then
		def.recoil_mult = 0
	end
	def.recoil_mult = math.floor(((def.fire_rate + def.dmg_mult) * def.pellets)/ (1 + def.recoil_mult))


	--set any missing values for non-point based features.
	if not def.ammo then
		def.ammo = "wm_gunslinger:ammo"
	end

	if not def.bullet then
		def.bullet = "wm_gunslinger_bullet.png"
	end

	if def.mode == "burst" and not def.burst then
		def.burst = 3
	end

	if (def.round == "explosive" or def.round == "incendiary") and not def.dmg_radius then
		def.dmg_radius = 1
	end
	if def.round == "explosive" and not def.boom_radius then
		def.boom_radius = 1
	end
	if def.round == "incendiary" and not def.fire_count then
		def.fire_count = 3
	end

	--extra energy use for specials
	if (def.round == "explosive" or def.round == "incendiary") then
		def.efficiency = math.floor(((def.fire_rate + def.range + def.dmg_mult)*def.pellets*def.dmg_radius) / ((1 + def.efficiency) * 10))
	end


	-- Add additional helper fields for internal use
	--def.unit_wear = math.ceil(config.max_wear / def.clip_size)
	def.unit_time = 1 / def.fire_rate

	-- Register gun
	wm_gunslinger.__guns[name] = def

	def.itemdef.on_use = on_lclick
	--def.itemdef.on_secondary_use = on_rclick
	def.itemdef.on_place = function(stack, player, pointed)
		if pointed.type == "node" then
			local node = minetest.get_node_or_nil(pointed.under)
			local nodedef = minetest.registered_items[node.name]
			--return nodedef.on_rightclick or on_rclick(stack, player)
		elseif pointed.type == "object" then
			local entity = pointed.ref:get_luaentity()
			return entity:on_rightclick(player) or on_rclick(stack, player)
		end
	end

	-- Register tool
	minetest.register_tool(name, def.itemdef)
	--minetest.register_craftitem(name, def.itemdef)

end
