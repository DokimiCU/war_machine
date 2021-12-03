---------------------------------------------------
--ARMOR
--[[]
Elements: armor_head, armor_torso, armor_legs, armor_feet
Attributes: armor_heal, armor_fire, armor_water
Physics: physics_jump, physics_speed, physics_gravity
Durability: armor_use, flammable

texture = <filename>
preview = <filename>
armor_groups = <table>
damage_groups = <table>
reciprocate_damage = <bool>
on_equip = <function>
on_unequip = <function>
on_destroy = <function>
on_damage = <function>
on_punched = <function>


]]


--Notes:
--[[
Two sets:

Commando: gives special abilities.
-helmet: water breathing
-chest: fire proofing
-legs: jump
-feet: speed

Battle Drone: all armor and healing, but slow.
-helmet:
-chest:
-legs:
-feet:

]]

--------------------------------------------------

-- COMMANDO

armor:register_armor("wm_armor:commando_head_unit", {
	description = "Commando Head Unit",
	inventory_image = "wm_armor_commando_head_unit_inv.png",
	texture = "wm_armor_commando_head_unit.png",
	preview = "wm_armor_commando_head_unit_preview.png",
	groups = {armor_head=1, armor_heal=1, armor_water = 1, armor_use=800},
	armor_groups = {fleshy=5},
	on_equip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_unequip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_destroy = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_break", pos = pos, gain = 0.5,})
		end
	end,
	on_damage = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_damage", pos = pos, gain = 0.5,})
		end
	end,
})

armor:register_armor("wm_armor:commando_chest_unit", {
	description = "Commando Chest Unit",
	inventory_image = "wm_armor_commando_chest_unit_inv.png",
	texture = "wm_armor_commando_chest_unit.png",
	preview = "wm_armor_commando_chest_unit_preview.png",
	groups = {armor_torso=1, armor_heal=1, armor_fire = 5, armor_use=800},
	armor_groups = {fleshy=10},
	on_equip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_unequip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_destroy = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_break", pos = pos, gain = 0.5,})
		end
	end,
	on_damage = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_damage", pos = pos, gain = 0.5,})
		end
	end,
})

armor:register_armor("wm_armor:commando_leg_unit", {
	description = "Commando Leg Unit",
	inventory_image = "wm_armor_commando_leg_unit_inv.png",
	texture = "wm_armor_commando_leg_unit.png",
	preview = "wm_armor_commando_leg_unit_preview.png",
	groups = {armor_legs=1, armor_heal=1, physics_gravity= -0.42, armor_use=800},
	armor_groups = {fleshy=10},
	on_equip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_unequip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_destroy = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_break", pos = pos, gain = 0.5,})
		end
	end,
	on_damage = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_damage", pos = pos, gain = 0.5,})
		end
	end,
})

armor:register_armor("wm_armor:commando_foot_unit", {
	description = "Commando Foot Unit",
	inventory_image = "wm_armor_commando_foot_unit_inv.png",
	texture = "wm_armor_commando_foot_unit.png",
	preview = "wm_armor_commando_foot_unit_preview.png",
	groups = {armor_feet=1, armor_heal=1, physics_speed= 0.34, armor_use=800},
	armor_groups = {fleshy=5},
	on_equip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_unequip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_destroy = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_break", pos = pos, gain = 0.5,})
		end
	end,
	on_damage = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_damage", pos = pos, gain = 0.5,})
		end
	end,
})




--------------------------------------------------

-- BATTLE DRONE

armor:register_armor("wm_armor:drone_head_unit", {
	description = "Battle Drone Head Unit",
	inventory_image = "wm_armor_drone_head_unit_inv.png",
	texture = "wm_armor_drone_head_unit.png",
	preview = "wm_armor_drone_head_unit_preview.png",
	groups = {armor_head=1, armor_heal=10, physics_gravity= 0.03, physics_speed= -0.05, armor_use=200},
	armor_groups = {fleshy=8},
	on_equip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_unequip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_destroy = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_break", pos = pos, gain = 0.5,})
		end
	end,
	on_damage = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_damage", pos = pos, gain = 0.5,})
		end
	end,
})

armor:register_armor("wm_armor:drone_chest_unit", {
	description = "Battle Drone Chest Unit",
	inventory_image = "wm_armor_drone_chest_unit_inv.png",
	texture = "wm_armor_drone_chest_unit.png",
	preview = "wm_armor_drone_chest_unit_preview.png",
	groups = {armor_torso=1, armor_heal=20, armor_fire = 3, physics_gravity= 0.06, physics_speed= -0.10, armor_use=200},
	armor_groups = {fleshy=20},
	on_equip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_unequip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_destroy = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_break", pos = pos, gain = 0.5,})
		end
	end,
	on_damage = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_damage", pos = pos, gain = 0.5,})
		end
	end,
})

armor:register_armor("wm_armor:drone_leg_unit", {
	description = "Battle Drone Leg Unit",
	inventory_image = "wm_armor_drone_leg_unit_inv.png",
	texture = "wm_armor_drone_leg_unit.png",
	preview = "wm_armor_drone_leg_unit_preview.png",
	groups = {armor_legs=1, armor_heal=20, physics_gravity= 0.06, physics_speed= -0.10, armor_use=200},
	armor_groups = {fleshy=20},
	on_equip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_unequip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_destroy = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_break", pos = pos, gain = 0.5,})
		end
	end,
	on_damage = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_damage", pos = pos, gain = 0.5,})
		end
	end,
})

armor:register_armor("wm_armor:drone_foot_unit", {
	description = "Battle Drone Foot Unit",
	inventory_image = "wm_armor_drone_foot_unit_inv.png",
	texture = "wm_armor_drone_foot_unit.png",
	preview = "wm_armor_drone_foot_unit_preview.png",
	groups = {armor_feet=1, armor_heal=10, physics_gravity= 0.03, physics_speed= -0.05, armor_use=200},
	armor_groups = {fleshy=8},
	on_equip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_unequip = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_equip", pos = pos, gain = 0.5,})
		end
	end,
	on_destroy = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_break", pos = pos, gain = 0.5,})
		end
	end,
	on_damage = function(player)
		local pos = player:get_pos()
		if pos then
			minetest.sound_play({	name = "wm_armor_damage", pos = pos, gain = 0.5,})
		end
	end,
})
