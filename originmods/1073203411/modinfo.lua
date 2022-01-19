-- This information tells other players more about the mod
name = "Megarandom world"
description = [[

Generate huge, random and more varied maps.

version 1.8.1: added a new setting "optimized worldgen" and a setting to tweak the world size.

]]
author = "Swaggy"
version = "1.8.1"
forumthread = ""
api_version = 10


priority = 1000

icon_atlas = "preview.xml"
icon = "preview.tex"

dst_compatible = true
reign_of_giants_compatible = true

all_clients_require_mod = true
client_only_mod = false

server_filter_tags = {"environment","worldgen"}

configuration_options =
{

	{
		name = "",
		label = "WORLD SETTINGS",
			hover = "",
		options =	{
						{description = "", data = 0},
					},
		default = 0,
	},
	{
		name = "WorldShape",
		label = "World shape",
			hover = "Custom world shapes instead of the original game tree shape.",
		options =	{
						{description = "Disabled", data = 0, hover = "Original game shape."},
						{description = "Continental", data = 6, hover = "Recommended. Circular world with many connections."},
						--{description = "Continental2", data = 9, hover = "Recommended. Circular world with many connections."},
						{description = "Toric", data = 5, hover = "Circular world with less connections."},
						{description = "Loop", data = 220, hover = "1 giant circle with no connections. Not recommended for normal games."},
						{description = "2 Loops", data = 2, hover = "2 giant circles. Not recommended for normal games."},
						{description = "4 Loops", data = 3, hover = "4 giant circles."},
						{description = "2 Loops Brch", data = 12, hover = "2 circles with random branches."},
						{description = "4 Loops Brch", data = 14, hover = "4 circles with random branches."},
						{description = "N Loops Brch", data = 15, hover = "The number of circles will be computed based on the size of the map."},
						{description = "Line", data = 7, hover = "The world will be just a big line. Not recommended for normal games."},
						{description = "Thick Line", data = 8, hover = "Rectangular world. Rather interesting and original shape."},
						--{description = "Line", data = 1}, -- only for debug, not recommended for high number of biomes
					},
		default = 6,
	},
	{
		name = "mapSize",
		label = "Map size",
			hover = "Size of the map.",
		options ={
					{description = "Default", data = -1, hover = "The map size will be the one you selected in the game menu."},
					{description = "Automatic", data = 0, hover = "Auto-determined based on number of biomes, mods, etc."},
					{description = "1.1x Larger", data = 480, hover = "The map will be 1.1x larger than Huge."},
					{description = "1.2x Larger", data = 500, hover = "The map will be 1.2x larger than Huge."},
					{description = "1.3x Larger", data = 520},
					{description = "1.4x Larger", data = 540},
					{description = "1.5x Larger", data = 560},
					{description = "1.7x Larger", data = 580},
					{description = "1.8x Larger", data = 600},
					{description = "1.9x Larger", data = 620},
					{description = "2.0x Larger", data = 640},
					{description = "2.2x Larger", data = 660},
					{description = "2.3x Larger", data = 680},
					{description = "2.4x Larger", data = 700},
					{description = "2.6x Larger", data = 720, hover = "Not recommended."},
					{description = "2.7x Larger", data = 740, hover = "Not recommended."},
					{description = "2.9x Larger", data = 760, hover = "Not recommended."},
					{description = "3.0x Larger", data = 780, hover = "Not recommended."},
					{description = "3.2x Larger", data = 800, hover = "Not recommended."},
					{description = "3.6x Larger", data = 850, hover = "Not recommended."},
					{description = "4.0x Larger", data = 900, hover = "Not recommended."},
				},
					default = 0,
	},
	{
		name = "WorldgenOptimization",
		label = "Optimize Worldgen",
			hover = "Much, much faster loading time, and more objects spawned, at the expense of rare occurences of non-vanilla world generation (eg. Pig King in Bee biome).",
		options =	{
						{description = "Disabled", data = false, hover = "Original game algorithm."},
						{description = "Enabled", data = true, hover = "Things will get spawned in more lenient places."},
					},
		default = true,
	},
	{
		name = "",
		label = "BIOME SETTINGS",
			hover = "",
		options =	{
						{description = "", data = 0},
					},
		default = 0,
	},
	{
		name = "RandomOptionalBiomes",
		label = "Random Optional Biomes",
			hover = "Randomly chooses extra biomes",
		default = 12,
	},
	{
		name = "RandomOptionalCaveBiomes",
		label = "Random Optional Cave Biomes",
			hover = "Randomly chooses extra Cave biomes",
		default = 16,
	},
	{
		name = "InfusedWorldsRandomOptionalBiomes",
		label = "Number of biomes",
		hover = "Number of forest/cave/MultiWorlds biomes on the map (does not include other mods). Too many may cause longer map generation.",
		options =	{
						{description = "Less", data = 7, hover = "44 biomes. Not recommended."},
						{description = "Normal", data = 11, hover = "48 biomes. Not recommended. The more, the better."},
						{description = "Lots", data = 15, hover = "52 biomes. Recommended"},
						{description = "Too many", data = 19, hover = "56 biomes. Not recommended. Longer world creation time."},
						{description = "Pls no", data = 23, hover = "60 biomes. Not recommended. Please use the \"giant size\" mod."},
						{description = "u crazy ??", data = 27, hover = "64 biomes. Not recommended."},
						--{description = "38 (DEBUG)", data = 1},
					},
		default = 15,
	},
	{
		name = "CaveTasksEnabled",
		label = "Cave biomes",
			hover = "Enable cave biomes on surface.",
		options =	{
						{description = "Disabled", data = false},
						{description = "Enabled", data = true},
						--{description = "38 (DEBUG)", data = 1},
					},
		default = true,
	},
	{
		name = "MultiTasksEnabled",
		label = "MultiWorld biomes",
			hover = "Enable Multi-World biomes. Requires the mod \"Multi-Worlds DST\" !",
		options =	{
						--{description = "Unavailable", data = false, hover = "This feature is temporarily disabled."}, -- TODO also disabled in modworldgenmain.lua
						--
						{description = "Disabled", data = false},
						{description = "Enabled", data = true},
						--
					},
		default = false,
	},
	{
		name = "RandomOptionalRuins",
		label = "Ruins",
			hover = "Number of ruins on the map.",
		options =	{
						{description = "Disabled", data = 0, hover = "No ruins will spawn in overworld."},
						{description = "Few", data = 0.33, hover = "Enable 33% of the ruins to spawn."},
						{description = "Normal", data = 0.66, hover = "Enable 50% of the ruins to spawn."},
						{description = "Lots", data = 0.8, hover = "Enable most of the ruins biomes."},
						{description = "Too many", data = 1, hover = "Enable most of the ruins + atrium and labyrinth. Very long/bugged worldgen."},
					},
		default = 0.66,
	},
	{
		name = "RandomOptionalForests",
		label = "Forest",
			hover = "Number of bonus forest biomes on the map (2nd Deciduous, Triple MacTusk...)",
		options =	{
						{description = "Disabled", data = -1, hover = "Bonus forest biomes will be disabled."},
						{description = "Few", data = 0, hover = "Bonus forest biomes will only be spawned if there is nothing else left."},
						{description = "Normal", data = --[[WARNING: HARDCODED--]] 1.42, hover = "Experimental: spawn as many bonus biomes as in vanilla."},
						{description = "Lots", data = 5, hover = "At least 5 bonus forest biomes will be spawned."},
						{description = "Too many", data = 8, hover = "At least 8 bonus forest biomes will be spawned."},
					},
		default = 5,
	},
	-- Gameplay Options
	{
		name = "",
		label = "GAMEPLAY SETTINGS",
			hover = "",
		options =	{
						{description = "", data = 0},
					},
		default = 0,
	},
	{
		name = "LightsOutStartingItems",
		label = "Lights Out Mod Starting Items",
			hover = "Adds essential Lights Out game mode Starting Items",
		
		default = 0,
	},
	{
		name = "OverworldNightmarePhase",
		label = "Nightmare Phase",
			hover = "Enable Nightmare Phase when walking on ruins.",
			options =
					{
						{description = "Disabled", data = 0},
						{description = "Enabled", data = 1},
					},
		default = 1,
	},
	{
		name = "OverworldNightmarePhaseHUDEffects",
		label = "Nightmare Effects",
			hover = "If nightmare phase is enabled, darken screen when entering a nightmare zone.",
			options =
					{
						{description = "Disabled", data = false},
						{description = "Enabled", data = true},
					},
		default = true,
	},
	{
		name = "OverworldEarthquakes",
		label = "Earthquakes",
			hover = "Enable Earthquakes in overworld",
			options =
					{
						{description = "Disabled", data = false},
						{description = "Enabled", data = true},
					},
		default = true,
	},
	
	{
		name = "",
		label = "OTHER SETTINGS",
			hover = "",
		options =	{
						{description = "", data = 0},
					},
		default = 0,
	},	
	{
		name = "RandomSpawn",
		label = "Spawn biome",
		hover = "Biome where the portal will spawn.",
		options =	{
						{description = "Default", data = false, hover = "Spawn in the default grass biome."},
						{description = "Random", data = true, hover = "Can spawn at other locations, but still in grass."},
						{description = "MADNESS", data = "Madness", hover = "Can spawn really everywhere, including hostile places."},
					},
		default = false,	
	},
	{
		name = "ForceOutsideTasksOutside",
		label = "Force cave on edges",
		hover = "Define the cave biomes placement. As they are more dangzerous in general it is better to place them on the edges of the map.",
		options =	{
						{description = "Yes", data = true, hover = "Placed near the edges of the world."},
						{description = "No", data = false, hover = "Placed randomly."},
					},
		default = true,
	},
	
	{
		name = "ShowWorldGenWarnings",
		label = "WorldGen warnings",
		hover = "Allow the mod to show warnings, like \"Multi Worlds can not be found\", etc.",
		options =	{
						{description = "No", data = false},
						{description = "Yes", data = true},
					},
		default = true,	
	},
	{
		name = "RevealMapAtStart",
		label = "[Debug] Reveal map",
		hover = "In case you just want to try and quickly see how the new shapes look like. Only works in local.",
		options =	{
						{description = "No", data = false, hover = "Default."},
						{description = "Yes", data = true, hover = "Will reveal the map. Does not work on dedicated servers."},
					},
		default = false,	
	},
-- Multi Worlds options
	{
		name = "",
		label = "MULTI-WORLDS",
			hover = "",
		options =	{
						{description = "", data = 0},
					},
		default = 0,
	},
	{
		name = "MultiTasksBeachEnabled",
		label = "Beach",
			hover = "Enable beach biome.",
		options =	{
						{description = "Disabled", data = 0},
						{description = "Normal", data = 4},
					},
		default = 4,
	},
	{
		name = "MultiTasksBeaverEnabled",
		label = "Beaver",
			hover = "Enable beaver biome.",
		options =	{
						{description = "Disabled", data = 0},
						{description = "Normal", data = 4},
						{description = "More", data = 8},
					},
		default = 4,
	},
	{
		name = "MultiTasksCuteEnabled",
		label = "Bunny",
			hover = "Enable cave bunny biomes.",
		options =	{
						{description = "Disabled", data = 0},
						{description = "Normal", data = 4},
						{description = "More", data = 5},
					},
		default = 4,
	},
	{
		name = "MultiTasksChezzEnabled",
		label = "Cyborg",
			hover = "Enable metal/cyborg biomes.",
		options =	{
						{description = "Disabled", data = 0},
						{description = "Less", data = 4},
						{description = "Normal", data = 6},
					},
		default = 4,
	},
	{
		name = "MultiTasksGrayEnabled",
		label = "Gray",
			hover = "Enable gray biomes.",
		options =	{
						{description = "Disabled", data = 0},
						{description = "Normal", data = 4},
					},
		default = 4,
	},
	{
		name = "MultiTasksJungleEnabled",
		label = "Jungle",
			hover = "Enable jungle biome.",
		options =	{
						{description = "Disabled", data = 0},
						{description = "Normal", data = 4},
					},
		default = 4,
	},
	{
		name = "MultiTasksSnowEnabled",
		label = "Snowy",
			hover = "Enable snowy biomes.",
		options =	{
						{description = "Disabled", data = 0},
						{description = "Normal", data = 4},
					},
		default = 4,
	},
	{
		name = "MultiTasksSlimeyEnabled",
		label = "Slimy",
			hover = "Enable slimy (Ewecus) biomes.",
		options =	{
						{description = "Disabled", data = 0},
						{description = "Normal", data = 4},
					},
		default = 4,
	},
	{
		name = "MultiTasksFireEnabled",
		label = "Volcano",
			hover = "Enable volcano biomes.",
		options =	{
						{description = "Disabled", data = 0},
						{description = "Normal", data = 4},
					},
		default = 4,
	},
	{
		name = "MultiworldsPigkingOption",
		label = "Special kings",
			hover = "How many of the Multi Worlds kings to spawn.",
		options =	{
						{description = "0", data = 0},
						{description = "1", data = 1},
						{description = "2", data = 2},
						{description = "3", data = 3},
						{description = "4", data = 4},
						{description = "5 (All)", data = 5},
						--{description = "6 (All)", data = 6},
					},
		default = 2,
	},
	{
		name = "MultiworldsNightmareChezz",
		label = "Nightmare Phase",
			hover = "Enable nightmare phase in some cyborg biomes.",
		options =	{
						{description = "No", data = false},
						{description = "Yes", data = true},
						--{description = "6 (All)", data = 6},
					},
		default = true,
	},
	{
		name = "",
		label = "",
			hover = "",
		options =	{
						{description = "", data = 0},
					},
		default = 0,
	},
	{
		name = "",
		label = "SET PIECES OPTIONS",
			hover = "",
		options =	{
						{description = "", data = 0},
					},
		default = 0,
	},
	{
		name = "",
		label = "Bosses",
			hover = "",
		options =	{
						{description = "", data = 0},
					},
		default = 0,
	},
	{
		name = "MooseSpawn",
		label = "Moose",
			hover = "Moose Spawn Eggs",
		options =	{
						{description = "Disabled", data = 0},
						{description = "1", data = 1},
						{description = "2", data = 2},
						{description = "3", data = 3},
						{description = "4", data = 4},
						{description = "5", data = 5},
						{description = "6", data = 6},
						{description = "7", data = 7},
						{description = "8", data = 8},
						{description = "9", data = 9},
						{description = "10", data = 10},
					},
		default = 9,
	},
	{
		name = "VolcanoDragonflySpawn",
		label = "Volcano Dragonfly",
			hover = "Volcano Dragonfly that spawns in Multi Worlds Volcano biome.",
		options =	{
						{description = "Disabled", data = 0},
						{description = "1", data = 1},
					},
		default = 1,
	},
	{
		name = "AncientGuardianSpawn",
		label = "Ancient Guardian",
			hover = "Ancient Guardian Spawn Arena",
		options =	{
						{description = "Disabled", data = 0},
						{description = "Sometimes", data = 0.5},
						{description = "Always", data = 1},
					},
		default = 0.5,
	},
	{
		name = "AncientFuelweaverSpawn",
		label = "Reanimated Skeleton",
			hover = "Custom Reanimated Skeleton set piece.",
		options =	{
						{description = "Disabled", data = false},
						{description = "1", data = true},
					},
		default = true,
	},
	--[[
	{
		name = "TigerSharkSpawn",
		label = "Tiger Shark",
			hover = "Spawn Tigershark in Beach biome",
		options =	{
						{description = "Disabled", data = false},
						{description = "coming soon ...", data = true},
					},
		default = false,
	},
	{
		name = "SealnadoSpawn",
		label = "Sealnado",
			hover = "Spawn Sealnado in Windy Plains",
		options =	{
						{description = "Disabled", data = false},
						{description = "coming soon ...", data = true},
					},
		default = false,
	},
	
	{
		name = "",
		label = "Pig Kings",
			hover = "",
		options =	{
						{description = "", data = 0},
					},
		default = 0,
	},
	{
		name = "DefaultPigkingOption",
		label = "Normal kings",
			hover = "How many default pig kings to spawn.",
		options =	{
						--{description = "0", data = 0},
						{description = "1", data = 1},
						--{description = "2", data = 2},
					},
		default = 1,
	},]]--
	{
		name = "",
		label = "Mod Set Pieces",
			hover = "",
		options =	{
						{description = "", data = 0},
					},
		default = 0,
	},
	{
		name = "RandomBasementSetpiece",
		label = "Basement",
			hover = "If the mod \"Basements\" is enabled, spawn a random basement somewhere.",
		options =	{
						{description = "Disabled", data = 0},
						{description = "1", data = 1},
						{description = "2", data = 2},
						{description = "3", data = 3},
					},
		default = 1,
	},
	{
		name = "",
		label = "Forest Set Pieces",
			hover = "",
		options =	{
						{description = "", data = 0},
					},
		default = 0,
	},
	{
		name = "EnableCaveSetpiecesOnSurface",
		label = "Cave on Surface",
			hover = "Enable some cave set pieces on surface. Only has effect if Cave biomes are disabled.",
		options =	{
						{description = "Disabled", data = 0},
						{description = "Enabled", data = 1},
					},
		default = 0,
	},
-- Default Biomes Set Pieces
	{
		name = "ResurrectionStoneOption",
		label = "Resurrection Stone",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 2,
	},
	{
		name = "FarmplotOption",
		label = "Farmplot",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 5,
	},
	{
		name = "StoneHengeOption",
		label = "Stonehenge",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 4,
	},
	{
		name = "SimpleBaseOption",
		label = "Simple Base",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 2,
	},
	{
		name = "RuinedBaseOption",
		label = "Ruined Base",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 2,
	},
	{
		name = "GrottoOption",
		label = "Grotto",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 12,
	},
	{
		name = "LivingTreeOption",
		label = "Living Tree",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 2,
	},
	{
		name = "MacTuskTownOption",
		label = "MacTusk Town",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "MermShrineOption",
		label = "Merm Shrine",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "PigShrineOption",
		label = "Pig Shrine",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 0,
	},
	{
		name = "VillageSquareOption",
		label = "Village Square",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "PigGuardsOption",
		label = "Pig Guards",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "PigTownOption",
		label = "Pig Town",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "FisherPigOption",
		label = "Fisher Pig",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "SwampPigOption",
		label = "Swamp Pig",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "DeciduousPondOption",
		label = "Deciduous Pond",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 3,
	},
	{
		name = "ChessSpot1Option",
		label = "Chess Spot 1",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "ChessSpot2Option",
		label = "Chess Spot 2",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "ChessSpot3Option",
		label = "Chess Spot 3",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "Maxwell1Option",
		label = "Maxwell 1",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "Maxwell2Option",
		label = "Maxwell 2",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "Maxwell3Option",
		label = "Maxwell 3",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "Maxwell4Option",
		label = "Maxwell 4",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "Maxwell5Option",
		label = "Maxwell 5",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "Maxwell6Option",
		label = "Maxwell 6",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "Maxwell7Option",
		label = "Maxwell 7",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
-- Cave Biomes Set Pieces
--[[
	{
		name = "",
		label = "Cave Set Pieces",
			hover = "",
		options =	{
						{description = "", data = 0},
					},
		default = 0,
	},
--]]
	{
		name = "CaveBaseOption",
		label = "Cave Base",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 9,
	},
	{
		name = "MushBaseOption",
		label = "Mush Base",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 9,
	},
	{
		name = "SinkBaseOption",
		label = "Sink Base",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 9,
	},
	{
		name = "RuinsCampOption",
		label = "Ruins Camp",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 4,
	},
	{
		name = "RabbitTownOption",
		label = "Rabbit Town",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 2,
	},
	{
		name = "MilitaryEntranceOption",
		label = "Military Entrance",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "AltarRoomOption",
		label = "Altar Room",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "SpiralOption",
		label = "Spiral",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "BrokenAltarOption",
		label = "Broken Altar",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "Chessy1Option",
		label = "Chessy 1",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "Chessy2Option",
		label = "Chessy 2",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "Chessy3Option",
		label = "Chessy 3",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "Chessy4Option",
		label = "Chessy 4",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "Chessy5Option",
		label = "Chessy 5",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "Chessy6Option",
		label = "Chessy 6",
			hover = "How many of said Set Pieces can appear on all valid biomes",
		default = 1,
	},
	{
		name = "AutoDownloadMultiworlds",
		default = true,
	},
	
	{
		name = "",
		label = "OLD-TROPICAL EXP",
			hover = "Requires \"Tropical Experience - The Volcano Biome\"",
		options =	{
						{description = "", data = 0},
					},
		default = 0,
	},
	{
		name = "VolcanoRandomOceanBiomes",
		label = "Ocean biomes",
			hover = "Number of ocean biomes.\nThis requires the mod \"Volcano Biome - Shipwrecked Experience\".",
		options =	{
						{description = "None", data = 0},
						{description = "Less", data = 0.5},
						{description = "Lots", data = 1.0},
					},
		default = 0.5,
	},
	{
		name = "VolcanoCenterOcean",
		label = "Group Ocean",
			hover = "Place all ocean biomes near each other.",
		options =	{
						{description = "No", data = false},
						{description = "Yes", data = true},
					},
		default = true,
	},
	{
		name = "VolcanoWaterGeneration",
			label = "Replace default water",
			hover = "Replace default water with Shipwrecked water. Disabling it has not been tested.",
		options =	{
						{description = "No", data = false},
						{description = "Yes", data = true},
					},
		default = true,
	},
	{
		name = "VolcanoBeachStart",
			label = "Beach Start",
			hover = "Theportal will always start on the beach.",
		options =	{
						{description = "No", data = false},
						{description = "Yes", data = true},
					},
		default = true,
	},
}

--Adds a priority to the mod. Loads it before or after other mods. This can help to fix various incompatibilities between other mods.
--priority = 8888.88487878488