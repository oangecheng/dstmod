
local dress_uses=aipGetModConfig("dress_uses")
local weapon_damage=aipGetModConfig("weapon_damage")
local language=aipGetModConfig("language")


local PERISH_MAP={
less=0.5,
normal=1,
much=2,
}
local DAMAGE_MAP={
less=TUNING.SPEAR_DAMAGE*0.5,
normal=TUNING.SPEAR_DAMAGE,
large=TUNING.SPEAR_DAMAGE*2,
}

local LANG_MAP={
english={
NAME="Joker Face",
REC_DESC="Neurotic awards",
DESC="Something seems to surround it",
},
chinese={
NAME="诙谐面具",
REC_DESC="神经质的嘉奖",
DESC="似乎有什么环绕着它",
},
russian={
NAME="Лицо Джокера",
REC_DESC="Награда невротика",
DESC="Кажется,что-то окружает его",
},
}

local LANG=LANG_MAP[language] or LANG_MAP.english

TUNING.AIP_JOKER_FACE_FUEL=TUNING.ONEMANBAND_PERISHTIME*PERISH_MAP[dress_uses]
TUNING.AIP_JOKER_FACE_MAX_RANGE=12
TUNING.AIP_JOKER_FACE_DAMAGE=DAMAGE_MAP[weapon_damage]


STRINGS.NAMES.AIP_JOKER_FACE=LANG.NAME
STRINGS.RECIPE_DESC.AIP_JOKER_FACE=LANG.REC_DESC
STRINGS.CHARACTERS.GENERIC.DESCRIBE.AIP_JOKER_FACE=LANG.DESC


local aip_joker_face=Recipe("aip_joker_face",{Ingredient("livinglog",3),Ingredient("spidereggsack",1),Ingredient("razor",1)},RECIPETABS.DRESS,TECH.SCIENCE_TWO)
aip_joker_face.atlas="images/inventoryimages/aip_joker_face.xml"


local function jokerOrbFn()
local inst=CreateEntity()

inst.entity:AddTransform()
inst.entity:AddAnimState()
inst.entity:AddLight()
inst.entity:AddNetwork()

MakeFlyingCharacterPhysics(inst,1,.5)

inst.AnimState:SetBank("projectile")
inst.AnimState:SetBuild("staff_projectile")
inst.AnimState:PlayAnimation("fire_spin_loop",true)

inst:AddTag("projectile")
inst:AddTag("flying")
inst:AddTag("ignorewalkableplatformdrowning")


inst.Light:SetIntensity(.6)
inst.Light:SetRadius(.5)
inst.Light:SetFalloff(.6)
inst.Light:Enable(true)
inst.Light:SetColour(180/255,195/255,225/255)

inst.entity:SetPristine()

if not TheWorld.ismastersim then
return inst
end


inst:DoTaskInTime(0.5,function()
if inst._master~=true then
inst:Remove()
end
end)

return inst
end

local jokerOrbPrefab=Prefab("aip_joker_orb",jokerOrbFn,{ Asset("ANIM","anim/staff_projectile.zip") },{ "fire_projectile" })


local tempalte=require("prefabs/aip_dress_template")
local prefab=tempalte("aip_joker_face",{
keepHead=true,
prefabs={
"aip_joker_orb"
},
fueled={
level=TUNING.AIP_JOKER_FACE_FUEL,
},
onEquip=function(inst,owner)
inst.components.aipc_guardian_orb:Start(owner)
end,
onUnequip=function(inst,owner)
inst.components.aipc_guardian_orb:Stop()
end,
postInst=function(inst)

inst:AddComponent("aipc_guardian_orb")
inst.components.aipc_guardian_orb.spawnPrefab="aip_joker_orb"
inst.components.aipc_guardian_orb.projectilePrefab="fire_projectile"


inst:AddComponent("weapon")
inst.components.weapon:SetDamage(TUNING.AIP_JOKER_FACE_DAMAGE)
inst.components.weapon:SetRange(0,0)


inst.components.fueled.fueltype=FUELTYPE.MAGIC
inst.components.fueled:SetSections(5)
inst.components.fueled.accepting=false
end,
})

return { prefab,jokerOrbPrefab }
