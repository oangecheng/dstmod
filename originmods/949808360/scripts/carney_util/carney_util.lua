local ThePlayer = GLOBAL.ThePlayer
local TheInput = GLOBAL.TheInput
local TheNet = GLOBAL.TheNet
local cst = GLOBAL.STRINGS.CARNEYSTRINGS
local SpawnPrefab = GLOBAL.SpawnPrefab

AddModRPCHandler(modname, "Check", function(player)
	if not player:HasTag("playerghost") and player.components.carneystatus then
		player.components.talker:Say("lv "..(player.components.carneystatus.level).."  ".."exp "..(math.floor(player.components.carneystatus.exp)).."/"..(player.components.carneystatus.maxexp))
    end
end)

local KEY_K = GLOBAL.KEY_K
AddModRPCHandler(modname, "K", function(player)
	if not player:HasTag("playerghost") and player.components.carneystatus then
		--player.components.talker:Say("dd "..(GLOBAL.CONTROL_SECONDARY))
		--SpawnPrefab("seffc").entity:SetParent(player.entity)
	end
end)

AddModRPCHandler(modname, "Dodge", function(player)
	if not player:HasTag("playerghost") and player.components.carneystatus then
		local missactioning = player.components.carneystatus.missactioning
		if missactioning == 0 then
			if not player.sg:HasStateTag("busy") and not player.components.rider:IsRiding() then
				player.AnimState:PlayAnimation("jumpout")
				player.sg.statemem.action = player.bufferedaction
				player.sg:SetTimeout(.7)
				SpawnPrefab("bee_poof_big").Transform:SetPosition(player.Transform:GetWorldPosition())
				player.components.carneystatus.missactioning = 1

				if TUNING.crossedge then
					player.Physics:ClearCollisionMask()
					player.Physics:CollidesWith(GLOBAL.COLLISION.GROUND)
					player.Physics:CollidesWith(GLOBAL.COLLISION.CHARACTERS)
	    			player.Physics:CollidesWith(GLOBAL.COLLISION.GIANTS)
	    		else
	    			--GLOBAL.ChangeToGhostPhysics(player)
	    			player.Physics:ClearCollisionMask()
					player.Physics:CollidesWith(GLOBAL.COLLISION.GROUND)
					player.Physics:CollidesWith(GLOBAL.COLLISION.CHARACTERS)
	    			player.Physics:CollidesWith(GLOBAL.COLLISION.GIANTS)
	    			player.Physics:CollidesWith(GLOBAL.COLLISION.WORLD)
	    			--player.Physics:CollidesWith(GLOBAL.COLLISION.OBSTACLES)
	    			--player.Physics:CollidesWith(GLOBAL.COLLISION.SMALLOBSTACLES)
	    		end
				local x1,y1,z1 = player.Transform:GetWorldPosition()

				local w = player.components.carneystatus.speedwalk
				local r = player.components.carneystatus.speedrun
				for i=1, 25 do
					player:DoTaskInTime(i/25*.8, function()
						player.components.locomotor.walkspeed = w*(1+(25-i+1)/25)
						player.components.locomotor.runspeed = r*(1+(25-i+1)/25)
					end)
				end

				player.components.carneystatus.miss = 1
				local level = player.components.carneystatus.level
				if level > 100 then level = 100 end
				player:DoTaskInTime(.35+level/100*.35, function()
					player.components.carneystatus.miss = 0
				end)

				player:DoTaskInTime(.6, function()
					GLOBAL.ChangeToCharacterPhysics(player)
					local x2,y2,z2 = player.Transform:GetWorldPosition()

					if GLOBAL.TheWorld.Map:IsPassableAtPoint(x1, 0, z1)
					or GLOBAL.TheWorld.Map:IsPassableAtPoint(x1-1, 0, z1)
					or GLOBAL.TheWorld.Map:IsPassableAtPoint(x1, 0, z1-1)
					or GLOBAL.TheWorld.Map:IsPassableAtPoint(x1+1, 0, z1)
					or GLOBAL.TheWorld.Map:IsPassableAtPoint(x1, 0, z1+1) then
						if not GLOBAL.TheWorld.Map:IsPassableAtPoint(x2, 0, z2) and TUNING.crossedge then
							player:DoTaskInTime(.1, function()
								player.Transform:SetPosition(x1, 0, z1)
							end)
							SpawnPrefab("spawn_fx_medium").Transform:SetPosition(x1, 0, z1)
							SpawnPrefab("spawn_fx_medium").Transform:SetPosition(x2, 0, z2)
						end
					else
						if GLOBAL.TheWorld.Map:IsOceanAtPoint(x1, 0, z1) then
							if not GLOBAL.TheWorld.Map:IsPassableAtPoint(x2, 0, z2) and TUNING.crossedge then
								player:DoTaskInTime(.1, function()
									player.components.drownable:OnFallInOcean()
								end)
							end
						end
					end
				end)

				player:DoTaskInTime(.7, function()
					player.components.locomotor.walkspeed = w
					player.components.locomotor.runspeed = r
					if player.components.locomotor.wantstomoveforward then
						player.AnimState:PlayAnimation("run_loop", true)
					else
						if not player.sg:HasStateTag("busy") and not player.sg:HasStateTag("doing") then
							player.sg:GoToState("idle")
						end
					end
				end)

				player:DoTaskInTime(.9, function()
					player.components.carneystatus.missactioning = 0
				end)
			end
		end
	end
end)

