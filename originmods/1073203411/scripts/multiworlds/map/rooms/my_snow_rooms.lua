

AddRoomPreInit(
	"SnowyHerds", function(room)
	if room.contents.countprefabs then
		room.contents.countprefabs.koalefant_winter = 1 -- formerly none
	else
		room.contents.countprefabs = {koalefant_winter = 1} -- formerly none
	end
	
	room.contents.distributeprefabs.rock_ice = 0.25 -- formerly 0.05
	
	room.contents.distributeprefabs.bunneefalo = room.contents.distributeprefabs.beefalo
	room.contents.distributeprefabs = nil
end)

AddRoomPreInit("SnowyBunnies", function(room)
	room.contents.distributeprefabs.evergreen = 7 -- formerly 9
	room.contents.distributeprefabs.rock_ice = 0.2 -- formerly none
end)


AddRoomPreInit("SnowyTotallyNormalForest", function(room)
	room.contents.distributepercent = room.contents.distributepercent*1.2
	room.contents.distributeprefabs.evergreen = room.contents.distributeprefabs.evergreen*1.2
	room.contents.distributeprefabs.rock_ice = 0.2 -- formerly none
	room.contents.distributeprefabs.pighouse_blue = 0.08 -- formerly none
end)

AddRoomPreInit("SnowyLeifForest", function(room)
	room.contents.distributepercent = room.contents.distributepercent*1.2
	room.contents.distributeprefabs.evergreen = room.contents.distributeprefabs.evergreen*1.2
	room.contents.distributeprefabs.pighouse_blue = 0.08 -- formerly none
end)

--[[
AddRoom("Custom Iced Lake",{
	colour={r=.25,g=.28,b=.25,a=.50},
	value = GROUND.ICE_LAKE -- TODO is invisible
	internal_type = GLOBAL.NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
	tags = {"ExitPiece", "Chester_Eyebone", "RoadPoison"},
	contents =  {
		distributepercent = 0.15,
		distributeprefabs = {
			fireflies = 0.1,
			rock_ice = 0.3,
		}
	}
})
--]]
AddRoomPreInit("SnowyIcedLake", function(room)
	room.contents.distributepercent = 0.25
	room.contents.distributeprefabs = {
			fireflies = 0.1,
			rock_ice = 0.3,
			ice = 0.1
		}
end)
