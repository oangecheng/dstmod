local _G = GLOBAL
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

local LAN_ = GetModConfigData('Language')
if LAN_ then
	require 'SEscripts/strings_cn'
	TUNING.SElan = "cn"
else
	require 'SEscripts/strings_en'
	TUNING.SElan = "en"
end

if GetModConfigData('Disintegrate') then
    TUNING.allowgoldstaff = true
else
    TUNING.allowgoldstaff = false
end

PrefabFiles = {
	"secoin",
    "stealer",
    "goldstaff",
    "vipcard",
    "luckamulet",
}

Assets = {
    Asset("ATLAS", "images/inventoryimages/secoin.xml"),
    Asset("IMAGE", "images/inventoryimages/secoin.tex"),
    Asset("ATLAS", "images/sehud/mainbutton.xml"),
    Asset("IMAGE", "images/sehud/mainbutton.tex"),
    Asset("ATLAS", "images/sehud/bg.xml"),
    Asset("IMAGE", "images/sehud/bg.tex"),
    Asset("ATLAS", "images/sehud/exp_act.xml"),
    Asset("IMAGE", "images/sehud/exp_act.tex"),
    Asset("ATLAS", "images/sehud/exp_dact.xml"),
    Asset("IMAGE", "images/sehud/exp_dact.tex"),
    Asset("ATLAS", "images/sehud/expmask.xml"),
    Asset("IMAGE", "images/sehud/expmask.tex"),
    Asset("ATLAS", "images/sehud/level_act.xml"),
    Asset("IMAGE", "images/sehud/level_act.tex"),
    Asset("ATLAS", "images/sehud/level_dact.xml"),
    Asset("IMAGE", "images/sehud/level_dact.tex"),
    Asset("ATLAS", "images/sehud/status_"..TUNING.SElan..".xml"),
    Asset("IMAGE", "images/sehud/status_"..TUNING.SElan..".tex"),
    Asset("ATLAS", "images/sehud/hudcoin.xml"),
    Asset("IMAGE", "images/sehud/hudcoin.tex"),
    Asset("ATLAS", "images/sehud/slotbg_normal.xml"),
    Asset("IMAGE", "images/sehud/slotbg_normal.tex"),
    Asset("ATLAS", "images/sehud/slotbg_special.xml"),
    Asset("IMAGE", "images/sehud/slotbg_special.tex"),
    Asset("ATLAS", "images/sehud/slotbg_fresh.xml"),
    Asset("IMAGE", "images/sehud/slotbg_fresh.tex"),
    Asset("ATLAS", "images/sehud/back.xml"),
    Asset("IMAGE", "images/sehud/back.tex"),
    Asset("ATLAS", "images/sehud/next.xml"),
    Asset("IMAGE", "images/sehud/next.tex"),
    Asset("ATLAS", "images/sehud/close.xml"),
    Asset("IMAGE", "images/sehud/close.tex"),
    Asset("ATLAS", "images/sehud/infobutton.xml"),
    Asset("IMAGE", "images/sehud/infobutton.tex"),
    Asset("ATLAS", "images/sehud/infoback.xml"),
    Asset("IMAGE", "images/sehud/infoback.tex"),
    Asset("ATLAS", "images/sehud/infopage_"..TUNING.SElan..".xml"),
    Asset("IMAGE", "images/sehud/infopage_"..TUNING.SElan..".tex"),
    Asset("ATLAS", "images/sehud/new.xml"),
    Asset("IMAGE", "images/sehud/new.tex"),
    Asset("ATLAS", "images/sehud/up.xml"),
    Asset("IMAGE", "images/sehud/up.tex"),
    Asset("ATLAS", "images/sehud/low.xml"),
    Asset("IMAGE", "images/sehud/low.tex"),
}

