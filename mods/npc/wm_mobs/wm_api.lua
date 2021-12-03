---------------------------------------
--Mob functions specifically for wm_mobs




local random = math.random
local abs = math.abs
local abr = minetest.get_mapgen_setting('active_block_range')
local time = os.time





----------------------------------------------------
local function drop_item(self, item, chance)

	if not self or not item then
		return
	end

	if random() < chance then

		local pos = self.object:get_pos()
		local drop = minetest.add_item(pos, item)

		if drop and drop:get_luaentity() then

			drop:set_velocity({
				x = random(-10, 10) / 9,
				y = 6,
				z = random(-10, 10) / 9,
			})

		elseif drop then
			drop:remove() -- item does not exist
		end
	end

end

----------------------------------------------------
-- returns near entity friend - or - foe
local function get_nearby_team_entity(self, team, fof)

	for _,obj in ipairs(self.nearby_objects) do

		local luaent = obj:get_luaentity()

		if mobkit.is_alive(obj)
		and not obj:is_player()
		and luaent
		then
			if (fof == "friend" and luaent.team == team)
			or  (fof == "foe" and luaent.team ~= team) then
				return obj
			end
		end
	end
	return
end

-- returns near entity friend - or - foe
local function get_closest_team_entity(self, team, fof)
	local cobj = nil
	local dist = abr*64
	local pos = self.object:get_pos()
	for _,obj in ipairs(self.nearby_objects) do
		local luaent = obj:get_luaentity()
		if mobkit.is_alive(obj)
		and not obj:is_player()
		and luaent then
			if (fof == "friend" and luaent.team == team)
			or  (fof == "foe" and luaent.team ~= team) then
				local opos = obj:get_pos()
				local odist = abs(opos.x-pos.x) + abs(opos.z-pos.z)
				if odist < dist then
					dist=odist
					cobj=obj
				end
			end
		end
	end
	return cobj
end

----------------------------------------------------
-- limited repel
local function hq_repelled(self,prty,tgtobj, min, max)
	mobkit.make_sound(self, 'misc', 0.06, 30)
	local timer = time() + random(min,max)	--  attention span
	local func = function(self)

		if not mobkit.is_alive(tgtobj) then
			return true
		end

		if time() > timer then
			return true
		end

		if mobkit.is_queue_empty_low(self) and self.isonground then

			local pos = mobkit.get_stand_pos(self)
			local opos = tgtobj:get_pos()
			local dist = vector.distance(pos,opos)
			local tpos = {x=2*pos.x - opos.x,
							y=opos.y,
							z=2*pos.z - opos.z}

			if dist < self.view_range/2 then
				mobkit.goto_next_waypoint(self,tpos)
			else
				mobkit.lq_idle(self,1)
				return true
			end
		end
	end
	mobkit.queue_high(self,func,prty)
end

----------------------------------------------------
-- limited attraction
local function hq_attracted(self,prty,tgtobj, min, max)
	mobkit.make_sound(self, 'misc', 0.06, 30)
	local timer = time() + random(min,max)	--  attention span
	local func = function(self)

		if not mobkit.is_alive(tgtobj) then
			return true
		end

		if time() > timer then
			return true
		end

		if mobkit.is_queue_empty_low(self) and self.isonground then
			local pos = mobkit.get_stand_pos(self)
			local pos2 = tgtobj:get_pos()
			local dist = vector.distance(pos,pos2)

			if dist > 3 then
				mobkit.goto_next_waypoint(self,pos2)
			else
				--don't squish
				if random()<0.1 then
					hq_repelled(self,prty,tgtobj, 1, 2)
				else
					mobkit.lq_idle(self,1)
				end
				return true
			end
		end
	end
	mobkit.queue_high(self,func,prty)
end



----------------------------------------------------
--Strategy and Tactics
--


