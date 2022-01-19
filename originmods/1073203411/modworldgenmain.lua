

local megarandom_show_mw_warning = 0



local debug_taskchoice = false
local force_multiworlds = false



local require = GLOBAL.require
require("map/lockandkey")
require("map/tasks")
require("map/rooms")
require("map/terrain")
require("map/level")
require("constants")
local StaticLayout = require("map/static_layout")
local Layouts = require("map/layouts").Layouts -- load the table of existing layouts.

local blockersets = require("map/blockersets")

local LOCKS = GLOBAL.LOCKS
local KEYS = GLOBAL.KEYS
--GLOBAL.SIZE_VARIATION = GetModConfigData("GlobalBiomeSize")
local GROUND = GLOBAL.GROUND
local LEVELTYPE = GLOBAL.LEVELTYPE

function contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end
function concat(t1,t2)
	size1 = #t1
	size2 = #t2
	tnew = {}
    for i=1,size1 do
        tnew[i] = t1[i]
    end
    for i=1,size2 do
        tnew[i+size1] = t2[i]
    end
	GLOBAL.assert(#tnew == size1 + size2)
    return tnew
end

local function mGetModConfigData(param)
	local value = GetModConfigData(param)
	if type(value) == 'boolean' then
		return value and 4 or 0
	else
		return value
	end
	
end
--------------------------------------------------------------------------
------ Get user parameters, import required mod files, utilities ---------
--------------------------------------------------------------------------

local cave_tasks_enabled = GetModConfigData("CaveTasksEnabled")
local multi_tasks_enabled = GetModConfigData("MultiTasksEnabled")


--local volcano_mod_enabled = false -- GLOBAL.KnownModIndex:IsModEnabled("workshop-1402200186") or GLOBAL.KnownModIndex:IsModEnabled("workshop-1440234653") or GLOBAL.KnownModIndex:IsModEnabled("workshop-1505270912")
local volcano_mod_enabled = GLOBAL.KnownModIndex:IsModEnabled("workshop-1505270912")

if false and volcano_mod_enabled then

local waterGeneration = GetModConfigData("VolcanoWaterGeneration")
local volcanoGentype = 15


volcano1_overrides = {
	["workshop-1440234653"] = {
		["configuration_options"] =
		{
			["World Generation"] = volcanoGentype,
			["megarandomCompatibilityWater"] = waterGeneration,
		},
	}
  }
volcano2_overrides = {
	["workshop-1505270912"] = {
		["configuration_options"] =
		{
			["World Generation"] = volcanoGentype,
			["megarandomCompatibilityWater"] = waterGeneration,
		},
	}
  }

GLOBAL.KnownModIndex:ApplyConfigOptionOverrides(volcano1_overrides)
GLOBAL.KnownModIndex:ApplyConfigOptionOverrides(volcano2_overrides)

end

if multi_tasks_enabled then
-- Make sure that "Multi Worlds" is installed and enabled by the user
	local multiworlds_enabled = GLOBAL.KnownModIndex:IsModEnabled("workshop-1883683402") or GLOBAL.KnownModIndex:IsModEnabled("workshop-1237378537") or GLOBAL.KnownModIndex:IsModEnabled("workshop-1424317590") or GLOBAL.KnownModIndex:IsModEnabled("workshop-1448196849")
	-- ^ Sorry, had to hardcode the "Multiworld" mod ID here :/ If you have made a fork of MW and want it to be recognized by Megarandom please message me on Steam 
	if force_multiworlds then GLOBAL.assert(multiworlds_enabled, "\n\n-----------------------------------------------------------------------------------------------------------------------------------------------------------------\n\n\n                                                                                      MULTI WORLDS NOT ENABLED !\n\n                                                        You must enable the MULTI WORLDS mod when using the Megarandom preset.\n                                                        Please download it on the Steam Workshop and activate it in the mods menu !\n\n                                                                         (If you keep getting this warning, please disable the mod for now and write me a message on Steam.)\n               ↑                  ↑                 ↑               ↑                  ↑                 ↑               ↑                  ↑                 ↑\n-----------------------------------------------------------------------------------------------------------------------------------------------------------------\n-----------------------------------------------------------------------------------------------------------------------------------------------------------------\n\n\n\n\n\n\n") end
	if multiworlds_enabled then
	print("[Megarandom] Found Multi Worlds mod")
	else
	print("[Megarandom] Did not find Multi Worlds mod despite the user requesting it")
 if false then
	print("Trying to enable it with modoverrides...")
	multiworlds_overrides = {
	["workshop-1883683402"] = {
		["enabled"] = true
	}
  }
  GLOBAL.KnownModIndex:ApplyEnabledOverrides(multiworlds_overrides)
 else
	-- autodownload
	if false then
		print("[Megarandom] Trying with library manager ...")
		GLOBAL.package.loaded["librarymanager"] = nil
		local AutoSubscribeAndEnableWorkshopMods = GLOBAL.require("libs/librarymanager")
		AutoSubscribeAndEnableWorkshopMods({"workshop-1883683402"})
	end
  end
	local multiworlds_enabled2 = GLOBAL.KnownModIndex:IsModEnabled("workshop-1883683402") or GLOBAL.KnownModIndex:IsModEnabled("workshop-1237378537") or GLOBAL.KnownModIndex:IsModEnabled("workshop-1448196849")
	--GLOBAL.assert(multiworlds_enabled2,"[Megarandom] Multi Worlds was not found. This could be an internal bug, better stop now.")
	if not multiworlds_enabled2 then
		multi_tasks_enabled = false
		print("[Megarandom] Could not enable MultiWorlds ! Going on without the new biomes")
		-- show warning
		megarandom_show_mw_warning = 1
		
	end
	end
end


local multi_tasks_slimey_enabled = mGetModConfigData("MultiTasksSlimeyEnabled") > 0 and multi_tasks_enabled
local multi_tasks_gray_enabled = mGetModConfigData("MultiTasksGrayEnabled") > 0 and multi_tasks_enabled
local multi_tasks_snow_enabled = mGetModConfigData("MultiTasksSnowEnabled") > 0 and multi_tasks_enabled
local multi_tasks_beach_enabled = mGetModConfigData("MultiTasksBeachEnabled") > 0 and multi_tasks_enabled
local multi_tasks_beaver_enabled = mGetModConfigData("MultiTasksBeaverEnabled") > 0 and multi_tasks_enabled
local multi_tasks_jungle_enabled = mGetModConfigData("MultiTasksJungleEnabled") > 0 and multi_tasks_enabled
local multi_tasks_cute_enabled = mGetModConfigData("MultiTasksCuteEnabled") > 0 and multi_tasks_enabled
local multi_tasks_chezz_enabled = mGetModConfigData("MultiTasksChezzEnabled") > 0 and multi_tasks_enabled
local multi_tasks_fire_enabled = mGetModConfigData("MultiTasksFireEnabled") > 0 and multi_tasks_enabled

if not multi_tasks_slimey_enabled and not multi_tasks_gray_enabled and not multi_tasks_snow_enabled and not multi_tasks_chezz_enabled and not
multi_tasks_beach_enabled and not multi_tasks_beaver_enabled and not multi_tasks_jungle_enabled and not multi_tasks_cute_enabled and not multi_tasks_fire_enabled then
multi_tasks_enabled = false
end

if multi_tasks_enabled then

 -- My Custom Multi World rooms
 if multi_tasks_slimey_enabled then
  modimport("scripts/multiworlds/map/rooms/my_slimey_rooms")
 end
 if multi_tasks_gray_enabled then
  modimport("scripts/multiworlds/map/rooms/my_gray_rooms")
 end
 if multi_tasks_snow_enabled then
  modimport("scripts/multiworlds/map/rooms/my_snow_rooms")
 end
 if multi_tasks_beach_enabled or multi_tasks_beaver_enabled or multi_tasks_jungle_enabled then
  modimport("scripts/multiworlds/map/rooms/my_water_rooms")
 end
 if multi_tasks_chezz_enabled and GetModConfigData("MultiworldsNightmareChezz") then
  modimport("scripts/multiworlds/map/cyborg_nightmare.lua")
 end
 local iron_detected = GLOBAL.KnownModIndex:IsModEnabled("workshop-1079879145") or GLOBAL.KnownModIndex:IsModEnabled("workshop-737366433")
 if iron_detected then
  print("[Megarandom] Moar metals mod detected !")
  
  if multi_tasks_beach_enabled or multi_tasks_beaver_enabled or multi_tasks_jungle_enabled then
   modimport("scripts/multiworlds/map/rooms/more_metals_water_rooms")
  end
end
 local tungsten_detected = GLOBAL.KnownModIndex:IsModEnabled("workshop-1079879145") or GLOBAL.KnownModIndex:IsModEnabled("workshop-358015908")
 if tungsten_detected then
  print("[Megarandom] Tungsten mod detected !")
  if multi_tasks_snow_enabled then
   modimport("scripts/multiworlds/map/rooms/more_metals_snow_rooms")
  end
end


-- My Custom Multi World tasks
 if multi_tasks_snow_enabled then
  modimport("scripts/multiworlds/map/tasks/my_snow_tasks")
 end
 if multi_tasks_cute_enabled then
  modimport("scripts/multiworlds/map/tasks/my_cute_tasks")
 end
 if multi_tasks_gray_enabled then
  modimport("scripts/multiworlds/map/tasks/my_gray_tasks")
 end
 if multi_tasks_beaver_enabled then
  modimport("scripts/multiworlds/map/tasks/my_water_tasks")
 end
 if multi_tasks_fire_enabled then
  modimport("scripts/multiworlds/map/tasks/my_fire_tasks")
 end
 
-- Add ox
 modimport("scripts/multiworlds/map/add_oxen")

  
end --if multi_tasks_enabled

modimport("scripts/uncompromising_mode/main")
modimport("scripts/others/_main")






--------------------------------------------------------------------------
------ Tweak default cave biomes. Add tasks and rooms            ---------
--------------------------------------------------------------------------


if cave_tasks_enabled then

modimport("scripts/caves/map/tasks/mycaves")

end

if GetModConfigData("RandomOptionalRuins") > 0 then


modimport("scripts/caves/map/tasks/myruins")

end

if cave_tasks_enabled then
-- Add tentaclepillar spawn
modimport("scripts/caves/map/rooms/MySinkholeSwamp")

-- Reduce mush forests size
modimport("scripts/caves/map/reduce_mushforests")

-- Add some slurpers, the default numbers seem to be too low
modimport("scripts/caves/map/add_slurpers")
						
end -- if caves_enabled


local megarandom_tasks_to_remove = {}

--------------------------------------------------------------------------
------ World generation 1:  Create/Select set pieces             ---------
--------------------------------------------------------------------------

	  
------- Set pieces -------------------------------------

-- Choose only 1 pig king

local numDefaultPigking = 1 -- GetModConfigData("DefaultPigkingOption")
local numTorchPigking = 0

local pigking_task = "Speak to the king"

if numDefaultPigking == 0 then
	pigking_task = nil
	megarandom_tasks_to_remove["Speak to the king"] = true
end
if numDefaultPigking == 1 then
	if math.random()< 0 then --TODO
		pigking_task = "Pigs in the city"
		megarandom_tasks_to_remove["Speak to the king"] = true
		numDefaultPigking=0
		numTorchPigking=1
	end
end
if numDefaultPigking == 2 then
	if math.random()< 0 then --TODO
		pigking_task = "Pigs in the city"
		megarandom_tasks_to_remove["Speak to the king"] = true
	end
	numDefaultPigking=1
	numTorchPigking=1
end


local defaultpig_spawntasks = {"Make a pick", "Speak to the king","Magic meadow","Befriend the pigs","Frogs and bugs","Mole Colony Deciduous","MudWorld","MudCave","MudLights"}


-- Randomly choose some multi worlds pig kings
local multiworlds_pigkings_enabled = GetModConfigData("MultiworldsPigkingOption") > 0 and multi_tasks_enabled
local multi_worlds_pigtasks = {}
if multiworlds_pigkings_enabled then
	if multi_tasks_slimey_enabled then
		table.insert(multi_worlds_pigtasks,"Speak to the king slimey")
	end
	if multi_tasks_snow_enabled then
		if multi_tasks_gray_enabled then
			if math.random() > 0.5 then
				table.insert(multi_worlds_pigtasks,"Custom speak to the king gray")
			else
				table.insert(multi_worlds_pigtasks,"Custom speak to the king blue-gray")
			end
		else
			table.insert(multi_worlds_pigtasks,"Speak to the king snowy")
		end
	elseif multi_tasks_gray_enabled then
		table.insert(multi_worlds_pigtasks,"Custom speak to the king gray")
	end

	if multi_tasks_beaver_enabled then
		table.insert(multi_worlds_pigtasks,"Custom speak to the king water")
	end
	
	if multi_tasks_chezz_enabled then
		table.insert(multi_worlds_pigtasks,"Speak to the king chezz")
	end
	if multi_tasks_cute_enabled then
		table.insert(multi_worlds_pigtasks,"Custom speak to the king cute")
	end
end
local nkings = 0
if multi_tasks_enabled then 
	nkings = math.min( #multi_worlds_pigtasks, GetModConfigData("MultiworldsPigkingOption"))
end

if cave_tasks_enabled and GetModConfigData("AncientFuelweaverSpawn") then

-- A custom "Stalker Altar" set piece that I have created.

Layouts["StalkerAltar"] = StaticLayout.Get("caves/map/static_layouts/stalker_altar",{
			start_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN,
			fill_mask = GLOBAL.PLACE_MASK.IGNORE_IMPASSABLE_BARREN,
			layout_position = GLOBAL.LAYOUT_POSITION.CENTER})	
end

local megarandom_setpieces = 
{
			["ResurrectionStone"] = { count = GetModConfigData("ResurrectionStoneOption"), tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Badlands", "BlueForest","RedForest","GreenForest"}},
			["WormholeGrass"] = { count = 8, tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"}},
			["MooseNest"] = { count = GetModConfigData("MooseSpawn"), tasks={"Make a pick", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Make a Beehat", "Magic meadow", "Frogs and bugs"}},
--			["DragonflyArena"] = { count = GetModConfigData("DragonflySpawn"), tasks={"Badlands"}}, --Dragonfly Spawn Place
			["CaveEntrance"] = { count = 10, tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"}},
-- Default Biomes Set Pieces
			["Farmplot"] = { count = GetModConfigData("FarmplotOption"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs","BlueForest","RedForest","GreenForest"}},
			["StoneHenge"] = { count = GetModConfigData("StoneHengeOption"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
-- BROKEN			["CropCircle"] = { count = GetModConfigData("CropCircleOption"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "Beeeees!", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
-- BROKEN			["MushroomRingSmall"] = { count = GetModConfigData("MushroomRingSmallOption"), tasks={"Forest hunters", "Speak to the king", "Befriend the pigs", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
-- BROKEN			["MushroomRingMedium"] = { count = GetModConfigData("MushroomRingMediumOption"), tasks={"Forest hunters", "Speak to the king", "Befriend the pigs", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
-- BROKEN			["MushroomRingLarge"] = { count = GetModConfigData("MushroomRingLargeOption"), tasks={"Forest hunters", "Speak to the king", "Befriend the pigs", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["SimpleBase"] = { count = GetModConfigData("SimpleBaseOption"), tasks={"Dig that rock"}},
			["RuinedBase"] = { count = GetModConfigData("RuinedBaseOption"), tasks={"Dig that rock"}},
--			["Grotto"] = { count = GetModConfigData("GrottoOption"), tasks={"Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Badlands", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs","MudWorld","MudCave","MudLights","BlueForest","RedForest","GreenForest"}},
			["LivingTree"] = { count = GetModConfigData("LivingTreeOption"), tasks={"Squeltch", "Forest hunters"}},
			["MacTuskTown"] = { count = GetModConfigData("MacTuskTownOption"), tasks={"Forest hunters", "Badlands","MudWorld","BlueForest"}},
			["MacTuskCity"] = { count = GetModConfigData("MacTuskCityOption"), tasks={"Forest hunters", "Badlands"}},
			["MaxMermShrine"] = { count = GetModConfigData("MermShrineOption"), tasks={"Squeltch"}},
			["MaxPigShrine"] = { count = GetModConfigData("PigShrineOption"), tasks={"Speak to the king"}},
			["VillageSquare"] = { count = GetModConfigData("VillageSquareOption"), tasks=defaultpig_spawntasks},
			["PigGuards"] = { count = GetModConfigData("PigGuardsOption"), tasks={"Forest hunters", "Speak to the king"}},
			["PigTown"] = { count = GetModConfigData("PigTownOption"), tasks=defaultpig_spawntasks},
			--["DefaultPigking"] = { count = math.max(numDefaultPigking-1,0), tasks={"Speak to the king"}},
			["TorchPigking"] = { count = numTorchPigking, tasks=defaultpig_spawntasks},
			["FisherPig"] = { count = GetModConfigData("FisherPigOption"), tasks=defaultpig_spawntasks},
			["SwampPig"] = { count = GetModConfigData("SwampPigOption"), tasks={"Squeltch"}},
			["DeciduousPond"] = { count = GetModConfigData("DeciduousPondOption"), tasks={"Speak to the king"}},
			["ChessSpot1"] = { count = GetModConfigData("ChessSpot1Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["ChessSpot2"] = { count = GetModConfigData("ChessSpot2Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["ChessSpot3"] = { count = GetModConfigData("ChessSpot3Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["Maxwell1"] = { count = GetModConfigData("Maxwell1Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["Maxwell2"] = { count = GetModConfigData("Maxwell2Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["Maxwell3"] = { count = GetModConfigData("Maxwell3Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["Maxwell4"] = { count = GetModConfigData("Maxwell4Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["Maxwell5"] = { count = GetModConfigData("Maxwell5Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["Maxwell6"] = { count = GetModConfigData("Maxwell6Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},
			["Maxwell7"] = { count = GetModConfigData("Maxwell7Option"), tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs"}},

		-- IN DEVELOPMENT
			-- ["RuinedGuarden"] is the room used in the Labyrinth
			--["WalledGarden"] = { count = 1, tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "MyRockyLand", "RedForest", "GreenForest", "BlueForest"}},
			
			-- present in the "brokenaltar" task, there is also a brokenaltar set piece similar to it
			--["SacredBarracks"] = { count = 1, tasks={"DEBUGTASK"}}, -- cool but big and dangerous
			--["HalloweenPumpkins"] = { count = 1, tasks={"DEBUGTASK"}},
			["TreeFarm"] = { count = 1, tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs","BlueForest","RedForest","GreenForest","MyUndergroundForest"}},
			["MushroomRingSmall"] = { count = 1, tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs","BlueForest","RedForest","GreenForest"}},
			["MushroomRingMedium"] = { count = 1, tasks={"Make a pick", "Forest hunters", "Speak to the king", "Befriend the pigs", "For a nice walk", "The hunters", "Magic meadow", "Frogs and bugs","BlueForest","RedForest","GreenForest"}},
			
			
			--["DefaultPlusStart"] -- why not, in the future
			
			--["InsaneWormhole"] = { count = 1, tasks={"DEBUGTASK"}},
			
			-- present in the unused "TentacleMud" room
			--["Mudlights"] = { count = 1, tasks={"DEBUGTASK"}},

		}

	if cave_tasks_enabled then
		-- Cave Biomes Set Pieces
		megarandom_setpieces["TentaclePillar"] = { count = 3, tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "MyBigBatCave", "MyRockyLand", "RedForest", "GreenForest", "BlueForest", "SpillagmiteCaverns", "SwampySinkhole", "CaveSwamp", "UndergroundForest", "PleasantSinkhole", "FungalNoiseForest", "FungalNoiseMeadow", "BatCloister", "RabbitTown", "RabbitCity", "SpiderLand", "RabbitSpiderWar",}}
		megarandom_setpieces["CaveBase"] = { count = GetModConfigData("CaveBaseOption"), tasks={"SpillagmiteCaverns", "BatCloister", "MyBigBatCave"}}
		megarandom_setpieces["MushBase"] = { count = GetModConfigData("MushBaseOption"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "CaveSwamp", "RedForest", "GreenForest", "BlueForest"}}
		megarandom_setpieces["SinkBase"] = { count = GetModConfigData("SinkBaseOption"), tasks={"PleasantSinkhole", "RedForest", "GreenForest", "BlueForest"}}
		megarandom_setpieces["RabbitTown"] = { count = GetModConfigData("RabbitTownOption"), tasks={"PleasantSinkhole", "RedForest", "GreenForest", "BlueForest","MyUndergroundForest"}}
		megarandom_setpieces["RabbitHermit"] = { count = GetModConfigData("RabbitTownOption"), tasks={"PleasantSinkhole", "RedForest", "GreenForest", "BlueForest","Make a pick","Great Plains","Beeeees!","Forest hunters","MyUndergroundForest"}}	
		megarandom_setpieces["Chessy_1"] = { count = GetModConfigData("Chessy1Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "MyRockyLand", "RedForest", "GreenForest", "BlueForest"}}
		megarandom_setpieces["Chessy_2"] = { count = GetModConfigData("Chessy2Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "MyRockyLand", "RedForest", "GreenForest", "BlueForest"}}
		megarandom_setpieces["Chessy_3"] = { count = GetModConfigData("Chessy3Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "MyRockyLand", "RedForest", "GreenForest", "BlueForest"}}
		megarandom_setpieces["Chessy_4"] = { count = GetModConfigData("Chessy4Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "MyRockyLand", "RedForest", "GreenForest", "BlueForest"}}
		megarandom_setpieces["Chessy_5"] = { count = GetModConfigData("Chessy5Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "MyRockyLand", "RedForest", "GreenForest", "BlueForest"}}
		megarandom_setpieces["Chessy_6"] = { count = GetModConfigData("Chessy6Option"), tasks={"MudWorld", "MudCave", "MudLights", "MudPit", "MyRockyLand", "RedForest", "GreenForest", "BlueForest"}}
		if GetModConfigData("AncientFuelweaverSpawn") then
		megarandom_setpieces["StalkerAltar"] = { count = 1, tasks={"BlueForest","RedForest","GreenForest"}}
		end
	else
		if GetModConfigData("EnableCaveSetpiecesOnSurface") > 0 then
			local cavesetpieces_surfacecandidates = { "Make a pick", "Dig that rock", "Great Plains", "Squeltch", "Beeeees!", "Speak to the king", "Forest hunters", "Befriend the pigs", "For a nice walk", "Kill the spiders", "Killer bees!", "Make a Beehat", "The hunters", "Magic meadow", "Frogs and bugs", "Badlands"}
			megarandom_setpieces["RabbitHermit"] = { count = GetModConfigData("RabbitTownOption"), tasks=cavesetpieces_surfacecandidates}
			megarandom_setpieces["Chessy_"..math.random(1,6)] = { count = GetModConfigData("Chessy1Option"), tasks=cavesetpieces_surfacecandidates}
		end
	end
			
	if GetModConfigData("RandomOptionalRuins") > 0 then
		-- Ruins setpieces
		megarandom_setpieces["MilitaryEntrance"] = { count = GetModConfigData("MilitaryEntranceOption"), tasks={"Sacred"}}
	
		if GetModConfigData("RandomOptionalRuins") > 0.99 then
			-- only in that case, because it makes longer loading times and most of people complain about it
			megarandom_setpieces["RuinsCamp"] = { count = GetModConfigData("RuinsCampOption"), tasks={"Sacred"}}
		end
		
		megarandom_setpieces["AltarRoom"] = { count = GetModConfigData("AltarRoomOption"), tasks={"Sacred"}}
		megarandom_setpieces["Spiral"] = { count = GetModConfigData("SpiralOption"), tasks={"Sacred"}}
		megarandom_setpieces["BrokenAltar"] = { count = GetModConfigData("BrokenAltarOption"), tasks={"Sacred"}}
	end
	
--------------------------------------------------------------------------
------ World generation 2:  Choose tasks.                        ---------
--------------------------------------------------------------------------
--[[

  1) I have introduced a few new things compared to the original system. There are no more locks and keys anymore.

      - "chosen" tasks will always spawn. For example, the default forest biomes.
	  - "optional" tasks will be picked randomly.
	   (The number of optional tasks is set by the config parameter "InfusedWorldsRandomOptionalBiomes") 

      - "inside" tasks will spawn close to the center of the map. They should be the most interesting and less dangerous tasks.
	  - "outside" will spawn on the edge or fill if there is still room in the center.

  2) There are lists to control which tasks are in these categories, for example:
          chosen_tasks_inside, optional_tasks_outside etc.
		  
     You can perfectly edit these lists if you know what you're doing.

  3) A taskset will then be built using these lists.
  
]]
------- Default tasks ------------------

	local chosen_tasks_default = {
		"Make a pick",	-- this task is the starting one, it is advised not to remove it
		"Dig that rock",
		"Great Plains",
		"Squeltch",
		"Beeeees!",
		"Forest hunters",
		"Badlands",
		"For a nice walk",
		"Lightning Bluff"
	}
	
	if pigking_task then
		table.insert(chosen_tasks_default,pigking_task)
	end
	
	-- INSIDE --
	-- Tasks that will always be selected and spawn near the center of the map
	local chosen_tasks_inside = {}
	
	-- OUTSIDE --
	-- Tasks that will be added to default list but with a special lock
	-- making them less likely to be placed in the center
	local chosen_tasks_outside = {}
	
	if cave_tasks_enabled then
		table.insert(chosen_tasks_inside,  "MudWorld")
		table.insert(chosen_tasks_inside,  "MudCave")
	end
	
	if multi_tasks_enabled then
		if multi_tasks_gray_enabled then
			table.insert(chosen_tasks_inside,  "Grayness four a")
			table.insert(chosen_tasks_inside,  "Grayness two b")
			table.insert(chosen_tasks_inside,  "Grayness four b")
			if mGetModConfigData("MultiTasksGrayEnabled") > 3 then
				table.insert(chosen_tasks_inside,  "Grayness one")
			end
		end
		if multi_tasks_slimey_enabled then
			table.insert(chosen_tasks_inside,  "Slimey two b")
			table.insert(chosen_tasks_inside,  "Slimey three b")
			table.insert(chosen_tasks_inside,  "Slimey four b")
			megarandom_setpieces["WormTrap"] = { count=1,tasks={"Slimey two b","Slimey three b","Slimey four b","Speak to the king slimey"}}
		end
		if multi_tasks_beaver_enabled then
			table.insert(chosen_tasks_inside,  "Water two b")
			local beaver_rate = mGetModConfigData("MultiTasksBeaverEnabled")
			if beaver_rate > 4 then
				table.insert(chosen_tasks_inside, "Water two a")
				
				if math.random() < 0.5 then
					table.insert(chosen_tasks_inside, "Water three a")
				else
					table.insert(chosen_tasks_inside, "Water three e")
				end
			end
		end
		if multi_tasks_jungle_enabled then
			table.insert(chosen_tasks_inside,  "Old water two c")
		end
		if multi_tasks_beach_enabled then
			table.insert(chosen_tasks_inside,  "Water three d")
		end
		if multi_tasks_cute_enabled then
			table.insert(chosen_tasks_inside,  "Cuteness three c")
			table.insert(chosen_tasks_inside,  "Cuteness four d") -- pirate bunny beach TODO
			
			megarandom_setpieces["TrapRabbitMeat"] = {count = 1, tasks={"Cuteness three c","Cuteness four d","Cuteness two c","Multi one a"}}
			
			--table.insert(chosen_tasks_inside,  "Cuteness two c")
			if mGetModConfigData("MultiTasksCuteEnabled") > 4 then
				table.insert(chosen_tasks_outside, "Multi one a")
				megarandom_setpieces["BunnymanFarmers"] = {count = 1, tasks={"Cuteness three c","Cuteness four d","Cuteness two c","Multi one a"}}
				AddRoomPreInit("MultiHerds",function(room) 
					if not room.contents.countprefabs then room.contents.countprefabs = {} end
					room.contents.countprefabs.bunneefalo = 2
				end)
			end
		end
		if multi_tasks_snow_enabled then
			table.insert(chosen_tasks_inside,  "Custom Snowy two b")
		end
		
		if multi_tasks_fire_enabled then
			table.insert(chosen_tasks_outside,"Custom fire four b")
			table.insert(chosen_tasks_outside,"Custom fire two c")
		end
		
		if multi_tasks_chezz_enabled then
			table.insert(chosen_tasks_outside,  "Chezzness three c")
			if mGetModConfigData("MultiTasksChezzEnabled") > 4 then
				
				table.insert(chosen_tasks_outside,  "Chezzness three a")
				table.insert(chosen_tasks_outside,  "Chezzness three b")
			end
		end

	end
	
	-- DEBUG
	if GetModConfigData("InfusedWorldsRandomOptionalBiomes") < 5 then
		table.insert(chosen_tasks_inside,  "DEBUGTASK")
	end
	
	
	if GetModConfigData("RandomOptionalRuins") > 0 then
		table.insert(chosen_tasks_outside,  "Sacred")
	end
	
	if cave_tasks_enabled then
		table.insert(chosen_tasks_outside,  "MudLights")
		table.insert(chosen_tasks_outside,  "MyRockyLand")
		table.insert(chosen_tasks_outside,  "SpillagmiteCaverns")
		table.insert(chosen_tasks_outside,  "MyBigBatCave")
		table.insert(chosen_tasks_outside,  "MudPit")
		table.insert(chosen_tasks_outside,  "ToadStoolTask1")
			
		-- Choose 2 types of mushroom forests
		if math.random() < 0.34 then
			table.insert(chosen_tasks_outside,"RedForest")
			table.insert(chosen_tasks_outside,"GreenForest")
		else
		if math.random() < 0.5 then
			table.insert(chosen_tasks_outside,"RedForest")
			table.insert(chosen_tasks_outside,"BlueForest")
		else
			table.insert(chosen_tasks_outside,"BlueForest")
			table.insert(chosen_tasks_outside,"GreenForest")
		end
		end
	end
	
	-- OPTIONAL TASKS, INSIDE --
	
	local optional_tasks_inside = {
		-- 5 tasks will be put inside randomly, see code below
	}
	
	-- BONUS FOREST BIOMES --
	local bonus_forest_biomes = {}
				bonus_forest_biomes[1] = "Befriend the pigs"
				bonus_forest_biomes[2] = "Kill the spiders"
				bonus_forest_biomes[3] = "Killer bees!"
				bonus_forest_biomes[4] = "Make a Beehat"
				bonus_forest_biomes[5] = "The hunters"
				bonus_forest_biomes[6] = "Magic meadow"
				bonus_forest_biomes[7] = "Frogs and bugs"
				bonus_forest_biomes[8] = "Oasis"
				bonus_forest_biomes[9] = "Mole Colony Deciduous"
				bonus_forest_biomes[10] = "Mole Colony Rocks"
				bonus_forest_biomes[11] = "MooseBreedingTask"
	local is_bonus_forest_biome = {}  -- useful for later
	for _,biome in pairs(bonus_forest_biomes) do
		is_bonus_forest_biome[biome] = 1
	end
				
	local nbonus_forest_biomes=GetModConfigData("RandomOptionalForests")
	
	if nbonus_forest_biomes >= 0 then
	
		-- optional tasks that should be more likely than others
		local optional_tasks_likely = bonus_forest_biomes
		
		local use_vanilla_generation=(nbonus_forest_biomes == 1.42)
		
		
		-- 5 of them are selected directly, others are put with optional tasks
		mychose = math.max(nbonus_forest_biomes,5)
		if use_vanilla_generation then
			print("[Megarandom] Forest biomes: Using vanilla generation")
		else 
			local str=""
			if nbonus_forest_biomes == 0 then
				str=" optional"
			end
			print("[Megarandom] Forest biomes: spawning ",mychose,str," bonus biomes")
		end
		myselected = {}
		ntries = 0
		--assert(mychose <= #optional_tasks_likely, "Internal mod error.")
		for i=1,#optional_tasks_likely do
			myselected[i] = false
		end
		for i=1,mychose do
			local the_chosen_one=math.random(#optional_tasks_likely)
			while myselected[the_chosen_one] and ntries <= 1000 do
				the_chosen_one=math.random(#optional_tasks_likely)
				ntries=ntries+1
			end
			myselected[the_chosen_one] = true
		end
		for i=1,#optional_tasks_likely do
			if myselected[i] then
				if nbonus_forest_biomes > 0 then
					print("[Megarandom] Choosing ", optional_tasks_likely[i])
					table.insert(chosen_tasks_inside,optional_tasks_likely[i])
				else
					print("[Megarandom] Optional ", optional_tasks_likely[i])
					table.insert(optional_tasks_inside,optional_tasks_likely[i])
				end
			else
				if not use_vanilla_generation and nbonus_forest_biomes > 0 then
					print("[Megarandom] Optional ", optional_tasks_likely[i])
					table.insert(optional_tasks_inside,optional_tasks_likely[i])
				end
			end
		end
	end
	
	
	-- OPTIONAL TASKS, OUTSIDE --
	
	local optional_tasks_outside = {
	
		-- some tasks will be put here later
	
	}
	
	local optional_tasks_outside_cave = {
	-- Other Optional Cave Tasks
			"MySwampySinkhole",
			"CaveSwamp",
			"MyUndergroundForest",
--			"PleasantSinkhole", -- removed, it is a boring biome
--			"FungalNoiseForest",
--			"FungalNoiseMeadow",
			"BatCloister",
			"RabbitTown",
			"RabbitCity",
			"SpiderLand",
			"RabbitSpiderWar",
			
-- Exit caves
--			"CaveExitTask1",
--			"CaveExitTask2",
--			"ToadStoolTask2",
--			"CaveExitTask3",
--			"CaveExitTask4",
--			"CaveExitTask5",
--			"CaveExitTask6",
--			"CaveExitTask7",
--			"CaveExitTask8",
--			"CaveExitTask9",
--			"CaveExitTask10",
--			"ToadStoolTask3",

-- Ruins will be added just below
	--	"MoreAltars",
	--	"CaveJungle",
	--	"SacredDanger",
--	--	"MilitaryPits",
	--	"MuddySacred",
	--	"Residential2",
	--	"Residential3",
	--	"LichenLand",
	--	"Residential",
--	--	"Military",		-- bugged terrain TODO
	--	"TheLabyrinth", -- bugged terrain
	--	"SacredAltar",
	--	"AtriumMaze", -- should maybe be disabled for megarandom mod, causes too many restarts
	--	"InfusedWorld_MinotaurHome",
		

	}
	
	if cave_tasks_enabled then
		for i=1,#optional_tasks_outside_cave do
			table.insert(optional_tasks_outside,optional_tasks_outside_cave[i])
		end
	end
	
	if multi_tasks_enabled then
		if multi_tasks_gray_enabled then
		--table.insert(optional_tasks_outside,"Speak to the king gray")
		end
		if multi_tasks_cute_enabled then
		--table.insert(optional_tasks_outside,"Custom Speak to the king cute")
		end
	end
	
	-- pig kings tasks
	print("[Megarandom] Placing "..nkings.." Multi-Worlds kings.")
	local choose_one = function(list)
		local n=#list
		i = math.random(1,n)
		elem = list[i]
		list[i] = list[n]
		list[n] = nil
		return elem
	end
	local n=0
	while n<nkings do
		local king = choose_one(multi_worlds_pigtasks)
		if n == 0 then
			table.insert(chosen_tasks_inside,king)
			print("inside  ->",king)
		else
			table.insert(chosen_tasks_outside,king)
			print("outside ->",king)
		end
		n=n+1
	end
	
	
	-- Ruins
	if GetModConfigData("RandomOptionalRuins") > 0 then
	local ruins_optional_tasks = {
		"MoreAltars",
		"CaveJungle",
		"SacredDanger",
--		"MilitaryPits",
		"MuddySacred",
		"Residential2",
		"Residential3",
		"LichenLand",
		"Residential",
--		"Military",		-- bugged terrain TODO
--		"TheLabyrinth", -- bugged terrain, disabled for the moment :(
		"SacredAltar",
--		"AtriumMaze", -- should maybe be disabled for megarandom mod, causes too many restarts
--		"InfusedWorld_MinotaurHome",
	}
	
	if GetModConfigData("RandomOptionalRuins") > 0.99 then
	
		GLOBAL.GROUND.FAKE_GROUND = GLOBAL.GROUND.CARPET
		table.insert(chosen_tasks_outside,  "AtriumMaze")
		table.insert(chosen_tasks_outside,  "InfusedWorld_MinotaurHome")
--		table.insert(optional_tasks_outside,  "TheLabyrinth")
	elseif GetModConfigData("RandomOptionalRuins") > 0 then
		if GetModConfigData("AncientGuardianSpawn") > 0.5 then
			table.insert(chosen_tasks_outside,  "InfusedWorld_MinotaurHome")
		elseif GetModConfigData("AncientGuardianSpawn") > 0.0 then
			table.insert(optional_tasks_outside,  "InfusedWorld_MinotaurHome")
		end
	end
	
	for i=1,#ruins_optional_tasks do
		if math.random() < GetModConfigData("RandomOptionalRuins") then
			table.insert(optional_tasks_outside,ruins_optional_tasks[i])
			--print("Inserted ruin "..ruins_optional_tasks[i])
		end
	end
	end
	
--------------------------------------------------------------------------
------ World generation 3:  Generate taskset.                    ---------
--------------------------------------------------------------------------
	
-- Add special lock to the outside tasks
-- The lock will be used by a function in storygen.lua to
-- make this task less likely to be placed in the center.
if GetModConfigData("ForceOutsideTasksOutside") and GetModConfigData("WorldShape") > 0 then
function add_outside_lock(task)
	--print("[Megarandom] Task ", task.id, " added to outside tasks")
	table.insert(task.locks,LOCKS.HARD) -- I chose to use this lock name arbitrarily	
end
else
function add_outside_lock(task)
	--print("[Megarandom] Task ", task.id, " added to outside tasks")
	task.locks = {LOCKS.HARD} -- I chose to use this lock name arbitrarily	
end
end
for i, task in ipairs(chosen_tasks_outside) do
	AddTaskPreInit(task, add_outside_lock)
end
for i, task in ipairs(optional_tasks_outside) do
	AddTaskPreInit(task, add_outside_lock)
end
	
-- Create task set

local tasks_mandatory=concat(concat(chosen_tasks_default,chosen_tasks_inside),chosen_tasks_outside)

--[[
AddTaskSet("Multifused",	{
        name="Multifused",
		location = "forest",
		tasks = tasks_mandatory,
		numoptionaltasks = GetModConfigData("InfusedWorldsRandomOptionalBiomes"),
		valid_start_tasks = {
			"Make a pick",
			},
-- Other Optional Tasks
		optionaltasks = concat(optional_tasks_inside,optional_tasks_outside),
-- Set Pieces
		set_pieces = megarandom_setpieces,
	}
)
]]--
--[[
AddLevel(LEVELTYPE.SURVIVAL, { 
		id = "MEGARANDOM",
		name = "Megarandom",
		desc = "A mix of forest, caves, and multiland biomes",
		location = "forest",
		version = 2,
		overrides = {
			task_set = "Multifused",
		},		
	})
((]]
	

	--	tasks = tasks_mandatory,
	--	numoptionaltasks = GetModConfigData("InfusedWorldsRandomOptionalBiomes"),
	--	optionaltasks
	--	set_pieces = megarandom_setpieces,

	local megarandom_tasks = tasks_mandatory
	local megarandom_optional_tasks = concat(optional_tasks_inside,optional_tasks_outside)

	local megarandom_optional_setpieces = {}
	
function print_table(t,str)
	if str then print(str) end
	for k,v in pairs(t) do
	print(k,":",v)
	end
end
function megarandomize_tasks(level)

	local tasks = level.tasks
	local optionaltasks = level.optionaltasks
	local ntasks=0
	local noptionaltasks=0
	
	local tasks_set = {}
	local optionaltasks_set = {}
	
	if debug_taskchoice then
	print_table(tasks,"original tasks")
	print_table(optionaltasks,"original optional tasks")
	
	print_table(megarandom_tasks,"megarandom tasks")
	print_table(megarandom_optional_tasks,"megarandom optional tasks")
	end
	
	for _,task in pairs(tasks) do
		if not is_bonus_forest_biome[task] then
			tasks_set[task] = 2
		else
			print("[Megarandom-d] Removed task '"..task.."' from level tasks: is bonus forest biome.")
		end
	end
	for _,task in pairs(optionaltasks) do
		if not is_bonus_forest_biome[task] then
			optionaltasks_set[task] = 2
		else
			print("[Megarandom-d] Removed task '"..task.."' from level optional tasks: is bonus forest biome.")
		end
	end
	
	for _,task in pairs(megarandom_tasks) do
		if tasks_set[task] then
			-- skip the task
			tasks_set[task] = 1
			if debug_taskchoice then
			print("[Megarandom-d] There was already a task named '"..task.."' in level tasks.")
			end
		elseif optionaltasks_set[task] then
			-- move to normal tasks
			tasks_set[task] = 1
			optionaltasks_set[task] = nil
			if debug_taskchoice then
			print("[Megarandom-d] There was already a task named '"..task.."' in level optionaltasks.")
			end
		else
			-- insert task
			tasks_set[task] = 1
			if debug_taskchoice then
			print("[Megarandom-d] Inserting Megarandom task '"..task.."' in level tasks.")
			end
		end
	end
	
	for _,task in pairs(megarandom_optional_tasks) do
		if tasks_set[task] then
			tasks_set[task] = 1
			-- skip the task
			if debug_taskchoice then
			print("[Megarandom-d] There was already a task named '"..task.."' in level tasks.")
			end
		elseif optionaltasks_set[task] then
			-- skip
			optionaltasks_set[task] = 1
			if debug_taskchoice then
			print("[Megarandom-d] There was already a task named '"..task.."' in level optionaltasks.")
			end
		else
			-- insert task
			optionaltasks_set[task] = 1
		end
	end
	
	--debug
	for task,v in pairs(tasks_set) do
		if v ~= 1 then
			if megarandom_tasks_to_remove[task] then
			print("[Megarandom-d] Removed task '"..task.."' from level tasks.")
			tasks_set[task] = nil
			else
			print("[Megarandom-d] Found unknown task '"..task.."' in level tasks.")
			end
		end
	end
	for task,v in pairs(optionaltasks_set) do
		if v ~= 1 then
			print("[Megarandom-d] Found unknown task '"..task.."' in level optional tasks.")
		end
	end
	
	local new_tasks = {}
	local new_optionaltasks = {}
	
	print("[Megarandom-d] ------------------------------------------ ")
	print("[Megarandom-d] New tasks:")
	for task,_ in pairs(tasks_set) do
		table.insert(new_tasks,task)
		ntasks=ntasks+1
		print("[Megarandom-d]",task)
	end
	print("[Megarandom-d] New optional tasks:")
	for task,_ in pairs(optionaltasks_set) do
		table.insert(new_optionaltasks,task)
		noptionaltasks=noptionaltasks+1
		print("[Megarandom-d]",task)
	end
	
	level.tasks = new_tasks
	level.optionaltasks = new_optionaltasks
	level.numoptionaltasks = GetModConfigData("InfusedWorldsRandomOptionalBiomes")

	if debug_taskchoice then
	print_table(level.tasks,"new tasks")
	print_table(level.optionaltasks,"new optional tasks")
	end

	if false and volcano_mod_enabled and GetModConfigData("VolcanoRandomOceanBiomes") > 0 then	
		print("[Megarandom] Volcano biome is enabled, reducing number of tasks.")
		level.numoptionaltasks = level.numoptionaltasks - 4
	end
	print("[Megarandom-d] Setting number of optional tasks to "..level.numoptionaltasks)
	
end


function megarandomize_setpieces(level)
	local setpieces = level.set_pieces
	local optionalsetpieces = level.random_set_pieces
	local n=0
	
	if false then
	
		print_table(setpieces,"original set pieces")
		print_table(optionalsetpieces,"original optional set pieces")
	
		print_table(megarandom_setpieces,"megarandom set pieces")
		print_table(megarandom_optional_setpieces,"megarandom optional set pieces")
	end
	
	-- debug
	for setpiece,v in pairs(setpieces) do
		if not megarandom_setpieces[setpiece] and not megarandom_optional_setpieces[setpiece] then
			print("[Megarandom-d] Will megarandomize unknown setpiece '"..setpiece.."' in level setpieces.")
		end
	end
	for k,setpiece in pairs(optionalsetpieces) do
		if not megarandom_setpieces[setpiece] and not megarandom_optional_setpieces[setpiece] then
			print("[Megarandom-d] Will megarandomize unknown setpiece '"..setpiece.."' in level optionalsetpieces.")
		end
	end
	
	for setpiece,v in pairs(megarandom_setpieces) do
		if setpieces[setpiece] then
			-- overwrite the setpiece
			if debug_taskchoice then
				print("[Megarandom-d] There was already a setpiece named '"..setpiece.."' in level setpieces.")
			end
			setpieces[setpiece] = v
		--elseif optionalsetpieces[setpiece] then
		--	ignore this case	
			-- move to normal setpieces
		--	setpieces[setpiece] = v
		--	optionalsetpieces[setpiece] = nil
		--	print("[Megarandom-d] There was already a setpiece named '"..setpiece.."' in level optionalsetpieces.")
		else
			-- insert setpiece
			setpieces[setpiece] = v
		end
	end
	
	-- TODO do something with optional set pieces
	
	if debug_taskchoice then
	print_table(level.set_pieces,"new set pieces")
	print_table(level.random_set_pieces,"new optional set pieces")
	end
	
end
	

local warningfile = "megarandom_globals.txt"
local write_warnings = function(mw,ml)
	file = GLOBAL.io.open(warningfile,"w")
	file:write(mw..ml)
	file:close()
end
write_warnings(0,0)

--AddLevelPreInit("SURVIVAL_TOGETHER",
AddLevelPreInitAny(
	function(level)
	
		level.megarandom = {}
		
		if not level.central_tasks then
			level.central_tasks = {}
		end
		if not level.ignore_tasks then
			level.ignore_tasks = {}
		end
		
		if level.location ~= "forest" then
            return
        end
		
		megarandomize_tasks(level)
		megarandomize_setpieces(level)
		--TODO
		
		
		
		
		--Volcano biome
		if volcano_mod_enabled then
			modimport("scripts/volcano/moredragoons")
		end
		if false and volcano_mod_enabled then
			
			local insert_volcano_biomes = require "volcano/insert_volcano_tasks"
			insert_volcano_biomes(level)
			
			-- centralize ocean
			if GetModConfigData("VolcanoCenterOcean") and GetModConfigData("VolcanoRandomOceanBiomes") > 0 then
			
				
				level.megarandom.volcano_central_ocean = true
				
				local chosen_ocean_tasks = {
			-- old volcano
			--[[			"WATER_CORAL_TASK_FOREST",
						"WATER_DEEP_TASK_FOREST",
						"WATER_MEDIUM_TASK_FOREST",
						"WATER_MEDIUM1_TASK_FOREST",
						"WATER_SHALLOW_TASK_FOREST",
						"WATER_SHALLOW1_TASK_FOREST",
						"WATER_SHALLOW2_TASK_FOREST",
						"MANGROVE_TASK_FOREST",
						"MANGROVE_TASK_FOREST2",
						"MANGROVE_TASK_FOREST3",
			--]]
					-- CORAL
					"MILHA_0",
					-- DEEP
					"MILHA_413",
					-- DEEP, KRAKEN
					"MILHA_44112",
					-- MEDIUM
					"MILHA_1",
					"MILHA_311",
					-- OCTOPUS
					"MILHA_4113",
					-- SHALLOW
					"MILHA_411",
					"MILHA_12",
					"MILHA_13",
					-- MANGROVE
					"MILHA_02",
					"MILHA_111",
					"MILHA_0002",
					"BEACH_TASK_FOREST",
				}
				
				for _,water_task in ipairs(chosen_ocean_tasks) do
					table.insert(level.tasks, water_task)
				end

				level.central_tasks = concat(level.central_tasks,
						chosen_ocean_tasks
				)
				
				
				print("Debug central tasks:")
				for _,task in ipairs(level.central_tasks) do
					print(task)
				end
			end
			
			-- ignore some ocean tasks
			if GetModConfigData("VolcanoRandomOceanBiomes") < 1 then
				for _,task in ipairs(
					{
						--[[ OLD VOLCANO
						"WATER_MEDIUM2_TASK_FOREST",
						"WATER_MEDIUM3_TASK_FOREST",
						"WATER_MEDIUM4_TASK_FOREST",
						"WATER_MEDIUM5_TASK_FOREST",
						
						"WATER_SHALLOW3_TASK_FOREST",
						"WATER_SHALLOW4_TASK_FOREST",
						"WATER_SHALLOW5_TASK_FOREST",
						"WATER_SHALLOW6_TASK_FOREST",
						"WATER_SHALLOW7_TASK_FOREST",
						"WATER_SHALLOW8_TASK_FOREST",
						
						"WATER_DEEP2_TASK_FOREST",
						"WATER_DEEP1_TASK_FOREST",
						]]--
						
						"MILHA_3",
						"MILHA_01",
						"MILHA_031",
						"MILHA_33",
						"MILHA_212",
						"MILHA_213",
						"MILHA_11",
						"MILHA_0003",
						"MILHA_1111",
						"MILHA_1112",
						"MILHA_1113",
						"MILHA_2112",
						"MILHA_2113",
						"MILHA_00003",
						"MILHA_11112",
						
				}) do
					level.ignore_tasks[task] = true
				end
			end
		
			
			if GetModConfigData("VolcanoBeachStart") then
				level.overrides.start_location = "beachstart"
			end
			
		end
		-- warning management
		local megarandom_show_multiland_warning = 0
		if level.overrides and level.overrides.task_set == "multi" then
			megarandom_show_multiland_warning = 1
		end
		--TODO debug
        level.overrides.keep_disconnected_tiles = true
		
		write_warnings(megarandom_show_mw_warning,megarandom_show_multiland_warning)
	end)


