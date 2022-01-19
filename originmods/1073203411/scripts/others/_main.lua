
local windy_plains_enabled = GLOBAL.KnownModIndex:IsModEnabled("workshop-923823873")
local birds_and_berries_enabled = GLOBAL.KnownModIndex:IsModEnabled("workshop-522117250") or GLOBAL.KnownModIndex:IsModEnabled("workshop-1079880641")
local mandraketree_enabled = GLOBAL.KnownModIndex:IsModEnabled("workshop-659459255")
local teleportato_enabled = GLOBAL.KnownModIndex:IsModEnabled("workshop-756229217")

if windy_plains_enabled then
print("[Megarandom] Found Windy Plains !")
modimport("scripts/others/windyplains")
end
if birds_and_berries_enabled then
print("[Megarandom] Found Birds & Berries & Flowers for friends !")
modimport("scripts/others/birdsberriesforfriends")
end
if mandraketree_enabled then
print("[Megarandom] Found Mandrake Tree !")
modimport("scripts/others/mandraketree")
end
-- Teleportato compatibility
if teleportato_enabled then
print("[Megarandom] Found Teleportato !")
modimport("scripts/others/teleportato")
end

local basement_enabled = GLOBAL.KnownModIndex:IsModEnabled("workshop-1349799880") and GetModConfigData("RandomBasementSetpiece")
if basement_enabled then
print("[Megarandom] Found Basements !")
modimport("scripts/others/basements")
end

local optimize_enabled = GetModConfigData("WorldgenOptimization")
if optimize_enabled then 
print("[Megarandom] Will optimize World Gen !")
modimport("scripts/others/optimizeworldgen")
end

modimport("scripts/others/cosmetics_to_ground")