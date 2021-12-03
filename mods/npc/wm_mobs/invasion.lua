---------------------------------------
--Map based Invasion of territory

local random = math.random
local time = os.time




-------------------------------------------
--The Wow looking bits...invasion

local function effects(pos, pos2, blast, team)
  if not pos or not pos2 then
		return
	end

	minetest.add_particlespawner({
		amount = 1,
		time = 0.2,
		-- make it hit the top of a block exactly with the bottom
		minpos = {x = pos2.x, y = pos2.y + 50.5, z = pos2.z },
		maxpos = {x = pos2.x, y = pos2.y + 50.5, z = pos2.z },
		minvel = {x = 0, y = 0, z = 0},
		maxvel = {x = 0, y = 0, z = 0},
		minacc = {x = 0, y = 0, z = 0},
		maxacc = {x = 0, y = 0, z = 0},
		minexptime = 0.2,
		maxexptime = 0.2,
		minsize = 1000,
		maxsize = 1000,
		collisiondetection = true,
		vertical = true,
		texture = "wm_mobs_lightning.png",
		glow = 14,
	})

	minetest.sound_play({ pos = pos, name = "wm_mobs_thunder", gain = 8, max_hear_distance = 500 })

	tnt.boom(pos2, {damage_radius= blast*6, radius= blast, ignore_protection=false})

  --
  if team then
    if team == "friendly" then
      minetest.set_node(pos2, {name = "wm_mobs:orbital_pod_friendly"})
        return
    elseif team == "hostile" then
      minetest.set_node(pos2, {name = "wm_mobs:orbital_pod_hostile"})
      return
    end
  end
end



-------------------------------------------
local function select_pos(pos, spread)


  if pos.y < -20 then
    --minetest.chat_send_player(plyr_name, minetest.colorize("#cc0000", "Below ground!"))
    return false
  end

  --random posiotn at height
  pos.x = math.floor(pos.x + random(-spread, spread))
  pos.y = math.floor(pos.y + 50)
  pos.z = math.floor(pos.z + random(-spread, spread))

  --below our height pos, drop more than raise, bc player might be on a pole
  local pos2 = {x = pos.x, y = pos.y - 70, z = pos.z}

  --look for a hit falling down
  local b, pos2 = minetest.line_of_sight(pos, pos2)

  -- nothing but air found below
  if b then
    --minetest.chat_send_player(plyr_name, minetest.colorize("#cc0000", "All air"))
    return false
  end

  local n = minetest.get_node({x = pos2.x, y = pos2.y - 1/2, z = pos2.z})

  if n.name == "air" or n.name == "ignore" then
    --minetest.chat_send_player(plyr_name, minetest.colorize("#cc0000", "Funny business"))
    return false
  end

  return pos2

end



-------------------------------------------
--Bombard
local interval = 5
local timer = 0

