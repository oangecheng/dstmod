require 'util'
local AmeliaInvincibility = require "modifications/amelia_invincibility"

local MakePlayerCharacter = require "prefabs/player_common"
local Destroy = require "modifications/amelia_gpdestroy"
local GroundPound = require "modifications/amelia_groundpound"

local assets = {
	Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
	Asset( "ANIM", "anim/amelia.zip" ),
	Asset( "ANIM", "anim/ghost_amelia_build.zip" ),
}

local start_inv = {}
for k, v in pairs(TUNING.GAMEMODE_STARTING_ITEMS) do
    start_inv[string.lower(k)] = v.AMELIA
end
local prefabs = FlattenTree(start_inv, true)

-- Dialogues to pick randomly when Amelia get tilted
local salty_gamer_dialogues = {
	"IT'S THE PING!",
	"I was lagging!", 
    "My teammates SUCK!",
    "You guys SUCK!",
    "I'm not toxic!",
    "WHAAATTTTT!!?",
	"HOW DID THAT HIT ME!?",
	"What the heck!",
	"WHAT?!",
	"FEORJGIEF#@efef!!!",
	"ARGGGGGGGGGHHHHHH!!!",
	"*Raging Desk Slam Sound*",
	"*Angry Gremlin Noise*",
	"This mob is OP!!",
	"F**KKKKKK!!!!!"
}

local function SelfDropSalt(inst, item_counts)
	if inst ~= nil and inst.components.lootdropper ~= nil then
		local self_pos = inst:GetPosition()
		for i=1, item_counts do
			inst.components.lootdropper:SpawnLootPrefab('saltrock', self_pos)
		end
	end
end

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when not a ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "amelia_speed_mod", TUNING.AMELIA_MS)
end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "amelia_speed_mod")
end

local function onSave(inst, data)
	data.bubba = inst.bubba ~= nil and inst.bubba:GetSaveRecord() or nil
end

-- When loading or spawning the character
local function onLoad(inst, data)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
	end
	
	if data ~= nil and data.bubba ~= nil then
		inst._bubba_spawntask:Cancel()
		inst._bubba_spawntask = nil

		local bubba = SpawnSaveRecord(data.bubba)
		inst.bubba = bubba
		if bubba ~= nil then
			if inst.migrationpets ~= nil then
				table.insert(inst.migrationpets, bubba)
			end
			bubba:LinkToPlayer(inst)

	        bubba.AnimState:SetMultColour(0,0,0,1)
            bubba.components.colourtweener:StartTween({1,1,1,1}, 19*FRAMES)
			local fx = SpawnPrefab(bubba.spawnfx)
			fx.entity:SetParent(bubba.entity)

			inst:ListenForEvent("onremove", inst._bubba_onremove, bubba)
		end
	end
end

