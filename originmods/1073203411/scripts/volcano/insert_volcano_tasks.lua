
local volcano_foldername = "workshop-1505270912"
local volcano_magma_biome = GetModConfigData("Magma_Biome",volcano_foldername)
local volcano_volcano_biome = GetModConfigData("Volcano_Biome",volcano_foldername)
local volcano_meadow_biome = GetModConfigData("Meadow_Biome",volcano_foldername)
local volcano_tidalmarsh_biome = GetModConfigData("Tidalmarsh_Biome",volcano_foldername)
local volcano_jungle_biome = GetModConfigData("Jungle_Biome",volcano_foldername)
local volcano_beach_biome = GetModConfigData("Beach_Biome",volcano_foldername)
local volcano_gorge_biome = GetModConfigData("TheGorge_Biome",volcano_foldername)
local volcano_lavaarena_biome = GetModConfigData("Lavarena_Biome",volcano_foldername)


return function(level)

			if volcano_magma_biome then
				table.insert(level.tasks, "MAGMAFIELD_TASK_FOREST")
			end
			if volcano_volcano_biome then
                table.insert(level.tasks, "VOLCANO_TASK_FOREST")
			end
			if volcano_meadow_biome then
                table.insert(level.tasks, "MEADOW_TASK_FOREST")
			end
			if volcano_tidalmarsh_biome then
                table.insert(level.tasks, "TIDALMARSH_TASK_FOREST")
			end
			if volcano_jungle_biome then
                table.insert(level.tasks, "JUNGLE_TASK_FOREST")
			end
			if volcano_beach_biome then
                table.insert(level.tasks, "BEACH_TASK_FOREST")
			end
--                table.insert(level.tasks, "MANGROVE_TASK_FOREST")
--                table.insert(level.tasks, "MANGROVE_TASK_FOREST2")
--                table.insert(level.tasks, "MANGROVE_TASK_FOREST3")
--                table.insert(level.tasks, "WATER_SHALLOW_TASK_FOREST")
--                table.insert(level.tasks, "WATER_SHALLOW1_TASK_FOREST")
--                table.insert(level.tasks, "WATER_SHALLOW2_TASK_FOREST")
--                table.insert(level.tasks, "WATER_SHALLOW3_TASK_FOREST")
--                table.insert(level.tasks, "WATER_SHALLOW4_TASK_FOREST")
--                table.insert(level.tasks, "WATER_SHALLOW5_TASK_FOREST")
--                table.insert(level.tasks, "WATER_SHALLOW6_TASK_FOREST")
--                table.insert(level.tasks, "WATER_SHALLOW7_TASK_FOREST")
--                table.insert(level.tasks, "WATER_SHALLOW8_TASK_FOREST")
--                table.insert(level.tasks, "WATER_MEDIUM_TASK_FOREST")
--                table.insert(level.tasks, "WATER_MEDIUM1_TASK_FOREST")
--                table.insert(level.tasks, "WATER_MEDIUM2_TASK_FOREST")
--                table.insert(level.tasks, "WATER_MEDIUM3_TASK_FOREST")
--                table.insert(level.tasks, "WATER_MEDIUM4_TASK_FOREST")
--                table.insert(level.tasks, "WATER_MEDIUM5_TASK_FOREST")
--                table.insert(level.tasks, "WATER_CORAL_TASK_FOREST")
--                table.insert(level.tasks, "WATER_DEEP_TASK_FOREST")
--                table.insert(level.tasks, "WATER_DEEP1_TASK_FOREST")
--                table.insert(level.tasks, "WATER_DEEP2_TASK_FOREST")
			if volcano_gorge_biome then
                table.insert(level.tasks, "GEORGE_TASK_FOREST")
			end
			if volcano_lavaarena_biome then
				table.insert(level.tasks, "LAVARENA_TASK_FOREST")
			end
end