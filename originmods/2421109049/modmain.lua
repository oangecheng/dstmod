local _G = GLOBAL
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

local Cflowercave = GetModConfigData("flowercave")
local Cpond = GetModConfigData("pond")

local ACTIONS = GLOBAL.ACTIONS					--收获之书
local ActionHandler = GLOBAL.ActionHandler
local IsServer = GLOBAL.TheNet:GetIsServer() or GLOBAL.TheNet:IsDedicated()

local AllRecipes = GLOBAL.AllRecipes			--护符
local GetValidRecipe = GLOBAL.GetValidRecipe
local TheInput = GLOBAL.TheInput
local ThePlayer = GLOBAL.ThePlayer

local COLLISION = GLOBAL.COLLISION
local SpawnPrefab = GLOBAL.SpawnPrefab
local FRAMES = GLOBAL.FRAMES

local State = GLOBAL.State
local EventHandler = GLOBAL.EventHandler
local TimeEvent = GLOBAL.TimeEvent
local EQUIPSLOTS = GLOBAL.EQUIPSLOTS

GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})  		--铠甲

local LAN_ = GetModConfigData('Language')
if LAN_ then
require 'strings_carney_c'
TUNING.carneylan = true
else
require 'strings_carney_e'
TUNING.carneylan = false
end

local limit = GetModConfigData('DaggerLimit')
if limit then
	TUNING.wklimit = true
else
	TUNING.wklimit = false
end

local cross = GetModConfigData('CrossEdge')
if cross then
	TUNING.crossedge = true
else
	TUNING.crossedge = false
end

TUNING.DodgeKey = GetModConfigData('DodgeKey')
TUNING.ChargeKey = GetModConfigData('ChargeKey')
TUNING.IcicleKey = GetModConfigData('IcicleKey')
TUNING.NightVisionKey = GetModConfigData('NightVisionKey')
TUNING.CheckKey = GetModConfigData('CheckKey')

--选人信息
TUNING.CARNEY_HEALTH = 100
TUNING.CARNEY_HUNGER = 100
TUNING.CARNEY_SANITY = 100
if LAN_ then
	STRINGS.CHARACTER_SURVIVABILITY.carney = "易如反掌"
else
	STRINGS.CHARACTER_SURVIVABILITY.carney = "Pretty Easy"
end
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.CARNEY = {"whiteberet","angelcrystal"}
local c_startitem = {
	whiteberet = {
		atlas = "images/inventoryimages/whiteberet.xml",
		image = "whiteberet.tex",
	},
	angelcrystal = {
		atlas = "images/inventoryimages/angelcrystal.xml",
		image = "angelcrystal.tex",
	},
}
for k,v in pairs(c_startitem) do
	TUNING.STARTING_ITEM_IMAGE_OVERRIDE[k] = v
end

modimport("scripts/carney_util/carney_util.lua")

PrefabFiles = {
	"carney",
	"freshaura",
	"whiteberet",
	"angelcrystal",
	"windyknife",
	"nylon",
	"carneychargefx",
	"book_harvest",		--收获之书
	"lingdongamulet",	--护符
	"kj",				--铠甲
	"make_placer",
    }

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/carney.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/carney.xml" ),

    Asset( "IMAGE", "images/avatars/self_inspect_carney.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_carney.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/carney.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/carney.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/carney_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/carney_silho.xml" ),
	
	Asset( "IMAGE", "images/names_carney.tex" ),
    Asset( "ATLAS", "images/names_carney.xml" ),

    Asset( "IMAGE", "bigportraits/carney.tex" ),
    Asset( "ATLAS", "bigportraits/carney.xml" ),
	
	Asset( "IMAGE", "images/map_icons/carney.tex" ),
	Asset( "ATLAS", "images/map_icons/carney.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_carney.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_carney.xml" ),

	Asset( "IMAGE", "images/avatars/avatar_ghost_carney.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_carney.xml" ),

	Asset( "ATLAS", "images/inventoryimages/whiteberet.xml"),
	Asset( "IMAGE", "images/inventoryimages/whiteberet.tex" ),

	Asset( "ATLAS", "images/inventoryimages/windyknife.xml"),
	Asset( "IMAGE", "images/inventoryimages/windyknife.tex" ),

	Asset( "ATLAS", "images/inventoryimages/nylon.xml"),
	Asset( "IMAGE", "images/inventoryimages/nylon.tex" ),

	Asset( "ATLAS", "images/inventoryimages/lingdongamulet.xml"),--护符
	Asset( "IMAGE", "images/inventoryimages/lingdongamulet.tex"),
	
	Asset( "ATLAS", "images/inventoryimages/book_harvest.xml"),	--收获书
	Asset( "IMAGE", "images/inventoryimages/book_harvest.tex"),
	
	Asset("ATLAS", "images/inventoryimages/kj.xml"),			--铠甲
	Asset("IMAGE", "images/inventoryimages/kj.tex"),
	
	Asset("ATLAS", "images/inventoryimages/pond_cave.xml"),		--洞穴池塘
    Asset("IMAGE", "images/inventoryimages/pond_cave.tex"),
	
	Asset("ATLAS", "images/inventoryimages/flower_cave_triple.xml"),	--荧光果
    Asset("IMAGE", "images/inventoryimages/flower_cave_triple.tex"),

	Asset( "ATLAS", "images/hud/carneytab.xml"),
	Asset( "IMAGE", "images/hud/carneytab.tex" ),
}

