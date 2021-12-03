------------------------------------
--MAPGEN
------------------------------------






------------------------------------
--BIOMES
------------------------------------
-------------------
local t = 50
local l = 25
local h = 75

--Heights
local mt_max = 31000
local mt_min = 100

local land_max = 120
local land_min = 2

local ocean_max = 4
local ocean_min = -120

local underg_max = -100
local underg_min = -31000

--local base_max = -1050
--local base_min = -31000
------------------------


--
-- Register biomes
--
local upper_limit = 31000
local lower_limit = -31000

local mountain_min = 170
local alpine_min = 140
local highland_min = 100
local upland_min = 90
local lowland_max = 9

local beach_max = 5
local beach_min = -10
local shallow_ocean_min = -30
local deep_ocean_min = -120

---
local extreme_high = 95
local high = 75
local middle = 50
local low = 25
local extreme_low = 5



----------------------
-- rockland


minetest.register_biome({
	name = "rockland",
	node_top = "mapgen:stones",
	depth_top = 1,
	node_filler = "mapgen:stones",
	depth_filler = 2,
	node_stone = "mapgen:rock",
	node_river_water = "air",
	node_riverbed = "mapgen:rock",
	depth_riverbed = 1,
	node_cave_liquid = {"air"},
	node_dungeon = "mapgen:rock",
	node_dungeon_stair = "mapgen:rock",
	vertical_blend = 5,
	y_max = upper_limit,
	y_min = beach_min,
	heat_point = middle,
	humidity_point = middle,
})

minetest.register_biome({
	name = "rockland2",
	node_top = "mapgen:sand",
	depth_top = 1,
	node_filler = "mapgen:stones",
	depth_filler = 1,
	node_stone = "mapgen:rock",
	node_river_water = "air",
	node_riverbed = "mapgen:stones",
	depth_riverbed = 1,
	node_cave_liquid = {"air"},
	node_dungeon = "mapgen:rock",
	node_dungeon_stair = "mapgen:rock",
	vertical_blend = 5,
	y_max = upper_limit,
	y_min = beach_min,
	heat_point = middle-1,
	humidity_point = middle-1,
})



----------------------

minetest.register_biome({
	name = "basin",
	node_top = "mapgen:sand",
	depth_top = 3,
	node_filler = "mapgen:sand",
	depth_filler = 3,
	node_stone = "mapgen:rock",
	node_river_water = "air",
	node_riverbed = "mapgen:stones",
	depth_riverbed = 2,
	node_cave_liquid = {"air"},
	node_dungeon = "mapgen:rock",
	node_dungeon_stair = "mapgen:rock",
	vertical_blend = 3,
	y_max = beach_max,
	y_min = deep_ocean_min,
	heat_point = middle,
	humidity_point = middle,
})


minetest.register_biome({
	name = "basin2",
	node_top = "mapgen:sand",
	depth_top = 1,
	node_filler = "mapgen:stones",
	depth_filler = 1,
	node_stone = "mapgen:rock",
	node_river_water = "air",
	node_riverbed = "mapgen:stones",
	depth_riverbed = 2,
	node_cave_liquid = {"air"},
	node_dungeon = "mapgen:rock",
	node_dungeon_stair = "mapgen:rock",
	vertical_blend = 3,
	y_max = beach_max,
	y_min = deep_ocean_min,
	heat_point = middle-1,
	humidity_point = middle-1,
})



-------------------------
--underground
minetest.register_biome({
	name = "underground",
	node_stone = "mapgen:rock",
	node_dungeon = "mapgen:rock",
	node_dungeon_stair = "mapgen:rock",
	vertical_blend = 20,
	node_cave_liquid = {"air"},
	node_dungeon = "mapgen:rock",
	node_dungeon_stair = "mapgen:rock",
	y_max = deep_ocean_min,
	y_min = lower_limit,
	heat_point = middle,
	humidity_point = middle,
})
