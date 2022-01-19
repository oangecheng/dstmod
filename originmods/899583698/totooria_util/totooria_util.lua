local ThePlayer = GLOBAL.ThePlayer
local TheInput = GLOBAL.TheInput
local TheNet = GLOBAL.TheNet
local ttrstrs = GLOBAL.STRINGS.TTRSTRINGS
local SpawnPrefab = GLOBAL.SpawnPrefab

local KEY_J = GLOBAL.KEY_J
AddModRPCHandler(modname, "J", function(player)
	if not player:HasTag("playerghost") and player.prefab == "totooria" then
		local damagemult = math.ceil((TUNING.WENDY_DAMAGE_MULT * (1 + player.components.totooriastatus.gongjili/20) * ((player.components.health.maxhealth - player.components.health.currenthealth)/100*player.components.totooriastatus.yonggan + 1))*100)
		player.components.talker:Say(ttrstrs[17]..ttrstrs[18]..(player.components.totooriastatus.dengji).."  "..ttrstrs[34]..(player.components.totooriastatus.jinengdian).."  "..ttrstrs[49]..(player.components.totooriastatus.exp).."\n"..ttrstrs[19]..(10*player.components.totooriastatus.xingyun)..ttrstrs[20].."  "..ttrstrs[21]..(damagemult)..ttrstrs[20].."\n"..ttrstrs[22]..(2.5*player.components.totooriastatus.sudu)..ttrstrs[20].."  "..ttrstrs[23]..(6.25*player.components.totooriastatus.xueliang))
    end
end)

local KEY_UP = GLOBAL.KEY_UP
AddModRPCHandler(modname, "UP", function(player)
	if not player:HasTag("playerghost") and player.prefab == "totooria" then
		if player.components.totooriastatus.jinengdian > 0 then
				player.components.totooriastatus.jinengdian = player.components.totooriastatus.jinengdian - 1
				player.components.totooriastatus.xingyun = player.components.totooriastatus.xingyun + 1
				if player.components.totooriastatus.yijiajineng == 0 then
					player.components.totooriastatus.tintdata01 = 4
				end
				if player.components.totooriastatus.yijiajineng == 1 then
					player.components.totooriastatus.tintdata02 = 4
				end
				if player.components.totooriastatus.yijiajineng == 2 then
					player.components.totooriastatus.tintdata03 = 4
				end
				if player.components.totooriastatus.yijiajineng == 3 then
					player.components.totooriastatus.tintdata04 = 4
				end
				if player.components.totooriastatus.yijiajineng == 4 then
					player.components.totooriastatus.tintdata05 = 4
				end
				if player.components.totooriastatus.yijiajineng == 5 then
					player.components.totooriastatus.tintdata06 = 4
				end
				if player.components.totooriastatus.yijiajineng == 6 then
					player.components.totooriastatus.tintdata07 = 4
				end
				if player.components.totooriastatus.yijiajineng == 7 then
					player.components.totooriastatus.tintdata08 = 4
				end
				if player.components.totooriastatus.yijiajineng == 8 then
					player.components.totooriastatus.tintdata09 = 4
				end
				if player.components.totooriastatus.yijiajineng == 9 then
					player.components.totooriastatus.tintdata10 = 4
				end
				if player.components.totooriastatus.yijiajineng == 10 then
					player.components.totooriastatus.tintdata11 = 4
				end
				if player.components.totooriastatus.yijiajineng == 11 then
					player.components.totooriastatus.tintdata12 = 4
				end
				if player.components.totooriastatus.yijiajineng == 12 then
					player.components.totooriastatus.tintdata13 = 4
				end
				if player.components.totooriastatus.yijiajineng == 13 then
					player.components.totooriastatus.tintdata14 = 4
				end
				if player.components.totooriastatus.yijiajineng == 14 then
					player.components.totooriastatus.tintdata15 = 4
				end
				if player.components.totooriastatus.yijiajineng == 15 then
					player.components.totooriastatus.tintdata16 = 4
				end
				if player.components.totooriastatus.yijiajineng == 16 then
					player.components.totooriastatus.tintdata17 = 4
				end
				if player.components.totooriastatus.yijiajineng == 17 then
					player.components.totooriastatus.tintdata18 = 4
				end
				if player.components.totooriastatus.yijiajineng == 18 then
					player.components.totooriastatus.tintdata19 = 4
				end
				if player.components.totooriastatus.yijiajineng == 19 then
					player.components.totooriastatus.tintdata20 = 4
				end
				player.components.totooriastatus.yijiajineng = player.components.totooriastatus.yijiajineng + 1
				player.components.talker:Say(ttrstrs[24].."\n"..ttrstrs[25])
		else
			player.components.talker:Say(ttrstrs[26])
		end
	end
end)

