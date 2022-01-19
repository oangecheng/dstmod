

local StaticLayout = GLOBAL.require("map/static_layout")
local Layouts = GLOBAL.require("map/layouts").Layouts -- load the table of existing layouts.


Layouts["BasementSetpiece"] = StaticLayout.Get("others/basement_setpiece",{
			start_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN,
			fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN,
			layout_position = GLOBAL.LAYOUT_POSITION.CENTER})
			

AddLevelPreInitAny(function(level)

	level.set_pieces["BasementSetpiece"] = { count = GetModConfigData("RandomBasementSetpiece"), tasks=
		{
			"Forest hunters",
			"Oasis",
			"Lightning Bluff",
			"BlueForest",
			"RedForest",
			"GreenForest",
			"MyUndergroundForest",
			"MySwampySinkhole",
			"CaveSwamp",
			"MudPit",
			"MyRockyLand",
			"Spillagmitecaverns",
			"For a nice walk",
			}
		}


end)