minetest.register_globalstep(function(dtime)

    timer = timer + dtime

    if timer > interval then

      --reset timer and interval
      timer = 0
      interval = random(10, 300)

      --for message and position
      local plyrs = minetest.get_connected_players()
      local plyr = plyrs[random(#plyrs)]
      local plyr_name = plyr:get_player_name()

      --block
      if minetest.find_node_near(plyr:get_pos(), 100, {"wm_mobs:victory"}) then
        return
      end


      --pre-invasion bombardment
      minetest.chat_send_player(plyr_name, minetest.colorize("#cc0000", "ALERT! ORBITAL BOMBARDMENT INCOMING!"))
      minetest.sound_play("wm_mobs_alert_beep", {to_player = plyr_name, gain = 2})



      -- slowly go through them
      --make so ridiculous that player can't get far... limits size of engagements

      --some variants
      local c = random()
      if c > 0.7 then
        --terror strike
        local b_num = 600 --max strikes
        local time = 0
        for i = 1, b_num, 1 do
          time = time + random(0.1,2)
          minetest.after(time, function(plyr_name)
            local pos = plyr:get_pos()
            local pos2 = select_pos(pos, 140)
            effects(pos, pos2, 1)
          end, plyr_name)
        end

      elseif c > 0.45 then
        --slow strike
        local b_num = 10 --max strikes
        local time = 0
        for i = 1, b_num, 1 do
          time = time + random(30,60)
          minetest.after(time, function(plyr_name)
            local pos = plyr:get_pos()
            local pos2 = select_pos(pos, 160)
            effects(pos, pos2, 6)
          end, plyr_name)
        end
      else
        --standard shell shocking
        local b_num = 40 --max strikes
        local time = 0
        for i = 1, b_num, 1 do
          time = time + random(3,10)
          minetest.after(time, function(plyr_name)
            local pos = plyr:get_pos()
            local pos2 = select_pos(pos, 120)
            effects(pos, pos2, 2)
          end, plyr_name)
        end
      end


      --After bombardment ..one hopes... decide who is invading...and invade!

      if random() < 0.5 then
        local side = ""
        if random() < 0.49 then
          minetest.chat_send_player(plyr_name, minetest.colorize("#cc6600", "ALERT! REINFORCEMENTS INBOUND!"))
          minetest.sound_play("wm_mobs_alert_beep", {to_player = plyr_name, gain = 1})
          side = "friendly"
        else
          minetest.chat_send_player(plyr_name, minetest.colorize("#cc0000", "ALERT! HOSTILE OFFENSIVE INCOMING!"))
          minetest.sound_play("wm_mobs_alert_beep", {to_player = plyr_name, gain = 1})
          side = "hostile"
        end



        local b_num = 30 --max invasions
        local time = 0
        for i = 1, b_num, 1 do
          local time = 0
          time = time + random(5,20)

          minetest.after(time, function(plyr_name)
            local pos = plyr:get_pos()
            local pos2 = select_pos(pos, 80)
            if pos2 then
              effects(pos, pos2, 1, side)
            end
          end, plyr_name)
        end

      end


    end

end)


----------------------------------------------------------------
--The Conclusion to an invasion...
-- how to hold territory and "win"
--The creation of Tactical Targetting Scanner
--TTS
--periodically scans area and detonates anyone in that zone.
--created out of the OIDs
--makes areas safe, or impossible, spawns new troops if threatened
local troop_num = 2
local max_lvl = 5

local function troops(pos, r_num, team)
  if random() < 0.3 then

    if random() < 0.1 then
      local r = 1
      local ranpos = {x = pos.x + random(-r,r), y = pos.y + random(-r,2*r), z = pos.z + random(-r,r)}
      if minetest.get_node(ranpos).name == "air" then
        minetest.add_entity(ranpos, "wm_mobs:t10_oid_"..team)
      end
    end

    local r = 1
    for i = 1, r_num do
      local ranpos = {x = pos.x + random(-r,r), y = pos.y + random(-r,2*r), z = pos.z + random(-r,r)}
      if minetest.get_node(ranpos).name == "air" then
        minetest.add_entity(ranpos, "wm_mobs:t"..random(1,max_lvl).."_droid_"..team)
      end
    end
  end
end


--Aiming... then firing
local function aim_scan(pos, target, delay, spread)

  --get position.
  local pos2 = target:get_pos()

  --apply inaccuracy
  pos2.x = pos2.x + random(-spread, spread)
  pos2.z = pos2.z + random(-spread, spread)

  --don't shoot self.
  if pos == pos2 then
    return
  end

  --time delay
  local delay = random(delay/5, delay)
  --pause bombard
  minetest.after(delay, function(pos, pos2)
    effects(pos, pos2, 1)
  end, pos, pos2)

end


---Scanning
local function scan(pos, radius, team)
  --scan
  local ents = minetest.get_objects_inside_radius(pos, radius)
  if not ents then
    return
  end

  local delay_max = 5
  local spr_max = 1

  --include player if enemy
  if team == "hostile" then
    for _,obj in ipairs(ents) do

      if mobkit.is_alive(obj) then
        if obj:is_player() then
          aim_scan(pos, obj, delay_max, spr_max)
          troops(pos, 3, team)
          local plyr_name = obj:get_player_name()
          minetest.chat_send_player(plyr_name, minetest.colorize("#cc0000", "YOU HAVE BEEN SCANNED"))
          minetest.sound_play("wm_mobs_alert_beep", {to_player = plyr_name, gain = 1})
        else
          local luaent = obj:get_luaentity()
          if luaent and luaent.team == "friendly" then
            aim_scan(pos, obj, delay_max, spr_max)
            troops(pos, troop_num, team)
          end
        end
      end
    end
    --not hostile team..ignore player
  elseif team == "friendly" then
    for _,obj in ipairs(ents) do

      local luaent = obj:get_luaentity()

      if mobkit.is_alive(obj)
      and luaent
      and not obj:is_player() then
        if luaent.team == "hostile" then
          aim_scan(pos, obj, delay_max, spr_max)
          troops(pos, troop_num, team)
        end
      end
    end
  end
end



-----------------------------

local scan_max = 30
local scan_r = 15

minetest.register_node("wm_mobs:tts_hostile", {
	description = "Hostile Tactical Targetting Scanner",
  --drawtype = "allfaces",
	tiles = {"wm_mobs_tts_hostile.png",},
	paramtype = "light",
	light_source=minetest.LIGHT_MAX/2,
  --drop = "wm_mobs:orbital_pod",
	groups = {choppy = 3, flammable = 3, not_in_creative_inventory = 1},
	--sounds = default.node_sound_metal_defaults(),
  --set up a new node
  on_construct = function(pos)
    --start timer to scans
    local MR = random(scan_max/2,scan_max)
    minetest.get_node_timer(pos):start(MR)
  end,

  --Scan and bombard
  on_timer = function(pos, elapsed)
    scan(pos, scan_r, "hostile")
		return true
	end,
})


minetest.register_node("wm_mobs:tts_friendly", {
	description = "Friendly Tactical Targetting Scanner",
  --drawtype = "allfaces",
	tiles = {"wm_mobs_tts_friendly.png",},
	paramtype = "light",
	light_source=minetest.LIGHT_MAX/2,
  --drop = "wm_mobs:orbital_pod",
	groups = {choppy = 3, flammable = 3, not_in_creative_inventory = 1},
	--sounds = default.node_sound_metal_defaults(),
  --set up a new node
  on_construct = function(pos)
    --start timer to scans
    local MR = random(scan_max/2,scan_max)
    minetest.get_node_timer(pos):start(MR)
  end,

  --Scan and bombard
  on_timer = function(pos, elapsed)
    scan(pos, scan_r, "friendly")
		return true
	end,
})
