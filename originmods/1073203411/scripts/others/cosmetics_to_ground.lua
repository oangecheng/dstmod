
local function add_lightbulbs(room)
if room and room.contents.distributeprefabs then
room.contents.distributeprefabs.flower_cave = 0.5
room.contents.distributeprefabs.flower_cave_double = 0.1
room.contents.distributeprefabs.flower_cave_triple = 0.1
end
end
AddRoomPreInit("MagicalDeciduous",add_lightbulbs)