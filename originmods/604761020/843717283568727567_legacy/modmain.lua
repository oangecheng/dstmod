local _G = GLOBAL
    _G.SHANGROCKS_MINE =  33 * GetModConfigData("wajuecishu")
    _G.SHANGROCKS_MINE_MED = 22 * GetModConfigData("wajuecishu")
    _G.SHANGROCKS_MINE_LOW = 11 * GetModConfigData("wajuecishu")

    _G.SHANGROCKS_ROCKS = .1 * GetModConfigData("shitoubaolv")
    _G.SHANGROCKS_NITRE = .025 * GetModConfigData("shitoubaolv")
    _G.SHANGROCKS_FLINT = .06 * GetModConfigData("shitoubaolv")
    _G.SHANGROCKS_GOLDS = GetModConfigData("huangjinbaolv")

    _G.SHANG_SHENGDANSHI = GetModConfigData("SHENGDANSHI")
    _G.SHANG_RUOYINXIAN = GetModConfigData("RUOYINXIAN")

    _G.SHANGROCKS_BLUE      = .0009 * GetModConfigData("baoshibaolv")*GetModConfigData("blue_baoshi")
    _G.SHANGROCKS_RED       = .0005 * GetModConfigData("baoshibaolv")*GetModConfigData("red_baoshi")
    _G.SHANGROCKS_ORANGE    = .0006 * GetModConfigData("baoshibaolv")*GetModConfigData("orange_baoshi")
    _G.SHANGROCKS_YELLOW    = .0008 * GetModConfigData("baoshibaolv")*GetModConfigData("yellow_baoshi")
    _G.SHANGROCKS_GREEN     = .0004 * GetModConfigData("baoshibaolv")*GetModConfigData("green_baoshi")
    _G.SHANGROCKS_PURPLE    = .0007 * GetModConfigData("baoshibaolv")*GetModConfigData("purple_baoshi")
    _G.SHANGROCKS_THULECITE = .0001 * GetModConfigData("baoshibaolv")*GetModConfigData("thulecite_xiukuang")
    _G.SHANGROCKS_MARBLE    = .0050 * GetModConfigData("marble_suipian")

    _G.SHANGROCKS_SHENG = 480 * GetModConfigData("shishengzhang")

