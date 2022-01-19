local MakePlayerCharacter = require "prefabs/player_common"
local ttrstrs=STRINGS.TTRSTRINGS

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

        Asset( "ANIM", "anim/"..TUNING.ttranim..".zip" ),
		Asset( "ANIM", "anim/ghost_totooria_build.zip" ),
}
local prefabs = {}

-- Custom starting items
local start_inv = {
	"totooriastaff1",
	"totooriahat",
	"goldnugget",
	"goldnugget",
	"goldnugget",
	"goldnugget",
	"goldnugget",
	"goldnugget",
}

--勇敢特技判定
local function damagemodifer(inst, data)
	local modifer
	if inst.components.totooriastatus.yonggan == 1 then
		modifer = (inst.components.health.maxhealth - inst.components.health.currenthealth)/100
	else
		modifer = 0
	end
	inst.components.combat.damagemultiplier = (TUNING.WENDY_DAMAGE_MULT * (1 + inst.components.totooriastatus.gongjili/20) * (modifer + 1))
	inst.components.totooriastatus.damage = inst.components.combat.damagemultiplier*10000
end

local function xuezhecheck(inst)
	if inst:HasTag("teji_xuezhe") then
		inst.components.builder.ingredientmod = .5
	else
		inst.components.builder.ingredientmod = 1
	end
end

local function shuxing(inst) --计算属性
    --脑力和回脑速度判定
	local max_jiacheng = 20
	local jiacheng = math.min(inst.components.totooriastatus.dengji, max_jiacheng)
	local sanity_percent = inst.components.sanity:GetPercent()
	inst.components.sanity.max = math.ceil (200 + jiacheng * 10) --400
	inst.components.sanity:SetPercent(sanity_percent)
	inst.components.sanity.dapperness = TUNING.DAPPERNESS_HUGE/18*jiacheng
	
	if inst.components.totooriastatus.gongjili >= 10 then
		inst.components.totooriastatus.shixue = 1
	end
	if inst.components.totooriastatus.xueliang >= 10 then
		inst.components.totooriastatus.yonggan = 1
	end
	if inst.components.totooriastatus.sudu >= 10 then
		inst.components.totooriastatus.lingqiao = 1
	end
	
	--攻击力判定
	damagemodifer(inst)
	
	--HP判定
	local health_percent = inst.components.health:GetPercent()
	inst.components.health.maxhealth = 75+inst.components.totooriastatus.xueliang*125/20
	inst.components.health:SetPercent(health_percent)
	
	--速度判定
	if inst.components.totooriastatus.open == 1 then
		inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED + inst.components.totooriastatus.sudu/20*2) *1.5
		inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED + inst.components.totooriastatus.sudu/20*3) *1.5
	else
		inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED + inst.components.totooriastatus.sudu/20*2
		inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED + inst.components.totooriastatus.sudu/20*3
	end

	inst.components.totooriastatus.yijiajineng = inst.components.totooriastatus.gongjili + inst.components.totooriastatus.xueliang + inst.components.totooriastatus.xingyun + inst.components.totooriastatus.sudu
	
	--等级特技判定
	if inst.components.totooriastatus.dengji == 20 and inst.components.totooriastatus.xuezheon ==1 then
		inst:AddTag("teji_xuezhe")
	end
	if inst.components.totooriastatus.dengji >= 15 and inst.components.totooriastatus.qiaoshouon ==1 then
		inst:AddTag("teji_qiaoshou")
	end
	if inst.components.totooriastatus.dengji >= 10 and inst.components.totooriastatus.dachuon ==1 then
		inst:AddTag("teji_dachu")
	end
	if inst.components.totooriastatus.dengji >=5 and inst.components.totooriastatus.youshanon ==1 then
		inst:AddTag("teji_youshan")
		inst:RemoveTag("scarytoprey")
	end
	
	--学者特技设置
	xuezhecheck(inst)
end

