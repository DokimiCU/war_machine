---------------------------------------
--Nodes
--for mob production etc

local random = math.random
----------------------------------
--Bodies...
minetest.register_node("wm_mobs:body", {
	description = "Destroyed Droid",
	tiles = {"wm_mobs_body.png"},
	groups = {cracky = 3, not_in_creative_inventory = 1, falling_node = 1, dig_immediate = 3},
	--sounds = default.node_sound_metal_defaults(),
	--on_use = minetest.item_eat(1), -- recycle it!

})



----------------------------------
minetest.register_node("wm_mobs:victory", {
	description = "Victory Point (secures 100m radius)",
	tiles = {
		"wm_mobs_orbital_pod.png",
		"wm_mobs_tts_friendly.png",
		"wm_mobs_tts_friendly.png",
		"wm_mobs_tts_friendly.png",
		"wm_mobs_tts_friendly.png",
		"wm_mobs_tts_friendly.png"
	},
	groups = {cracky = 3, not_in_creative_inventory = 1, falling_node = 1},
	--sounds = default.node_sound_metal_defaults(),
	--on_use = minetest.item_eat(1), -- recycle it!

})


-------------------------------------------
--Orbital Pod
--produced by invasion, unleashes the beast...
local r_num = 5
local max_lvl = 5
local t10_tme_max = 10

minetest.register_node("wm_mobs:orbital_pod_friendly", {
	description = "Friendly Orbital Pod",
  --drawtype = "allfaces",
	tiles = {"wm_mobs_orbital_pod.png",},
	paramtype = "light",
	light_source=minetest.LIGHT_MAX,
  --drop = "wm_mobs:orbital_pod",
	groups = {cracky = 1, not_in_creative_inventory = 1, level = 2},
	--sounds = default.node_sound_metal_defaults(),
  --set up a new node
  on_construct = function(pos)
    --start timer to release
    local MR = random(t10_tme_max/2,t10_tme_max)
    minetest.get_node_timer(pos):start(MR)
  end,

  --Release.. 1 OID, and troops
  on_timer = function(pos, elapsed)
    minetest.set_node(pos, {name = "air"})
		if random()<0.1 then
			minetest.add_entity(pos, "wm_mobs:t10_oid_friendly")
		end
		local r = 3
		for i = 1, random(1, r_num) do
			local ranpos = {x = pos.x + random(-r,r), y = pos.y + random(-r,2*r), z = pos.z + random(-r,r)}
			if minetest.get_node(ranpos).name == "air" then
	    	minetest.add_entity(ranpos, "wm_mobs:t"..random(1,max_lvl).."_droid_friendly")
			end
		end
		return false
	end,
})

minetest.register_node("wm_mobs:orbital_pod_hostile", {
	description = "Hostile Orbital Pod",
  --drawtype = "allfaces",
	tiles = {"wm_mobs_orbital_pod.png",},
	paramtype = "light",
	light_source=minetest.LIGHT_MAX,
  --drop = "wm_mobs:orbital_pod",
	groups = {cracky = 1, not_in_creative_inventory = 1, level = 2},
	--sounds = default.node_sound_metal_defaults(),
  --set up a new node
  on_construct = function(pos)
    --start timer to release
    local MR = random(t10_tme_max/2,t10_tme_max)
    minetest.get_node_timer(pos):start(MR)
  end,

  --Release
	on_timer = function(pos, elapsed)
		minetest.set_node(pos, {name = "air"})
		if random()<0.1 then
			minetest.add_entity(pos, "wm_mobs:t10_oid_hostile")
		end
		local r = 3
		for i = 1, random(1, r_num) do
			local ranpos = {x = pos.x + random(-r,r), y = pos.y + random(-r,2*r), z = pos.z + random(-r,r)}
			if minetest.get_node(ranpos).name == "air" then
				minetest.add_entity(ranpos, "wm_mobs:t"..random(1,max_lvl).."_droid_hostile")
			end
		end
		return false
	end,
})
