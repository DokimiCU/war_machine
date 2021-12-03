local modpath = minetest.get_modpath("wm_gunslinger") .. "/"

-- Import API
dofile(modpath .. "api.lua")

-- If builtin guns not disabled, import builtin guns from guns.lua
--[[
if not minetest.settings:get_bool("wm_gunslinger.disable_builtin") then
	dofile(modpath .. "guns.lua")
end


-- Register default ammo item
minetest.register_craftitem("wm_gunslinger:ammo", {
	description = "Generic ammo",
	inventory_image = "wm_gunslinger_ammo.png",
	stack_max = 300
})

minetest.register_alias("ammo", "wm_gunslinger:ammo")

]]


--to do, split cracky and fleshy, so blunt vs armored
