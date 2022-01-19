
-- Add some slurpers, the default numbers seem to be too low

AddRoomPreInit("BGSinkhole", function(room) room.contents.distributeprefabs.slurper_spawner = 0.02 end)
AddRoomPreInit("GrasslandSinkhole", function(room) room.contents.distributeprefabs.slurper_spawner = 0.02 end)
AddRoomPreInit("SparseSinkholes", function(room) room.contents.distributeprefabs.slurper_spawner = 0.02 end)
AddRoomPreInit("SinkholeCopses", function(room) room.contents.distributeprefabs.slurper_spawner = 0.02 end)
AddRoomPreInit("SinkholeForest", function(room) room.contents.distributeprefabs.slurper_spawner = 0.02 end)

AddRoomPreInit("ToadstoolArenaBGMud", function(room) room.contents.distributeprefabs.slurper_spawner = 0.02 end)
AddRoomPreInit("BatCave", function(room) room.contents.distributeprefabs.slurper_spawner = 0.02 end)

local put_slurpers =
		function(room) 
			room.contents.distributeprefabs.slurper = 0.02
			room.contents.distributeprefabs.slurper_spawner = 0.004
		end
AddRoomPreInit("RedMushForest", put_slurpers)
AddRoomPreInit("RedSpiderForest", put_slurpers)
AddRoomPreInit("BGRedMush", put_slurpers)
AddRoomPreInit("BGRedMushRoom", put_slurpers)
AddRoomPreInit("GreenMushForest", put_slurpers)
AddRoomPreInit("BGGreenMush", put_slurpers)
AddRoomPreInit("BGGreenMushRoom", put_slurpers)
AddRoomPreInit("BlueMushForest", put_slurpers)
AddRoomPreInit("BGBlueMush", put_slurpers)
AddRoomPreInit("BGBlueMushRoom", put_slurpers)


local increase_slurpers =
		function(room)
			if room.contents.distributeprefabs.slurper_spawner then
				room.contents.distributeprefabs.slurper_spawner = room.contents.distributeprefabs.slurper_spawner*1.2
			end
		end
AddRoomPreInit("LichenLand", increase_slurpers)
AddRoomPreInit("CaveJungle", increase_slurpers)
AddRoomPreInit("RuinedCity", increase_slurpers)
AddRoomPreInit("wetwilds", increase_slurpers)
AddRoomPreInit("BGWilds", put_slurpers)
AddRoomPreInit("BGWildsRoom", put_slurpers)