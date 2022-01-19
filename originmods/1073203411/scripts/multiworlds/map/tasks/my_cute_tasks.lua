AddTask("Custom speak to the king cute", {
	locks={LOCKS.PIGKING,LOCKS.TIER2},
	keys_given={KEYS.PIGS,KEYS.GOLD,KEYS.TIER3},
	room_choices={
		["PigKingdom"] = 1,
		["CuteGiantBunnyLair"] = 1,
	}, 
	room_bg=GROUND.FUNGUS,
	background_room="BGCuteFungus",
	colour={r=1,g=1,b=0,a=1}
})