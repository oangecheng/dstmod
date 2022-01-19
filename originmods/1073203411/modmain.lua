local require = GLOBAL.require
local AllRecipes = GLOBAL.AllRecipes
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local TECH = GLOBAL.TECH
local clock = GLOBAL.GetTime

local __DEBUG__ = true

PrefabFiles = {}
Assets = {
	-- Assets for recipes
	Asset("IMAGE", "images/inventoryimages/bamboo.tex" ),
	Asset("ATLAS", "images/inventoryimages/bamboo.xml" ),
}

-- GUI
Popups = require("GUI/popups")

-- Nightmare phase in overworld
modimport("scripts/caves/gameplay/overworld_nightmare")

-- Earthquakes in overworld
modimport("scripts/caves/gameplay/overworld_earthquakes")

-- Toadstool spawn
modimport("scripts/caves/gameplay/overworld_toadstool")

-- Ancient FuelWeaver spawn
modimport("scripts/caves/gameplay/ancient_fuelweaver")

-- Map reveal
modimport("scripts/others/mapreveal")



local multi_tasks_enabled = GetModConfigData("MultiTasksEnabled")
local mandraketree_enabled = GLOBAL.KnownModIndex:IsModEnabled("workshop-659459255")

local more_adventures_mod_enabled = GLOBAL.KnownModIndex:IsModEnabled("workshop-1219372069")
local greenworld_enabled = GLOBAL.KnownModIndex:IsModEnabled("workshop-1290063173")

local multiworld_enabled = GLOBAL.KnownModIndex:IsModEnabled("workshop-726432903") or GLOBAL.KnownModIndex:IsModEnabled("workshop-1237378537") or GLOBAL.KnownModIndex:IsModEnabled("workshop-1448196849")

local basement_enabled = GLOBAL.KnownModIndex:IsModEnabled("workshop-1349799880") and GetModConfigData("RandomBasementSetpiece")
if basement_enabled then
table.insert(PrefabFiles, "basement_spawner")
end


local warning_multiworldnotenabled = false
if multi_tasks_enabled and not multiworld_enabled then
	warning_multiworldnotenabled = true
	multiworld_enabled = false
end

if multiworld_enabled then
	if multiworld_tweaks_enabled and multi_tasks_enabled then
		print("[Megarandom] Applying Multi Worlds tweaks ...")
		modimport("scripts/multiworlds/gameplay/changes.lua")
	end
end




-- TODO
if GetModConfigData("ShowWorldGenWarnings") then

GLOBAL.megarandom_show_multiland_warning = false
GLOBAL.megarandom_show_mw_warning = false
GLOBAL.megarandom_internal_error = false
AddSimPostInit(function()
	if GLOBAL.TheNet:GetIsServer() then
	local warningfile = "megarandom_globals.txt"
	file = GLOBAL.io.open(warningfile,"r")
	local globalstr = file:read()
	file:close()
	
	local internal_error_detected = false
	local i = 1
	local function readbyte()
		local byte = globalstr:sub(i,i)
		i=i+1
		if byte == "0" then
			return false
		elseif byte == "1" then
			return true
		else
			internal_error_detected = true
			return false
		end
	end
	
	GLOBAL.megarandom_show_mw_warning = readbyte()
	GLOBAL.megarandom_show_multiland_warning = readbyte()
	
	GLOBAL.megarandom_internal_error = internal_error_detected
	end
end)

Popups = require("GUI/popups")

		AddPlayerPostInit(function(player) 
		
			if GLOBAL.TheNet:GetIsServer() and (GLOBAL.megarandom_show_mw_warning or GLOBAL.megarandom_show_multiland_warning or GLOBAL.megarandom_internal_error) then

			if not player.components.mypopup then
				player:AddComponent("mypopup")
				GLOBAL.assert(player.components.mypopup)
				
				if GLOBAL.megarandom_show_multiland_warning then
					warning_message = "You have selected the \"Multiland\" preset. Megarandom does NOT require a special preset anymore, and the Multiland preset will probably not do what you want. You should probably restart with the default preset."
				elseif GLOBAL.megarandom_show_mw_warning then
					warning_message = "Multi-Worlds could not be found.\nThe map has been generated without the biomes.\n\nPlease either download \"Multi-Worlds\" or disable it in Megarandom mod menu to remove this warning."
				else
					warning_message = "An unexpected error was encountered during Worldgen. Please report this message on the Megarandom mod page."
				end
				
				player:DoTaskInTime(1, function() 
					Popups.CreateChoicePopup("Megarandom - Warning",
						warning_message,
						function() end,
						function() end)
				end)
			end
			
			end
		end)
end





