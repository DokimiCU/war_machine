--[[
local path = minetest.get_modpath("wm_armor")


dofile(path .. "/armor.lua")
dofile(path .. "/crafts.lua")


--remove unsuitable armors
minetest.settings:set_bool("armor_material_wood", false)
minetest.settings:set_bool("armor_material_cactus", false)
minetest.settings:set_bool("armor_material_steel", false)
minetest.settings:set_bool("armor_material_bronze", false)
minetest.settings:set_bool("armor_material_diamond", false)
minetest.settings:set_bool("armor_material_gold", false)
minetest.settings:set_bool("armor_material_mithril", false)
minetest.settings:set_bool("armor_material_crystal", false)

--enable
minetest.settings:set_bool("armor_water_protect", true)
minetest.settings:set_bool("armor_fire_protect", true)
]]
