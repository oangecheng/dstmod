local _G = GLOBAL

-- 是否开启多倍采集功能
local useMorePick = GetModConfigData('UseMorePick')
-- 是否开启额外掉落功能
local useMoreDrop = GetModConfigData('UseMoreDrop')
-- 是否开启人物强化功能
local useRoleStrenth = GetModConfigData('UseRoleStrenth')
-- 是否开启武器可升级
-- 目前仅支持战斗长矛
local useWeaponLevelUp = GetModConfigData('UseWeaponLevelUp')


if useMorePick then
	modimport("scripts/zaxmods/zaxmorepick.lua")
end


modimport("scripts/zaxmods/zaxweapons.lua")


if GLOBAL.TheNet:GetIsServer() then
	-- 角色初始化
	AddPlayerPostInit(function (inst)

		-- 角色升级
		inst:AddComponent("rolelevel")

		-- 额外掉落
		if useMoreDrop then 
			inst:AddComponent("extradrop")
		end

		-- 角色强化
		if useRoleStrenth then
			inst:AddComponent("rolestrenth")
		end


		inst.components.talker:Say("我又来到这个奇怪的世界！")

	end)
end


