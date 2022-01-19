
-- All the biomes in this file come from Deja Vu's "Advanced World Generation" mod

-- Custom Ancient Guardian Spawn Biome
AddTask("InfusedWorld_MinotaurHome",	{
					locks={ LOCKS.NONE },
					keys_given={ KEYS.CAVE, KEYS.TIER1 },
					room_tags = {"Nightmare"},
						room_choices =
							{
								["InfusedWorld_MinotaurHome_BackgroundRoom"] = 2 * math.random(GLOBAL.SIZE_VARIATION),
								["InfusedWorld_MinotaurHome_Spawn"] = GetModConfigData("AncientGuardianSpawn"),
							},
						room_bg=GROUND.BRICK,
						background_room="InfusedWorld_MinotaurHome_BackgroundRoom",
						colour={r=0,g=0,b=0,a=0},
					}
	)

AddRoom("InfusedWorld_MinotaurHome_BackgroundRoom",	{
			colour={r=0.3,g=0.2,b=0.1,a=0.3},
			value = GROUND.BRICK, 
			contents =	{
					distributepercent = 0.15,
						distributeprefabs =
							{
								nightmarelight = 0.30,
								chessjunk1 = 0.1,
								chessjunk2 = 0.1,
								chessjunk3 = 0.1,
								ruins_statue_head = 0.1,
								ruins_statue_head_nogem = 0.2,
								ruins_statue_mage = 0.1,
								ruins_statue_mage_nogem = 0.2,
								rook_nightmare = 0.08,
								bishop_nightmare = 0.08,
								knight_nightmare = 0.08,
							}
					}
				}
	)

AddRoom("InfusedWorld_MinotaurHome_Spawn",	{
			colour={r=0.3,g=0.2,b=0.1,a=0.3},
			value = GROUND.BRICK, 
			contents =	{
			countstaticlayouts = 
						{
							["WalledGarden"] = 1,
						},          
					},
					}
	)