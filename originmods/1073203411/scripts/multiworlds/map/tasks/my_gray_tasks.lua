
AddTask("Custom speak to the king gray", {
	locks={LOCKS.PIGKING,LOCKS.TIER2},
	keys_given={KEYS.PIGS,KEYS.TIER3},
	room_choices={
		["GrayPigKingdom"] = 1,
		["GrayMagicalDeciduous"] = 1,
		["GrayDeepDeciduous"] = 3, 
	}, 
	room_bg=GROUND.GRASS,
	background_room="BGGrayDeciduous",
	colour={r=1,g=1,b=0,a=1}
})

AddTask("Custom speak to the king blue-gray", {
	locks={LOCKS.PIGKING,LOCKS.TIER2},
	keys_given={KEYS.PIGS,KEYS.TIER3},
	room_choices={
		["SnowyPigKingdom"] = 1,
		["SnowyIcedLake"] = 1,
		["GrayMagicalDeciduous"] = 1,
		["GrayDeepDeciduous"] = 2, 
	}, 
	room_bg=GROUND.GRASS,
	background_room="BGGrayDeciduous",
	colour={r=1,g=1,b=0,a=1}
})