AddModRPCHandler(modname, "Charge", function(player)
	if not player:HasTag("playerghost") and player.components.carneystatus then
		if player.components.carneystatus.power == 0 then
	        player.components.carneystatus:powerready()
	    end
	end
end)

AddModRPCHandler(modname, "Icicle", function(player)
	if not player:HasTag("playerghost") and player.components.carneystatus then
		player.components.carneystatus:spelldone()
	end
end)

local carney_handlers = {}
AddPlayerPostInit(function(inst)
	inst:DoTaskInTime(0, function()
		if inst == GLOBAL.ThePlayer then
			if inst.prefab == "carney" then
				carney_handlers[0] = TheInput:AddKeyDownHandler(TUNING.CheckKey, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
            			SendModRPCToServer(MOD_RPC[modname]["Check"])
            		end
				end)
				carney_handlers[1] = TheInput:AddKeyDownHandler(KEY_K, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
						SendModRPCToServer(MOD_RPC[modname]["K"])
					end
				end)
				carney_handlers[2] = TheInput:AddKeyDownHandler(TUNING.DodgeKey, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
						SendModRPCToServer(MOD_RPC[modname]["Dodge"])
						if not GLOBAL.ThePlayer:HasTag("playerghost") and GLOBAL.ThePlayer.cmissactioning:value() == 0 then
							if not GLOBAL.ThePlayer:HasTag("busy") and not GLOBAL.ThePlayer.replica.rider._isriding:value() then
								--if GLOBAL.ThePlayer.components.locomotor and GLOBAL.ThePlayer.components.locomotor.wantstomoveforward then
								GLOBAL.ThePlayer.AnimState:PlayAnimation("jumpout")
								--end
								--GLOBAL.ThePlayer.sg.statemem.action = GLOBAL.ThePlayer.bufferedaction
								--GLOBAL.ThePlayer.sg:SetTimeout(.7)
								GLOBAL.ThePlayer:DoTaskInTime(.7, function()
									if GLOBAL.ThePlayer.components.locomotor and GLOBAL.ThePlayer.components.locomotor.wantstomoveforward then
										GLOBAL.ThePlayer.AnimState:PlayAnimation("run_loop", true)
									else
										if not GLOBAL.ThePlayer:HasTag("busy") and not GLOBAL.ThePlayer:HasTag("doing") then
											--GLOBAL.ThePlayer.sg:GoToState("idle")
										end
									end
								end)
							end
						end
					end
				end)
				carney_handlers[3] = TheInput:AddKeyDownHandler(TUNING.ChargeKey, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
            			SendModRPCToServer(MOD_RPC[modname]["Charge"])
            		end
				end)
				carney_handlers[4] = TheInput:AddKeyDownHandler(TUNING.IcicleKey, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
            			SendModRPCToServer(MOD_RPC[modname]["Icicle"])
            		end
				end)
			else
				carney_handlers[0] = nil
				carney_handlers[1] = nil
				carney_handlers[2] = nil
				carney_handlers[3] = nil
				carney_handlers[4] = nil
			end
		end
	end)
end)