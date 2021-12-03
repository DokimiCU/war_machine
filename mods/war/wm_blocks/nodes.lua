---------------------------------------------------
--blast effects for default:
local random = math.random

------------------------------------
crafting.register_type("inv")
------------------------------------
crafting.register_recipe({
	type = "inv",
	output = "wm_mobs:victory",
	items = {'wm_mobs:body 99'},
	level = 1,
	always_known = true,
})

crafting.register_recipe({
	type = "inv",
	output = "wm_mobs:tts_friendly",
	items = {'wm_mobs:tts_hostile'},
	level = 1,
	always_known = true,
})
	---------------------------------------------------
--BUIDLING NODES
--Bunker

minetest.register_node("wm_blocks:bunker", {
	description = "Bunker Concrete",
	tiles = {"wm_blocks_bunker.png"},
	sounds = mapgen.node_sound_stone_defaults(),
	groups = {cracky = 3, level = 2},
	on_blast = function(pos)
		minetest.set_node(pos, {name = "wm_blocks:bunker_weak"})
	end,
})

--Bunker weak
minetest.register_node("wm_blocks:bunker_weak", {
	description = "Bunker Concrete (weakened)",
	tiles = {"wm_blocks_bunker_weak.png"},
	sounds = mapgen.node_sound_stone_defaults(),
	groups = {cracky = 3, not_in_creative_inventory = 1},
	on_blast = function(pos)
		minetest.set_node(pos, {name = "wm_blocks:bunker_damaged"})
	end,
})

--Bunker damaged
minetest.register_node("wm_blocks:bunker_damaged", {
	description = "Bunker Concrete (damaged)",
	tiles = {"wm_blocks_bunker_damaged.png"},
	sounds = mapgen.node_sound_stone_defaults(),
	groups = {cracky = 2, not_in_creative_inventory = 1},
	on_blast = function(pos)
		minetest.set_node(pos, {name = "wm_blocks:bunker_badly_damaged"})
	end,
})


--Bunker badly damaged
minetest.register_node("wm_blocks:bunker_badly_damaged", {
	description = "Bunker Concrete (badly damaged)",
	tiles = {"wm_blocks_bunker_badly_damaged.png"},
	sounds = mapgen.node_sound_stone_defaults(),
	groups = {cracky = 1, stone = 1, not_in_creative_inventory = 1},
	on_blast = function(pos)
		--minetest.set_node(pos, {name = "default:gravel"})
		minetest.set_node(pos, {name = "mapgen:stones"})
	end,
})


---Craft bunker
crafting.register_recipe({
	type = "inv",
	output = "wm_blocks:bunker 3",
	items = {'wm_mobs:body'},
	level = 1,
	always_known = true,
})


--[[
minetest.register_craft({
	type = "shapeless",
	output = "wm_blocks:bunker 6",
	recipe = {"group:stone", "group:sand", "default:gravel"}
})
]]


--Barbed Wire
minetest.register_node("wm_blocks:wire", {
	description = "Barbed Wire",
	drawtype = "firelike",
	paramtype = "light",
	tiles = {"wm_blocks_wire.png"},
	--sounds = default.node_sound_metal_defaults(),
	groups = {snappy = 3},
	walkable = false,
	damage_per_second = 1,
	selection_box = {
		type = "fixed",
		fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3},
		},
	})


---Craft wire
crafting.register_recipe({
	type = "inv",
	output = "wm_blocks:wire 16",
	items = {'wm_mobs:body'},
	level = 1,
	always_known = true,
})

--[[
minetest.register_craft({
	type = "shapeless",
	output = "wm_blocks:wire 16",
	recipe = {"default:steel_ingot"}
})
]]



--Sandbags

minetest.register_node("wm_blocks:sandbags", {
	description = "Sandbags",
	tiles = {"wm_blocks_sandbags.png"},
	sounds = mapgen.node_sound_sand_defaults(),
	groups = {crumbly = 3, falling_node = 1},
	on_blast = function(pos)
		--minetest.set_node(pos, {name = "default:sand"})
		minetest.set_node(pos, {name = "mapgen:sand"})
	end,
})


---Craft sandbags
crafting.register_recipe({
	type = "inv",
	output = "wm_blocks:sandbags 6",
	items = {'wm_mobs:body'},
	level = 1,
	always_known = true,
})
--[[
minetest.register_craft({
	type = "shapeless",
	output = "wm_blocks:sandbags 6",
	recipe = {"group:crumbly","group:crumbly","group:crumbly", "default:paper"}
})
]]



minetest.register_node("wm_blocks:bunker_lamp", {
	description = "Bunker Lamp",
	tiles = {"wm_blocks_lamp.png"},
	sounds = mapgen.node_sound_stone_defaults(),
	light_source = 9,
	groups = {cracky = 3},
	on_blast = function(pos)
		minetest.set_node(pos, {name = "wm_blocks:bunker_badly_damaged"})
	end,
})


---Craft sandbags
crafting.register_recipe({
	type = "inv",
	output = "wm_blocks:bunker_lamp",
	items = {'wm_mobs:body'},
	level = 1,
	always_known = true,
})
