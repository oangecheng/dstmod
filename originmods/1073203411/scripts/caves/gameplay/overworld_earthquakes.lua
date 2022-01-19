if GetModConfigData("OverworldEarthquakes") then
AddPrefabPostInit("forest_network", function(inst)
	if not GLOBAL.TheWorld.components.overworldquaker then
		GLOBAL.TheWorld:AddComponent("overworldquaker")
	end
end)
end