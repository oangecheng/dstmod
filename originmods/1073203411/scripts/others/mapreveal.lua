
-- Map reveal
local function revealer( inst )

if GLOBAL.TheWorld.ismastersim then
	
	inst:DoTaskInTime( 0.001, function() 
	
	
	local minimap = TheSim:FindFirstEntityWithTag("minimap")

		if minimap then
			minimap.MiniMap:EnableFogOfWar(not GetModConfigData("RevealMapAtStart"))
		end
		
	end)
	
	end
end
AddPrefabPostInit("forest", revealer )