for i=1, 5 do
    table.insert(Assets, Asset("ATLAS", "images/sehud/swdj_"..TUNING.SElan..i..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/sehud/swdj_"..TUNING.SElan..i..".tex"))
end
for i=1, 6 do
    table.insert(Assets, Asset("ATLAS", "images/sehud/vip"..(i-1)..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/sehud/vip"..(i-1)..".tex"))
end
for i=1, 10 do
    table.insert(Assets, Asset("ATLAS", "images/sehud/numbers/"..(i-1)..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/sehud/numbers/"..(i-1)..".tex"))
end
for i=1, 10 do
    table.insert(Assets, Asset("ATLAS", "images/sehud/bignums/"..(i-1)..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/sehud/bignums/"..(i-1)..".tex"))
end
local titles = {"food", "cloth", "smithing", "resource", "precious"}
for k,v in pairs(titles) do
    table.insert(Assets, Asset("ATLAS", "images/sehud/title_"..v..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/sehud/title_"..v..".tex"))
    table.insert(Assets, Asset("ATLAS", "images/sehud/"..v.."_act_"..TUNING.SElan..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/sehud/"..v.."_act_"..TUNING.SElan..".tex"))
    table.insert(Assets, Asset("ATLAS", "images/sehud/"..v.."_dact_"..TUNING.SElan..".xml"))
    table.insert(Assets, Asset("IMAGE", "images/sehud/"..v.."_dact_"..TUNING.SElan..".tex"))
end

--载入清单
modimport("scripts/SEscripts/itemlist.lua")

--角色交易属性
AddPlayerPostInit(function(inst)
    inst.seccoin = GLOBAL.net_int(inst.GUID,"seccoin")
    inst.secexp = GLOBAL.net_int(inst.GUID,"secexp")
    inst.seclevel = GLOBAL.net_shortint(inst.GUID,"seclevel")
    inst.secvip = GLOBAL.net_shortint(inst.GUID,"secvip")
    inst.secprecious = GLOBAL.net_bytearray(inst.GUID,"secprecious")
    inst.secpreciouschange = GLOBAL.net_bool(inst.GUID, "secpreciouschange")
    inst.secsoundm = GLOBAL.net_bool(inst.GUID, "secsoundm", "secsoundm")
    if not GLOBAL.TheNet:GetIsClient() then
        inst:AddComponent("seplayerstatus")
        inst.components.seplayerstatus:Init(inst)
    end
end)
--全局经济数据
AddPrefabPostInit("forest", function(inst) GLOBAL.TheWorld:AddComponent("seworldstatus") end)
AddPrefabPostInit("cave", function(inst) GLOBAL.TheWorld:AddComponent("seworldstatus") end)

--设置modrpc
AddModRPCHandler("SimpleEconomy", "sebuy", function(player, iname, more, lastskin)
    local tab = {TUNING.allgoods, TUNING.selist_low}
    local alllist = {}
    for k_,v_ in pairs(tab) do
        for k,v in pairs(v_) do table.insert(alllist, v) end
    end
    local iprice = 0
    for k,v in pairs(alllist) do
        if iname == v.name then
            iprice = v.price
            break
        end
    end
    
    local iiname = iname
    local multi = 1
    if more then multi = 10 end
    
    local discount = player.components.seplayerstatus.discount
    if iiname == "vipcard" then
        discount = 1
    end
    if player.components.health.currenthealth > 0 and not player:HasTag("playerghost") then
        if player.components.seplayerstatus.coin >= math.ceil(iprice*discount)*multi then
            for i=1, multi do
                if iname == "blueprint" and math.random(0, 40) <= 1 then
                    iiname = selist_blueprint[math.random(#selist_blueprint)].name
                end
                local item = GLOBAL.SpawnPrefab(iiname, lastskin, nil, player.userid)
                player.components.inventory:GiveItem(item, nil, player:GetPosition())
            end
            player.components.seplayerstatus:DoDeltaCoin(-iprice, multi)
        end
    else
        if player.components.seplayerstatus.coin >= math.ceil(iprice*discount)*multi then
            local pt = Point(player.Transform:GetWorldPosition())
            for i=1, multi do
                if iname == "blueprint" and math.random(0, 40) <= 1 then
                    iiname = selist_blueprint[math.random(#selist_blueprint)].name
                end
                local angle = math.random()*2*GLOBAL.PI
                local loots = GLOBAL.SpawnPrefab(iiname, lastskin, nil, player.userid)
                loots.Transform:SetPosition(pt.x,pt.y,pt.z)
                loots.Physics:SetVel(2*math.cos(angle), 10, 2*math.sin(angle))
            end
            player.components.seplayerstatus:DoDeltaCoin(-iprice, multi)
        end
    end
end)

--UI尺寸
local function ScaleUI(self, screensize)
	local hudscale = self.top_root:GetScale()
	self.uiseconomy:SetScale(.75*hudscale.x,.75*hudscale.y,1)
end

--UI
local uiseconomy = require("widgets/uiseconomy")
local function Adduiseconomy(self)
    self.uiseconomy = self.top_root:AddChild(uiseconomy(self.owner))
    local screensize = {GLOBAL.TheSim:GetScreenSize()}
    ScaleUI(self, screensize)
    self.uiseconomy:SetHAnchor(0)
    self.uiseconomy:SetVAnchor(0)
    --H: 0=中间 1=左端 2=右端
    --V: 0=中间 1=顶端 2=底端
    self.uiseconomy:MoveToFront()
    local OnUpdate_base = self.OnUpdate
	self.OnUpdate = function(self, dt)
		OnUpdate_base(self, dt)
		local curscreensize = {GLOBAL.TheSim:GetScreenSize()}
		if curscreensize[1] ~= screensize[1] or curscreensize[2] ~= screensize[2] then
			ScaleUI(self)
            screensize = curscreensize
		end
	end
end
AddClassPostConstruct("widgets/controls", Adduiseconomy)

TUNING.stealercandig = GetModConfigData("Dig")
TUNING.stealercanhammer = GetModConfigData("Hammer")