local KEY_DOWN = GLOBAL.KEY_DOWN
AddModRPCHandler(modname, "DOWN", function(player)
	if not player:HasTag("playerghost") and player.prefab == "totooria" then
		if player.components.totooriastatus.jinengdian > 0 then
			player.components.totooriastatus.jinengdian = player.components.totooriastatus.jinengdian - 1
			player.components.totooriastatus.sudu = player.components.totooriastatus.sudu + 1
			if player.components.totooriastatus.open == 1 then
				player.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED + player.components.totooriastatus.sudu/20*2) *2
				player.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED + player.components.totooriastatus.sudu/20*3) *2
			else
				player.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED + player.components.totooriastatus.sudu/20*2
				player.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED + player.components.totooriastatus.sudu/20*3
			end
			if player.components.totooriastatus.sudu == 10 and player.components.totooriastatus.lingqiao == 0 then
				player.components.totooriastatus.lingqiao = 1
				player.components.talker:Say(ttrstrs[27].."\n"..ttrstrs[38].."\n"..ttrstrs[25])
			else
				player.components.talker:Say(ttrstrs[27].."\n"..ttrstrs[25])
			end
			if player.components.totooriastatus.yijiajineng == 0 then
				player.components.totooriastatus.tintdata01 = 3
			end
			if player.components.totooriastatus.yijiajineng == 1 then
				player.components.totooriastatus.tintdata02 = 3
			end
			if player.components.totooriastatus.yijiajineng == 2 then
				player.components.totooriastatus.tintdata03 = 3
			end
			if player.components.totooriastatus.yijiajineng == 3 then
				player.components.totooriastatus.tintdata04 = 3
			end
			if player.components.totooriastatus.yijiajineng == 4 then
				player.components.totooriastatus.tintdata05 = 3
			end
			if player.components.totooriastatus.yijiajineng == 5 then
				player.components.totooriastatus.tintdata06 = 3
			end
			if player.components.totooriastatus.yijiajineng == 6 then
				player.components.totooriastatus.tintdata07 = 3
			end
			if player.components.totooriastatus.yijiajineng == 7 then
				player.components.totooriastatus.tintdata08 = 3
			end
			if player.components.totooriastatus.yijiajineng == 8 then
				player.components.totooriastatus.tintdata09 = 3
			end
			if player.components.totooriastatus.yijiajineng == 9 then
				player.components.totooriastatus.tintdata10 = 3
			end
			if player.components.totooriastatus.yijiajineng == 10 then
				player.components.totooriastatus.tintdata11 = 3
			end
			if player.components.totooriastatus.yijiajineng == 11 then
				player.components.totooriastatus.tintdata12 = 3
			end
			if player.components.totooriastatus.yijiajineng == 12 then
				player.components.totooriastatus.tintdata13 = 3
			end
			if player.components.totooriastatus.yijiajineng == 13 then
				player.components.totooriastatus.tintdata14 = 3
			end
			if player.components.totooriastatus.yijiajineng == 14 then
				player.components.totooriastatus.tintdata15 = 3
			end
			if player.components.totooriastatus.yijiajineng == 15 then
				player.components.totooriastatus.tintdata16 = 3
			end
			if player.components.totooriastatus.yijiajineng == 16 then
				player.components.totooriastatus.tintdata17 = 3
			end
			if player.components.totooriastatus.yijiajineng == 17 then
				player.components.totooriastatus.tintdata18 = 3
			end
			if player.components.totooriastatus.yijiajineng == 18 then
				player.components.totooriastatus.tintdata19 = 3
			end
			if player.components.totooriastatus.yijiajineng == 19 then
				player.components.totooriastatus.tintdata20 = 3
			end
			player.components.totooriastatus.yijiajineng = player.components.totooriastatus.yijiajineng + 1
		else
			player.components.talker:Say(ttrstrs[26])
		end
	end
