
-----------------------------------------------------------

--ammo pack
minetest.register_tool("wm_weapons:energy_module", {
	description = "Energy Module",
	inventory_image = "wm_weapons_energy_module.png",
	on_use = minetest.item_eat(30)
	--stack_max = 1,

})

local em = "wm_weapons:energy_module"

-----------------------------------------------------------
--T1
-- points budget:10

local t1_bullet = "wm_weapons_bullet.png"
local t1_fire = "wm_weapons_laser_1"
local t1_fire_mp = "wm_weapons_laser_1"--"wm_weapons_laser_1b"
local t1_ooa = "wm_weapons_ooa"


--T1 Infantry Rifle
wm_gunslinger.register_gun("wm_weapons:t1_in_rifle", {
	--visuals etc
	itemdef = {
		description = "T1 Infantry Rifle",
		inventory_image = "wm_weapons_t1_in_rifle.png",
		wield_image = "wm_weapons_t1_in_rifle.png",
		wield_scale = {x = 1.5, y = 1.5, z = 1},
	},
	ammo = em,
	bullet = t1_bullet,
	sounds = {
		fire = t1_fire,
		ooa = t1_ooa,
		--load = "",
	},
	--
	mode = "semi-automatic",
	--points
	fire_rate = 1,
	dmg_mult = 2,
	range = 6,
	pellets = 1,
	efficiency = 0,
	spread_mult = 0,
	recoil_mult = 0,
	--scope = "vignette.png",
})







--T1 machinepistol
wm_gunslinger.register_gun("wm_weapons:t1_machinepistol", {
	itemdef = {
		description = "T1 machine-pistol",
		inventory_image = "wm_weapons_t1_machinepistol.png",
		wield_image = "wm_weapons_t1_machinepistol.png",
		wield_scale = {x = 1.5, y = 1.5, z = 1},
	},
	ammo = em,
	bullet = t1_bullet,
	sounds = {
		fire = t1_fire_mp,
		ooa = t1_ooa,
		--load = "",
	},
	--
	mode = "automatic",
	--points
	fire_rate = 3,
	dmg_mult = 3,
	range = 3,
	pellets = 1,
	efficiency = 0,
	spread_mult = 0,
	recoil_mult = 0,
	--scope = "vignette.png",
})


-----------------------------------------------------------
--T2
-- points budget:20

local t2_bullet = "wm_weapons_bullet.png"
local t2_fire = "wm_weapons_laser_2"
local t2_fire_heavy = "wm_weapons_laser_2b"
local t2_ooa = "wm_weapons_ooa"

--T2 Infantry Rifle
wm_gunslinger.register_gun("wm_weapons:t2_in_rifle", {
	--visuals etc
	itemdef = {
		description = "T2 Infantry Rifle",
		inventory_image = "wm_weapons_t2_in_rifle.png",
		wield_image = "wm_weapons_t2_in_rifle.png",
		wield_scale = {x = 1.5, y = 1.5, z = 1},
	},
	ammo = em,
	bullet = t2_bullet,
	sounds = {
		fire = t2_fire,
		ooa = t2_ooa,
		--load = "",
	},
	--
	mode = "semi-automatic",
	--points
	fire_rate = 1,
	dmg_mult = 4,
	range = 12,
	pellets = 1,
	efficiency = 0,
	spread_mult = 2,
	recoil_mult = 0,
	--scope = "vignette.png",
})


--T2 machinepistol
wm_gunslinger.register_gun("wm_weapons:t2_machinepistol", {
	--visuals etc
	itemdef = {
		description = "T2 machine-pistol",
		inventory_image = "wm_weapons_t2_machinepistol.png",
		wield_image = "wm_weapons_t2_machinepistol.png",
		wield_scale = {x = 1.5, y = 1.5, z = 1},
	},
	ammo = em,
	bullet = t2_bullet,
	sounds = {
		fire = t2_fire,
		ooa = t2_ooa,
		--load = "",
	},
	--
	mode = "automatic",
	--points
	fire_rate = 4,
	dmg_mult = 7,
	range = 5,
	pellets = 1,
	efficiency = 1,
	spread_mult = 1,
	recoil_mult = 1,
		--scope = "vignette.png",
})



