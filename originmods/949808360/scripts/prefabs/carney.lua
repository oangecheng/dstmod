local MakePlayerCharacter = require "prefabs/player_common"
local cst=STRINGS.CARNEYSTRINGS

local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),

        Asset( "ANIM", "anim/carney.zip" ),
		Asset( "ANIM", "anim/ghost_carney_build.zip" ),
}
local prefabs = {}

local start_inv = {
	"whiteberet",
}

local function value(inst) --计算属性
	local lv = inst.components.carneystatus.level

    --饥饿判定
	local hunger_percent = inst.components.hunger:GetPercent()
	inst.components.hunger.max = 100 + lv*2
	inst.components.hunger:SetPercent(hunger_percent)

	--脑力判定
	local sanity_percent = inst.components.sanity:GetPercent()
	inst.components.sanity.max = 100 + lv*1
	inst.components.sanity:SetPercent(sanity_percent)
	
	--血量判定
	local health_percent = inst.components.health:GetPercent()
	inst.components.health.maxhealth = 100 + lv*1
	inst.components.health:SetPercent(health_percent)

	--最高exp判定
	inst.components.carneystatus.maxexp = lv * 200 + 100

	--速度计算
	inst.components.locomotor.walkspeed = inst.components.carneystatus.speedwalk
	inst.components.locomotor.runspeed = inst.components.carneystatus.speedrun
end

local function levelup(inst)
	inst.components.carneystatus.level = inst.components.carneystatus.level + 1
	inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
	inst.components.talker:Say("Level UP!")
	value(inst)
	inst.components.health:DoDelta(inst.components.health.maxhealth/5)
end

local function onkilledother(inst, data)
    local victim = data.victim

	if victim.components.freezable or victim:HasTag("monster") and victim.components.health then
		local value = math.ceil(victim.components.health.maxhealth)
		inst.components.carneystatus:DoDeltaExp(value)
	end
	
	if victim.components.lootdropper then
		if victim.components.freezable or victim:HasTag("monster") then
		    if math.random(1, 100) <= inst.components.carneystatus.level then
				victim.components.lootdropper:DropLoot()
	        end
		end
	end
end

local function onbecamehuman(inst)
	value(inst)
end

local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    if not inst:HasTag("playerghost") then
        onbecamehuman(inst)
    end
end