local function shengji(inst)
	if inst.components.totooriastatus.dengji < 20 then
				inst.components.totooriastatus.dengji = inst.components.totooriastatus.dengji + 1
				inst.components.totooriastatus.jinengdian = inst.components.totooriastatus.jinengdian + 1
				inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
				if inst.components.totooriastatus.dengji == 5 then
				inst.components.talker:Say(ttrstrs[1].."\n"..ttrstrs[2].."\n"..ttrstrs[6]..(inst.components.totooriastatus.jinengdian)..ttrstrs[7].."\n"..ttrstrs[8])
				else
				if inst.components.totooriastatus.dengji == 10 then
				inst.components.talker:Say(ttrstrs[1].."\n"..ttrstrs[3].."\n"..ttrstrs[6]..(inst.components.totooriastatus.jinengdian)..ttrstrs[7].."\n"..ttrstrs[8])
				else
				if inst.components.totooriastatus.dengji == 15 then
				inst.components.talker:Say(ttrstrs[1].."\n"..ttrstrs[4].."\n"..ttrstrs[6]..(inst.components.totooriastatus.jinengdian)..ttrstrs[7].."\n"..ttrstrs[8])
				else
				if inst.components.totooriastatus.dengji == 20 then
				inst.components.talker:Say(ttrstrs[1].."\n"..ttrstrs[5].."\n"..ttrstrs[6]..(inst.components.totooriastatus.jinengdian)..ttrstrs[7].."\n"..ttrstrs[8])
				else
				inst.components.talker:Say(ttrstrs[1].."\n"..ttrstrs[6]..(inst.components.totooriastatus.jinengdian)..ttrstrs[7].."\n"..ttrstrs[8])
				end end end
			end
	end
	shuxing(inst)
end

local function xidian(inst)
	if inst.components.totooriastatus.dengji < 5 then
		inst.components.talker:Say(ttrstrs[9])
	else
		inst.components.totooriastatus.dengji = inst.components.totooriastatus.dengji - 5
		inst.components.totooriastatus.jinengdian = inst.components.totooriastatus.dengji
		inst.components.totooriastatus.xingyun = 0
		inst.components.totooriastatus.gongjili = 0
		inst.components.totooriastatus.xueliang = 0
		inst.components.totooriastatus.sudu = 0

		inst.components.totooriastatus.tintdata01 = 0
	    inst.components.totooriastatus.tintdata02 = 0
	    inst.components.totooriastatus.tintdata03 = 0
	    inst.components.totooriastatus.tintdata04 = 0
	    inst.components.totooriastatus.tintdata05 = 0
	    inst.components.totooriastatus.tintdata06 = 0
	    inst.components.totooriastatus.tintdata07 = 0
	    inst.components.totooriastatus.tintdata08 = 0
	    inst.components.totooriastatus.tintdata09 = 0
	    inst.components.totooriastatus.tintdata10 = 0
	    inst.components.totooriastatus.tintdata11 = 0
	    inst.components.totooriastatus.tintdata12 = 0
	    inst.components.totooriastatus.tintdata13 = 0
	    inst.components.totooriastatus.tintdata14 = 0
	    inst.components.totooriastatus.tintdata15 = 0
	    inst.components.totooriastatus.tintdata16 = 0
	    inst.components.totooriastatus.tintdata17 = 0
	    inst.components.totooriastatus.tintdata18 = 0
	    inst.components.totooriastatus.tintdata19 = 0
	    inst.components.totooriastatus.tintdata20 = 0
		
		if inst.components.totooriastatus.dengji >= 10 and inst.components.totooriastatus.dengji <15 then
			inst:RemoveTag("teji_qiaoshou")
			inst.components.talker:Say(ttrstrs[10].."\n"..ttrstrs[11].."\n"..ttrstrs[15]..(inst.components.totooriastatus.dengji)..ttrstrs[16]..(inst.components.totooriastatus.jinengdian)..ttrstrs[7].."\n"..ttrstrs[8])
		else
			if inst.components.totooriastatus.dengji >= 5 and inst.components.totooriastatus.dengji <10 then
				inst:RemoveTag("teji_dachu")
				inst.components.talker:Say(ttrstrs[10].."\n"..ttrstrs[12].."\n"..ttrstrs[15]..(inst.components.totooriastatus.dengji)..ttrstrs[16]..(inst.components.totooriastatus.jinengdian)..ttrstrs[7].."\n"..ttrstrs[8])
			else
				if inst.components.totooriastatus.dengji >= 0 and inst.components.totooriastatus.dengji <5 then
					inst:RemoveTag("teji_youshan")
					inst:AddTag("scarytoprey")
					inst.components.talker:Say(ttrstrs[10].."\n"..ttrstrs[13].."\n"..ttrstrs[15]..(inst.components.totooriastatus.dengji)..ttrstrs[16]..(inst.components.totooriastatus.jinengdian)..ttrstrs[7].."\n"..ttrstrs[8])
				else
					if inst.components.totooriastatus.dengji == 15 then
						inst:RemoveTag("teji_xuezhe")
						inst.components.talker:Say(ttrstrs[10].."\n"..ttrstrs[14].."\n"..ttrstrs[15]..(inst.components.totooriastatus.dengji)..ttrstrs[16]..(inst.components.totooriastatus.jinengdian)..ttrstrs[7].."\n"..ttrstrs[8])
					else
						inst.components.talker:Say(ttrstrs[10].."\n"..ttrstrs[15]..(inst.components.totooriastatus.dengji)..ttrstrs[16]..(inst.components.totooriastatus.jinengdian)..ttrstrs[7].."\n"..ttrstrs[8])
					end
				end
			end
		end
		shuxing(inst)
	end
