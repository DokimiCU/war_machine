--
-- Register Egg
--

wm_mobs.create_mob = function(placer, itemstack, name, pos)
	local meta = itemstack:get_meta()
	local meta_table = meta:to_table()
	local sdata = minetest.serialize(meta_table)
	local mob = minetest.add_entity(pos, name, sdata)
	local ent = mob:get_luaentity()
	itemstack:take_item() -- since mob is unique we remove egg once spawned
	return ent
end



wm_mobs.pos_to_spawn = function(name, pos)
	local x = pos.x
	local y = pos.y
	local z = pos.z
	if minetest.registered_entities[name] and minetest.registered_entities[name].visual_size.x then
		if minetest.registered_entities[name].visual_size.x >= 32 and
			minetest.registered_entities[name].visual_size.x <= 48 then
				y = y + 2
		elseif minetest.registered_entities[name].visual_size.x > 48 then
			y = y + 5
		else
			y = y + 1
		end
	end
	local spawn_pos = { x = x, y = y, z = z}
	return spawn_pos
end




wm_mobs.register_egg = function(name, desc, inv_img, no_creative)
	local grp = {spawn_egg = 1}
	minetest.register_craftitem(name, { -- register new spawn egg containing mob information
		description = desc,
		inventory_image = inv_img,
		groups = {spawn_egg = 2},
		stack_max = 99,
		on_place = function(itemstack, placer, pointed_thing)
			local spawn_pos = pointed_thing.above
			-- am I clicking on something with existing on_rightclick function?
			local under = minetest.get_node(pointed_thing.under)
			local def = minetest.registered_nodes[under.name]
			if def and def.on_rightclick then
				return def.on_rightclick(pointed_thing.under, under, placer, itemstack)
			end
			if spawn_pos and not minetest.is_protected(spawn_pos, placer:get_player_name()) then
				if not minetest.registered_entities[name] then
					return
				end
				spawn_pos = wm_mobs.pos_to_spawn(name, spawn_pos)
				local ent = wm_mobs.create_mob(placer, itemstack, name, spawn_pos)
			end
			return itemstack
		end,
	})
end





wm_mobs.capture = function(self, clicker)
	local new_stack = ItemStack(self.name) 	-- add special mob egg with all mob information
	local stack_meta = new_stack:get_meta()
	--local sett ="---TABLE---: "
	--local sett = ""
	--local i = 0
	for key, value in pairs(self) do
		local what_type = type(value)
		if what_type ~= "function"
		and what_type ~= "nil"
		and what_type ~= "userdata"
		then
			if what_type == "boolean" or what_type == "number" then
				value = tostring(value)
			end
			stack_meta:set_string(key, value)
		end
	end


	local inv = clicker:get_inventory()
	local pname = clicker:get_player_name()
	if inv:room_for_item("main", new_stack) then
		inv:add_item("main", new_stack)
		minetest.sound_play("wm_mobs_alert_beep", {to_player = pname , gain = 1})
	  minetest.chat_send_player(pname, minetest.colorize("#cc6600", "Droid added to storage!"))
	else
		minetest.add_item(clicker:get_pos(), new_stack)
		minetest.sound_play("wm_mobs_robot_warn", {to_player = pname , gain = 1})
	  minetest.chat_send_player(pname, minetest.colorize("#cc6600", "Insufficient storage space!"))
	end

	self.object:remove()
	return stack_meta
end