--T2 Heavy Rifle...boom
wm_gunslinger.register_gun("wm_weapons:t2_heavy_rifle_e", {
	itemdef = {
		description = "T2 Heavy Rifle E",
		inventory_image = "wm_weapons_t2_he_rifle_e.png",
		wield_image = "wm_weapons_t2_he_rifle_e.png",
		wield_scale = {x = 1.5, y = 1.5, z = 1},
	},
	ammo = em,
	bullet = t2_bullet,
	sounds = {
		fire = t2_fire_heavy,
		ooa = t2_ooa,
	},
	--
	mode = "semi-automatic",
	--points
	fire_rate = 0.8,
	dmg_mult = 8.2,
	range = 5,
	pellets = 1,
	efficiency = 1,
	spread_mult = 1,
	recoil_mult = 1,
	--scope = "vignette.png",
	round = "explosive",
	dmg_radius = 1,
	boom_radius = 1,
})


--T2 Heavy Rifle..flame
wm_gunslinger.register_gun("wm_weapons:t2_heavy_rifle_f", {
	itemdef = {
		description = "T2 Heavy Rifle F",
		inventory_image = "wm_weapons_t2_he_rifle_f.png",
		wield_image = "wm_weapons_t2_he_rifle_f.png",
		wield_scale = {x = 1.5, y = 1.5, z = 1},
	},
	ammo = em,
	bullet = t2_bullet,
	sounds = {
		fire = t2_fire_heavy,
		ooa = t2_ooa,
	},
	--
	mode = "semi-automatic",
	--points
	fire_rate = 0.8,
	dmg_mult = 11.2,
	range = 2,
	pellets = 1,
	efficiency = 1,
	spread_mult = 1,
	recoil_mult = 1,
	--scope = "vignette.png",
	round = "incendiary",
	dmg_radius = 1,
	fire_count = 2,
})




-----------------------------------------------------------
--T3
-- points budget:30

local t3_bullet = "wm_weapons_bullet.png"
local t3_fire = "wm_weapons_laser_3"
local t3_fire_sg = "wm_weapons_laser_3b"
local t3_ooa = "wm_weapons_ooa"


--T3 Bolt
wm_gunslinger.register_gun("wm_weapons:t3_bolt", {
	--visuals etc
	itemdef = {
		description = "T3 Bolt",
		inventory_image = "wm_weapons_t3_bolt.png",
		wield_image = "wm_weapons_t3_bolt.png",
		wield_scale = {x = 2, y = 2, z = 1.5},
	},
	ammo = em,
	bullet = t3_bullet,
	sounds = {
		fire = t3_fire,
		ooa = t3_ooa,
		--load = "",
	},
	--
	mode = "automatic",
	--points
	fire_rate = 1.4,
	dmg_mult = 25,
	range = 1.6,
	pellets = 1,
	efficiency = 0,
	spread_mult = 1,
	recoil_mult = 1,
	--scope = "vignette.png",
})


--T3 Blow Torch
wm_gunslinger.register_gun("wm_weapons:t3_blow_torch", {
	--visuals etc
	itemdef = {
		description = "T3 Blow Torch",
		inventory_image = "wm_weapons_t3_blow_torch.png",
		wield_image = "wm_weapons_t3_blow_torch.png",
		wield_scale = {x = 2, y = 2, z = 1.5},
	},
	ammo = em,
	bullet = t3_bullet,
	sounds = {
		fire = t3_fire,
		ooa = t3_ooa,
		--load = "",
	},
	--
	mode = "automatic",
	--points
	fire_rate = 1,
	dmg_mult = 12,
	range = 3,
	pellets = 1,
	efficiency = 1,
	spread_mult = 1,
	recoil_mult = 1,
	--scope = "vignette.png",
	round = "incendiary",
	dmg_radius = 2,
	fire_count = 8,
})


--T3 Shotgun

