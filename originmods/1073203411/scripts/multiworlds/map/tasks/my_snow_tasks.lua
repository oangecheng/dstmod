
local r1 = 0
local r2 = 0
local r3 = 0
local r4 = 0
local r5 = 0
local r = math.random()
if r < 0.2 then
r1 = 1
elseif r < 0.4 then
r2 = 1
elseif r < 0.6 then
r3 = 1
elseif r < 0.8 then
r4 = 1
else
--r5 = 1
end

AddTask("Custom Snowy two b", {
	locks={LOCKS.TIER1},
	keys_given={KEYS.TIER2},
	room_choices={
		["SnowyHerds"] = 1,
		["SnowyLeifForest"] = 1+r1,
		["SnowyTotallyNormalForest"] = 1+r2,
		["SnowyBunnies"] = 1+r3,
		["SnowyYetiTerritory"] = 1+r4,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.SNOWY,
	background_room="BGSnowy",
})