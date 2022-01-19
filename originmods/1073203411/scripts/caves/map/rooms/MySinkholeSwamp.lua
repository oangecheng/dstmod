-- Added tentaclepillar
AddRoom("MySinkholeSwamp", {
    colour={r=0.4,g=0.1,b=0.6,a=0.9},
    value = GROUND.MARSH,
    tags = {"Hutch_Fishbowl"},
    type = GLOBAL.NODE_TYPE.Room,
    contents =  {
		countprefabs = {
			tentacle_pillar = 1
		},
        distributepercent = .35,
        distributeprefabs=
        {
            tentacle = 1,
            reeds = 0.5,
            marsh_bush = 1.5,
            marsh_tree = 0.2,
            spiderden = 0.2,

            cavelight = 0.5,
            cavelight_small = 0.5,
            cavelight_tiny = 0.5,
        },
    }
})