local function oneat(inst, food) 
	local humblefood = {"fish", "fish_cooked", "eel", "eel_cooked", "fishmeat", "fishmeat_cooked", "fishmeat_small", "fishmeat_small_cooked", "yotp_food3"}
	local mediumfood = {"surfnturf", "seafoodgumbo", "fishsticks", "californiaroll", "fishtacos", "ceviche", "unagi", "barnaclestuffedfishhead", "moqueca", "frogfishbowl"}
	local seniorfood = {}
	for i=1, #mediumfood do
		table.insert(seniorfood, i+#mediumfood*0, mediumfood[i].."_spice_chili")
	end
	for i=1, #mediumfood do
		table.insert(seniorfood, i+#mediumfood*1, mediumfood[i].."_spice_garlic")
	end
	for i=1, #mediumfood do
		table.insert(seniorfood, i+#mediumfood*2, mediumfood[i].."_spice_salt")
	end
	for i=1, #mediumfood do
		table.insert(seniorfood, i+#mediumfood*3, mediumfood[i].."_spice_sugar")
	end
	if food and food.components.edible then
		for i=1, #humblefood do
			if food.prefab == humblefood[i]
				then
				inst.components.carneystatus:DoDeltaExp(1000)
				inst.components.talker:Say("exp +1000")
				inst.components.sanity:DoDelta(20)
			end
		end
		for i=1, #mediumfood do
			if food.prefab == mediumfood[i]
				then
				inst.components.carneystatus:DoDeltaExp(2000)
				inst.components.talker:Say("exp +2000")
				inst.components.sanity:DoDelta(30)
			end
		end
		for i=1, #seniorfood do
			if food.prefab == seniorfood[i]
				then
				inst.components.carneystatus:DoDeltaExp(3000)
				inst.components.talker:Say("exp +3000")
				inst.components.sanity:DoDelta(40)
			end
		end
	end
end

local function DoDeltaExpCARNEY(inst)
	if inst.components.carneystatus.exp >= inst.components.carneystatus.maxexp then
		levelup(inst)
		local expnew = inst.components.carneystatus.exp - inst.components.carneystatus.maxexp
		inst.components.carneystatus.exp = 0
		if expnew > 0 then
			inst.components.carneystatus:DoDeltaExp(expnew)
		end
	end
end

local function onwalk(inst)
	if inst.components.locomotor.wantstomoveforward then
		inst.components.carneystatus:DoDeltaExp(.5)
	end
end

local function powerready(inst)
	if not inst.components.inventory.equipslots[EQUIPSLOTS.HANDS] then 
		return
	end
	local item = inst.components.inventory.equipslots[EQUIPSLOTS.HANDS].prefab
	if item ~= "boomerang"
    and item ~= "blowdart_sleep"
    and item ~= "blowdart_fire"
    and item ~= "blowdart_pipe"
    and item ~= "blowdart_yellow"
    and item ~= "blowdart_walrus"
    and item ~= "waterballoon"
    and item ~= "sleepbomb"
    then
	    inst.components.carneystatus.power = 1
		inst.powerfx = SpawnPrefab("carneychargefx")
	    inst.powerfx.entity:AddFollower()
	    inst.powerfx.Follower:FollowSymbol(inst.GUID, "swap_object", 30, -150, 0)
	    if item == "umbrella" or item == "grass_umbrella" then
	    	inst.powerfx.Follower:FollowSymbol(inst.GUID, "swap_object", -10, -380, 0)
	    end
	    if item == "shovel" or item == "goldenshovel" or item == "pitchfork" then
	    	inst.powerfx.Follower:FollowSymbol(inst.GUID, "swap_object", 0, 130, 0)
	    end
	    if item == "windyknife" then
	    	inst.powerfx.Follower:FollowSymbol(inst.GUID, "swap_object", 0, -150, 0)
	    end
	    if item == "totooriastaff1"
	    	or item == "totooriastaff2"
	    	or item == "totooriastaff3"
	    	or item == "totooriastaff4"
	    	or item == "totooriastaff5green"
	    	or item == "totooriastaff5orange"
	    	or item == "totooriastaff5yellow"
    	then
	    	inst.powerfx.Follower:FollowSymbol(inst.GUID, "swap_object", 0, -185, 0)
	    end
		inst.components.combat.damagemultiplier = inst.components.carneystatus.level*5/200 + 1.25
	end
end

local function hitother(inst)
	if inst.components.carneystatus.power == 1 and inst.components.combat.target and inst.components.combat.target:IsValid() then
		if inst.components.rider:IsRiding() then return end
		inst:DoTaskInTime(FRAMES*2, function()
			inst.components.carneystatus.power = 0
		end)
		inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
	    SpawnPrefab("firesplash_fx").Transform:SetPosition(inst.components.combat.target.Transform:GetWorldPosition())
	    inst.powerfx:Remove()
	    inst.fxout = SpawnPrefab("deer_fire_burst")
		inst.fxout.entity:SetParent(inst.entity)
		inst.fxout.entity:AddFollower()
    	inst.fxout.Follower:FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
		inst.SoundEmitter:PlaySound("dontstarve/common/fireOut")
		inst.components.combat.damagemultiplier = 1
		if inst.components.hunger.current <= 0 then
        	inst.components.health:DoDelta(-5)
        end
		inst.components.hunger:DoDelta(-5)
	end
end

local function unequip(inst,data)
	if inst.components.carneystatus.power == 1 and data.eslot == EQUIPSLOTS.HANDS then
		inst.powerfx:Remove()
		inst.fxout = SpawnPrefab("deer_fire_burst")
		inst.fxout.entity:SetParent(inst.entity)
		inst.fxout.entity:AddFollower()
    	inst.fxout.Follower:FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
		inst.SoundEmitter:PlaySound("dontstarve/common/fireOut")
		inst.components.carneystatus.power = 0
		inst.components.combat.damagemultiplier = 1
	end
end

local function deletefx(inst)
	if inst.freshfx then
		SpawnPrefab("lightning").Transform:SetPosition(inst.freshfx.Transform:GetWorldPosition())
		SpawnPrefab("explode_small").Transform:SetPosition(inst.freshfx.Transform:GetWorldPosition())
		inst.freshfx:Remove()
	end
end

local function spelldone(inst,data)
	inst:DoTaskInTime(0.1, function()
		if inst.components.carneystatus.spelling == 0 then
		    inst.components.carneystatus.spelling = 1
			if inst.components.hunger.current <= 0 then
				inst.components.health:DoDelta(-15)
			end
			inst.components.hunger:DoDelta(-15)
		    inst.freshfx = SpawnPrefab("freshaura")
		    inst.freshfx.Transform:SetPosition(inst.Transform:GetWorldPosition())
		    inst.freshfx:ListenForEvent("onremove", deletefx, inst)
		    inst.spellfx1 = SpawnPrefab("positronbeam_back")
		    inst.spellfx2 = SpawnPrefab("positronbeam_front")
		    inst.spellfx3 = SpawnPrefab("positronpulse")
		    inst.spellfx4 = SpawnPrefab("deer_ice_circle")
		    inst.spellfx5 = SpawnPrefab("deer_ice_flakes")
		    inst.spellfx1.entity:SetParent(inst.freshfx.entity)
		    inst.spellfx2.entity:SetParent(inst.freshfx.entity)
		    inst.spellfx3.entity:SetParent(inst.freshfx.entity)
		    inst.spellfx4.entity:SetParent(inst.freshfx.entity)
		    inst.spellfx5.entity:SetParent(inst.freshfx.entity)
		else
			inst.components.carneystatus.spelling = 0
			local p = nil
			if inst.freshfx then p = inst.freshfx else p = inst end
			SpawnPrefab("lightning").Transform:SetPosition(p.Transform:GetWorldPosition())
			SpawnPrefab("explode_small").Transform:SetPosition(p.Transform:GetWorldPosition())
			local pos = Vector3(inst.freshfx.Transform:GetWorldPosition())
			local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, 3)
			local amount = -1
			for k,v in pairs(ents) do
	    		if v:IsValid()
				and v.components.health
				and v.components.combat
				and not v.components.health:IsDead()
				and not v:HasTag("player")
				and not v:HasTag("wall")
				and not v:HasTag("structure")
				then
					if not v.components.inventoryitem or not v.components.inventoryitem.owner then
						amount = amount + 1
					end
	       		end
	    	end
			local value = (inst.components.carneystatus.level + 20)*(inst.components.carneystatus.power/4+1)*(1 + amount/10)
			for k,v in pairs(ents) do
	    		if v:IsValid()
				and v.components.health
				and v.components.combat
				and not v.components.health:IsDead()
				and not v:HasTag("player")
				and not v:HasTag("wall")
				and not v:HasTag("structure")
				then
					if not v.components.inventoryitem or not v.components.inventoryitem.owner then
	       				v.components.combat:GetAttacked(inst, value)
	       			end
	       		end
	    	end
	    	if inst.components.carneystatus.power == 1 then
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
			    SpawnPrefab("firesplash_fx").Transform:SetPosition(p.Transform:GetWorldPosition())
				inst.powerfx:Remove()
				inst.fxout = SpawnPrefab("deer_fire_burst")
				inst.fxout.entity:SetParent(inst.entity)
				inst.fxout.entity:AddFollower()
		    	inst.fxout.Follower:FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
				inst.SoundEmitter:PlaySound("dontstarve/common/fireOut")
				inst.components.carneystatus.power = 0
				inst.components.combat.damagemultiplier = 1
				inst.components.hunger:DoDelta(-5)
		        if inst.components.hunger.current <= 0 then
		        	inst.components.health:DoDelta(-5)
		        end
			end
			inst.freshfx:Remove()
	    end
    end)
end

local function OnDeath(inst)
	if inst.components.carneystatus.spelling == 1 then
		spelldone(inst)
	end
end

local function UpdateTemperature(inst)
	if TheWorld.state.temperature < 40 then
		inst.components.temperature:SetModifier("ctemp", -10)
	else
		inst.components.temperature:SetModifier("ctemp", 0)
	end
end

local common_postinit = function(inst)
	inst.clevel = net_shortint(inst.GUID,"clevel")
	inst.cexp = net_shortint(inst.GUID,"cexp")
	inst.cmiss = net_shortint(inst.GUID,"cmiss")
	inst.cmissactioning = net_shortint(inst.GUID,"cmissactioning")

	inst.MiniMapEntity:SetIcon( "carney.tex" )
	inst.soundsname = "willow"
	inst:AddTag("carney")
end

local master_postinit = function(inst)
	inst.components.eater:SetOnEatFn(oneat)

	inst:AddComponent("carneystatus")

	inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE
	inst:DoPeriodicTask(60, UpdateTemperature)
	
    inst.components.combat.damagemultiplier = 1
    inst.components.health.absorb = -.25
	
	inst.components.locomotor.walkspeed = inst.components.carneystatus.speedwalk
	inst.components.locomotor.runspeed = inst.components.carneystatus.speedrun

	inst.OnLoad = onload
    inst.OnNewSpawn = onload

	inst:ListenForEvent("killed", onkilledother)
    inst:ListenForEvent("onhitother", hitother)
    inst:ListenForEvent("DoDeltaExpCARNEY", DoDeltaExpCARNEY)
    inst:ListenForEvent("locomote", onwalk)
    inst:ListenForEvent("powerready", powerready)
    inst:ListenForEvent("unequip", unequip)
    inst:ListenForEvent("spelldone", spelldone)
    inst:ListenForEvent("ms_becomeghost", OnDeath)
    inst:ListenForEvent("death", OnDeath)

	value(inst)

	--闪避
	inst.components.combat.oldAttacked = inst.components.combat.GetAttacked
	function inst.components.combat:GetAttacked(...)
		if inst.components and inst.components.carneystatus and inst.components.carneystatus.miss == 1 then
			local fx = SpawnPrefab("shadow_shield3")
    		fx.entity:SetParent(inst.entity)
    		fx.entity:AddFollower()
	    	fx.Follower:FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
		else
			return inst.components.combat:oldAttacked(...)
		end
	end
end

return MakePlayerCharacter("carney", prefabs, assets, common_postinit, master_postinit, start_inv)