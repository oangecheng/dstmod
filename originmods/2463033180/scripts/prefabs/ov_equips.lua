local assets = { Asset("\065\078\073\077", "\097\110\105\109\047\111\118\095\097\114\109\111\114\046\122\105\112"), Asset("\065\078\073\077", "\097\110\105\109\047\111\118\095\104\101\108\109\101\116\046\122\105\112"), Asset("\065\078\073\077", "\097\110\105\109\047\111\118\095\119\101\097\112\111\110\115\046\122\105\112"), Asset("\065\078\073\077", "\097\110\105\109\047\111\118\095\098\097\103\049\046\122\105\112"), Asset("\065\078\073\077", "\097\110\105\109\047\111\118\095\098\097\103\050\046\122\105\112"), Asset("\065\078\073\077", "\097\110\105\109\047\111\118\095\097\109\117\108\101\116\115\046\122\105\112"), Asset("\065\084\076\065\083", "\105\109\097\103\101\115\047\105\110\118\101\110\116\111\114\121\105\109\097\103\101\115\047\111\118\095\101\113\117\105\112\115\046\120\109\108") } local function CanFix(inst,type) inst:AddComponent("\116\114\097\100\101\114") inst["\099\111\109\112\111\110\101\110\116\115"]["\116\114\097\100\101\114"]["\111\110\097\099\099\101\112\116"] = function(item,giver,fixer) if type == "\119\101\097\112\111\110" then local finiteuses = inst["\099\111\109\112\111\110\101\110\116\115"]["\102\105\110\105\116\101\117\115\101\115"] finiteuses:Use(-0x12C) if finiteuses:GetPercent() >= 0x1 then finiteuses:SetPercent(0x1) end elseif type == "\097\114\109\111\114" then local pre = inst["\099\111\109\112\111\110\101\110\116\115"]["\097\114\109\111\114"]:GetPercent() inst["\099\111\109\112\111\110\101\110\116\115"]["\097\114\109\111\114"]:SetPercent(math["\109\105\110"](0x1, pre + 0x12C/1300)) elseif type == "\102\117\101\108\101\100" then inst["\099\111\109\112\111\110\101\110\116\115"]["\102\117\101\108\101\100"]:DoDelta(0xFA) end end inst["\099\111\109\112\111\110\101\110\116\115"]["\116\114\097\100\101\114"]:SetAcceptTest(function(item,fixer,giver) if fixer["\112\114\101\102\097\098"] == "\111\118\095\112\108\117\109\101\049" then return true end giver["\099\111\109\112\111\110\101\110\116\115"]["\116\097\108\107\101\114"]:Say("\229\174\131\233\156\128\232\166\129\231\148\168\230\180\129\231\153\189\231\154\132\231\190\189\230\175\155\232\191\155\232\161\140\228\191\174\231\144\134\229\147\166\033") return false end) end local function NoHoles(pt) return not TheWorld["\077\097\112"]:IsPointNearHole(pt) end local function doAttacked(owner,data) if math["\114\097\110\100\111\109"]() < 0.8 then local target = data["\097\116\116\097\099\107\101\114"] if target and target:IsValid() then local pt = target:GetPosition() local offset = FindWalkableOffset(pt, math["\114\097\110\100\111\109"]() * 0x2 * PI, 0x2, 0x3, false, true, NoHoles) if offset then local tentacle = SpawnPrefab("\115\104\097\100\111\119\116\101\110\116\097\099\108\101") tentacle["\084\114\097\110\115\102\111\114\109"]:SetPosition(pt["\120"] + offset["\120"], 0x0, pt["\122"] + offset["\122"]) tentacle["\099\111\109\112\111\110\101\110\116\115"]["\099\111\109\098\097\116"]:SetTarget(target) end end end end local function fn1() local inst = CreateEntity() inst["\101\110\116\105\116\121"]:AddTransform() inst["\101\110\116\105\116\121"]:AddAnimState() inst["\101\110\116\105\116\121"]:AddNetwork() MakeInventoryPhysics(inst) inst["\065\110\105\109\083\116\097\116\101"]:SetBank("\111\118\095\097\114\109\111\114") inst["\065\110\105\109\083\116\097\116\101"]:SetBuild("\111\118\095\097\114\109\111\114") inst["\065\110\105\109\083\116\097\116\101"]:PlayAnimation("\105\100\108\101") inst["\101\110\116\105\116\121"]:SetPristine() if not TheWorld["\105\115\109\097\115\116\101\114\115\105\109"] then return inst end inst:AddTag("\111\118\095\097\114\109\111\114") inst:AddComponent("\105\110\115\112\101\099\116\097\098\108\101") inst:AddComponent("\097\114\109\111\114") inst["\099\111\109\112\111\110\101\110\116\115"]["\097\114\109\111\114"]:InitCondition(0x514,0.8) inst:AddComponent("\105\110\118\101\110\116\111\114\121\105\116\101\109") inst["\099\111\109\112\111\110\101\110\116\115"]["\105\110\118\101\110\116\111\114\121\105\116\101\109"]["\097\116\108\097\115\110\097\109\101"] = "\105\109\097\103\101\115\047\105\110\118\101\110\116\111\114\121\105\109\097\103\101\115\047\111\118\095\101\113\117\105\112\115\046\120\109\108" inst:AddComponent("\101\113\117\105\112\112\097\098\108\101") inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]["\101\113\117\105\112\115\108\111\116"] = EQUIPSLOTS["\066\079\068\089"] inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnEquip(function(inst, owner) owner["\065\110\105\109\083\116\097\116\101"]:OverrideSymbol("\115\119\097\112\095\098\111\100\121", "\111\118\095\097\114\109\111\114", "\115\119\097\112\095\098\111\100\121") inst:ListenForEvent("\097\116\116\097\099\107\101\100", doAttacked, owner) end) inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnUnequip(function(inst, owner) owner["\065\110\105\109\083\116\097\116\101"]:ClearOverrideSymbol("\115\119\097\112\095\098\111\100\121") inst:RemoveEventCallback("\097\116\116\097\099\107\101\100", doAttacked, owner) end) CanFix(inst,"\097\114\109\111\114") return inst end local function fn2() local inst = CreateEntity() inst["\101\110\116\105\116\121"]:AddTransform() inst["\101\110\116\105\116\121"]:AddAnimState() inst["\101\110\116\105\116\121"]:AddNetwork() MakeInventoryPhysics(inst) inst["\065\110\105\109\083\116\097\116\101"]:SetBank("\111\118\095\104\101\108\109\101\116") inst["\065\110\105\109\083\116\097\116\101"]:SetBuild("\111\118\095\104\101\108\109\101\116") inst["\065\110\105\109\083\116\097\116\101"]:PlayAnimation("\105\100\108\101") inst["\101\110\116\105\116\121"]:SetPristine() if not TheWorld["\105\115\109\097\115\116\101\114\115\105\109"] then return inst end inst:AddTag("\111\118\095\104\101\108\109\101\116") inst:AddComponent("\105\110\115\112\101\099\116\097\098\108\101") inst:AddComponent("\097\114\109\111\114") inst["\099\111\109\112\111\110\101\110\116\115"]["\097\114\109\111\114"]:InitCondition(0x514,0.5) inst:AddComponent("\105\110\118\101\110\116\111\114\121\105\116\101\109") inst["\099\111\109\112\111\110\101\110\116\115"]["\105\110\118\101\110\116\111\114\121\105\116\101\109"]["\097\116\108\097\115\110\097\109\101"] = "\105\109\097\103\101\115\047\105\110\118\101\110\116\111\114\121\105\109\097\103\101\115\047\111\118\095\101\113\117\105\112\115\046\120\109\108" inst:AddComponent("\105\110\115\117\108\097\116\111\114") inst["\099\111\109\112\111\110\101\110\116\115"]["\105\110\115\117\108\097\116\111\114"]:SetWinter() inst["\099\111\109\112\111\110\101\110\116\115"]["\105\110\115\117\108\097\116\111\114"]:SetInsulation(0xF0) inst:AddComponent("\101\113\117\105\112\112\097\098\108\101") inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]["\101\113\117\105\112\115\108\111\116"] = EQUIPSLOTS["\072\069\065\068"] inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnEquip(function(inst, owner) owner["\065\110\105\109\083\116\097\116\101"]:OverrideSymbol("\115\119\097\112\095\104\097\116", "\111\118\095\104\101\108\109\101\116", "\115\119\097\112\095\104\097\116") owner["\065\110\105\109\083\116\097\116\101"]:Show("\072\065\084") owner["\065\110\105\109\083\116\097\116\101"]:Show("\072\065\084\095\072\065\073\082") owner["\099\111\109\112\111\110\101\110\116\115"]["\104\101\097\108\116\104"]["\101\120\116\101\114\110\097\108\102\105\114\101\100\097\109\097\103\101\109\117\108\116\105\112\108\105\101\114\115"]:SetModifier(inst, 0x0) end) inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnUnequip(function(inst, owner) owner["\065\110\105\109\083\116\097\116\101"]:Hide("\072\065\084") owner["\065\110\105\109\083\116\097\116\101"]:Hide("\072\065\084\095\072\065\073\082") owner["\065\110\105\109\083\116\097\116\101"]:Show("\072\065\073\082\095\078\079\072\065\084") owner["\065\110\105\109\083\116\097\116\101"]:Show("\072\065\073\082") owner["\099\111\109\112\111\110\101\110\116\115"]["\104\101\097\108\116\104"]["\101\120\116\101\114\110\097\108\102\105\114\101\100\097\109\097\103\101\109\117\108\116\105\112\108\105\101\114\115"]:RemoveModifier(inst) end) CanFix(inst,"\097\114\109\111\114") return inst end local function equip1(inst, owner) owner["\065\110\105\109\083\116\097\116\101"]:OverrideSymbol("\115\119\097\112\095\111\098\106\101\099\116", "\111\118\095\119\101\097\112\111\110\115", inst["\112\114\101\102\097\098"]) owner["\065\110\105\109\083\116\097\116\101"]:Show("\065\082\077\095\099\097\114\114\121") owner["\065\110\105\109\083\116\097\116\101"]:Hide("\065\082\077\095\110\111\114\109\097\108") end local function unequip1(inst, owner) owner["\065\110\105\109\083\116\097\116\101"]:Hide("\065\082\077\095\099\097\114\114\121") owner["\065\110\105\109\083\116\097\116\101"]:Show("\065\082\077\095\110\111\114\109\097\108") end local damageli = { {0x19,50,10}, {0x1,2,0x8} } local dofnli = { [1] = function(inst) inst:AddComponent("\116\111\111\108") inst["\099\111\109\112\111\110\101\110\116\115"]["\116\111\111\108"]:SetAction(ACTIONS["\067\072\079\080"], 0xA) inst["\099\111\109\112\111\110\101\110\116\115"]["\116\111\111\108"]:SetAction(ACTIONS["\077\073\078\069"], 0xA) inst["\099\111\109\112\111\110\101\110\116\115"]["\116\111\111\108"]:SetAction(ACTIONS["\068\073\071"]) inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnEquip(function(inst, owner) equip1(inst, owner) end) inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnUnequip(function(inst, owner) unequip1(inst, owner) end) end, [2] = function(inst) inst["\099\111\109\112\111\110\101\110\116\115"]["\119\101\097\112\111\110"]:SetElectric() inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnEquip(function(inst, owner) equip1(inst, owner) inst["\076\105\103\104\116"]:Enable(true) inst["\076\105\103\104\116"]:SetRadius(0x5) inst["\076\105\103\104\116"]:SetFalloff(0.8) inst["\076\105\103\104\116"]:SetIntensity(0.8) inst["\076\105\103\104\116"]:SetColour(0x0, 0xB7/255, 0x1) end) inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnUnequip(function(inst, owner) unequip1(inst, owner) inst["\076\105\103\104\116"]:Enable(false) end) inst:AddComponent("\102\105\110\105\116\101\117\115\101\115") inst["\099\111\109\112\111\110\101\110\116\115"]["\102\105\110\105\116\101\117\115\101\115"]:SetMaxUses(0x514) inst["\099\111\109\112\111\110\101\110\116\115"]["\102\105\110\105\116\101\117\115\101\115"]:SetUses(0x514) inst["\099\111\109\112\111\110\101\110\116\115"]["\102\105\110\105\116\101\117\115\101\115"]:SetOnFinished(inst["\082\101\109\111\118\101"]) CanFix(inst,"\119\101\097\112\111\110") end, [3] = function(inst) inst:AddTag("\101\120\116\105\110\103\117\105\115\104\101\114") inst["\099\111\109\112\111\110\101\110\116\115"]["\119\101\097\112\111\110"]:SetOnAttack(function(inst, attacker, target, skipsanity) if target["\099\111\109\112\111\110\101\110\116\115"]["\102\114\101\101\122\097\098\108\101"] then target["\099\111\109\112\111\110\101\110\116\115"]["\102\114\101\101\122\097\098\108\101"]:AddColdness(0x1) target["\099\111\109\112\111\110\101\110\116\115"]["\102\114\101\101\122\097\098\108\101"]:SpawnShatterFX() end if target["\099\111\109\112\111\110\101\110\116\115"]["\098\117\114\110\097\098\108\101"] then if target["\099\111\109\112\111\110\101\110\116\115"]["\098\117\114\110\097\098\108\101"]:IsBurning() then target["\099\111\109\112\111\110\101\110\116\115"]["\098\117\114\110\097\098\108\101"]:Extinguish() elseif target["\099\111\109\112\111\110\101\110\116\115"]["\098\117\114\110\097\098\108\101"]:IsSmoldering() then target["\099\111\109\112\111\110\101\110\116\115"]["\098\117\114\110\097\098\108\101"]:SmotherSmolder() end end end) inst["\099\111\109\112\111\110\101\110\116\115"]["\119\101\097\112\111\110"]:SetProjectile("\105\099\101\095\112\114\111\106\101\099\116\105\108\101") inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnEquip(function(inst, owner) equip1(inst, owner) end) inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnUnequip(function(inst, owner) unequip1(inst, owner) end) inst:AddComponent("\102\105\110\105\116\101\117\115\101\115") inst["\099\111\109\112\111\110\101\110\116\115"]["\102\105\110\105\116\101\117\115\101\115"]:SetMaxUses(0x1E) inst["\099\111\109\112\111\110\101\110\116\115"]["\102\105\110\105\116\101\117\115\101\115"]:SetUses(0x1E) inst["\099\111\109\112\111\110\101\110\116\115"]["\102\105\110\105\116\101\117\115\101\115"]:SetOnFinished(inst["\082\101\109\111\118\101"]) end, } local function makeweapons(id) local name = string["\102\111\114\109\097\116"]("\111\118\095\119\101\097\112\111\110\037\048\049\100",id) local function fn() local inst = CreateEntity() inst["\101\110\116\105\116\121"]:AddLight() inst["\101\110\116\105\116\121"]:AddNetwork() inst["\101\110\116\105\116\121"]:AddTransform() inst["\101\110\116\105\116\121"]:AddAnimState() MakeInventoryPhysics(inst) inst["\065\110\105\109\083\116\097\116\101"]:SetBank("\111\118\095\119\101\097\112\111\110\115") inst["\065\110\105\109\083\116\097\116\101"]:SetBuild("\111\118\095\119\101\097\112\111\110\115") inst["\065\110\105\109\083\116\097\116\101"]:PlayAnimation(name) inst["\101\110\116\105\116\121"]:SetPristine() if not TheWorld["\105\115\109\097\115\116\101\114\115\105\109"] then return inst end inst:AddTag("\111\118\095\101\113\117\105\112") inst:AddTag("\111\118\095\119\101\097\112\111\110\115") inst:AddTag("\097\111\101\119\101\097\112\111\110\095\108\101\097\112") inst:AddTag(name) inst:AddComponent("\119\101\097\112\111\110") inst["\099\111\109\112\111\110\101\110\116\115"]["\119\101\097\112\111\110"]:SetDamage(damageli[1][id]) inst["\099\111\109\112\111\110\101\110\116\115"]["\119\101\097\112\111\110"]:SetRange(damageli[2][id], damageli[2][id]*1.25) inst:AddComponent("\101\113\117\105\112\112\097\098\108\101") inst:AddComponent("\105\110\115\112\101\099\116\097\098\108\101") inst:AddComponent("\105\110\118\101\110\116\111\114\121\105\116\101\109") inst["\099\111\109\112\111\110\101\110\116\115"]["\105\110\118\101\110\116\111\114\121\105\116\101\109"]["\097\116\108\097\115\110\097\109\101"] = "\105\109\097\103\101\115\047\105\110\118\101\110\116\111\114\121\105\109\097\103\101\115\047\111\118\095\101\113\117\105\112\115\046\120\109\108" dofnli[id](inst) return inst end return Prefab(name, fn, assets) end local function makeamulets(id) local name = string["\102\111\114\109\097\116"]("\111\118\095\097\109\117\108\101\116\037\048\049\100", id) local function fn() local inst = CreateEntity() inst["\101\110\116\105\116\121"]:AddTransform() inst["\101\110\116\105\116\121"]:AddAnimState() inst["\101\110\116\105\116\121"]:AddNetwork() inst["\065\110\105\109\083\116\097\116\101"]:SetBank("\111\118\095\097\109\117\108\101\116\115") inst["\065\110\105\109\083\116\097\116\101"]:SetBuild("\111\118\095\097\109\117\108\101\116\115") inst["\065\110\105\109\083\116\097\116\101"]:PlayAnimation(name) MakeInventoryPhysics(inst) inst["\101\110\116\105\116\121"]:SetPristine() if not TheWorld["\105\115\109\097\115\116\101\114\115\105\109"] then return inst end inst:AddTag("\114\097\114\101\105\116\101\109") inst:AddComponent("\105\110\115\112\101\099\116\097\098\108\101") inst:AddComponent("\105\110\118\101\110\116\111\114\121\105\116\101\109") inst["\099\111\109\112\111\110\101\110\116\115"]["\105\110\118\101\110\116\111\114\121\105\116\101\109"]["\097\116\108\097\115\110\097\109\101"] = "\105\109\097\103\101\115\047\105\110\118\101\110\116\111\114\121\105\109\097\103\101\115\047\111\118\095\101\113\117\105\112\115\046\120\109\108" inst:AddComponent("\101\113\117\105\112\112\097\098\108\101") inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]["\101\113\117\105\112\115\108\111\116"] = EQUIPSLOTS["\078\069\067\075"] or EQUIPSLOTS["\066\079\068\089"] if id == 0x1 then inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]["\100\097\112\112\101\114\110\101\115\115"] = 0.6 inst:AddComponent("\105\110\115\117\108\097\116\111\114") inst["\099\111\109\112\111\110\101\110\116\115"]["\105\110\115\117\108\097\116\111\114"]:SetWinter() inst["\099\111\109\112\111\110\101\110\116\115"]["\105\110\115\117\108\097\116\111\114"]:SetInsulation(0xF0) elseif id == 0x2 then inst:AddComponent("\097\114\109\111\114") inst["\099\111\109\112\111\110\101\110\116\115"]["\097\114\109\111\114"]:InitCondition(0x514,0.3) inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnEquip(function(inst, owner) owner["\111\118\095\104\112\117\112"] = owner:DoPeriodicTask(0x5, function() owner["\099\111\109\112\111\110\101\110\116\115"]["\104\101\097\108\116\104"]:DoDelta(0x3) end) end) inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnUnequip(function(inst, owner) if owner["\111\118\095\104\112\117\112"] then owner["\111\118\095\104\112\117\112"]:Cancel() owner["\111\118\095\104\112\117\112"] = nil end end) CanFix(inst,"\097\114\109\111\114") end return inst end return Prefab(name, fn) end local function equip2(inst, owner) owner["\065\110\105\109\083\116\097\116\101"]:OverrideSymbol("\115\119\097\112\095\098\111\100\121", inst["\112\114\101\102\097\098"], "\115\119\097\112\095\098\111\100\121") end local function unequip2(inst, owner) owner["\065\110\105\109\083\116\097\116\101"]:ClearOverrideSymbol("\115\119\097\112\095\098\111\100\121") owner["\065\110\105\109\083\116\097\116\101"]:ClearOverrideSymbol("\098\097\099\107\112\097\099\107") end local function makebags(id) local name = string["\102\111\114\109\097\116"]("\111\118\095\098\097\103\037\048\049\100", id) local function fn() local inst = CreateEntity() inst["\101\110\116\105\116\121"]:AddNetwork() inst["\101\110\116\105\116\121"]:AddTransform() inst["\101\110\116\105\116\121"]:AddAnimState() inst["\101\110\116\105\116\121"]:AddSoundEmitter() inst["\065\110\105\109\083\116\097\116\101"]:SetBank(name) inst["\065\110\105\109\083\116\097\116\101"]:SetBuild(name) inst["\065\110\105\109\083\116\097\116\101"]:PlayAnimation("\105\100\108\101") MakeInventoryPhysics(inst) inst["\101\110\116\105\116\121"]:SetPristine() if not TheWorld["\105\115\109\097\115\116\101\114\115\105\109"] then if id == 0x1 then inst["\079\110\069\110\116\105\116\121\082\101\112\108\105\099\097\116\101\100"] = function(inst) inst["\114\101\112\108\105\099\097"]["\099\111\110\116\097\105\110\101\114"]:WidgetSetup("\107\114\097\109\112\117\115\095\115\097\099\107") end end return inst end inst:AddTag(name) inst:AddComponent("\105\110\115\112\101\099\116\097\098\108\101") inst:AddComponent("\105\110\118\101\110\116\111\114\121\105\116\101\109") inst["\099\111\109\112\111\110\101\110\116\115"]["\105\110\118\101\110\116\111\114\121\105\116\101\109"]["\097\116\108\097\115\110\097\109\101"] = "\105\109\097\103\101\115\047\105\110\118\101\110\116\111\114\121\105\109\097\103\101\115\047\111\118\095\101\113\117\105\112\115\046\120\109\108" inst["\099\111\109\112\111\110\101\110\116\115"]["\105\110\118\101\110\116\111\114\121\105\116\101\109"]["\099\097\110\103\111\105\110\099\111\110\116\097\105\110\101\114"] = false inst:AddComponent("\101\113\117\105\112\112\097\098\108\101") inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]["\101\113\117\105\112\115\108\111\116"] = EQUIPSLOTS["\066\065\067\075"] or EQUIPSLOTS["\066\079\068\089"] if id == 0x1 then inst:AddTag("\102\114\105\100\103\101") inst:AddComponent("\099\111\110\116\097\105\110\101\114") inst["\099\111\109\112\111\110\101\110\116\115"]["\099\111\110\116\097\105\110\101\114"]:WidgetSetup("\107\114\097\109\112\117\115\095\115\097\099\107") inst:AddComponent("\119\097\116\101\114\112\114\111\111\102\101\114") inst["\099\111\109\112\111\110\101\110\116\115"]["\119\097\116\101\114\112\114\111\111\102\101\114"]:SetEffectiveness(0.9) inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnEquip(function(inst, owner) equip2(inst, owner) inst["\099\111\109\112\111\110\101\110\116\115"]["\099\111\110\116\097\105\110\101\114"]:Open(owner) end) inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnUnequip(function(inst, owner) unequip2(inst, owner) inst["\099\111\109\112\111\110\101\110\116\115"]["\099\111\110\116\097\105\110\101\114"]:Close(owner) end) elseif id == 0x2 then inst:AddComponent("\102\117\101\108\101\100") inst["\099\111\109\112\111\110\101\110\116\115"]["\102\117\101\108\101\100"]:InitializeFuelLevel(0x12C) inst["\099\111\109\112\111\110\101\110\116\115"]["\102\117\101\108\101\100"]:SetFirstPeriod(0x1, 0x1) inst["\099\111\109\112\111\110\101\110\116\115"]["\102\117\101\108\101\100"]:SetDepletedFn(inst["\082\101\109\111\118\101"]) inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnEquip(function(inst, owner) equip2(inst, owner) owner["\111\118\095\105\110\118\097\108\105\100"] = true inst["\099\111\109\112\111\110\101\110\116\115"]["\102\117\101\108\101\100"]:StartConsuming() inst["\083\111\117\110\100\069\109\105\116\116\101\114"]:PlaySound("\111\108\105\118\105\097\047\115\102\120\047\111\118\095\109\117\115\105\099","\111\118\095\109\117\115\105\099") inst["\111\118\095\112\108\097\110\116"] = inst:DoPeriodicTask(0x1, function(inst) local x,y,z = inst["\084\114\097\110\115\102\111\114\109"]:GetWorldPosition() local ents = TheSim:FindEntities(x,y,z, 0x5) for k,v in pairs(ents) do if v["\099\111\109\112\111\110\101\110\116\115"]["\102\097\114\109\112\108\097\110\116\116\101\110\100\097\098\108\101"] then v["\099\111\109\112\111\110\101\110\116\115"]["\102\097\114\109\112\108\097\110\116\116\101\110\100\097\098\108\101"]:TendTo(inst) end end end) end) inst["\099\111\109\112\111\110\101\110\116\115"]["\101\113\117\105\112\112\097\098\108\101"]:SetOnUnequip(function(inst, owner) unequip2(inst, owner) owner["\111\118\095\105\110\118\097\108\105\100"] = nil inst["\099\111\109\112\111\110\101\110\116\115"]["\102\117\101\108\101\100"]:StopConsuming() inst["\083\111\117\110\100\069\109\105\116\116\101\114"]:KillSound("\111\118\095\109\117\115\105\099") if inst["\111\118\095\112\108\097\110\116"] then inst["\111\118\095\112\108\097\110\116"]:Cancel() inst["\111\118\095\112\108\097\110\116"] = nil end end) CanFix(inst,"\102\117\101\108\101\100") end return inst end return Prefab(name, fn) end local t = {} table["\105\110\115\101\114\116"](t, Prefab("\111\118\095\097\114\109\111\114", fn1, assets)) table["\105\110\115\101\114\116"](t, Prefab("\111\118\095\104\101\108\109\101\116", fn2)) for i=0x1,3 do table["\105\110\115\101\114\116"](t, makeweapons(i)) end for i=0x1,2 do table["\105\110\115\101\114\116"](t, makeamulets(i)) end for i=0x1,2 do table["\105\110\115\101\114\116"](t, makebags(i)) end return unpack(t)
