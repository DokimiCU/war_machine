
------------------------------------
--STONE
--------------------------------------




------------------------------------
--SAND
------------------------------------
minetest.register_node("mapgen:sand", {
	description = "Sand",
	tiles = {"mapgen_sand.png"},
	groups = {crumbly = 3, falling_node = 1},
	sounds = mapgen.node_sound_sand_defaults(),
})


------------------------------------
--STONES
------------------------------------
minetest.register_node("mapgen:stones", {
	description = "Stones",
	tiles = {"mapgen_stones.png"},
	groups = {crumbly = 3, falling_node = 1},
	on_blast = function(pos)
		minetest.set_node(pos, {name = "mapgen:sand"})
	end,
	sounds = mapgen.node_sound_gravel_defaults(),
})


------------------------------------
--ROCK
------------------------------------
minetest.register_node("mapgen:rock", {
	description = "Rock",
	tiles = {"mapgen_rock.png"},
	groups = {cracky = 3, crumbly = 2, stone = 1},
	on_blast = function(pos)
		minetest.set_node(pos, {name = "mapgen:stones"})
	end,
	sounds = mapgen.node_sound_stone_defaults(),
})