local function onAttacked(inst, data)
	if data.attacker ~= nil and math.random() <= TUNING.AMELIA_SALT_DROPRATE_ATTACKED then
		SelfDropSalt(inst, 1)
		inst.components.sanity:DoDelta(-TUNING.AMELIA_SANITY_PENALTY_ON_SALT)
		if TUNING.AMELIA_TOXIC_GAMER_LINES_ENABLED then
			inst.components.talker:Say(salty_gamer_dialogues[math.random(#salty_gamer_dialogues)])
		end
    end
end

local function onDeath(inst)
	SelfDropSalt(inst, 3)
end

local function SpawnBubba(inst)
    local player_check_distance = 40
    local attempts = 0
    
    local max_attempts = 30
    local x, y, z = inst.Transform:GetWorldPosition()

    local bubba = SpawnPrefab("bubba")
	inst.bubba = bubba
	bubba:LinkToPlayer(inst)
    inst:ListenForEvent("onremove", inst.bubba, bubba)

    while true do
        local offset = FindWalkableOffset(inst:GetPosition(), math.random() * PI, player_check_distance + 1, 10)

        if offset then
            local spawn_x = x + offset.x
            local spawn_z = z + offset.z
            
            if attempts >= max_attempts then
                bubba.Transform:SetPosition(spawn_x, y, spawn_z)
                break
            elseif not IsAnyPlayerInRange(spawn_x, 0, spawn_z, player_check_distance) then
                bubba.Transform:SetPosition(spawn_x, y, spawn_z)
                break
            else
                attempts = attempts + 1
            end
        elseif attempts >= max_attempts then
            bubba.Transform:SetPosition(x, y, z)
            break
        else
            attempts = attempts + 1    
        end
    end

    return bubba
end

local function onBubbaRemoved(inst)
	inst.bubba = nil
	inst._replacebubbatask = inst:DoTaskInTime(1, function(i) i._replacebubbatask = nil if i.bubba == nil then SpawnBubba(i) end end)
end

local function OnDespawn(inst)
    if inst.bubba ~= nil then
		inst.bubba:OnPlayerLinkDespawn()
    end
end

local function OnRemoveEntity(inst)
	-- hack to remove pets when spawned due to session state reconstruction for autosave snapshots
	if inst.bubba ~= nil and inst.bubba.spawntime == GetTime() then
		inst:RemoveEventCallback("onremove", inst._bubba_onremove, inst.bubba)
		inst.bubba:Remove()
	end

	if inst._story_proxy ~= nil and inst._story_proxy:IsValid() then
		inst._story_proxy:Remove()
	end
end

local function DoGroundpound(inst)
	if not (inst.sg:HasStateTag("busy") or inst.sg:HasStateTag("doing") or 
	        inst.sg:HasStateTag("nointerrupt") or inst.sg.statemem.heavy) then -- Prevents interupting busy states ie: kiara_parry
		if inst.components.rider and inst.components.rider:IsRiding() then
			inst.components.talker:Say("Not a good idea to do that while riding.")
		else
			if inst.components.hunger and inst.components.hunger.current > TUNING.AMELIA_GROUNDPOUND_HUNGER_COST then
					inst.components.hunger:DoDelta(-TUNING.AMELIA_GROUNDPOUND_HUNGER_COST)
					inst.sg:GoToState("ame_pound_pre")
			else
				inst.components.talker:Say("I'm too hungry to do that move.")
			end
		end
	end
end

local function OnKeyDown(inst, data)
	if data.inst == ThePlayer then
		 if data.key == _G[TUNING.AMELIA_GROUNDPOUND_KEY] then
			if data.inst.HUD and (data.inst.HUD:IsChatInputScreenOpen() or data.inst.HUD:IsConsoleScreenOpen()) then return end
			if TheWorld.ismastersim then
				BufferedAction(inst, inst, ACTIONS.AMELIA_GROUNDPOUND):Do()
			else
				SendModRPCToServer(MOD_RPC["amelia"]["GroundPoundAction"], inst)
			end
		end
	end
end

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "amelia.tex" )
	
	inst:AddTag("amelia")

	AmeliaInvincibility(inst)

	inst.entity:AddSoundEmitter()
	inst:AddComponent("keyhandler")
	inst:ListenForEvent("keydown", OnKeyDown)
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	inst:AddComponent("lootdropper")
	inst:AddComponent("timer")
	-- Set starting inventory
    inst.starting_inventory = start_inv[TheNet:GetServerGameMode()] or start_inv.default
	
	-- choose which sounds this character will play
	inst.soundsname = TUNING.AMELIA_VOICE
	
	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	-- Stats	
	inst.components.health:SetMaxHealth(TUNING.AMELIA_HEALTH)
	inst.components.hunger:SetMax(TUNING.AMELIA_HUNGER)
	inst.components.sanity:SetMax(TUNING.AMELIA_SANITY)
	
	-- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = TUNING.AMELIA_DPS
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = TUNING.AMELIA_HUNGER_RATE * TUNING.WILSON_HUNGER_RATE

	--Movement Speed
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "amelia_speed_mod", TUNING.AMELIA_MS)

	inst.components.petleash:SetMaxPets(0) -- Amelia can only have Bubba as a pet

	inst._bubba_spawntask = inst:DoTaskInTime(0, function(i) i._bubba_spawntask = nil SpawnBubba(i) end)
	inst._bubba_onremove = function(bubba) onBubbaRemoved(inst) end
	inst:DoPeriodicTask(60,function ()
		local random = math.random(0,100)
		if 5<random then
			inst.components.talker:Say("*HIC*")
		end
	end)
	inst.OnSave = onSave
	inst.OnLoad = onLoad
	inst.OnNewSpawn = onLoad
	inst.OnDespawn = OnDespawn
	
	inst:ListenForEvent("onremove", OnRemoveEntity)
	inst:ListenForEvent("amelia_groundpound", DoGroundpound)

	--Hides Armor and Hat
	if TUNING.AMELIA_HIDDEN then
		inst:ListenForEvent("equip", function()
			inst.AnimState:ClearOverrideSymbol("swap_hat")
			inst.AnimState:Show("hair")
			inst.AnimState:ClearOverrideSymbol("swap_body")
			inst.AnimState:Show("body")
		end)
	end


	inst:AddComponent("groundpounder")
	inst.components.groundpounder.DestroyPoints = Destroy -- Custom DestroyPoints for AOE range and logic
	inst.components.groundpounder.GroundPound = GroundPound -- Custom GROUND POUND
	inst.components.groundpounder.gprange = TUNING.AMELIA_GROUNDPOUND_RADIUS -- Damage Range/ Victim range/ Your mom
	inst.components.groundpounder.destroyer = TUNING.AMELIA_GROUNDPOUND_DESTROY_STRUCTURE_ENABLED -- Can Destroy boulders/trees etc
	inst.components.groundpounder.groundpounddamagemult = TUNING.AMELIA_GROUNDPOUND_DMG_MULTI -- Damage multiplier
    inst.components.groundpounder.damageRings = 1 -- Hurting
    inst.components.groundpounder.destructionRings = 1 -- Ring for destoying ie boulders
	inst.components.groundpounder.platformPushingRings = 1 -- Not sure what this is but for pushing objects maybe
	--TODO might change how it creates effects because it's kinda missleading
    inst.components.groundpounder.numRings = 2 -- Visual Rings
    
	-- Event listeners
	inst:ListenForEvent("attacked", onAttacked)
	inst:ListenForEvent("death", onDeath)
end

return MakePlayerCharacter("amelia", prefabs, assets, common_postinit, master_postinit, prefabs)