wm_gunslinger.register_gun("wm_weapons:t3_shotgun", {
	itemdef = {
		description = "T3 Shotgun",
		inventory_image = "wm_weapons_t3_shotgun.png",
		wield_image = "wm_weapons_t3_shotgun.png",
		wield_scale = {x = 1.5, y = 1.5, z = 1},
	},
	ammo = em,
	bullet = t3_bullet,
	sounds = {
		fire = t3_fire_sg,
		ooa = t3_ooa,
		--load = "",
	},
	--
	mode = "semi-automatic",
	--points
	fire_rate = 1,
	dmg_mult = 21,
	range = 2,
	pellets = 3,
	efficiency = 2,
	spread_mult = 0,
	recoil_mult = 1,
	--scope = "vignette.png",
})



-----------------------------------------------------------
--T4: 50
-- points budget:

local t4_bullet = "wm_weapons_bullet.png"
local t4_fire = "wm_weapons_laser_5"
local t4_ooa = "wm_weapons_ooa"


--T4 Hunter
wm_gunslinger.register_gun("wm_weapons:t4_hunter", {
	--visuals etc
	itemdef = {
		description = "T4 Hunter",
		inventory_image = "wm_weapons_t4_hunter.png",
		wield_image = "wm_weapons_t4_hunter.png",
		wield_scale = {x = 2, y = 2, z = 1.5},
	},
	ammo = em,
	bullet = t4_bullet,
	sounds = {
		fire = t4_fire,
		ooa = t4_ooa,
	},
	--
	mode = "semi-automatic",
	--points
	fire_rate = 1,
	dmg_mult = 26,
	range = 20,
	pellets = 1,
	efficiency = 0,
	spread_mult = 2,
	recoil_mult = 0,
	--scope = "vignette.png",
})


-----------------------------------------------------------
--T5
-- points budget:80
local t5_bullet = "wm_weapons_bullet.png"
local t5_fire = "wm_weapons_laser_5"
local t5_ooa = "wm_weapons_ooa"

--T5 Annihilator
wm_gunslinger.register_gun("wm_weapons:t5_annihilator", {
	itemdef = {
		description = "T5 Annihilator",
		inventory_image = "wm_weapons_t5_annihilator.png",
		wield_image = "wm_weapons_t5_annihilator.png",
		wield_scale = {x = 1.5, y = 1.5, z = 1},
	},
	ammo = em,
	bullet = t5_bullet,
	sounds = {
		fire = t5_fire,
		ooa = t5_ooa,
		--load = "",
	},
	--
	mode = "semi-automatic",
	--points
	fire_rate = 2,
	dmg_mult = 40,
	range = 6,
	pellets = 1,
	efficiency = 14,
	spread_mult = 1,
	recoil_mult = 5,
	--scope = "vignette.png",
	round = "explosive",
	dmg_radius = 5,
	boom_radius = 1,
	--round = "incendiary",
	--dmg_radius = 1,
	--fire_count = 2,
})




-----------------------------------------------------------
--T10
-- points budget: 890
local t10_bullet = "wm_weapons_bullet.png"
local t10_fire = "wm_weapons_laser_5"
local t10_ooa = "wm_weapons_ooa"

--T10 Bansaw... cutting saw..basically melee
wm_gunslinger.register_gun("wm_weapons:t10_bansaw", {
	itemdef = {
		description = "T10 Bansaw",
		inventory_image = "wm_weapons_t10_bansaw.png",
		wield_image = "wm_weapons_t10_bansaw.png",
		wield_scale = {x = 2.5, y = 2.5, z = 1.5},
	},
	ammo = em,
	bullet = t10_bullet,
	sounds = {
		fire = t10_fire,
		ooa = t10_ooa,
		--load = "",
	},
	--
	mode = "automatic",
	--points
	fire_rate = 4,
	dmg_mult = 285.6,
	range = 0.4,
	pellets = 1,
	efficiency = 200,
	spread_mult = 200,
	recoil_mult = 198,
	--scope = "vignette.png",
	--round = "explosive",
	--dmg_radius = 1,
	--boom_radius = 1,
	round = "incendiary",
	dmg_radius = 1,
	fire_count = 1,
})