end)

local KEY_LEFT = GLOBAL.KEY_LEFT
AddModRPCHandler(modname, "LEFT", function(player)
	if not player:HasTag("playerghost") and player.prefab == "totooria" then
		if player.components.totooriastatus.jinengdian > 0 then
			player.components.totooriastatus.jinengdian = player.components.totooriastatus.jinengdian - 1
			player.components.totooriastatus.gongjili = player.components.totooriastatus.gongjili + 1
			local damagemult = (TUNING.WENDY_DAMAGE_MULT * (1 + player.components.totooriastatus.gongjili/20) * ((player.components.health.maxhealth - player.components.health.currenthealth)/100*player.components.totooriastatus.yonggan + 1))
			player.components.combat.damagemultiplier = damagemult
			player.components.totooriastatus.damage = damagemult*10000
			if player.components.totooriastatus.gongjili == 10 and player.components.totooriastatus.shixue == 0 then
				player.components.totooriastatus.shixue = 1
				player.components.talker:Say(ttrstrs[28].."\n"..ttrstrs[37].."\n"..ttrstrs[25])
			else
				player.components.talker:Say(ttrstrs[28].."\n"..ttrstrs[25])
			end
			if player.components.totooriastatus.yijiajineng == 0 then
				player.components.totooriastatus.tintdata01 = 1
			end
			if player.components.totooriastatus.yijiajineng == 1 then
				player.components.totooriastatus.tintdata02 = 1
			end
			if player.components.totooriastatus.yijiajineng == 2 then
				player.components.totooriastatus.tintdata03 = 1
			end
			if player.components.totooriastatus.yijiajineng == 3 then
				player.components.totooriastatus.tintdata04 = 1
			end
			if player.components.totooriastatus.yijiajineng == 4 then
				player.components.totooriastatus.tintdata05 = 1
			end
			if player.components.totooriastatus.yijiajineng == 5 then
				player.components.totooriastatus.tintdata06 = 1
			end
			if player.components.totooriastatus.yijiajineng == 6 then
				player.components.totooriastatus.tintdata07 = 1
			end
			if player.components.totooriastatus.yijiajineng == 7 then
				player.components.totooriastatus.tintdata08 = 1
			end
			if player.components.totooriastatus.yijiajineng == 8 then
				player.components.totooriastatus.tintdata09 = 1
			end
			if player.components.totooriastatus.yijiajineng == 9 then
				player.components.totooriastatus.tintdata10 = 1
			end
			if player.components.totooriastatus.yijiajineng == 10 then
				player.components.totooriastatus.tintdata11 = 1
			end
			if player.components.totooriastatus.yijiajineng == 11 then
				player.components.totooriastatus.tintdata12 = 1
			end
			if player.components.totooriastatus.yijiajineng == 12 then
				player.components.totooriastatus.tintdata13 = 1
			end
			if player.components.totooriastatus.yijiajineng == 13 then
				player.components.totooriastatus.tintdata14 = 1
			end
			if player.components.totooriastatus.yijiajineng == 14 then
				player.components.totooriastatus.tintdata15 = 1
			end
			if player.components.totooriastatus.yijiajineng == 15 then
				player.components.totooriastatus.tintdata16 = 1
			end
			if player.components.totooriastatus.yijiajineng == 16 then
				player.components.totooriastatus.tintdata17 = 1
			end
			if player.components.totooriastatus.yijiajineng == 17 then
				player.components.totooriastatus.tintdata18 = 1
			end
			if player.components.totooriastatus.yijiajineng == 18 then
				player.components.totooriastatus.tintdata19 = 1
			end
			if player.components.totooriastatus.yijiajineng == 19 then
				player.components.totooriastatus.tintdata20 = 1
			end
			player.components.totooriastatus.yijiajineng = player.components.totooriastatus.yijiajineng + 1
		else
			player.components.talker:Say(ttrstrs[26])
		end
	end
end)

