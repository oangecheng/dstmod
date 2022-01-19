
AddRoomPreInit(
	"SnowyHerds", function(room)
	room.contents.countprefabs.rock_tough = 2 -- formerly none
end)


AddRoomPreInit("SnowyBunnies", function(room)
	if room.contents.countprefabs then
		room.contents.countprefabs.rock_tough = 4
	else
		room.contents.countprefabs = {rock_tough = 4} -- formerly none
	end
end)


AddRoomPreInit("SnowyTotallyNormalForest", function(room)
	room.contents.distributeprefabs.rock_tough = 0.08 -- formerly none
end)

AddRoomPreInit("Custom Iced Lake", function(room)
	room.contents.distributeprefabs.rock_tough = 0.1 -- formerly none
end)
AddRoomPreInit("SnowyIcedLake", function(room)
	room.contents.distributeprefabs.rock_tough = 0.1 -- formerly none
end)