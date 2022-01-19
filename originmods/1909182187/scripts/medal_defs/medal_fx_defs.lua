local function FinalOffset1(inst)
    inst.AnimState:SetFinalOffset(1)
end
--特效统一配置
local medal_fx={
	{--血蜜粘液
		name = "medal_blood_honey_splat",
		bank = "spat_splat",
		build = "medal_blood_honey_splat",
		anim = "idle",
	},
	{--血蜜飞溅
		name = "medal_honey_splash",
		bank = "honey_splash",
		build = "medal_honey_splash",
		anim = "anim",
		nofaced = true,
		transform = Vector3(1.4, 1.4, 1.4),
		fn = FinalOffset1,
	},
	{--血蜜飞溅(aoe效果)
		name = "medal_honey_splash2",
		bank = "honey_splash",
		build = "medal_honey_splash",
		anim = "anim",
		nofaced = true,
		transform = Vector3(1.4, 1.4, 1.4),
	},
}


--子弹特效
local shot_types = {"mandrakeberry", "devoursoul", "sanityrock", "sandspike", "spines", "water", "houndstooth", "taunt"}
for _, shot_type in ipairs(shot_types) do
    table.insert(medal_fx, {
        name = "slingshotammo_hitfx_"..shot_type,
        bank = "slingshotammo",
        build = "medalslingshotammo",
        anim = "used",
        fn = function(inst)
			if shot_type ~= "rocks" then
		        inst.AnimState:OverrideSymbol("rock", "medalslingshotammo", shot_type)
			end
		    inst.AnimState:SetFinalOffset(3)
		end,
    })
end

return medal_fx