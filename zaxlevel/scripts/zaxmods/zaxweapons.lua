

list =  {
	"ruins_bat",
	"walrus_tusk",
	"dragon_scales",
	"tentaclespike",
}


if GLOBAL.TheNet:GetIsServer() then
	for i=1, #list do
		AddPrefabPostInit(list[i], function(inst) 
			inst:AddComponent("tradable")
		end)
	end

	AddPrefabPostInit("spear_wathgrithr", function(inst) 
		inst:AddComponent("trader")
		inst:AddComponent("weaponlevel")
	end)

end





