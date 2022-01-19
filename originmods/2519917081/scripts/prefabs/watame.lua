local MakePlayerCharacter = require "prefabs/player_common"

local SetAutoRespawn = require "modifications.watame_auto_respawn"
local CheckCurrentAnim = require "modifications.watame_night_fever_player"
local Jingisukan = require "modifications.watame_jingisukan"
local WatameWool = require "modifications.watame_wool"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
	Asset("ANIM", "anim/beard.zip"),
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.WATAME
end


--local prefabs = FlattenTree(start_inv, true)

local prefabs =
{
    "steelwool",
}

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when not a ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "watame_speed_mod", TUNING.WATAME_MS)
	inst.components.burnable:SetBurnTime(10) --I don't know why every died the burning time will reset so I add this in here.
end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "watame_speed_mod")
end

local function onsave(inst, data)
    if data then
        if inst.deathcounts ~= nil then
            data.latestdeathcounts = inst.deathcounts
        end
    end
end

-- When loading or spawning the character
local function onload(inst, data)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

	if data and data.latestdeathcounts then
        inst.deathcounts = data.latestdeathcounts
    end

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end

local function OnDespawn(inst)
	TheWorld:PushEvent("enabledynamicmusic", true)
	if inst.SoundEmitter then
		inst.SoundEmitter:KillSound("wnf_loop")
	end
	if inst.my_dance_floor then
		inst.my_dance_floor:RemoveFloor()
		inst.my_dance_floor = nil
		inst.components.skinner:SetSkinMode("normal_skin")
	end
end

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "watame.tex" )
	
	inst:AddTag("watame")  --添加用來讓watame可以製作個人道具的代碼
	inst:AddTag("bearded")

	inst.entity:AddSoundEmitter()
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- Set starting inventory
	inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
	
	-- choose which sounds this character will play
	inst.soundsname = TUNING.WATAME_VOICE
	
	if TUNING.WATAME_VOICE == "wathgrithr" or TUNING.WATAME_VOICE == "webber" then
		inst.talker_path_override = "dontstarve_DLC001/characters/"
	end
	
	inst.my_dance_floor = nil
	
	--這裡開始是新增的coding

	if TUNING.WATAME_IMMUNE_TO_COLD then
		--不怕冷
		inst.components.temperature.mintemp = 5
	else
		inst.components.temperature.inherentinsulation = TUNING.INSULATION_SMALL
	end


	--鼓舞人心(周圍隊友san值回復(小))
	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = (TUNING.SANITYAURA_SMALL)	
	inst.components.sanity.neg_aura_mult = 1.5
	
	--自體回復San值(小)
	inst.components.sanity.dapperness = TUNING.DAPPERNESS_SMALL
	
	--8秒重生(並且下一次死亡必須以正常方式復活才能再度獲得8秒重生)

	SetAutoRespawn(inst)
	CheckCurrentAnim(inst)

	--可以刮羊毛
	WatameWool(inst)

	--死亡後掉肉
	inst:AddComponent("lootdropper")
	inst:ListenForEvent("death", Jingisukan)

	--新增的coding到這裡結束

	-- Stats	
	inst.components.health:SetMaxHealth(TUNING.WATAME_HEALTH)
	inst.components.hunger:SetMax(TUNING.WATAME_HUNGER)
	inst.components.sanity:SetMax(TUNING.WATAME_SANITY)
	
	--著火時燒傷時間更長(一般角色約3秒)
	inst.components.burnable:SetBurnTime(10)

	-- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = TUNING.WATAME_DPS
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = TUNING.WATAME_HUNGER_RATE * TUNING.WILSON_HUNGER_RATE
	
	inst.OnSave = onsave
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	inst.OnDespawn = OnDespawn
end

return MakePlayerCharacter("watame", prefabs, assets, common_postinit, master_postinit, start_inv)
