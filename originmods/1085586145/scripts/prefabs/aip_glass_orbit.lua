local dev_mode=aipGetModConfig("dev_mode")=="enabled"

local language=aipGetModConfig("language")


local LANG_MAP={
english={
NAME="Moon Connection Point",
DESC="Create an invisible path",
},
chinese={
NAME="月能联结点",
DESC="链接着远方的道路",
},
}

local LANG=LANG_MAP[language] or LANG_MAP.english

STRINGS.NAMES.AIP_GLASS_ORBIT_POINT=LANG.NAME
STRINGS.CHARACTERS.GENERIC.DESCRIBE.AIP_GLASS_ORBIT_POINT=LANG.DESC


local assets={
Asset("ANIM","anim/aip_glass_orbit.zip"),
}


local function pointFn()
local inst=CreateEntity()

inst.entity:AddTransform()
inst.entity:AddAnimState()
inst.entity:AddNetwork()

MakeTinyFlyingCharacterPhysics(inst,0,0)

inst.AnimState:SetBank("aip_glass_orbit")
inst.AnimState:SetBuild("aip_glass_orbit")
inst.AnimState:PlayAnimation("loop",true)


inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
inst.AnimState:SetSortOrder(3)

inst:AddTag("aip_glass_orbit_point")


inst:AddTag("flying")


inst:AddComponent("aipc_orbit_point")

inst.entity:SetPristine()

if not TheWorld.ismastersim then
return inst
end

inst:AddComponent("inspectable")

MakeHauntableLaunch(inst)



inst.aipPoints={}

return inst
end



local function orbitFn()
local inst=CreateEntity()

inst.entity:AddTransform()
inst.entity:AddAnimState()


inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
inst.AnimState:SetLayer(LAYER_WORLD_BACKGROUND)
inst.AnimState:SetSortOrder(2)

inst.AnimState:SetBank("aip_glass_orbit")
inst.AnimState:SetBuild("aip_glass_orbit")
inst.AnimState:PlayAnimation("idle")

inst:AddTag("NOCLICK")
inst:AddTag("fx")



if not TheWorld.ismastersim then
return inst
end

inst.persists=false

return inst
end


local function linkFn()
local inst=CreateEntity()

inst.entity:AddTransform()
inst.entity:AddAnimState()
inst.entity:AddNetwork()

MakeTinyFlyingCharacterPhysics(inst,0,0)

inst.AnimState:SetBank("aip_glass_orbit_point")
inst.AnimState:SetBuild("aip_glass_orbit_point")
inst.AnimState:PlayAnimation("idle")

inst.AnimState:OverrideMultColour(0,0,0,dev_mode and 0.3 or 0)

inst:AddTag("NOCLICK")
inst:AddTag("fx")


inst:AddComponent("aipc_orbit_link")

inst.entity:SetPristine()

if not TheWorld.ismastersim then
return inst
end

return inst
end

return Prefab("aip_glass_orbit",orbitFn,assets),
Prefab("aip_glass_orbit_point",pointFn,assets),
Prefab("aip_glass_orbit_link",linkFn,assets)