AddStategraphPostInit("wilson", function(self)
    for key,value in pairs(self.states) do
        if value.name == 'run_stop' then
            local original_run_stop_onenter = self.states[key].onenter
            self.states[key].onenter = function(inst)
            	if inst.cmiss and inst.cmiss:value() == 1 then
            		inst.components.locomotor:Stop()
                else
                    original_run_stop_onenter(inst)
                end
            end
        end
        if value.name == 'run_start' then
            local original_run_start_onenter = self.states[key].onenter
            self.states[key].onenter = function(inst)
            	if inst.cmiss and inst.cmiss:value() == 1 then
            		inst.components.locomotor:RunForward()
            		inst.sg.mem.footsteps = 0
                else
                    original_run_start_onenter(inst)
                end
            end
        end
        if value.name == 'run' then
            local original_run_onenter = self.states[key].onenter
            self.states[key].onenter = function(inst)
            	if inst.cmiss and inst.cmiss:value() == 1 then
            		inst.components.locomotor:RunForward()
            		inst.sg:SetTimeout(inst.AnimState:GetCurrentAnimationLength())
                else
                    original_run_onenter(inst)
                end
            end
        end
        if value.name == 'funnyidle' then
            local original_funnyidle_onenter = self.states[key].onenter
            self.states[key].onenter = function(inst)
            	if inst.cmiss and inst.cmiss:value() == 1 then
                else
                    original_funnyidle_onenter(inst)
                end
            end
        end
        if value.name == 'attack' then
            local original_attack_onenter = self.states[key].onenter
            self.states[key].onenter = function(inst)
	            if inst
	            	and inst.components
	            	and inst.components.inventory
	            	and inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS) ~= nil
	            	and not inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS):HasTag("windyknife") then
	            	return original_attack_onenter(inst)
            	end
	            local function DoMountSound(inst, mount, sound, ispredicted)
				    if mount ~= nil and mount.sounds ~= nil then
				        inst.SoundEmitter:PlaySound(mount.sounds[sound], nil, nil, ispredicted)
				    end
				end
	            if inst.components.combat:InCooldown() then
	                inst.sg:RemoveStateTag("abouttoattack")
	                inst:ClearBufferedAction()
	                inst.sg:GoToState("idle", true)
	                return
	            end
            	local FRAMES = GLOBAL.FRAMES
	            local buffaction = inst:GetBufferedAction()
	            local target = buffaction ~= nil and buffaction.target or nil
	            local equip = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
	            inst.components.combat:SetTarget(target)
	            inst.components.combat:StartAttack()
	            inst.components.locomotor:Stop()
	            local cooldown = inst.components.combat.min_attack_period + .5 * FRAMES
	            if inst.components.rider:IsRiding() then
	                if equip ~= nil and (equip.components.projectile ~= nil or equip:HasTag("rangedweapon")) then
	                    inst.AnimState:PlayAnimation("player_atk_pre")
	                    inst.AnimState:PushAnimation("player_atk", false)
	                    if (equip.projectiledelay or 0) > 0 then
	                        --V2C: Projectiles don't show in the initial delayed frames so that
	                        --     when they do appear, they're already in front of the player.
	                        --     Start the attack early to keep animation in sync.
	                        inst.sg.statemem.projectiledelay = 8 * FRAMES - equip.projectiledelay
	                        if inst.sg.statemem.projectiledelay > FRAMES then
	                            inst.sg.statemem.projectilesound =
	                                (equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
	                                (equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
	                                "dontstarve/wilson/attack_weapon"
	                        elseif inst.sg.statemem.projectiledelay <= 0 then
	                            inst.sg.statemem.projectiledelay = nil
	                        end
	                    end
	                    if inst.sg.statemem.projectilesound == nil then
	                        inst.SoundEmitter:PlaySound(
	                            (equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
	                            (equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
	                            "dontstarve/wilson/attack_weapon",
	                            nil, nil, true
	                        )
	                    end
	                    cooldown = math.max(cooldown, 13 * FRAMES)
	                else
	                    inst.AnimState:PlayAnimation("atk_pre")
	                    inst.AnimState:PushAnimation("atk", false)
	                    DoMountSound(inst, inst.components.rider:GetMount(), "angry", true)
	                    cooldown = math.max(cooldown, 16 * FRAMES)
	                end
	            elseif equip ~= nil and equip:HasTag("windyknife") then
	                inst.AnimState:PlayAnimation("atk_pre")
	                inst.AnimState:PushAnimation("atk", false)
	                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
	                cooldown = 11 * FRAMES
	            elseif equip ~= nil and equip:HasTag("whip") then
	                inst.AnimState:PlayAnimation("whip_pre")
	                inst.AnimState:PushAnimation("whip", false)
	                inst.sg.statemem.iswhip = true
	                inst.SoundEmitter:PlaySound("dontstarve/common/whip_large", nil, nil, true)
	                cooldown = math.max(cooldown, 17 * FRAMES)
	            elseif equip ~= nil and equip:HasTag("book") then
	                inst.AnimState:PlayAnimation("attack_book")
	                inst.sg.statemem.isbook = true
	                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
	                cooldown = math.max(cooldown, 19 * FRAMES)
	            elseif equip ~= nil and equip:HasTag("chop_attack") and inst:HasTag("woodcutter") then
	                inst.AnimState:PlayAnimation(inst.AnimState:IsCurrentAnimation("woodie_chop_loop") and inst.AnimState:GetCurrentAnimationTime() < 7.1 * FRAMES and "woodie_chop_atk_pre" or "woodie_chop_pre")
	                inst.AnimState:PushAnimation("woodie_chop_loop", false)
	                inst.sg.statemem.ischop = true
	                cooldown = math.max(cooldown, 11 * FRAMES)
	            elseif equip ~= nil and equip.components.weapon ~= nil and not equip:HasTag("punch") then
	                inst.AnimState:PlayAnimation("atk_pre")
	                inst.AnimState:PushAnimation("atk", false)
	                if (equip.projectiledelay or 0) > 0 then
	                    --V2C: Projectiles don't show in the initial delayed frames so that
	                    --     when they do appear, they're already in front of the player.
	                    --     Start the attack early to keep animation in sync.
	                    inst.sg.statemem.projectiledelay = 8 * FRAMES - equip.projectiledelay
	                    if inst.sg.statemem.projectiledelay > FRAMES then
	                        inst.sg.statemem.projectilesound =
	                            (equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
	                            (equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
	                            "dontstarve/wilson/attack_weapon"
	                    elseif inst.sg.statemem.projectiledelay <= 0 then
	                        inst.sg.statemem.projectiledelay = nil
	                    end
	                end
	                if inst.sg.statemem.projectilesound == nil then
	                    inst.SoundEmitter:PlaySound(
	                        (equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
	                        (equip:HasTag("shadow") and "dontstarve/wilson/attack_nightsword") or
	                        (equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
	                        "dontstarve/wilson/attack_weapon",
	                        nil, nil, true
	                    )
	                end
	                cooldown = math.max(cooldown, 13 * FRAMES)
	            elseif equip ~= nil and (equip:HasTag("light") or equip:HasTag("nopunch")) then
	                inst.AnimState:PlayAnimation("atk_pre")
	                inst.AnimState:PushAnimation("atk", false)
	                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
	                cooldown = math.max(cooldown, 13 * FRAMES)
	            elseif inst:HasTag("beaver") then
	                inst.sg.statemem.isbeaver = true
	                inst.AnimState:PlayAnimation("atk_pre")
	                inst.AnimState:PushAnimation("atk", false)
	                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
	                cooldown = math.max(cooldown, 13 * FRAMES)
	            elseif inst:HasTag("weremoose") then
	                inst.sg.statemem.ismoose = true
	                inst.AnimState:PlayAnimation(
	                    ((inst.AnimState:IsCurrentAnimation("punch_a") or inst.AnimState:IsCurrentAnimation("punch_c")) and "punch_b") or
	                    (inst.AnimState:IsCurrentAnimation("punch_b") and "punch_c") or
	                    "punch_a"
	                )
	                cooldown = math.max(cooldown, 15 * FRAMES)
	            else
	                inst.AnimState:PlayAnimation("punch")
	                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
	                cooldown = math.max(cooldown, 24 * FRAMES)
	            end

	            inst.sg:SetTimeout(cooldown)

	            if target ~= nil then
	                inst.components.combat:BattleCry()
	                if target:IsValid() then
	                    inst:FacePoint(target:GetPosition())
	                    inst.sg.statemem.attacktarget = target
	                end
	            end
	        end
        end
    end
end)

AddStategraphPostInit("wilson_client", function(self)
    for key,value in pairs(self.states) do
        if value.name == 'run_stop' then
            local original_run_stop_onenter = self.states[key].onenter
            self.states[key].onenter = function(inst)
            	if GLOBAL.ThePlayer.cmiss and GLOBAL.ThePlayer.cmiss:value() == 1 then
            		GLOBAL.ThePlayer.components.locomotor:Stop()
                else
                    original_run_stop_onenter(inst)
                end
            end
        end
        if value.name == 'run_start' then
            local original_run_start_onenter = self.states[key].onenter
            self.states[key].onenter = function(inst)
            	if GLOBAL.ThePlayer.cmiss and GLOBAL.ThePlayer.cmiss:value() == 1 then
            		GLOBAL.ThePlayer.components.locomotor:RunForward()
            		GLOBAL.ThePlayer.sg.mem.footsteps = 0
                else
                    original_run_start_onenter(inst)
                end
            end
        end
        if value.name == 'run' then
            local original_run_onenter = self.states[key].onenter
            self.states[key].onenter = function(inst)
            	if GLOBAL.ThePlayer.cmiss and GLOBAL.ThePlayer.cmiss:value() == 1 then
            		GLOBAL.ThePlayer.components.locomotor:RunForward()
            		GLOBAL.ThePlayer.sg:SetTimeout(GLOBAL.ThePlayer.AnimState:GetCurrentAnimationLength())
                else
                    original_run_onenter(inst)
                end
            end
        end
        if value.name == 'attack' then
            local original_attack_onenter = self.states[key].onenter
            self.states[key].onenter = function(inst)
	            if inst
	            	and inst.replica
	            	and inst.replica.inventory
	            	and inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS) ~= nil
	            	and not inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS):HasTag("windyknife") then
	            	return original_attack_onenter(inst)
	            end
	            local function DoMountSound(inst, mount, sound)
				    if mount ~= nil and mount.sounds ~= nil then
				        inst.SoundEmitter:PlaySound(mount.sounds[sound], nil, nil, true)
				    end
				end
				local FRAMES = GLOBAL.FRAMES
            	local buffaction = inst:GetBufferedAction()
	            local cooldown = 0
	            if inst.replica.combat ~= nil then
	                if inst.replica.combat:InCooldown() then
	                    inst.sg:RemoveStateTag("abouttoattack")
	                    inst:ClearBufferedAction()
	                    inst.sg:GoToState("idle", true)
	                    return
	                end
	                inst.replica.combat:StartAttack()
	                cooldown = inst.replica.combat:MinAttackPeriod() + .5 * FRAMES
	            end
	            inst.components.locomotor:Stop()
	            local equip = inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
	            local rider = inst.replica.rider
	            if rider ~= nil and rider:IsRiding() then
	                if equip ~= nil and (equip:HasTag("rangedweapon") or equip:HasTag("projectile")) then
	                    inst.AnimState:PlayAnimation("player_atk_pre")
	                    inst.AnimState:PushAnimation("player_atk", false)
	                    if (equip.projectiledelay or 0) > 0 then
	                        --V2C: Projectiles don't show in the initial delayed frames so that
	                        --     when they do appear, they're already in front of the player.
	                        --     Start the attack early to keep animation in sync.
	                        inst.sg.statemem.projectiledelay = 8 * FRAMES - equip.projectiledelay
	                        if inst.sg.statemem.projectiledelay > FRAMES then
	                            inst.sg.statemem.projectilesound =
	                                (equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
	                                (equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
	                                "dontstarve/wilson/attack_weapon"
	                        elseif inst.sg.statemem.projectiledelay <= 0 then
	                            inst.sg.statemem.projectiledelay = nil
	                        end
	                    end
	                    if inst.sg.statemem.projectilesound == nil then
	                        inst.SoundEmitter:PlaySound(
	                            (equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
	                            (equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
	                            "dontstarve/wilson/attack_weapon",
	                            nil, nil, true
	                        )
	                    end
	                    if cooldown > 0 then
	                        cooldown = math.max(cooldown, 13 * FRAMES)
	                    end
	                else
	                    inst.AnimState:PlayAnimation("atk_pre")
	                    inst.AnimState:PushAnimation("atk", false)
	                    DoMountSound(inst, rider:GetMount(), "angry")
	                    if cooldown > 0 then
	                        cooldown = math.max(cooldown, 16 * FRAMES)
	                    end
	                end
                elseif equip ~= nil and equip:HasTag("windyknife") then
	                inst.AnimState:PlayAnimation("atk_pre")
	                inst.AnimState:PushAnimation("atk", false)
	                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
	                cooldown = 11 * FRAMES
	            elseif equip ~= nil and equip:HasTag("whip") then
	                inst.AnimState:PlayAnimation("whip_pre")
	                inst.AnimState:PushAnimation("whip", false)
	                inst.sg.statemem.iswhip = true
	                inst.SoundEmitter:PlaySound("dontstarve/common/whip_pre", nil, nil, true)
	                if cooldown > 0 then
	                    cooldown = math.max(cooldown, 17 * FRAMES)
	                end
	            elseif equip ~= nil and equip:HasTag("book") then
	                inst.AnimState:PlayAnimation("attack_book")
	                inst.sg.statemem.isbook = true
	                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
	                if cooldown > 0 then
	                    cooldown = math.max(cooldown, 19 * FRAMES)
	                end
	            elseif equip ~= nil and equip:HasTag("chop_attack") and inst:HasTag("woodcutter") then
	                inst.AnimState:PlayAnimation(inst.AnimState:IsCurrentAnimation("woodie_chop_loop") and inst.AnimState:GetCurrentAnimationTime() < 7.1 * FRAMES and "woodie_chop_atk_pre" or "woodie_chop_pre")
	                inst.AnimState:PushAnimation("woodie_chop_loop", false)
	                inst.sg.statemem.ischop = true
	                cooldown = math.max(cooldown, 11 * FRAMES)
	            elseif equip ~= nil and
	                equip.replica.inventoryitem ~= nil and
	                equip.replica.inventoryitem:IsWeapon() and
	                not equip:HasTag("punch") then
	                inst.AnimState:PlayAnimation("atk_pre")
	                inst.AnimState:PushAnimation("atk", false)
	                if (equip.projectiledelay or 0) > 0 then
	                    --V2C: Projectiles don't show in the initial delayed frames so that
	                    --     when they do appear, they're already in front of the player.
	                    --     Start the attack early to keep animation in sync.
	                    inst.sg.statemem.projectiledelay = 8 * FRAMES - equip.projectiledelay
	                    if inst.sg.statemem.projectiledelay > FRAMES then
	                        inst.sg.statemem.projectilesound =
	                            (equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
	                            (equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
	                            "dontstarve/wilson/attack_weapon"
	                    elseif inst.sg.statemem.projectiledelay <= 0 then
	                        inst.sg.statemem.projectiledelay = nil
	                    end
	                end
	                if inst.sg.statemem.projectilesound == nil then
	                    inst.SoundEmitter:PlaySound(
	                        (equip:HasTag("icestaff") and "dontstarve/wilson/attack_icestaff") or
	                        (equip:HasTag("shadow") and "dontstarve/wilson/attack_nightsword") or
	                        (equip:HasTag("firestaff") and "dontstarve/wilson/attack_firestaff") or
	                        "dontstarve/wilson/attack_weapon",
	                        nil, nil, true
	                    )
	                end
	                if cooldown > 0 then
	                    cooldown = math.max(cooldown, 13 * FRAMES)
	                end
	            elseif equip ~= nil and
	                (equip:HasTag("light") or
	                equip:HasTag("nopunch")) then
	                inst.AnimState:PlayAnimation("atk_pre")
	                inst.AnimState:PushAnimation("atk", false)
	                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_weapon", nil, nil, true)
	                if cooldown > 0 then
	                    cooldown = math.max(cooldown, 13 * FRAMES)
	                end
	            elseif inst:HasTag("beaver") then
	                inst.sg.statemem.isbeaver = true
	                inst.AnimState:PlayAnimation("atk_pre")
	                inst.AnimState:PushAnimation("atk", false)
	                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
	                if cooldown > 0 then
	                    cooldown = math.max(cooldown, 13 * FRAMES)
	                end
	            elseif inst:HasTag("weremoose") then
	                inst.sg.statemem.ismoose = true
	                inst.AnimState:PlayAnimation(
	                    ((inst.AnimState:IsCurrentAnimation("punch_a") or inst.AnimState:IsCurrentAnimation("punch_c")) and "punch_b") or
	                    (inst.AnimState:IsCurrentAnimation("punch_b") and "punch_c") or
	                    "punch_a"
	                )
	                if cooldown > 0 then
	                    cooldown = math.max(cooldown, 15 * FRAMES)
	                end
	            else
	                inst.AnimState:PlayAnimation("punch")
	                inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
	                if cooldown > 0 then
	                    cooldown = math.max(cooldown, 24 * FRAMES)
	                end
	            end

	            if buffaction ~= nil then
	                inst:PerformPreviewBufferedAction()

	                if buffaction.target ~= nil and buffaction.target:IsValid() then
	                    inst:FacePoint(buffaction.target:GetPosition())
	                    inst.sg.statemem.attacktarget = buffaction.target
	                end
	            end

	            if cooldown > 0 then
	                inst.sg:SetTimeout(cooldown)
	            end
	        end
        end
    end
end)

local function morepick(inst)
	if not inst.components.pickable then return end
	inst.components.pickable.oldpick = inst.components.pickable.Pick
	inst.components.pickable.oldonpickedfn = inst.components.pickable.onpickedfn
	function inst.components.pickable:Pick(picker)
		local oldnum = self.numtoharvest
		if picker.components.carneystatus then
			local picklevel = 35
			local value = math.ceil(picker.components.carneystatus.level/picklevel)
			local chance = (picker.components.carneystatus.level - math.floor(picker.components.carneystatus.level/picklevel)*picklevel)/picklevel
			if chance ~= 0 then
				if math.random() <= chance then
					value = value + 1
				end
			else
				value = value + 1
			end
			self.numtoharvest = self.numtoharvest*value

			if inst.prefab == "cactus" or inst.prefab == "oasis_cactus" then
				inst.components.pickable.onpickedfn = function(inst, picker)
					inst.Physics:SetActive(false)
				    inst.AnimState:PlayAnimation(inst.has_flower and "picked_flower" or "picked")
				    inst.AnimState:PushAnimation("empty", true)

				    if picker ~= nil then
				        if picker.components.combat ~= nil and not (picker.components.inventory ~= nil and picker.components.inventory:EquipHasTag("bramble_resistant")) then
				            picker.components.combat:GetAttacked(inst, TUNING.CACTUS_DAMAGE)
				            picker:PushEvent("thorns")
				        end

				        if inst.has_flower then
				            local loot = GLOBAL.SpawnPrefab("cactus_flower")
				            loot.components.inventoryitem:InheritMoisture(GLOBAL.TheWorld.state.wetness, GLOBAL.TheWorld.state.iswet)
				            if picker.components.inventory ~= nil then
				            	if self.numtoharvest > 1 and loot.components.stackable ~= nil then
			                        loot.components.stackable:SetStackSize(self.numtoharvest)
			                    end
				                picker.components.inventory:GiveItem(loot, nil, inst:GetPosition())
				            else
				                local x, y, z = inst.Transform:GetWorldPosition()
				                loot.components.inventoryitem:DoDropPhysics(x, y, z, true)
				            end
				        end
				    end

				    inst.has_flower = false
				end
			end
		end

		inst.components.pickable:oldpick(picker)
		inst.components.pickable.onpickedfn = inst.components.pickable.oldonpickedfn
	    self.numtoharvest = oldnum
	end
end

local function moreharvest(self)
	local oooooldHarvest = self.Harvest
	function self:Harvest(picker)
		if not self.inst:HasTag("mushroom_farm") and not self.inst:HasTag("waterplant") then
			return oooooldHarvest(self, picker)
		end
		
		local num = 1
		if picker.components.carneystatus then
			local harvestlevel = 35
			local value = math.ceil(picker.components.carneystatus.level/harvestlevel)
			local chance = (picker.components.carneystatus.level - math.floor(picker.components.carneystatus.level/harvestlevel)*harvestlevel)/harvestlevel
			if chance ~= 0 then
				if math.random() <= chance then
					value = value + 1
				end
			else
				value = value + 1
			end
			num = num*value

			self.produce = self.produce * num
		end
		return oooooldHarvest(self, picker)
	end
end

local function farmharvest(inst)
	if not inst.components.growable then return end
	local oldSetStage = inst.components.growable.SetStage
	inst.components.growable.SetStage = function(self, stage)
		oldSetStage(self, stage)
		if inst.cnOldSpawnLootPrefabcache and inst.components.lootdropper then
			inst.components.lootdropper.SpawnLootPrefab = inst.cnOldSpawnLootPrefabcache
			inst.cnOldSpawnLootPrefabcache = nil
		end
		if inst.components.pickable then
			local selfpick = inst.components.pickable
			local oldpick = inst.components.pickable.Pick
			inst.components.pickable.Pick = function(selfpick, picker)
				if picker and inst.components.lootdropper and picker.components.carneystatus then
					if not inst.cnOldSpawnLootPrefabcache then
						inst.cnOldSpawnLootPrefabcache = inst.components.lootdropper.SpawnLootPrefab
					end
					local selflootdpr = inst.components.lootdropper
					inst.components.lootdropper.SpawnLootPrefab = function(selflootdpr, lootprefab, pt, linked_skinname, skin_id, userid)
						local loot = inst.cnOldSpawnLootPrefabcache(selflootdpr, lootprefab, pt, linked_skinname, skin_id, userid)
						if picker and loot ~= nil then
							local num = nil
							if picker.components.carneystatus then
								local harvestlevel = 35
								num = math.ceil(picker.components.carneystatus.level/harvestlevel)
								local chance = (picker.components.carneystatus.level - math.floor(picker.components.carneystatus.level/harvestlevel)*harvestlevel)/harvestlevel
								if chance ~= 0 then
									if math.random() <= chance then
										num = num + 1
									end
								else
									num = num + 1
								end
							end
							if loot.components.stackable then
								local orisize = loot.components.stackable.stacksize
								local amount = num and num*(orisize or 1) or orisize or 1
								local max = loot.components.stackable.maxsize
								if amount > max then amount = max end
								loot.components.stackable:SetStackSize(amount)
							elseif loot.components.lootdropper then
								local oldloots = loot.components.lootdropper.loot
								if oldloots and #oldloots >=1 and num then
									local items = {}
									for k, v in pairs(oldloots) do
										for i=1, num do
											table.insert(items, v)
										end
									end
									loot.components.lootdropper.loot = items
								end
							end
						end
						return loot
					end
				end
				return oldpick(selfpick, picker)
			end
		end
	end
end

if not GLOBAL.TheNet:GetIsClient() then
	local list = {
		"grass",
		"sapling",
		"reeds",
		"flower",
		"carrot_planted",
		"flower_evil",
		"berrybush",
		"berrybush2",
		"berrybush_juicy",
		"cactus",
		"oasis_cactus",
		"red_mushroom",
		"green_mushroom",
		"blue_mushroom",
		"cave_fern",
		"cave_banana_tree",
		"lichen",
		"marsh_bush",
		"flower_cave",
		"flower_cave_double",
		"flower_cave_triple",
		"sapling_moon",
		"succulent_plant",
		"bullkelp_plant",
		"wormlight_plant",
		"stalker_berry",
		"stalker_bulb",
		"stalker_bulb_double",
		"stalker_fern",
		"rock_avocado_bush",
		"rosebush", --棱镜蔷薇花
		"orchidbush", --棱镜兰草花
		"lilybush", --棱镜蹄莲花
		"monstrain", --棱镜雨竹
		"shyerryflower", --棱镜颤栗花
		"oceanvine",--苔藓藤条
		"myth_banana_tree",	
		"myth_peachtree",
	}
	for i=1, #list do
		AddPrefabPostInit(list[i], function(inst)
			morepick(inst)
		end)
	end
	AddComponentPostInit("harvestable", function(self)
		moreharvest(self)
	end)

	--新版农场
	local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
	local WEED_DEFS = require("prefabs/weed_defs").WEED_DEFS
	local DEFS = {}
	for k, v in pairs(PLANT_DEFS) do table.insert(DEFS, v) end
	for k, v in pairs(WEED_DEFS) do table.insert(DEFS, v) end
	for k, v in pairs(DEFS) do
		if not v.data_only then
			AddPrefabPostInit(v.prefab, function(inst)
				farmharvest(inst)
			end)
		end
	end
end

local carneytab = AddRecipeTab(STRINGS.CARNEYTAB, 999, "images/hud/carneytab.xml", "carneytab.tex", "carney")

AddRecipe("whiteberet", {GLOBAL.Ingredient("manrabbit_tail", 2), GLOBAL.Ingredient("silk", 6)}, 
carneytab, TECH.NONE, nil, nil, nil, nil, "carney", 
"images/inventoryimages/whiteberet.xml", "whiteberet.tex" )

AddRecipe("windyknife", {GLOBAL.Ingredient("walrus_tusk", 1), GLOBAL.Ingredient("dragon_scales", 1), GLOBAL.Ingredient("moonrocknugget", 2)}, 
carneytab, TECH.NONE, nil, nil, nil, nil, "carney", 
"images/inventoryimages/windyknife.xml", "windyknife.tex" )

AddRecipe("kj",{GLOBAL.Ingredient("armorwood", 1), GLOBAL.Ingredient("armor_sanity", 1),GLOBAL.Ingredient("armormarble", 1), GLOBAL.Ingredient("armorruins", 1),GLOBAL.Ingredient("raincoat", 1)},
carneytab, TECH.NONE, nil, nil, nil, nil, "carney", 
"images/inventoryimages/kj.xml", "kj.tex")

AddRecipe("nylon", {GLOBAL.Ingredient("bearger_fur", 1), GLOBAL.Ingredient("steelwool", 2), GLOBAL.Ingredient("silk", 8)}, 
carneytab, TECH.NONE, nil, nil, nil, nil, "carney", 
"images/inventoryimages/nylon.xml", "nylon.tex" )

AddRecipe("lingdongamulet", {Ingredient("amulet", 1), Ingredient("oceanfish_small_8_inv", 1),Ingredient("oceanfish_medium_8_inv", 1),Ingredient("opalpreciousgem", 1)}, 
carneytab, TECH.NONE, nil, nil, nil, nil, "carney", "images/inventoryimages/lingdongamulet.xml", "lingdongamulet.tex")

AddRecipe("angelcrystal", {GLOBAL.Ingredient("redmooneye", 1), GLOBAL.Ingredient("bluemooneye", 1), GLOBAL.Ingredient("purplemooneye", 1), GLOBAL.Ingredient("yellowmooneye", 1), GLOBAL.Ingredient("orangemooneye", 1), GLOBAL.Ingredient("greenmooneye", 1)}, 
carneytab, TECH.NONE, nil, nil, nil, nil, "carney", 
"images/inventoryimages/angelcrystal.xml", "angelcrystal.tex" )

AddRecipe("book_harvest", {Ingredient("livinglog", 2), Ingredient("papyrus", 2), Ingredient("nightmarefuel", 4)}, 
carneytab, TECH.NONE, nil, nil, nil, nil, "carney", 
"images/inventoryimages/book_harvest.xml")

AddRecipe("alterguardianhat", {Ingredient("alterguardianhatshard", 5), Ingredient("opalpreciousgem", 1)}, 
carneytab, TECH.NONE, nil, nil, nil, nil, "carney")

AddRecipe("oceanfish_small_8_inv", {GLOBAL.Ingredient("pondeel", 1),GLOBAL.Ingredient("redgem", 1),GLOBAL.Ingredient("cactus_flower", 5)}, 
carneytab, TECH.NONE, nil, nil, nil, nil, "carney")

AddRecipe("oceanfish_medium_8_inv", {GLOBAL.Ingredient("pondfish", 2),GLOBAL.Ingredient("bluegem", 1),GLOBAL.Ingredient("ice", 5)}, 
carneytab, TECH.NONE, nil, nil, nil, nil, "carney")

AddRecipe("opalpreciousgem", {Ingredient("redgem", 1), Ingredient("orangegem", 1), Ingredient("yellowgem", 1), Ingredient("greengem", 1), Ingredient("bluegem", 1), Ingredient("purplegem", 1)}, 
carneytab, TECH.NONE, nil, nil, nil, nil, "carney")

AddRecipe("hermit_pearl", {GLOBAL.Ingredient("lavae_egg", 1), Ingredient("marble", 1)}, 
carneytab, TECH.NONE, nil, nil, nil, nil, "carney")

AddRecipe("moonrocknugget", {GLOBAL.Ingredient("hermit_cracked_pearl", 1)}, 
RECIPETABS.REFINE, TECH.NONE, nil, nil, nil, 40, nil)

AddRecipe("giftwrap", {GLOBAL.Ingredient("cutgrass", 1), GLOBAL.Ingredient("twigs", 1)}, 
RECIPETABS.SURVIVAL, TECH.NONE, nil, nil, nil, nil, nil)

AddRecipe("deer_antler1", {Ingredient("twigs", 1),Ingredient("boneshard", 1), Ingredient("silk", 1)}, 
RECIPETABS.REFINE, TECH.NONE, nil, nil, nil, nil, nil)

AddRecipe("messagebottle", {Ingredient("moonglass", 3),Ingredient("papyrus", 1)}, 
RECIPETABS.REFINE, TECH.NONE, nil, nil, nil, nil, nil)

AddRecipe("livinglog", {Ingredient("log", 1),Ingredient("nightmarefuel", 1), Ingredient("purplegem", 1)}, 
RECIPETABS.MAGIC, TECH.MAGIC_TWO, nil, nil, nil, nil, nil)

AddRecipe("bonestew", {Ingredient("purplegem", 3)}, RECIPETABS.FARM, TECH.NONE, nil, nil, nil, 10, nil)

AddRecipe("fishsticks", {Ingredient("yellowgem", 1)}, RECIPETABS.FARM, TECH.NONE, nil, nil, nil, 5, nil)

AddRecipe("surfnturf", {Ingredient("orangegem", 1)}, RECIPETABS.FARM, TECH.NONE, nil, nil, nil, 5, nil)

AddRecipe("miniboatlantern", {Ingredient("lightbulb", 5), Ingredient("log", 2),Ingredient("torch", 1)}, RECIPETABS.LIGHT, TECH.NONE, nil, nil, nil, nil, nil)

AddRecipe("horn", {Ingredient("glommerflower", 1), Ingredient("glommerwings", 1)}, RECIPETABS.REFINE, TECH.NONE, nil, nil, nil, nil, nil)

AddRecipe("pond_cave", {Ingredient("pondeel", 4),Ingredient("goldenshovel", 1),Ingredient("wateringcan", 1)}, 
RECIPETABS.SURVIVAL, TECH.NONE, "pond_cave_placer",nil,nil,nil,nil,"images/inventoryimages/pond_cave.xml","pond_cave.tex")	--洞穴池塘
		
AddRecipe("flower_cave_triple", {Ingredient("lightbulb", 10),Ingredient("cutreeds", 4),Ingredient("dug_sapling_moon", 1)}, 
RECIPETABS.SURVIVAL, TECH.NONE, "flower_cave_triple_placer",nil,nil,nil,nil,"images/inventoryimages/flower_cave_triple.xml","flower_cave_triple.tex")	--荧光果

STRINGS.CHARACTERS.CARNEY = require "speech_wilson"

AddMinimapAtlas("images/map_icons/carney.xml")
AddModCharacter("carney","FEMALE")

--尼龙背包反鲜
local Vale = GetModConfigData("Val")

local judge = TUNING.PERISH_FRIDGE_MULT	--获取冰箱的保鲜数值

local function DoReperishable(inst)	
	if  inst.components.container ~= nil then
		for k,v in pairs(inst.components.container.slots) do	--遍历有perishable组件的物品
			if v.components.perishable then
				v.components.perishable:ReducePercent(-.03)	--加新鲜度
			end
		end
	end
end

local function nylon_fx(inst)
	if inst.components.container ~= nil then	--检测是否有这个组件
		if judge < 0 then	--如果开了冰箱回鲜
		elseif judge >= 0 then	--如果没开冰箱回鲜需要单独反鲜的话
			inst:DoPeriodicTask(1, DoReperishable, -.03)	
		end
	end
end

AddPrefabPostInit("nylon",nylon_fx)	

--金子成组给短剑充能
local function M_trader(self)
	function self:AcceptGift(giver, item, count)
	    if self:AbleToAccept(item, giver) ~= true then
	        return false
	    end

	    if self:WantsToAccept(item, giver) then
	        count = count or 1

	        if item.components.stackable ~= nil and item.components.stackable.stacksize > count then
	            if self.inst.prefab == "windyknife" then
	                --item = item.components.stackable:Get(item.components.stackable.stacksize)
	                item.components.inventoryitem:RemoveFromOwner(true)
	            else
	                item = item.components.stackable:Get(count)
	            end
	        else
	            item.components.inventoryitem:RemoveFromOwner(true)
	        end

	        if self.deleteitemonaccept then
	            item:Remove()
	        elseif self.inst.components.inventory ~= nil then
	            item.prevslot = nil
	            item.prevcontainer = nil
	            self.inst.components.inventory:GiveItem(item, nil, giver ~= nil and giver:GetPosition() or nil)
	        end

	        if self.onaccept ~= nil then
	            self.onaccept(self.inst, giver, item)
	        end

	        self.inst:PushEvent("trade", { giver = giver, item = item })

	        return true
	    end

	    if self.onrefuse ~= nil then
	        self.onrefuse(self.inst, giver, item)
	    end
	    return false
	end
end
if GLOBAL.TheNet:GetIsMasterSimulation() then
	AddComponentPostInit("trader",M_trader)
end

--收获之书
local function Read2(book,doer)
	if book.components.book then
		if book.components.book:OnRead(doer) then
			return true
		end		
	end
end

local id = "READ2" --必须大写，动作会被加入到ACTIONS表中，key就是id。
local name = "阅读" --随意，会在游戏中能执行动作时，显示出动作的名字
local fn = function(act)
	local reader = act.doer
    local inst = act.target or act.invobject
    if inst ~= nil and
        act.doer ~= nil and
        inst.components.book ~= nil then
        return Read2(inst,reader)
    end
end

AddAction(id,name,fn)

local testfn = function(inst, doer, actions, right) -- 设置动作的检测函数，如果满足条件，就向人物的动作可执行表中加入某个动作。right表示是否是右键动作。
    if doer:HasTag("player") and (inst.prefab == "book_harvest" or inst.prefab =="book_weather") then
        table.insert(actions, ACTIONS.READ2)
    end
end

AddComponentAction("INVENTORY", "book", testfn)

local state = "book" -- 设定要绑定的state
AddStategraphActionHandler("wilson",ActionHandler(ACTIONS.READ2, state))
AddStategraphActionHandler("wilson_client",ActionHandler(ACTIONS.READ2,state))


--水上漂
GLOBAL.TUNING.AGUA = GetModConfigData("agua")

local function DoRipple(inst)
    if inst.components.drownable ~= nil and inst.components.drownable:IsOverWater() and not inst:HasTag("playerghost") then
        SpawnPrefab("weregoose_ripple"..tostring(math.random(2))).entity:SetParent(inst.entity)
    end
end

local function DoSplash(inst)
    if inst.components.drownable ~= nil and inst.components.drownable:IsOverWater() and inst.sg:HasStateTag("moving") and not inst:HasTag("playerghost") then
        SpawnPrefab("weregoose_splash_med"..tostring(math.random(2))).entity:SetParent(inst.entity)
    end
end

local function DoWetness(inst)
    if inst.components.drownable ~= nil and inst.components.drownable:IsOverWater() then
        --if inst.components.moisture then
        local equipamentos = inst.components.inventory:GetWaterproofness()
        local coberturas = inst.components.moisture.inherentWaterproofness 
        local variante = equipamentos + coberturas
        if variante > 1 then variante = 1 end
        local quantidadefinal = 1 - variante
        inst.components.moisture:DoDelta(0.6*quantidadefinal)    
        --end
    end 
end

local function ShouldNotDrown(inst)
    if inst.components.drownable ~= nil then
        if inst.components.drownable.enabled ~= false then
            inst.components.drownable.enabled = false
            if not inst:HasTag("playerghost") then
                inst.Physics:ClearCollisionMask()
                inst.Physics:CollidesWith(COLLISION.GROUND)
                inst.Physics:CollidesWith(COLLISION.OBSTACLES)
                inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
                inst.Physics:CollidesWith(COLLISION.CHARACTERS)
                inst.Physics:CollidesWith(COLLISION.GIANTS)
                inst.Physics:Teleport(inst.Transform:GetWorldPosition())
                if inst.goosewettask == nil then
                	inst.goosewettask = inst:DoPeriodicTask(2, DoWetness, FRAMES)
                end
            end
        end
    end
end

local function ShouldDrown(inst)
    if inst.components.drownable ~= nil then
        if inst.components.drownable.enabled == false then
           inst.components.drownable.enabled = true
            if not inst:HasTag("playerghost") then
                inst.Physics:ClearCollisionMask()
                inst.Physics:CollidesWith(COLLISION.WORLD)
                inst.Physics:CollidesWith(COLLISION.OBSTACLES)
                inst.Physics:CollidesWith(COLLISION.SMALLOBSTACLES)
                inst.Physics:CollidesWith(COLLISION.CHARACTERS)
                inst.Physics:CollidesWith(COLLISION.GIANTS)
                inst.Physics:Teleport(inst.Transform:GetWorldPosition())
                if TUNING.AGUA == 1 then
	                if inst.goosewettask ~= nil then
	                inst.goosewettask:Cancel()
	                inst.goosewettask = nil
	            	end
                end
            end
        end
    end
end

local function my_equipped(inst, equipper)
	equipper.AnimState:OverrideSymbol("swap_hat", "hat_kelp", "swap_hat")
    equipper.AnimState:Show("HAT")
    equipper.AnimState:Show("HAIR_HAT")
    equipper.AnimState:Hide("HAIR_NOHAT")
    equipper.AnimState:Hide("HAIR")
    equipper.SoundEmitter:PlaySound("dontstarve_DLC001/common/moggles_on")
	
	if equipper:HasTag("player") then
        equipper.AnimState:Hide("HEAD")
        equipper.AnimState:Show("HEAD_HAT")
    end
	
    if not equipper:HasTag("playerghost") then
        if equipper.gooserippletask == nil then
            equipper.gooserippletask = equipper:DoPeriodicTask(.7, DoRipple, FRAMES)
        end
        if equipper.goosesplashtask == nil then
            equipper.goosesplashtask = equipper:DoPeriodicTask(.3, DoSplash, FRAMES)
        end
    else
        if equipper.gooserippletask ~= nil then
            equipper.gooserippletask:Cancel()
            equipper.gooserippletask = nil
        end
        if equipper.goosesplashtask ~= nil then
            equipper.goosesplashtask:Cancel()
            equipper.goosesplashtask = nil
        end
    end

    ShouldNotDrown(equipper)    
end

local function my_unequipped(inst, equipper)
    
	equipper.AnimState:ClearOverrideSymbol("swap_hat")
    equipper.AnimState:Hide("HAT")
    equipper.AnimState:Hide("HAIR_HAT")
    equipper.AnimState:Show("HAIR_NOHAT")
    equipper.AnimState:Show("HAIR")
    equipper.SoundEmitter:PlaySound("dontstarve_DLC001/common/moggles_off")

    if equipper:HasTag("player") then
        equipper.AnimState:Show("HEAD")
        equipper.AnimState:Hide("HEAD_HAT")
    end

    ShouldDrown(equipper)    
end

AddPrefabPostInit("kelphat", function(inst)
    if not GLOBAL.TheWorld.ismastersim then
        return
    end

    if inst.components.equippable == nil then
        inst:AddComponent("equippable")
    end
    inst.components.equippable:SetOnEquip(my_equipped)
    inst.components.equippable:SetOnUnequip(my_unequipped)
end)