--
--Swarm
--form a group without overcrowding
--also includes upgrade
--
local function hq_swarm(self,prty, min, max)
	local timer = time() + random(min,max)	--  attention span
	local func = function(self)

		if time() > timer then
			return true
		end

		if mobkit.is_queue_empty_low(self) and self.isonground then

			local pos = self.object:get_pos()
			local team = self.team
			local sw_dist = self.swarm_d

			--is anyone here?
			local ally_far = get_nearby_team_entity(self, team, "friend")
			if not ally_far then
				return true
			end
			local ally_near = get_closest_team_entity(self, team, "friend")


			--decide if going to respond to near or far
			if random() < 0.3 then

				local pos_f = ally_far:get_pos()

				--can't see them can't follow them
				--[[--too much performance cost for too little?
				if not minetest.line_of_sight(pos, pos_f) then
					return true
				end]]

				local dist_f = vector.distance(pos,pos_f)

				if ally_near ~= ally_far then
					if dist_f < sw_dist * 3 then
						--too close, getting crowded.
						hq_repelled(self,prty,ally_far, 2, 5)
						return true
					else
						-- too far... getting exposed.
						hq_attracted(self,prty,ally_far, 5, 10)
						--seeing as we are approaching...ask them for an objective
						--share_obj(self, ally_near)
						return true
					end
				end
			else

				local pos_n = ally_near:get_pos()
				--can't see them can't follow them
				--[[--too much performance cost for too little?
				if not minetest.line_of_sight(pos, pos_n) then
					return true
				end
				]]

				local dist_n = vector.distance(pos,pos_n)

				if dist_n <= sw_dist then
					if dist_n <= 1.5 and random()<0.1 then
						--merge
						--merge_droid(self,ally_near)
						return true
					else
						hq_repelled(self,prty,ally_near, 5, 10)
						return true
					end
				else
					hq_attracted(self,prty,ally_near, 2, 5)
					--seeing as we are approaching...ask them for an objective
					--share_obj(self, ally_near)
					return true
				end

			end

		else
			return true
		end
	end
	mobkit.queue_high(self,func,prty)
end





----------------------------------------------------
--Ranged Attacks ...using gunslinger

--
--Read weapon
--
local function get_gun(self)
	local weapon = self.weapon

	if not weapon then
		return nil
	end


	local weapon_def = wm_gunslinger.__guns[weapon]
	return weapon_def
end




