AddTask(
	"Custom speak to the king water",{
	locks = {LOCKS.TIER2},
	keys_given = {KEYS.TIER3},
	room_choices = {
		["WaterBeaverKingdom"] = 1,
		["CuteBeachPirates"] = math.random(0,1),
		["WaterMeanvers"] = math.random(0,2),
		["WaterMagicalForest"] = math.random(0,1)
		
	},
	room_bg=GROUND.GRASS_BLUE,
	background_room="BGWater",
	colour={r=1,g=1,b=0,a=1},
	entrance_room="WaterLureplantWall"
})

AddTask(
	"Old water two c",{
	locks = {LOCKS.TIER1},
	keys_given = {LOCKS.TIER2},
	room_choices = {
		["FireMonkeyJungle"] = 2,
		["FireSpiderJungle"] = 2,
		["FireJungle"] = 1+math.random(0,GLOBAL.SIZE_VARIATION),
	},
	room_bg=GROUND.JUNGLE,
	background_room="BGFireJungle",
	colour={r=1,g=1,b=0,a=1},
})