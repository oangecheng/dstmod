if multi_tasks_enabled then
-- spawn berry bushes in jungle
AddRoomPreInit(
	"BGFireJungle", function(room)
	room.contents.distributeprefabs.berryblu2 = 0.1
end)

AddRoomPreInit(
	"FireJungle", function(room)
	room.contents.distributeprefabs.berryblu2 = 0.1
end)

AddRoomPreInit(
	"FireSpiderJungle", function(room)
	room.contents.distributeprefabs.pineapple = 0.3
end)

AddRoomPreInit(
	"FireMonkeyJungle", function(room)
	room.contents.distributeprefabs.pineapple = 0.3
end)

-- spawn plants in water rooms
AddRoomPreInit("BGWater", function(room)
	room.contents.distributeprefabs.berrygree = 0.4
	room.contents.distributeprefabs.berrygre2 = 0.4
	room.contents.distributeprefabs.appletree = 0.4
	room.contents.distributeprefabs.pineapple = 0.3
end)

AddRoomPreInit("WaterForest", function(room)
	room.contents.distributeprefabs.berrygree = 0.4
	room.contents.distributeprefabs.berrygre2 = 0.4
	room.contents.distributeprefabs.appletree = 1.5
	room.contents.distributeprefabs.pineapple = 0.3
end)	
	

AddRoomPreInit("WaterBeaverKingdom", function(room)
	room.contents.distributeprefabs.berrygree = 0.4
	room.contents.distributeprefabs.berrygre2 = 0.4
	room.contents.distributeprefabs.appletree = 1.2
	room.contents.distributeprefabs.pineapple = 0.3
end)	
end