----------------------------------------------------
--T12 Orbital Invasion Droid (oid)
----------------------------------------------------



----------------------------------------------------
--Hostile
minetest.register_entity("wm_mobs:t10_oid_hostile",{
	-- required minetest api props
	team = "hostile",
	physical = true,
	level = 10,
	stepheight = 0.5,
	collide_with_objects = true,
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	visual = "mesh",
	mesh = "t10_oid.b3d",
	textures = {"wm_mobs_t10_oid_1.png"},
	visual_size = {x = 1.3, y = 1.3},
	makes_footstep_sound = true,

	-- required wm_mobs props
	timeout = 0,			-- entities are removed after this many seconds inactive
								-- 0 is never
								-- mobs having memory entries are not affected

	buoyancy = 0.3,			-- (0,1) - portion of collisionbox submerged
								-- = 1 - controlled buoyancy (fish, submarine)
								-- > 1 - drowns
								-- < 0 - MC like water trampolining

	lung_capacity = 200, 		-- seconds
	max_hp = minetest.PLAYER_MAX_HP_DEFAULT * 89,
	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,
	brainfunc = wm_mobs.t10_oid_brain,

	animation = {
		walk={range={x=51,y=52},speed=10,loop=true},
		--walk={range={x=32,y=49},speed=10,loop=true},
		stand={range={x=20,y=30},speed=1,loop=true},
		fire={range={x=20,y=30},speed=1,loop=true},
	},

	sounds = {
		attack = 'wm_mobs_robot_attack',
		misc = 'wm_mobs_robot_misc',
		warn = 'wm_mobs_robot_warn',
		hurt = 'wm_mobs_robot_hurt',
		--charge ="",
		scared = 'wm_mobs_robot_warn',
		die = 'wm_mobs_robot_die',
		alert = 'wm_mobs_alert_beep'
	},
	springiness= 0.1,
	max_speed = 5,					-- m/s
	jump_height = 3,				-- nodes/meters
	view_range = 20,					-- nodes/meters
	attack={range=0.6,damage_groups={fleshy=199}},
	armor_groups = {fleshy=40},
	weapon = "wm_weapons:t10_bansaw",

	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		wm_mobs.on_punch(self, tool_capabilities, puncher, dir, 55)
	end,
})


wm_mobs.register_egg("wm_mobs:t10_oid_hostile", "Hostile T10 OID", "wm_mobs_spawn_egg_oid.png", 0)




----------------------------------------------------
--Friendly

minetest.register_entity("wm_mobs:t10_oid_friendly",{
	-- required minetest api props
	team = "friendly",
	level = 10,
	physical = true,
	stepheight = 0.5,
	collide_with_objects = true,
	collisionbox = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
	visual = "mesh",
	mesh = "t10_oid.b3d",
	textures = {"wm_mobs_t10_oid_2.png"},
	visual_size = {x = 1.3, y = 1.3},
	makes_footstep_sound = true,

	-- required wm_mobs props
	timeout = 0,			-- entities are removed after this many seconds inactive
								-- 0 is never
								-- mobs having memory entries are not affected

	buoyancy = 0.3,			-- (0,1) - portion of collisionbox submerged
								-- = 1 - controlled buoyancy (fish, submarine)
								-- > 1 - drowns
								-- < 0 - MC like water trampolining

	lung_capacity = 200, 		-- seconds
	max_hp = minetest.PLAYER_MAX_HP_DEFAULT * 89,
	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,
	brainfunc = wm_mobs.t10_oid_brain,

	animation = {
		walk={range={x=51,y=52},speed=10,loop=true},
		--walk={range={x=32,y=49},speed=10,loop=true},
		stand={range={x=20,y=30},speed=1,loop=true},
		fire={range={x=20,y=30},speed=1,loop=true},
	},

	sounds = {
		attack = 'wm_mobs_robot_attack',
		misc = 'wm_mobs_robot_misc',
		warn = 'wm_mobs_robot_warn',
		hurt = 'wm_mobs_robot_hurt',
		--charge ="",
		scared = 'wm_mobs_robot_warn',
		die = 'wm_mobs_robot_die',
		alert = 'wm_mobs_alert_beep',
	},
	springiness= 0.1,
	max_speed = 5,					-- m/s
	jump_height = 3,				-- nodes/meters
	view_range = 20,					-- nodes/meters
	attack={range=0.6,damage_groups={fleshy=199}},
	armor_groups = {fleshy=40},
	weapon = "wm_weapons:t10_bansaw",

	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		wm_mobs.on_punch(self, tool_capabilities, puncher, dir, 55)
	end,
	on_rightclick = wm_mobs.capture, --only for friendly!
})


wm_mobs.register_egg("wm_mobs:t10_oid_friendly", "Friendly T10 OID", "wm_mobs_spawn_egg_oid.png", 0)
