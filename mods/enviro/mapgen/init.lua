
local path = minetest.get_modpath("mapgen")
mapgen = {}

------------------------------------
--Do files
------------------------------------

dofile(path .. "/sounds.lua")
dofile(path .. "/stone.lua")



dofile(path .. "/biomes.lua")

dofile(path .. "/control_points.lua")


------------------------------------
-- ESSENTIAL node aliases
------------------------------------

minetest.register_alias("mapgen_stone", "mapgen:rock")
minetest.register_alias("mapgen_water_source", "mapgen:sand")
minetest.register_alias("mapgen_river_water_source", "mapgen:sand")