local KEY_RIGHT = GLOBAL.KEY_RIGHT
AddModRPCHandler(modname, "RIGHT", function(player)
	if not player:HasTag("playerghost") and player.prefab == "totooria" then
		if player.components.totooriastatus.jinengdian > 0 then
			player.components.totooriastatus.jinengdian = player.components.totooriastatus.jinengdian - 1
			player.components.totooriastatus.xueliang = player.components.totooriastatus.xueliang + 1
			local health_percent = player.components.health:GetPercent()
			player.components.health.maxhealth = 75+player.components.totooriastatus.xueliang*125/20
			player.components.health:SetPercent(health_percent)
			if player.components.totooriastatus.xueliang == 10 and player.components.totooriastatus.yonggan == 0 then
				player.components.totooriastatus.yonggan = 1
				player.components.talker:Say(ttrstrs[29].."\n"..ttrstrs[36].."\n"..ttrstrs[25])
			else
				player.components.talker:Say(ttrstrs[29].."\n"..ttrstrs[25])
			end
			if player.components.totooriastatus.yijiajineng == 0 then
				player.components.totooriastatus.tintdata01 = 2
			end
			if player.components.totooriastatus.yijiajineng == 1 then
				player.components.totooriastatus.tintdata02 = 2
			end
			if player.components.totooriastatus.yijiajineng == 2 then
				player.components.totooriastatus.tintdata03 = 2
			end
			if player.components.totooriastatus.yijiajineng == 3 then
				player.components.totooriastatus.tintdata04 = 2
			end
			if player.components.totooriastatus.yijiajineng == 4 then
				player.components.totooriastatus.tintdata05 = 2
			end
			if player.components.totooriastatus.yijiajineng == 5 then
				player.components.totooriastatus.tintdata06 = 2
			end
			if player.components.totooriastatus.yijiajineng == 6 then
				player.components.totooriastatus.tintdata07 = 2
			end
			if player.components.totooriastatus.yijiajineng == 7 then
				player.components.totooriastatus.tintdata08 = 2
			end
			if player.components.totooriastatus.yijiajineng == 8 then
				player.components.totooriastatus.tintdata09 = 2
			end
			if player.components.totooriastatus.yijiajineng == 9 then
				player.components.totooriastatus.tintdata10 = 2
			end
			if player.components.totooriastatus.yijiajineng == 10 then
				player.components.totooriastatus.tintdata11 = 2
			end
			if player.components.totooriastatus.yijiajineng == 11 then
				player.components.totooriastatus.tintdata12 = 2
			end
			if player.components.totooriastatus.yijiajineng == 12 then
				player.components.totooriastatus.tintdata13 = 2
			end
			if player.components.totooriastatus.yijiajineng == 13 then
				player.components.totooriastatus.tintdata14 = 2
			end
			if player.components.totooriastatus.yijiajineng == 14 then
				player.components.totooriastatus.tintdata15 = 2
			end
			if player.components.totooriastatus.yijiajineng == 15 then
				player.components.totooriastatus.tintdata16 = 2
			end
			if player.components.totooriastatus.yijiajineng == 16 then
				player.components.totooriastatus.tintdata17 = 2
			end
			if player.components.totooriastatus.yijiajineng == 17 then
				player.components.totooriastatus.tintdata18 = 2
			end
			if player.components.totooriastatus.yijiajineng == 18 then
				player.components.totooriastatus.tintdata19 = 2
			end
			if player.components.totooriastatus.yijiajineng == 19 then
				player.components.totooriastatus.tintdata20 = 2
			end
			player.components.totooriastatus.yijiajineng = player.components.totooriastatus.yijiajineng + 1
		else
			player.components.talker:Say(ttrstrs[26])
		end
	end
end)

local KEY_K = GLOBAL.KEY_K
AddModRPCHandler(modname, "K", function(player)
	if not player:HasTag("playerghost") and player.prefab == "totooria" then
		player.components.talker:Say(ttrstrs[6]..(player.components.totooriastatus.jinengdian)..ttrstrs[7].."\n"..ttrstrs[30].."\n"..ttrstrs[31].."\n"..ttrstrs[32].."\n"..ttrstrs[33])
	end
end)

