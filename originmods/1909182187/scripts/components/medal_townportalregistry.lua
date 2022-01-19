--------------------------------------------------------------------------
--[[ TownPortalRegistry class definition ]]
--------------------------------------------------------------------------

return Class(function(self, inst)

assert(TheWorld.ismastersim, "TownPortalRegistry should not exist on client")

--------------------------------------------------------------------------
--[[ Member variables ]]
--------------------------------------------------------------------------

--Public
self.inst = inst--世界自身

--Private
local _townportals = {}--传送塔列表


--------------------------------------------------------------------------
--[[ Private member functions ]]
--私有成员函数
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Private event handlers ]]
--私有事件处理程序
--------------------------------------------------------------------------
--传送塔被激活时
local function OnTownPortalActivated(inst, townportal)
	--推送给被摸的传送塔
	townportal:PushEvent("get_medal_townportals",_townportals)
end
--当传送塔被移除时
local function OnRemoveTownPortal(townportal)
    for i, v in ipairs(_townportals) do
        if v == townportal then
            table.remove(_townportals, i)--移除传送塔列表中对应的传送塔
            --取消对该传送塔的监听事件
			inst:RemoveEventCallback("onremove", OnRemoveTownPortal, townportal)
            break
        end
    end
end
--注册传送塔
local function OnRegisterTownPortal(inst, townportal)
    --遍历传送塔列表，如果已有该传送塔则返回
	for i, v in ipairs(_townportals) do
        if v == townportal then
            return
        end
    end
	--将新的传送塔插入到传送塔列表里
    table.insert(_townportals, townportal)
	--给这个传送塔安排监听事件，监听自己被移除
    inst:ListenForEvent("onremove", OnRemoveTownPortal, townportal)
end

--------------------------------------------------------------------------
--[[ Initialization ]]
--------------------------------------------------------------------------

--Register events
inst:ListenForEvent("ms_medal_registertownportal", OnRegisterTownPortal)--监听注册事件
inst:ListenForEvent("medal_townportalactivated", OnTownPortalActivated)--监听被激活事件

--------------------------------------------------------------------------
--[[ Post initialization ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Update ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Public member functions ]]
--公共成员函数
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Save/Load ]]
--------------------------------------------------------------------------

--------------------------------------------------------------------------
--[[ Debug ]]
--------------------------------------------------------------------------
--调试用
function self:GetDebugString()
	local s = "Town Portals: " .. tostring(#_townportals)
	return s
end

--------------------------------------------------------------------------
--[[ End ]]
--------------------------------------------------------------------------

end)