--
--Combat
--does the whole ranged attack sequence, not just pulling trigger.
--
local function hq_fire_fight(self, target, prty)
	--  attention span..because they seem to get stuck
	local timer = time() + random(10,30)

	--first check if we are even up to the fight.
	local hp = self.hp
	local min_hp = self.max_hp/10

	if hp < min_hp then
		--about to die, so forget everything else and run
		--run from a fight coming your way that you can't win
		mobkit.clear_queue_high(self)
		mobkit.hq_runfrom(self,prty,target)
		return true
	end



	local func = function(self)
		if time() > timer then
			return true
		end

		if not mobkit.is_alive(target) then
			return true
		end

		local weapon_def = get_gun(self)
		--no weapon... just hunt (shouldn't have been called, or weapon assigned bugged)
		if not weapon_def then
			mobkit.hq_hunt(self,25,target)
			return true
		end


		if mobkit.is_queue_empty_low(self) then

			--get target position
			local pos = self.object:get_pos()
			--pos.y = pos.y + (self.collisionbox[5]/2)
			pos.y = pos.y + 0.5
			local pos2 = target:get_pos()
			--vary where to go for
			--otherwise can't hit in water, ...a bit crude
			pos2.y = pos2.y + random(0.5,0.75)
			local dist = vector.distance(pos,pos2)


			--too far to see it.
			if dist > self.view_range then
				hq_attracted(self,21,target, 5, 10)
				return true
			end

			local range = weapon_def.range

			--too far to see hit it.
			if dist > range then
				hq_attracted(self,21,target,1,5)
				return true
			end

			--can't see it.
			if not minetest.line_of_sight(pos, pos2) then
				--chance to approach
				--vs give up... help stop pile ups
				if random()<0.75 then
					hq_attracted(self,prty,target,1,3)
					return true
				else
					hq_repelled(self,prty,target, 2, 15)
					return true
				end
			end

			--close combat... go melee.
			--dist to match limit
			if dist < 2 then
				--chance to lunge and strike
				--vs back away (and shoot or escape).
				--help stop melee pile ups.
				if random()<0.5 then
					hq_repelled(self,prty,target, 1, 15)
					return true
				else
					mobkit.make_sound(self, 'attack', 2, 30)
					mobkit.make_sound(self, 'misc', 0.6, 10)
					mobkit.hq_attack(self,20,target)
					return true
				end
			end

			--Good to pull the trigger
			if random()< 0.15 then
				local rate = 1/weapon_def.fire_rate
				--don't fire if already doing so
				if self.firing ~= "firing" or not self.firing then
					mobkit.make_sound(self, 'misc', 0.5, 10)
					mobkit.lq_turn2pos(self,pos2)
					mobkit.animate(self,"fire")

					self.firing = "firing"
					--wait for gun to go through mechanisms and fire
					minetest.after(rate, function(self, weapon_def, pos, pos2)
						wm_gunslinger.mob_fire(weapon_def,self, pos, pos2)
						self.firing = ""
					end, self, weapon_def, pos, pos2)
				end
			end


			--follow up... co-ordinate
			--if random()<0.1 then
			--advanc/retreat by hp left
			--	hq_fireteam(self, pos, target, prty, 2, 30)
			--end

		end
	end

	mobkit.queue_high(self,func,prty)
end



----------------------------------------------------
--Death
--

-- Drop Weapon on death
--
local function drop_gun(self)

	local gun = self.weapon

	if not gun then
		return
	end

	drop_item(self, gun, 0.15)
	drop_item(self, "wm_weapons:energy_module", 0.15)

end



----------------------------------------------------
--
--Replace
-- try change it a node to something
--

local function hq_replace_node(self, prty, rate, replace)

	local func = function(self)

		if random() < rate then
				if mobkit.is_queue_empty_low(self) and self.isonground then

				mobkit.lq_idle(self,6)

				local pos = mobkit.get_stand_pos(self)

				--replace
				local what, with, y_offset
				local num = math.random(#replace)
				what = replace[num][1] or ""
				with = replace[num][2] or ""
				y_offset = replace[num][3] or 0
				pos.y = pos.y + y_offset
				if #minetest.find_nodes_in_area(pos, pos, what) > 0 and not minetest.is_protected(pos, "") then
					minetest.set_node(pos, {name = with})
					mobkit.make_sound(self, 'misc', 0.3, 5)
					return true
				else
					return true
				end
			else
				return true
			end
		end

	end
	mobkit.queue_high(self,func,prty)
end



----------------------------------------------------
--YOU HIT ME!
----------------------------------------------------
local function hit_damage(self,tool_capabilities)

	--how well it's soft bits are protected
	local ar = self.armor_groups.fleshy/100

	local fleshy_dmg = tool_capabilities.damage_groups.fleshy*ar
	mobkit.hurt(self,fleshy_dmg)
	mobkit.make_sound(self,'hurt')

end



function wm_mobs.on_punch(self, tool_capabilities, puncher, dir, prty)
  if mobkit.is_alive(self) then
    --do damage
    mobkit.clear_queue_high(self)
    mobkit.hurt(self,tool_capabilities.damage_groups.fleshy or 1)
    mobkit.make_sound(self,'punch')

		--kick back
		local hvel = vector.multiply(vector.normalize({x=dir.x,y=0,z=dir.z}),4)
		self.object:set_velocity({x=hvel.x,y=2,z=hvel.z})

    --fight or flight
    --flee if hurt
    if self.hp < self.max_hp/10 then
      mobkit.animate(self,'fast')
      mobkit.make_sound(self,'warn')
      mobkit.hq_runfrom(self, prty, puncher)
    end

		if puncher:is_player() then
			--friendly don't fight the player
			if team == "friendly" then
				--mobkit.clear_queue_high(self)
				mobkit.hq_runfrom(self,20,puncher)


			elseif team == "hostile" then
				--mobkit.clear_queue_high(self)
				hq_fire_fight(self, puncher, 25)
			end
			return
		end

		local punch_team
		local p_obj = puncher:get_luaentity()
		if p_obj ~= 'nil' then
			punch_team = p_obj.team

			if punch_team == team then
				--don't fight your mates
				--mobkit.clear_queue_high(self)
				mobkit.hq_runfrom(self,20,puncher)
				return
			elseif punch_team ~= team then
				--fight back
				--mobkit.clear_queue_high(self)
				hq_fire_fight(self, puncher, 25)
				return
			end
		end




  end
end

--[[
function wm_mobs.punch_mob(self, puncher, time_from_last_punch, tool_capabilities, dir)
	if not self then
		return
	end

	if mobkit.is_alive(self) then

		--kick back
		local hvel = vector.multiply(vector.normalize({x=dir.x,y=0,z=dir.z}),4)
		self.object:set_velocity({x=hvel.x,y=2,z=hvel.z})

		--do damage.
		hit_damage(self,tool_capabilities)

		local team = self.team


		if puncher:is_player() then
			--friendly don't fight the player
			if team == "friendly" then
				--mobkit.clear_queue_high(self)
				mobkit.hq_runfrom(self,20,puncher)


			elseif team == "hostile" then
				--mobkit.clear_queue_high(self)
				hq_fire_fight(self, puncher, 25)
			end
			return
		end

		local punch_team
		local p_obj = puncher:get_luaentity()
		if p_obj ~= 'nil' then
			punch_team = p_obj.team

			if punch_team == team then
				--don't fight your mates
				--mobkit.clear_queue_high(self)
				mobkit.hq_runfrom(self,20,puncher)
				return
			elseif punch_team ~= team then
				--fight back
				--mobkit.clear_queue_high(self)
				hq_fire_fight(self, puncher, 25)
				return
			end
		end
	end
end
]]
----------------------------------------------------
local function on_death(self)
	-- cease all activity
	mobkit.clear_queue_high(self)
	mobkit.hq_die(self)

	drop_gun(self)

	local pos1 = self.object:get_pos()
	if minetest.get_node(pos1, {name= "air"}) then
		minetest.set_node(pos1, {name = "wm_mobs:body"})
		minetest.check_for_falling(pos1)
		mobkit.make_sound(self, 'die', 0.5, 20)
	end

end


----------------------------------------------------
--BRAINS.... BRAINS....
----------------------------------------------------

----------------------------------------------------
--Just your regular cannon fodder
function wm_mobs.basic_droid_brain(self)
	local hp = self.hp
	-- vitals should be checked every step
	--died
	if hp <= 0 then
		on_death(self)
	end


	-- decision making
	if mobkit.timer(self,1) then
		local prty = mobkit.get_queue_priority(self)

		--get out of water
		if prty < 50 and self.isinliquid then
			--still need a chance of fighting so..
			if random()<0.8 then
				mobkit.hq_liquid_recovery(self,50)
				return
			end
		end


		local pos=self.object:get_pos()
		local team = self.team



		--nothing going on... so, fight/follow sequence
		if prty < 20 then

			--[[if you have an objective deal with it
			--ignoring who ever is around...
			--i.e. bloody minded focus on getting to position
			if random() < 0.1 then
				hq__proc_objective(self,10, 2,6)
				return
			end]]

			--scan for player
			local plyr=mobkit.get_nearby_player(self)
			--scan for enemy entities
			local en_ent = get_closest_team_entity(self, team, "foe")

			--attack first...
			if plyr or en_ent then

				--only hostile shoots at player
				if team == "hostile" then

					if en_ent and plyr then
						--choose which to shoot.
						if random() < 0.5 then

							--fire at player
							hq_fire_fight(self, plyr, 25)
							return
						else
							--fire at entity
							hq_fire_fight(self, en_ent, 25)
							return
						end
					elseif plyr then
						--only player here. fire at player
						hq_fire_fight(self, plyr, 25)
						return
					end
				end

				--friendlies, or only entities around.
				--shoot at enemy entity
				if en_ent then
					hq_fire_fight(self, en_ent, 25)
					return
				end
			end

			--second, huddle...should only get here if no one to shoot
			--swarm, roam, or stand at attention
			local swarm_chance = 0.3
			local roam_chance = 0.1
			--swarming for friendly ...follow the player
			--maybe add some way for player to adjust chance of them following them
			if team == "friendly" then
				if random() < swarm_chance then
					if plyr and random() < 0.15 then
						hq_attracted(self,2,plyr,12,30)
						return
					else
						hq_swarm(self,15, 11, 30)
						return
					end
				else
					mobkit.lq_idle(self,1)
					return
				end
			elseif random() < swarm_chance then
				hq_swarm(self,15, 11, 30)
				return
			else
				mobkit.lq_idle(self,1)
				return
			end

			--shouldn't get here...
			return
		end

		if mobkit.is_queue_empty_high(self) then
				mobkit.roam(self, 1)
		end
	end
end



----------------------------------------------------
--T10 OID
function wm_mobs.t10_oid_brain(self)
	local hp = self.hp
	-- vitals should be checked every step
	--died
	if hp <= 0 then
		on_death(self)
		return
	end


	-- decision making...
	if mobkit.timer(self,2) then
		local prty = mobkit.get_queue_priority(self)

		--get out of water
		if prty < 50 and self.isinliquid then
			mobkit.hq_liquid_recovery(self,50)
			return
		end


		local pos=self.object:get_pos()
		local team = self.team

		--nothing going on... so, fight/follow sequence
		if prty < 20 then
			--scan for player
			local plyr=mobkit.get_nearby_player(self)
			--scan for enemy entities
			local en_ent = get_nearby_team_entity(self, team, "foe")


			if (team == "hostile" and not en_ent and not plyr)
			or (team == "friendly" and not en_ent) then
				--No enemies around
				--Build scanner and remove itself
				if mobkit.is_queue_empty_low(self) and self.isonground then
					if random()< 0.05 then
						if minetest.get_node(pos, {name= "air"}) then
							minetest.set_node(pos, {name = "wm_mobs:tts_"..team})

							mobkit.clear_queue_high(self)
							self.object:remove()
							mobkit.make_sound(self, 'alert', 1, 20)
							mobkit.make_sound(self, 'misc', 0.5, 20)
							return
						end
					elseif random()< 0.2 then
						--do building
						local replace = {
							{"group:crumbly", "wm_blocks:bunker", -1},
							{"group:crumbly", "wm_blocks:bunker", -1},
							{"air", "wm_blocks:sandbags", 0},
							{"group:snappy", "wm_blocks:wire", 0},
						}
						hq_replace_node(self,25, 0.7, replace)
						return
					else
						mobkit.hq_roam(self,0)
						return
					end
				end

			else

				--attack first...
				if plyr or en_ent then

					--only hostile shoots at player
					if team == "hostile" then
						if en_ent and plyr then
							--choose which to shoot.
							if random() < 0.5 then
								--try to avoid fights
								if random()<0.8 then
									hq_repelled(self,25,plyr, 10, 30)
									return
								else
									--fire at player
									hq_fire_fight(self, plyr, 25)
									return
								end
							else
								--try to avoid fights
								if random()<0.8 then
									hq_repelled(self,25,en_ent, 10, 30)
									return
								else
									--fire at entity
									hq_fire_fight(self, en_ent, 25)
									return
								end
							end
						elseif plyr then
							--try to avoid fights
							if random()<0.8 then
								hq_repelled(self,25,plyr, 10, 30)
								return
							else
								--fire at player
								hq_fire_fight(self, plyr, 25)
								return
							end
						end
					end

					--friendlies, or only entities around.
					--shoot at enemy entity
					if en_ent then
						--try to avoid fights
						if random()<0.8 then
							hq_repelled(self,25,en_ent, 10, 30)
							return
						else
							--fire at entity
							hq_fire_fight(self, en_ent, 25)
							return
						end
					end
				end
			end
		end


		if mobkit.is_queue_empty_high(self) then
			mobkit.hq_roam(self,0)
		end
	end
end
