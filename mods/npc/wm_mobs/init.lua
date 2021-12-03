wm_mobs = {}



local modpath = minetest.get_modpath("wm_mobs") .. "/"




dofile(modpath .. "wm_api.lua")
dofile(modpath .. "api_capture.lua")



dofile(modpath .. "t1_droid.lua")
dofile(modpath .. "t2_droid.lua")
dofile(modpath .. "t3_droid.lua")
dofile(modpath .. "t4_droid.lua")
dofile(modpath .. "t5_droid.lua")
dofile(modpath .. "t10_oid.lua")

dofile(modpath .. "nodes.lua")
dofile(modpath .. "invasion.lua")



local random = math.random


---------------------------------
--Starting weapons
minetest.register_on_newplayer(function(player)
  local you = player:get_player_name()

  --so can do bed save immediately
  minetest.set_timeofday(0.2)

  local inventory = player:get_inventory()
  if random()<0.3 then
    inventory:add_item("main", "wm_weapons:t3_shotgun")
  elseif random()<0.6 then
    inventory:add_item("main", "wm_weapons:t2_in_rifle")
  elseif random()<1 then
    inventory:add_item("main", "wm_weapons:t1_machinepistol")
  end
  inventory:add_item("main", "wm_weapons:energy_module")
  minetest.sound_play("wm_mobs_alert_beep", {to_player = you, gain = 1})

  minetest.chat_send_player(you, minetest.colorize("#cc6600", "Connection established... initiating... controls active. All systems functional."))

end)


minetest.register_on_respawnplayer(function(player)
  local you = player:get_player_name()
  local inventory = player:get_inventory()
  if random()<0.3 then
    inventory:add_item("main", "wm_weapons:t3_shotgun")
  elseif random()<0.6 then
    inventory:add_item("main", "wm_weapons:t2_in_rifle")
  elseif random()<1 then
    inventory:add_item("main", "wm_weapons:t1_machinepistol")
  end
  inventory:set_stack("main", 8, "wm_weapons:energy_module")--add_item("main", "wm_weapons:energy_module")

  minetest.sound_play("wm_mobs_alert_beep", {to_player = you, gain = 1})

  minetest.chat_send_player(you, minetest.colorize("#cc6600", "Connection established... initiating... controls active. All systems functional."))
end)