local KEY_R = GLOBAL.KEY_R
AddModRPCHandler(modname, "R", function(player)
	if not player:HasTag("playerghost") and player.prefab == "totooria" then
		if player.components.totooriastatus.lingqiao == 1 and player.components.totooriastatus.open == 0 then
			if player.components.health:GetPercent() > .33 then
				if math.random() <.33 then
					player.components.talker:Say(ttrstrs[39])
				else
					if math.random() <.66 then
						player.components.talker:Say(ttrstrs[40])
					else
						player.components.talker:Say(ttrstrs[41])
					end
				end
			else
				if math.random() <.5 then
					player.components.talker:Say(ttrstrs[42])
				else
					player.components.talker:Say(ttrstrs[43])
				end
			end

			local x, y, z = player.Transform:GetWorldPosition()
		    GLOBAL.SpawnPrefab("shadow_despawn").Transform:SetPosition(x, y, z)
		    GLOBAL.SpawnPrefab("statue_transition_2").Transform:SetPosition(x, y, z)

			player.components.totooriastatus.open = 1
			player.components.locomotor.walkspeed = player.components.locomotor.walkspeed * 1.5
			player.components.locomotor.runspeed = player.components.locomotor.runspeed * 1.5
			local skilltime = player.components.totooriastatus.dengji * 1
			player:DoTaskInTime(skilltime, function()
				player.components.talker:Say(ttrstrs[44])
				player.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED + player.components.totooriastatus.sudu/20*2
				player.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED + player.components.totooriastatus.sudu/20*3
				player.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
				player.components.totooriastatus.open = 0
			end)
		end
	end
end)


local totooria_handlers = {}
AddPlayerPostInit(function(inst)
	-- We hack
	inst:DoTaskInTime(0, function()
		-- We check if the character is ourselves
		-- So if another horo player joins, we don't get the handlers
		if inst == GLOBAL.ThePlayer then
			-- If we are horo
			if inst.prefab == "totooria" then
				-- We create and store the key handlers
				totooria_handlers[0] = TheInput:AddKeyDownHandler(KEY_J, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
            			SendModRPCToServer(MOD_RPC[modname]["J"])
            		end
				end)
				totooria_handlers[1] = TheInput:AddKeyDownHandler(KEY_UP, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
            			SendModRPCToServer(MOD_RPC[modname]["UP"])
            		end
				end)
				totooria_handlers[2] = TheInput:AddKeyDownHandler(KEY_DOWN, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
            			SendModRPCToServer(MOD_RPC[modname]["DOWN"])
            		end
				end)
				totooria_handlers[3] = TheInput:AddKeyDownHandler(KEY_LEFT, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
            			SendModRPCToServer(MOD_RPC[modname]["LEFT"])
            		end
				end)
				totooria_handlers[4] = TheInput:AddKeyDownHandler(KEY_RIGHT, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
            			SendModRPCToServer(MOD_RPC[modname]["RIGHT"])
            		end
				end)
				totooria_handlers[5] = TheInput:AddKeyDownHandler(KEY_K, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
						SendModRPCToServer(MOD_RPC[modname]["K"])
					end
				end)
				totooria_handlers[6] = TheInput:AddKeyDownHandler(KEY_R, function()
					local screen = GLOBAL.TheFrontEnd:GetActiveScreen()
            		local IsHUDActive = screen and screen.name == "HUD"
            		if inst:IsValid() and IsHUDActive then
						SendModRPCToServer(MOD_RPC[modname]["R"])
					end
				end)
			else
				-- If not, we go to the handlerslist and empty it
				-- This is to avoid having the handlers if we switch characters in wilderness
				-- If it's already empty, nothing changes
				totooria_handlers[0] = nil
				totooria_handlers[1] = nil
				totooria_handlers[2] = nil
				totooria_handlers[3] = nil
				totooria_handlers[4] = nil
				totooria_handlers[5] = nil
				totooria_handlers[6] = nil
			end
		end
	end)
end)