local Rocks_Shang =
{
    "rock1", 
    "rock2", 
    "rock_flintless", 
    "rock_flintless_med", 
    "rock_flintless_low", 
    "rock_moon", 
}
_G.SetSharedLootTable( 'Shang'..'rock1',
{
    {'rocks',  _G.SHANGROCKS_ROCKS},
    {'rocks',  _G.SHANGROCKS_ROCKS},
    {'rocks',  _G.SHANGROCKS_ROCKS},
    {'nitre',  _G.SHANGROCKS_ROCKS},
    {'flint',  _G.SHANGROCKS_ROCKS},
    {'nitre',  _G.SHANGROCKS_NITRE},
    {'flint',  _G.SHANGROCKS_FLINT},

    {'bluegem',    _G.SHANGROCKS_BLUE},
    {'redgem',     _G.SHANGROCKS_RED},
    {'orangegem',  _G.SHANGROCKS_ORANGE},
    {'yellowgem',  _G.SHANGROCKS_YELLOW},
    {'greengem',   _G.SHANGROCKS_GREEN},
    {'purplegem',  _G.SHANGROCKS_PURPLE},
    {'thulecite',  _G.SHANGROCKS_THULECITE},
})
_G.SetSharedLootTable( 'Shang'..'rock2',
{
    {'rocks',       _G.SHANGROCKS_ROCKS},
    {'rocks',       _G.SHANGROCKS_ROCKS},
    {'rocks',       _G.SHANGROCKS_ROCKS},
    {'goldnugget',  .1 * _G.SHANGROCKS_GOLDS},
    {'flint',       _G.SHANGROCKS_ROCKS},
    {'goldnugget',  .025 * _G.SHANGROCKS_GOLDS},
    {'flint',       _G.SHANGROCKS_FLINT},

    {'bluegem',    _G.SHANGROCKS_BLUE*2},
    {'redgem',     _G.SHANGROCKS_RED*2},
    {'orangegem',  _G.SHANGROCKS_ORANGE*2},
    {'yellowgem',  _G.SHANGROCKS_YELLOW*2},
    {'greengem',   _G.SHANGROCKS_GREEN*2},
    {'purplegem',  _G.SHANGROCKS_PURPLE*2},
    {'thulecite',  _G.SHANGROCKS_THULECITE*2},
})
_G.SetSharedLootTable( 'Shang'..'rock_flintless',
{
    {'rocks',   _G.SHANGROCKS_ROCKS},
    {'rocks',   _G.SHANGROCKS_ROCKS},
    {'rocks',   _G.SHANGROCKS_ROCKS},
    {'rocks',   _G.SHANGROCKS_ROCKS},
    {'rocks',   _G.SHANGROCKS_FLINT},

    {'marble',  _G.SHANGROCKS_MARBLE*20},
    {'marble',  _G.SHANGROCKS_MARBLE*5},
    {'marble',  _G.SHANGROCKS_MARBLE},

    {'bluegem',    _G.SHANGROCKS_BLUE/2},
    {'redgem',     _G.SHANGROCKS_RED/2},
    {'orangegem',  _G.SHANGROCKS_ORANGE/2},
    {'yellowgem',  _G.SHANGROCKS_YELLOW/2},
    {'greengem',   _G.SHANGROCKS_GREEN/2},
    {'purplegem',  _G.SHANGROCKS_PURPLE/2},
    {'thulecite',  _G.SHANGROCKS_THULECITE/2},
})
_G.SetSharedLootTable( 'Shang'..'rock_flintless_med',
{
    {'rocks', _G.SHANGROCKS_ROCKS},
    {'rocks', _G.SHANGROCKS_ROCKS},
    {'rocks', _G.SHANGROCKS_ROCKS},
    {'rocks', _G.SHANGROCKS_NITRE},

    {'marble',  _G.SHANGROCKS_MARBLE*20},
    {'marble',  _G.SHANGROCKS_MARBLE},

    {'bluegem',    _G.SHANGROCKS_BLUE/2},
    {'redgem',     _G.SHANGROCKS_RED/2},
    {'orangegem',  _G.SHANGROCKS_ORANGE/2},
    {'yellowgem',  _G.SHANGROCKS_YELLOW/2},
    {'greengem',   _G.SHANGROCKS_GREEN/2},
    {'purplegem',  _G.SHANGROCKS_PURPLE/2},
    {'thulecite',  _G.SHANGROCKS_THULECITE/5},
})
_G.SetSharedLootTable( 'Shang'..'rock_flintless_low',
{
    {'rocks', _G.SHANGROCKS_ROCKS},
    {'rocks', _G.SHANGROCKS_ROCKS},
    {'rocks', _G.SHANGROCKS_NITRE},

    {'marble',  _G.SHANGROCKS_MARBLE*20},
    {'marble',  _G.SHANGROCKS_MARBLE*5},

    {'bluegem',    _G.SHANGROCKS_BLUE/2},
    {'redgem',     _G.SHANGROCKS_RED/2},
    {'orangegem',  _G.SHANGROCKS_ORANGE/2},
    {'yellowgem',  _G.SHANGROCKS_YELLOW/2},
    {'greengem',   _G.SHANGROCKS_GREEN/2},
    {'purplegem',  _G.SHANGROCKS_PURPLE/2},
    {'thulecite',  _G.SHANGROCKS_THULECITE/5},
})
_G.SetSharedLootTable( 'Shang'..'rock_moon',
{
    {'rocks',           _G.SHANGROCKS_ROCKS},
    {'rocks',           _G.SHANGROCKS_ROCKS},
    {'moonrocknugget',  _G.SHANGROCKS_ROCKS},
    {'flint',           _G.SHANGROCKS_ROCKS},
    {'moonrocknugget',  _G.SHANGROCKS_NITRE},
    {'flint',           _G.SHANGROCKS_FLINT},

    {'thulecite_pieces',  _G.SHANGROCKS_MARBLE*10},
    {'thulecite_pieces',  _G.SHANGROCKS_MARBLE*6},
    {'thulecite_pieces',  _G.SHANGROCKS_MARBLE},

    {'bluegem',    _G.SHANGROCKS_BLUE},
    {'redgem',     _G.SHANGROCKS_RED},
    {'orangegem',  _G.SHANGROCKS_ORANGE},
    {'yellowgem',  _G.SHANGROCKS_YELLOW},
    {'greengem',   _G.SHANGROCKS_GREEN},
    {'purplegem',  _G.SHANGROCKS_PURPLE},
    {'thulecite',  _G.SHANGROCKS_THULECITE},
})

