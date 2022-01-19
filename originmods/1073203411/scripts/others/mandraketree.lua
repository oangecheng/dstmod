

local function spawn_mandraketree(room)
if room.contents.countprefabs then
room.contents.countprefabs.mandraketree = 1
else
room.contents.countprefabs = {
	["mandraketree"] = 1,
	}
end
end

local r = math.random()

if r < 0.5 then
AddRoomPreInit("FireMonkeyJungle",spawn_mandraketree)
elseif r < 1.0 then
AddRoomPreInit("FireSpiderJungle",spawn_mandraketree)
else
-- nothing yet
end

