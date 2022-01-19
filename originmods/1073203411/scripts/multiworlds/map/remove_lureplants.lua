
-- Since the number of biomes in Megarandom is much higher than regular maps, "countprefabs" objects become much more dense
-- This code removes lureplants countprefabs

function remove_lureplant(room)
	if room.countprefabs and room.countprefabs.lureplant then
		room.countprefabs.lureplant = nil
	end
end

AddRoomPreInit("FireJungle",remove_lureplant)
AddRoomPreInit("WaterForest",remove_lureplant)