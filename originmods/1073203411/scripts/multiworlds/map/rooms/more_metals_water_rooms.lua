

AddRoomPreInit(
	"WaterBeaverForest", function(room)
	if room.contents.countprefabs then
		room.contents.countprefabs.rock_cobalt = 4
	else
		room.contents.countprefabs = {rock_cobalt = 4} -- formerly none
	end
end)

AddRoomPreInit(
	"WaterBeachRocks", function(room)
	if room.contents.countprefabs then
		room.contents.countprefabs.rock_cobalt = 1
	else
		room.contents.countprefabs = {rock_cobalt = 1} -- formerly none
	end
end)