end

local function onattack(inst, data)
	damagemodifer(inst)
	--嗜血特技判定
    local target = data.target
    if inst.components.totooriastatus.shixue == 1 then
    	if target.components.freezable or target:HasTag("monster") then
        	inst.components.health:DoDelta(inst.components.totooriastatus.gongjili / 10)
    	end
    end
end

local function onkilledother(inst, data)
    local victim = data.victim

	if victim.components.freezable or victim:HasTag("monster") and victim.components.health then
		local value = math.ceil(victim.components.health.maxhealth/100)
		inst.components.totooriastatus:DoDeltaExp(value)
	end
	
	--打怪掉东西
	if victim.components.lootdropper then
		if victim.components.freezable or victim:HasTag("monster") then
			if inst.components.totooriastatus.xingyun/10 > 1 then
			    victim.components.lootdropper:SpawnLootPrefab("goldnugget")
			    if math.random() <= (inst.components.totooriastatus.xingyun/10 - 1) then
					victim.components.lootdropper:DropLoot()
		        end
			else
			    if math.random() <= inst.components.totooriastatus.xingyun/10 then
				    if victim.components.lootdropper then
					    victim.components.lootdropper:SpawnLootPrefab("goldnugget")
				    end
			    end
		    end
		end
	end
end

local function onbecamehuman(inst)
	shuxing(inst)
end

local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    if not inst:HasTag("playerghost") then
        onbecamehuman(inst)
    end
end

local function oneat(inst, food) 
	if food and food.components.edible then
		if food.prefab == "mandrake" then --吃生的曼德拉草洗点，惩罚是降低5级
			xidian(inst)
		else
			if inst.components.totooriastatus.dengji ~= 20 then
				if food.prefab == "plantmeat" or food.prefab == "plantmeat_cooked" or food.prefab == "royal_jelly" or food.prefab == "cookedmandrake" or food.prefab == "mandrakesoup" or food.prefab == "tallbirdegg" or food.prefab == "tallbirdegg_cooked" or food.prefab == "tallbirdegg_cracked" or food.prefab == "wormlight" then
					inst.components.totooriastatus:DoDeltaExp(20)
				else
					if food.prefab == "butter" then
						inst.components.totooriastatus:DoDeltaExp(60)
					else
						if food.prefab == "jellybean" then
							inst.components.totooriastatus:DoDeltaExp(10)
						else
							if food.prefab == "deerclops_eyeball" then
								inst.components.totooriastatus:DoDeltaExp(100)
							else
								if food.prefab == "minotaurhorn" then
									inst.components.totooriastatus:DoDeltaExp(200)
								else
									if food and food.components.edible then
										local hunger = math.abs(food.components.edible:GetHunger())
										local sanity = math.abs(food.components.edible:GetSanity())
										local health = math.abs(food.components.edible:GetHealth())
										local delta = math.ceil((hunger + sanity + health)*.04)
										inst.components.totooriastatus:DoDeltaExp(delta)
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

local function onunlockrecipe(inst,data)
	if inst.components.totooriastatus.dengji ~= 20 then
		inst.components.totooriastatus:DoDeltaExp(5)
	end
end

--local function onsanitydelta(inst,data)
--	if inst.components.totooriastatus.dengji ~= 20 then
--		inst.components.totooriastatus:DoDeltaExp(math.random(1,3))
--	end
--end

local function onattacked(inst,data)
	if inst.components.totooriastatus.dengji ~= 20 then
		inst.components.totooriastatus:DoDeltaExp(1)
	end
end

