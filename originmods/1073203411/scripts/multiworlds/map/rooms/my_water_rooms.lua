

local function add_few_sand(room)
	if not room.contents.distributeprefabs.seashell_beached and not room.contents.distributeprefabs.sandhill then
		room.contents.distributepercent = room.contents.distributepercent*1.2
		room.contents.distributeprefabs.seashell_beached = 0.04
		room.contents.distributeprefabs.sandhill = 0.04
	end
end
local function add_much_sand(room)
	if not room.contents.distributeprefabs.seashell_beached and not room.contents.distributeprefabs.sandhill then
		room.contents.distributepercent = room.contents.distributepercent*1.3
		room.contents.distributeprefabs.seashell_beached = 0.07
		room.contents.distributeprefabs.sandhill = 0.07
	end
end
AddRoomPreInit("WaterBeach",add_much_sand)
--AddRoomPreInit("BGWaterBeach",add_much_sand)
AddRoomPreInit("WaterBeachRocks",add_few_sand)
AddRoomPreInit("WaterBeachSharkittens",add_few_sand)
AddRoomPreInit("CuteBeachPirates",add_few_sand)

AddRoomPreInit(
	"WaterBeaverForest", function(room)
	if not room.contents.distributeprefabs.wildmeanver_house then
	room.contents.distributeprefabs.wildmeanver_house = room.contents.distributeprefabs.wildbeaver_house * 0.2
	end
end)

AddRoomPreInit(
	"WaterRocks", function(room)
	room.contents.distributeprefabs.rock1 = 0.1
	room.contents.distributeprefabs.rock2 = 0.05
end)

AddRoomPreInit(
	"BGFireJungle", function(room)
	room.contents.distributepercent = 0.6 -- formerly 0.5
	room.contents.distributeprefabs.jungletree = 0.4 -- formerly 0.2
	room.contents.distributeprefabs.grass = 0.2 -- formerly 0.1
	room.contents.distributeprefabs.bambootree = 0.2 -- formerly 0.15
	room.contents.distributeprefabs.snake_hole = 0.05 -- formerly none
end)

AddRoomPreInit(
	"FireJungle", function(room)
	room.contents.distributepercent = 0.5 -- formerly 0.3
	room.contents.distributeprefabs.jungletree = 0.6 -- formerly 0.3
	room.contents.distributeprefabs.grass = 0.2 -- formerly 0.1
	room.contents.distributeprefabs.bambootree = 0.2 -- formerly 0.15
	room.contents.distributeprefabs.snake_hole = 0.15 -- formerly 0.05
	room.contents.distributeprefabs.pond_purple = 0.05 -- formerly none
end)

AddRoomPreInit(
	"FireMonkeyJungle", function(room)
	room.contents.distributepercent = 0.4 -- formerly 0.2
	room.contents.distributeprefabs.jungletree = 0.5 -- formerly 0.3
	room.contents.distributeprefabs.grass = 0.3 -- formerly 0.2
	room.contents.distributeprefabs.pond_purple = 0.05 -- formerly none
end)

AddRoomPreInit(
	"FireSpiderJungle", function(room)
	room.contents.distributepercent = 0.4 -- formerly 0.2
	room.contents.distributeprefabs.jungletree = 0.5 -- formerly 0.3
	room.contents.distributeprefabs.pond_purple = 0.05 -- formerly none
end)

AddRoomPreInit(
	"WaterBeachRocks", function(room)
	room.contents.distributeprefabs.rock2 = 0.05
end)
