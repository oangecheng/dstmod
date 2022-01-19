
local r1 = math.random(0,1)
local r2 = math.random(0,1)

if GetModConfigData("VolcanoDragonflySpawn") > 0 then
	nvolcanodragonfly = 1
else
	nvolcanodragonfly = nil
end


AddTask("Custom fire four b", {
	locks={LOCKS.TIER3},
	keys_given={KEYS.TIER4},
	room_choices={
		["FireDragonflyTerritory"] = 1+r1,
		["FireDragonflyLair"] = nvolcanodragonfly,
		["FireDragoonLair"] = 1+r2,
		["FireCoffee"] = 1+r1
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.MAGMA,
	background_room="BGFireDragonflyTerritory",
})
AddTask("Custom fire two c", {
	locks={LOCKS.TIER1},
	keys_given={KEYS.TIER2},
	room_choices={
		["FireForest2"] = 1+r2,
		["FireForest3"] = 1,
		["FireDesert"] = 1,
		["FireDesertHounds"] = 1,
	},
	colour={r=.25,g=.28,b=.25,a=.50},
	room_bg=GROUND.ASH,
	background_room="BGFire",
})