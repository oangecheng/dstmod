

local is_uncompromising_enabled = GLOBAL.KnownModIndex:IsModEnabled("workshop-2039181790")

if is_uncompromising_enabled then
	local StaticLayout = GLOBAL.require("map/static_layout")
	local Layouts = GLOBAL.require("map/layouts").Layouts -- load the table of existing layouts.

	print("[Megarandom] Uncompromising mode detected")
	Layouts["riceplantmedium"] = StaticLayout.Get("uncompromising_mode/riceplantmedium",{
				start_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN,
				fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN,
				layout_position = GLOBAL.LAYOUT_POSITION.CENTER})

	AddLevelPreInitAny(function(level)

		local has_squeltch=false
		for _,task in pairs(level.tasks) do
			if task == "Squeltch" then
				has_squeltch=true
			end
		end
		if has_squeltch then
		
			print("[Megarandom] Squeltch was found, spawning a smaller rice patch.")
			-- smaller
			level.set_pieces["riceplantmedium"] = { count = 1, tasks=
				{
					"Squeltch"
					}
				}
		else
			print("[Megarandom] Squeltch not found in this world, not spawning a smaller rice patch.")
		end


	end)
end