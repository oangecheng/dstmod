

if GLOBAL.TheNet:GetIsServer() then

	AddPrefabPostInit("spear_wathgrithr", function(inst) 
		inst:AddComponent("trader")
		inst:AddComponent("weaponlevel")
	end)

end





