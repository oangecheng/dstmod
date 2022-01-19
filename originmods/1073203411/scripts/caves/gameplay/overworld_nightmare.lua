
local clock = GLOBAL.GetTime

local OverworldNightmarePhase = GetModConfigData("OverworldNightmarePhase")

-- Adds Nightmare Phase function to overworld
if OverworldNightmarePhase > 0 then

	AddPrefabPostInit("forest_network", function(inst)
		if not GLOBAL.TheWorld.components.nightmareclock then
			GLOBAL.TheWorld:AddComponent("nightmareclock")
			if GLOBAL.TheWorld.ismastersim then
				GLOBAL.TheWorld:ListenForEvent("nightmareclocktick", 
					function(phase,timeinphase,time)
						if not GLOBAL.TheWorld.lastphase or phase ~= GLOBAL.TheWorld.lastphase.last_phase then
							GLOBAL.TheWorld.lastphase = phase
							GLOBAL.TheWorld:PushEvent("nightmarephasedirty")
						end
					end)
			end
		end
	end)
	
	local RemoveEventCallback = function(inst, event)
	if __DEBUG__ then
	print("[Megarandom-d] RemoveEventCallBack in",tostring(inst))
	end
	if inst.event_listening then	
	for e, sources  in pairs(inst.event_listening) do	
	if __DEBUG__ then
	print("[Megarandom-d] Found event_listening ",tostring(e),"in",tostring(inst))
	end
		if e == event then	
			for s, fns in pairs(sources) do
				if s.event_listeners then
					local listeners = s.event_listeners[e]	
					if listeners then
					print("[Megarandom] Removed listener ",tostring(listeners[inst]),"(event",tostring(e),"inst",tostring(inst),")")
					listeners[inst] = nil
					end	                
				end		            
			end	                          
		end
	end
	end
  	if inst.event_listeners then
		for e, listeners in pairs(inst.event_listeners) do	
			if e == event then	 
				for listener, fns in pairs(listeners) do
					if listener.event_listening then	
						local sources = listener.event_listening[e]	 
						if sources then
						
					if __DEBUG__ then
					print("[Megarandom-d] Removed source ",tostring(sources[inst]),"(event",tostring(e),"inst",tostring(inst),")")
					end
					sources[inst] = nil 
						end 
					end
				end	 
			end	 
		end	
 	end
	end
	
	
local function MyOnAreaChanged(inst, data)

	-- This tells if we are in a nightmare biome.
	local isinnightmare = data and data.tags and table.contains(data.tags, "Nightmare")
	
	-- Number of seconds before we actually apply the HUD change. This is to prevent overlapping blending effects.
	local DELAY_BLENDTIME_FOREST = 8
	local DELAY_BLENDTIME_NIGHTMARE = 12
	
	--
	-- inst.components.playervision.nextchange_mintime -- 
	inst.components.playervision.isinnightmare = isinnightmare
	
	if not isinnightmare then
		-- if we are in forest, change as soon as the blending effect ends.
		local time_to_wait = math.max(inst.components.playervision.nextchange_mintime - clock(),0)
		inst:DoTaskInTime(time_to_wait,function()
			-- check that we are still in forest and area was not changed inbetween.
			if not inst.components.playervision.isinnightmare and inst.components.playervision.nightmarevision then
			inst.components.playervision:SetNightmareVision(false)
			end
		end)
	else
		-- if we are in nightmare, update the HUD only after at least 10 seconds spent in nightmare.
		inst:DoTaskInTime(DELAY_BLENDTIME_NIGHTMARE,function()
		-- we are still in nightmare, have not yet activated nightmare vision, and have not returned into forest during the last 10 secs
			if inst.components.playervision.isinnightmare and not inst.components.playervision.nightmarevision then
			inst.components.playervision:SetNightmareVision(true)
			inst.components.playervision.nextchange_mintime = clock() + DELAY_BLENDTIME_FOREST
			end
		end)
	end
	
end

--[[
local ECLIPSE_COLORCUBES =
{
    main = "images/colour_cubes/eclipse.tex",
}

local ECLIPSE_PHASEFN =
{
    blendtime = 10.,
    events = {},
    fn = nil,
}
--]]
--AllPlayers[1].components.playervision:StartEclipse()
	AddPlayerPostInit(function(inst)
		if GLOBAL.TheWorld and GLOBAL.TheWorld:HasTag("forest") then
			local playervision = inst.components.playervision
			--RemoveEventCallback(playervision.inst,"changearea")
			if GetModConfigData("OverworldNightmarePhaseHUDEffects") then
			playervision.inst:ListenForEvent("changearea", MyOnAreaChanged)
			playervision.nextchange_mintime = clock()
			else
			playervision:SetNightmareVision(false)
			end
			
			--[[
			function playervision:StartEclipse() 
				local cctable = ECLIPSE_COLORCUBES

				local ccphasefn = 
					(cctable == ECLIPSE_COLORCUBES and ECLIPSE_PHASEFN)

				if cctable ~= self.currentcctable then
					self.currentcctable = cctable
					self.currentccphasefn = ccphasefn
					self.inst:PushEvent("ccoverrides", cctable)
					self.inst:PushEvent("ccphasefn", ccphasefn)
				end
			end
			function playervision:StopEclipse() 
				playervision:UpdateCCTable()
			end
			--]]
		end
	end)



	--local playervision = require("components/playervision")
	--RemoveEventCallback(playervision,"changearea")
	--playervision:RemoveAllEventCallbacks() -- doesn't work, nil value

	--AddPlayerPostInit(function(inst)
	--	if GLOBAL.TheWorld and not GLOBAL.TheWorld:HasTag("cave") then
	--		inst:RemoveComponent("areaaware")
	--	end
	--end)
	

end
