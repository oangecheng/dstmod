local require = GLOBAL.require

AddLevelPreInitAny(function(level)
	
	if level.location ~= "forest" then
            return
    end
		
	print("[Megarandom] Found teleportato mod.")
	
	local teleportato_layouts = {
		["TeleportatoBoxLayout"] = true,
		["TeleportatoRingLayoutSanityRocks"] = true,
        ["TeleportatoRingLayout"] = true,
		["TeleportatoPotatoLayout"] = true,
		["TeleportatoCrankLayout"] = true,
		["TeleportatoBaseLayout"] = true,
	} -- or we could as well walk through all the layouts and find those starting with "teleportato"

	
	local layouts = require("map/layouts")
	for _,name in pairs(teleportato_layouts) do
		local teleportato_setpiece = layouts.Layouts[name]
		if teleportato_setpiece then
			local old_mask = teleportato_setpiece.fill_mask
			teleportato_setpiece.fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN
			print("Changed "..name.." mask from "..old_mask.." to "..GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN)
		end
	end
	
	
	if level.ordered_story_setpieces then
		
		local new_ordered_setpieces = {}
		
		for _,piece in ipairs(level.ordered_story_setpieces) do
			if teleportato_layouts[piece] then
				print("Re-adding "..piece.." set piece to level")
				level.set_pieces[piece] = { count = 1, tasks={"Make a pick", "Dig that rock", "Great Plains", "Beeeees!", "Speak to the king", "Forest hunters", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs","Oasis","Badlands","Lightning Bluff"}}
			else
				table.insert(new_ordered_setpieces,piece)
			end
		end
		
		level.ordered_story_setpieces = new_ordered_setpieces
	end
end)