----------------------------------------------------
--T3 Droid
----------------------------------------------------



----------------------------------------------------
--Hostile
minetest.register_entity("wm_mobs:t3_droid_hostile",{
	-- required minetest api props
	team = "hostile",
	level = 3,
	physical = true,
	stepheight = 0.35,
	collide_with_objects = true,
	collisionbox = {-0.34, -0.95, -0.34, 0.34, 0.72, 0.34},
	visual = "mesh",
	mesh = "t1_droid.b3d",
	textures = {"wm_mobs_t1_droid_1.png"},
	visual_size = {x = 1, y = 1},
	makes_footstep_sound = true,

	-- required wm_mobs props
	timeout = 0,			-- entities are removed after this many seconds inactive
								-- 0 is never
								-- mobs having memory entries are not affected

	buoyancy = 1,			-- (0,1) - portion of collisionbox submerged
								-- = 1 - controlled buoyancy (fish, submarine)
								-- > 1 - drowns
								-- < 0 - MC like water trampolining

	lung_capacity = 80, 		-- seconds
	max_hp = minetest.PLAYER_MAX_HP_DEFAULT * 3,
	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,
	brainfunc = wm_mobs.basic_droid_brain,

	animation = {
		walk={range={x=41,y=101},speed=60,loop=true},
		stand={range={x=0,y=40},speed=1,loop=true},
		fire={range={x=0,y=40},speed=1,loop=true},
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
	springiness= 0,
	max_speed = 3,					-- m/s
	jump_height = 2.5,				-- nodes/meters
	view_range = 45,					-- nodes/meters
	swarm_d = 4,				-- distance between droids
	attack={range=0.5,damage_groups={fleshy=7}},
	armor_groups = {fleshy=90},
	weapon = "wm_weapons:t3_blow_torch",

	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		wm_mobs.on_punch(self, tool_capabilities, puncher, dir, 55)
	end,

})


wm_mobs.register_egg("wm_mobs:t3_droid_hostile", "Hostile T3 Droid", "wm_mobs_spawn_egg_t3.png", 0)




----------------------------------------------------
--Friendly
minetest.register_entity("wm_mobs:t3_droid_friendly",{
	-- required minetest api props
	team = "friendly",
	level = 3,
	physical = true,
	stepheight = 0.35,
	collide_with_objects = true,
	collisionbox = {-0.34, -0.95, -0.34, 0.34, 0.72, 0.34},
	visual = "mesh",
	mesh = "t1_droid.b3d",
	textures = {"wm_mobs_t1_droid_2.png"},
	visual_size = {x = 1, y = 1},
	makes_footstep_sound = true,

	-- required wm_mobs props
	timeout = 0,			-- entities are removed after this many seconds inactive
								-- 0 is never
								-- mobs having memory entries are not affected

	buoyancy = 1,			-- (0,1) - portion of collisionbox submerged
								-- = 1 - controlled buoyancy (fish, submarine)
								-- > 1 - drowns
								-- < 0 - MC like water trampolining

	lung_capacity = 80, 		-- seconds
	max_hp = minetest.PLAYER_MAX_HP_DEFAULT * 3,
	on_step = mobkit.stepfunc,
	on_activate = mobkit.actfunc,
	get_staticdata = mobkit.statfunc,
	brainfunc = wm_mobs.basic_droid_brain,

	animation = {
		walk={range={x=41,y=101},speed=60,loop=true},
		stand={range={x=0,y=40},speed=1,loop=true},
		fire={range={x=0,y=40},speed=1,loop=true},
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
	springiness= 0,
	max_speed = 3,					-- m/s
	jump_height = 2.5,				-- nodes/meters
	view_range = 45,					-- nodes/meters
	swarm_d = 4,				-- distance between droids
	attack={range=0.5,damage_groups={fleshy=7}},
	armor_groups = {fleshy=90},
	weapon = "wm_weapons:t3_shotgun",

	on_punch = function(self, puncher, time_from_last_punch, tool_capabilities, dir)
		wm_mobs.on_punch(self, tool_capabilities, puncher, dir, 55)
	end,
	on_rightclick = wm_mobs.capture, --only for friendly!
})


wm_mobs.register_egg("wm_mobs:t3_droid_friendly", "Friendly T3 Droid", "wm_mobs_spawn_egg_t3.png", 0)