local function onpreload(inst, data)
    if data then
	    if data.tintdata then
		else--照顾旧版存档玩家
			inst.components.totooriastatus.dengji = data.dengji
		    if data.yonggan and data.yonggan == true then
		        inst.components.totooriastatus.yonggan = 1
		    end
		    if data.shixue and data.shixue == true then
		        inst.components.totooriastatus.shixue = 1
		    end
		    if data.lingqiao and data.lingqiao == true then
		        inst.components.totooriastatus.lingqiao = 1
		    end

			inst.components.totooriastatus.jinengdian = data.xingyun*10 + data.gongjili + data.xueliang + data.sudu
			inst.components.totooriastatus.xingyun = 0
			inst.components.totooriastatus.gongjili = 0
			inst.components.totooriastatus.xueliang = 0
			inst.components.totooriastatus.sudu = 0

			inst:DoTaskInTime(3, function() inst.components.talker:Say(ttrstrs[45]) end)
			inst:DoTaskInTime(5, function() inst.components.talker:Say(ttrstrs[46].."\n"..ttrstrs[47].."\n"..ttrstrs[48]) end)
			inst:DoTaskInTime(7, function() inst.components.talker:Say(ttrstrs[46].."\n"..ttrstrs[47].."\n"..ttrstrs[48]) end)
			inst:DoTaskInTime(9, function() inst.components.talker:Say(ttrstrs[46].."\n"..ttrstrs[47].."\n"..ttrstrs[48]) end)
			inst:DoTaskInTime(11, function() inst.components.talker:Say(ttrstrs[46].."\n"..ttrstrs[47].."\n"..ttrstrs[48]) end)
			inst:DoTaskInTime(13, function() inst.components.talker:Say(ttrstrs[46].."\n"..ttrstrs[47].."\n"..ttrstrs[48]) end)
		end
		
	    shuxing(inst)
	end
end
local function onsave(inst, data)
	data.tintdata = inst.tintdata
end

local function DoDeltaYoushan(inst)
	if inst.components.totooriastatus.youshanon == 1 then
		inst:AddTag("teji_youshan")
		inst:RemoveTag("scarytoprey")
	else
		inst:RemoveTag("teji_youshan")
		inst:AddTag("scarytoprey")
	end
end

local function DoDeltaDachu(inst)
	if inst.components.totooriastatus.dachuon == 1 then
		inst:AddTag("teji_dachu")
	else
		inst:RemoveTag("teji_dachu")
	end
end

local function DoDeltaQiaoshou(inst)
	if inst.components.totooriastatus.qiaoshouon == 1 then
		inst:AddTag("teji_qiaoshou")
	else
		inst:RemoveTag("teji_qiaoshou")
	end
end

local function DoDeltaXuezhe(inst)
	if inst.components.totooriastatus.xuezheon == 1 then
		inst:AddTag("teji_xuezhe")
	else
		inst:RemoveTag("teji_xuezhe")
	end
	xuezhecheck(inst)
end

local function DoDeltaExpTTR(inst)
	if inst.components.totooriastatus.dengji == 20 then
		inst.components.totooriastatus.exp = 100
	else
		local value = inst.components.totooriastatus.exp - inst.components.totooriastatus.expold
		if value > 0 then
			inst.components.talker:Say("exp +"..(value))
		end
		if inst.components.totooriastatus.exp >= 100 then
			shengji(inst)
			if inst.components.totooriastatus.dengji == 20 then
				inst.components.totooriastatus.exp = 100
			else
				inst.components.totooriastatus:DoDeltaExp(-100)
			end
		end
	end
end

