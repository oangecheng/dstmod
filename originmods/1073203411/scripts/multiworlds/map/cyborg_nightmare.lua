local require = GLOBAL.require

local addNightmareTag = function(room)
	if not room.tags then
		room.tags = {}
	end
	table.append(room.tags,"Nightmare")
end

-- Does not work, it is executed too late
--AddRoomPreInit("ChezzPigKingdom",addNightmareTag)
--AddRoomPreInit("ChezzMagicalDeciduous",addNightmareTag)
--AddRoomPreInit("ChezzDeepDeciduous",addNightmareTag)

AddLevelPreInitAny(level,function(level)
	local Rooms = require("map/rooms")
	addNightmareTag(Rooms["ChezzPigKingdom"])
	addNightmareTag(Rooms["ChezzMagicalDeciduous"])
	addNightmareTag(Rooms["ChezzDeepDeciduous"])
	
end)

AddTaskPreInit("Speak to the king chezz",function(task)
	if not task.room_tags then
    task.room_tags = {"Nightmare"}
	else
	table.insert(task.room_tags,"Nightmare")
	end
end)