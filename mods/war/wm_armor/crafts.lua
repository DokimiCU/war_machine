---------------------------------------------------
--CRAFTS

local v = "default:steelblock"
local vl = "default:steel_ingot"
local e = "wm_weapons:energy_module"

minetest.register_craft({
	output = "wm_armor:drone_head_unit",
	recipe = {
		{v, v, v},
		{v, "", v},
		{"", "", ""},
	},
})
minetest.register_craft({
	output = "wm_armor:drone_chest_unit",
	recipe = {
		{v, "", v},
		{v, e, v},
		{v, v, v},
	},
})
minetest.register_craft({
	output = "wm_armor:drone_leg_unit",
	recipe = {
		{v, v, v},
		{v, "", v},
		{v, "", v},
	},
})
minetest.register_craft({
	output = "wm_armor:drone_foot_unit",
	recipe = {
		{v, "", v},
		{v, "", v},
	},
})


-----------------------

minetest.register_craft({
	output = "wm_armor:commando_head_unit",
	recipe = {
		{e, e, e},
		{vl, "", vl},
		{"", "", ""},
	},
})
minetest.register_craft({
	output = "wm_armor:commando_chest_unit",
	recipe = {
		{vl, "", vl},
		{vl, e, vl},
		{vl, e, vl},
	},
})
minetest.register_craft({
	output = "wm_armor:commando_leg_unit",
	recipe = {
		{e, e, e},
		{vl, "", vl},
		{vl, "", vl},
	},
})
minetest.register_craft({
	output = "wm_armor:commando_foot_unit",
	recipe = {
		{e, "", e},
		{vl, "", vl},
	},
})