local common_postinit = function(inst)
	inst.currentdengji = net_shortint(inst.GUID,"currentdengji")
	inst.currentjinengdian = net_shortint(inst.GUID,"currentjinengdian")
	inst.currentyijiajineng = net_shortint(inst.GUID,"currentyijiajineng")
	inst.currentxingyun = net_shortint(inst.GUID,"currentxingyun")
	inst.currentgongjili = net_shortint(inst.GUID,"currentgongjili")
	inst.currentxueliang = net_shortint(inst.GUID,"currentxueliang")
	inst.currentsudu = net_shortint(inst.GUID,"currentsudu")
	inst.currentyonggan = net_shortint(inst.GUID,"currentyonggan")
	inst.currentshixue = net_shortint(inst.GUID,"currentshixue")
	inst.currentlingqiao = net_shortint(inst.GUID,"currentlingqiao")
	inst.currentopen = net_shortint(inst.GUID,"currentopen")
	inst.currentdamage = net_shortint(inst.GUID,"currentdamage")
	inst.currentexp = net_shortint(inst.GUID,"currentexp")
	inst.currentexpold = net_shortint(inst.GUID,"currentexpold")
	inst.currentyoushanon = net_shortint(inst.GUID,"currentyoushanon")
	inst.currentdachuon = net_shortint(inst.GUID,"currentdachuon")
	inst.currentqiaoshouon = net_shortint(inst.GUID,"currentqiaoshouon")
	inst.currentxuezheon = net_shortint(inst.GUID,"currentxuezheon")

	inst.currenttintdata01 = net_shortint(inst.GUID,"currenttintdata01")
	inst.currenttintdata02 = net_shortint(inst.GUID,"currenttintdata02")
	inst.currenttintdata03 = net_shortint(inst.GUID,"currenttintdata03")
	inst.currenttintdata04 = net_shortint(inst.GUID,"currenttintdata04")
	inst.currenttintdata05 = net_shortint(inst.GUID,"currenttintdata05")
	inst.currenttintdata06 = net_shortint(inst.GUID,"currenttintdata06")
	inst.currenttintdata07 = net_shortint(inst.GUID,"currenttintdata07")
	inst.currenttintdata08 = net_shortint(inst.GUID,"currenttintdata08")
	inst.currenttintdata09 = net_shortint(inst.GUID,"currenttintdata09")
	inst.currenttintdata10 = net_shortint(inst.GUID,"currenttintdata10")
	inst.currenttintdata11 = net_shortint(inst.GUID,"currenttintdata11")
	inst.currenttintdata12 = net_shortint(inst.GUID,"currenttintdata12")
	inst.currenttintdata13 = net_shortint(inst.GUID,"currenttintdata13")
	inst.currenttintdata14 = net_shortint(inst.GUID,"currenttintdata14")
	inst.currenttintdata15 = net_shortint(inst.GUID,"currenttintdata15")
	inst.currenttintdata16 = net_shortint(inst.GUID,"currenttintdata16")
	inst.currenttintdata17 = net_shortint(inst.GUID,"currenttintdata17")
	inst.currenttintdata18 = net_shortint(inst.GUID,"currenttintdata18")
	inst.currenttintdata19 = net_shortint(inst.GUID,"currenttintdata19")
	inst.currenttintdata20 = net_shortint(inst.GUID,"currenttintdata20")

	inst.MiniMapEntity:SetIcon( "totooria.tex" )
	inst.soundsname = TUNING.ttrsound
	inst:AddTag("totooria_builder")
	--能使用香料研磨器
	inst:AddTag("professionalchef")
end

local master_postinit = function(inst)
	--inst.dengji = 0
	--inst.jinengdian = 0
	--inst.yijiajineng = 0
	--inst.xingyun = 0
	--inst.gongjili = 0
	--inst.xueliang = 0
	--inst.sudu = 0
	--inst.yonggan = false
	--inst.shixue = false
	--inst.lingqiao = false
	--inst.open = false

	inst.tintdata = true

	inst.components.eater:SetOnEatFn(oneat)
	
	inst:AddComponent("reader")

	inst:AddComponent("totooriastatus")
	
	inst.components.health:SetMaxHealth(75)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(200)
	
    inst.components.combat.damagemultiplier = TUNING.WENDY_DAMAGE_MULT
	inst.components.hunger.hungerrate = TUNING.WILSON_HUNGER_RATE
	
	inst.components.locomotor.walkspeed = TUNING.WILSON_WALK_SPEED
	inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED
	
	inst:ListenForEvent("killed", onkilledother)
	
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
	inst.OnLoad = onload
    inst.OnNewSpawn = onload

    inst:ListenForEvent("onattackother", onattack)
    inst:ListenForEvent("healthdelta", damagemodifer)

    inst:ListenForEvent("DoDeltaYoushan", DoDeltaYoushan)
    inst:ListenForEvent("DoDeltaDachu", DoDeltaDachu)
    inst:ListenForEvent("DoDeltaQiaoshou", DoDeltaQiaoshou)
    inst:ListenForEvent("DoDeltaXuezhe", DoDeltaXuezhe)

    inst:ListenForEvent("unlockrecipe", onunlockrecipe)
    --inst:ListenForEvent("sanitydelta", onsanitydelta)
    inst:ListenForEvent("attacked", onattacked)
    inst:ListenForEvent("DoDeltaExpTTR", DoDeltaExpTTR)

    local book_defs =
	{
	    "book_gardening",
	    "book_birds",
	    "book_horticulture",
	    "book_silviculture",
	    "book_sleep",
	    "book_brimstone",
	    "book_tentacles",
	}
	local old_DoBuild = inst.components.builder.DoBuild
    inst.components.builder.DoBuild = function(self, recname, pt, rotation, skin)
	    for k,v in pairs(book_defs) do
		    if recname and recname == ("t"..v) then recname = v end
		end
	    return old_DoBuild(self, recname, pt, rotation, skin)
	end

	shuxing(inst)
end

return MakePlayerCharacter("totooria", prefabs, assets, common_postinit, master_postinit, start_inv)