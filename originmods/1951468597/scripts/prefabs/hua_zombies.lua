local Are7xU={Asset("ANIM","anim/hua_zombies.zip")}local function yxjl(N9L,hDc_M)N9L.components.lootdropper:DropLoot()local qW0lRiD1=SpawnPrefab("collapse_small")qW0lRiD1.Transform:SetPosition(N9L.Transform:GetWorldPosition())qW0lRiD1:SetMaterial("stone")N9L:Remove()end;local function ZG(iD1IUx,JLCOx_ak)JLCOx_ak.hat=iD1IUx.hat end;local function Vu0cCAf(hPQ,R1FIoQI)local NsoTwDs=hPQ.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)if NsoTwDs~=nil then if NsoTwDs.components.fueled~=nil then NsoTwDs.components.fueled:StopConsuming()end;if NsoTwDs.components.perishable~=nil then NsoTwDs.components.perishable:StopPerishing()end;return end;if R1FIoQI~=nil and R1FIoQI.hat~=nil then hPQ.hat=R1FIoQI.hat;hPQ.AnimState:OverrideSymbol("swap_hat","hua_zombies",hPQ.hat)end end;local function q(HGli,iy)iy.AnimState:OverrideSymbol("swap_body","hua_zombies","swap_body")end;local function kP7O5(m6SCS0,NUhYw6R4)NUhYw6R4.AnimState:ClearOverrideSymbol("swap_body")end;local function lqT(Hv,Ch)if Ch.components.equippable~=nil and Ch.components.equippable.equipslot==EQUIPSLOTS.HEAD then return true end;return false end;local function mP3mlD(urkh,zhzpBSx,rHSjalVy)if rHSjalVy.components.equippable~=nil and rHSjalVy.components.equippable.equipslot==EQUIPSLOTS.HEAD then local TjhsnP=urkh.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)if TjhsnP~=nil then urkh.components.inventory:DropItem(TjhsnP)if TjhsnP.components.perishable~=nil then TjhsnP.components.perishable:StartPerishing()end end;urkh.components.inventory:Equip(rHSjalVy)end end;local PrPyxMK={"hat_a","hat_b","hat_c"}local function tczrIB(t5jzEd9,JZAU2)if JZAU2 and JZAU2.item then if JZAU2.item.components.fueled~=nil then JZAU2.item.components.fueled:StopConsuming()end;if JZAU2.item.components.perishable~=nil then JZAU2.item.components.perishable:StopPerishing()end end end;local function a()local zPXTTg=CreateEntity()zPXTTg.entity:AddTransform()zPXTTg.entity:AddAnimState()zPXTTg.entity:AddSoundEmitter()zPXTTg.entity:AddNetwork()zPXTTg.entity:AddDynamicShadow()zPXTTg.DynamicShadow:SetSize(1.3,.6)zPXTTg.AnimState:SetBank("hua_zombies")zPXTTg.AnimState:SetBuild("hua_zombies")zPXTTg.AnimState:PlayAnimation("idle")MakeHeavyObstaclePhysics(zPXTTg,.45)zPXTTg:SetPhysicsRadiusOverride(.45)zPXTTg.Transform:SetScale(10/9,10/9,10/9)zPXTTg:AddTag("heavy")zPXTTg.entity:SetPristine()if not TheWorld.ismastersim then return zPXTTg end;zPXTTg:AddComponent("heavyobstaclephysics") zPXTTg.components.heavyobstaclephysics:SetRadius(.45)zPXTTg:AddComponent("inspectable")zPXTTg:AddComponent("lootdropper")zPXTTg:AddComponent("inventoryitem")zPXTTg.components.inventoryitem.cangoincontainer=false;zPXTTg.components.inventoryitem:SetSinks(true)zPXTTg.components.inventoryitem.atlasname="images/inventoryimages/hua_zombies.xml"zPXTTg:AddComponent("inventory")zPXTTg:AddComponent("workable")zPXTTg.components.workable:SetWorkAction(ACTIONS.HAMMER)zPXTTg.components.workable:SetWorkLeft(5)zPXTTg.components.workable:SetOnFinishCallback(yxjl)zPXTTg:AddComponent("equippable")zPXTTg.components.equippable.equipslot=EQUIPSLOTS.BODY;zPXTTg.components.equippable:SetOnEquip(q)zPXTTg.components.equippable:SetOnUnequip(kP7O5)zPXTTg.components.equippable.walkspeedmult=TUNING.HEAVY_SPEED_MULT;zPXTTg:AddComponent("trader")zPXTTg.components.trader:SetAcceptTest(lqT)zPXTTg.components.trader.onaccept=mP3mlD;zPXTTg.components.trader.deleteitemonaccept=false;zPXTTg:ListenForEvent("equip",tczrIB)zPXTTg.OnSave=ZG;zPXTTg.OnLoad=Vu0cCAf;return zPXTTg end;local function wqU76o(seMLr,qX) local h_8=SpawnPrefab(seMLr.pieceid)h_8.Transform:SetPosition(qX.Transform:GetWorldPosition())h_8.hat=PrPyxMK[math.random(3)]h_8.AnimState:OverrideSymbol("swap_hat","hua_zombies",h_8.hat)seMLr:Remove()end;local function LB1Z(xL7OTb)local function a()local w8T3f=CreateEntity()w8T3f.entity:AddTransform()w8T3f:AddTag("CLASSIFIED")w8T3f.persists=false;w8T3f:DoTaskInTime(0,w8T3f.Remove)if not TheWorld.ismastersim then return w8T3f end;w8T3f.pieceid=xL7OTb;w8T3f.OnBuiltFn=wqU76o;return w8T3f end;return Prefab(xL7OTb.."_builder",a)end;return Prefab("hua_zombies",a,Are7xU),LB1Z("hua_zombies")