local function ShenZ(inst)
    local x, y, z = inst.Transform:GetWorldPosition()
    local zijin = inst.prefab
    if inst.Transform then inst.Transform:SetScale(.22, .96, .33) end
    inst:RemoveComponent("workable")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(_G.ACTIONS.DIG)
    inst.components.workable:SetOnFinishCallback(function(r)
        r.components.lootdropper:DropLoot(pt)
        r:Remove()
    end)
    inst.components.workable:SetWorkLeft(1)
    _G.MakeObstaclePhysics(inst, 0, 0)
    inst:DoTaskInTime(_G.SHANGROCKS_SHENG, function()
        inst:StartThread(function()
            if inst.Transform then inst.Transform:SetScale(1, 1, 1) end
            _G.Sleep(.1)
            inst.AnimState:PlayAnimation("low")
            if zijin ~= "rock_flintless_low" then _G.Sleep(.8)
                inst.AnimState:PlayAnimation("med")
                if zijin ~= "rock_flintless_med" then _G.Sleep(1.2)
                    inst.AnimState:PlayAnimation("full")
                end
            end
            _G.SpawnPrefab(zijin).Transform:SetPosition(x, y, z)
            inst:Remove()
        end)
    end)
end

local function OnWork(inst, worker, workleft)
    local pt = inst:GetPosition()
    if worker:HasTag("player") or workleft > 0 then
        inst.shengyucishu = inst.shengyucishu - 1
        inst.components.lootdropper:DropLoot(pt)
    else _G.MakeObstaclePhysics(inst, 0, 0)
    end
    if workleft <= 0 or inst.shengyucishu <= 0 then
        if inst.shengyucishu <= 0 then
            _G.SpawnPrefab("rock_break_fx").Transform:SetPosition(pt:Get())
            if _G.SHANGROCKS_SHENG == 0 then
                inst:Remove()
            else
                ShenZ(inst)
            end
        else
            inst.components.workable:SetWorkLeft(_G.SHANGROCKS_MINE*20)
        end
    else
        inst.AnimState:PlayAnimation(
            (inst.shengyucishu < _G.SHANGROCKS_MINE / 3 and "low") or
            (inst.shengyucishu < _G.SHANGROCKS_MINE * 2 / 3 and "med") or
            "full"
        )
    end
end

local function OnSave(inst,data)
	local zijin = inst.prefab
    local WeiKaiCaiShu = zijin == "rock_flintless_med" and _G.SHANGROCKS_MINE or 
                         zijin == "rock_flintless_low" and _G.SHANGROCKS_MINE_LOW or _G.SHANGROCKS_MINE
    data.shengyucishu = inst.shengyucishu>0 and inst.shengyucishu~=WeiKaiCaiShu and inst.shengyucishu or nil
end

local function OnLoad(inst,data)
    local zijin = inst.prefab
    local YiKaiCaiShu = zijin == "rock_flintless_med" and _G.SHANGROCKS_MINE or 
                        zijin == "rock_flintless_low" and _G.SHANGROCKS_MINE_LOW or _G.SHANGROCKS_MINE
    if data ~= nil then
        inst.shengyucishu = data.shengyucishu~=nil and data.shengyucishu<YiKaiCaiShu and data.shengyucishu or YiKaiCaiShu
        if inst.shengyucishu ~= nil then
            inst.AnimState:PlayAnimation(
                (inst.shengyucishu < _G.SHANGROCKS_MINE / 3 and "low") or
                (inst.shengyucishu < _G.SHANGROCKS_MINE * 2 / 3 and "med") or
                "full")
        end
    end
end

for k, v in pairs(Rocks_Shang) do
    AddPrefabPostInit(v,function(inst)
    	if not _G.TheWorld.ismastersim then
            return inst
        end
        local ShengYuCiShu = inst.prefab == "rock_flintless_low" and _G.SHANGROCKS_MINE_LOW or 
                             inst.prefab == "rock_flintless_med" and _G.SHANGROCKS_MINE_MED or _G.SHANGROCKS_MINE
        inst.shengyucishu = ShengYuCiShu
        inst.components.lootdropper:SetChanceLootTable('Shang'..inst.prefab)
        inst.components.workable:SetWorkAction(_G.ACTIONS.MINE)
        inst.components.workable:SetWorkLeft(ShengYuCiShu*10)
        inst.components.workable:SetOnWorkCallback(OnWork)
		local color = .5 + math.random() * .5
		local colora = _G.SHANG_SHENGDANSHI and 0 + math.random() * 1 or color
		local colorb = _G.SHANG_SHENGDANSHI and 0 + math.random() * 1 or color
		local colorc = _G.SHANG_SHENGDANSHI and 0 + math.random() * 1 or color
		local colord = (_G.SHANG_SHENGDANSHI or _G.SHANG_RUOYINXIAN) and .1 + math.random() * .9 or 1
        inst.AnimState:SetMultColour(colora, colorb, colorc, colord)

        inst.OnSave = OnSave
        inst.OnLoad = OnLoad
    end)
end