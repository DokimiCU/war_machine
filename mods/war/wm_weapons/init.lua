local modpath = minetest.get_modpath("wm_weapons") .. "/"


dofile(modpath .. "player_guns.lua")



minetest.register_craft({
	type = "cooking",
  cooktime = 30,
	output = "wm_weapons:energy_module",
	recipe = "wm_weapons:energy_module",
})
