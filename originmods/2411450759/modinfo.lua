-- This information tells other players more about the mod
name = "Amelia Watson"
description = [[
󰀨 HololiveEN: Amelia Watson 󰀨

Stats:
	󰀍 150 󰀎 150 󰀓 200

Perks:
	󰀏 Is a time traveller
	󰀙 Has special ground pounding move
	󰀃 Bubba is here with her

There is a config if you want to change her perks and other stats

Join Teamates! here 󰀖:
"https://www.youtube.com/channel/UCyl1z3jo3XHR1riLFKG5UAg"
		]]
author = "ZeroRyuk, Frambo, CoolChilli"
version = "1.2.4"

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

-- Compatible with Don't Starve Together
dst_compatible = true

-- Not compatible with Don't Starve
dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

-- Character mods are required by all clients
all_clients_require_mod = true 

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = {
"character",
"animation",
"amelia",
}

local function Title(title)
    return {
        name=title,
        hover = "",
        options={{description = "", data = 0}},
        default = 0,
        }
end
local sounds = {'walter', 'warly', 'wathgrithr', 'waxwell', 'webber', 'wendy', 'wickerbottom', 'willow', 'wilson', 'winnie', 'winona', 'wolfgang', 'woodie', 'wortox', 'wurt', 'wx78'}
local soundOptions = {}
for i = 1, #sounds, 1 do
		soundOptions[i] = {description=sounds[i],data=sounds[i]}
end
local keys = {"A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","F1","F2","F3","F4","F5","F6","F7","F8","F9","F10","F11","F12","LAlt","RAlt","LCtrl","RCtrl","LShift","RShift","Tab","Capslock","Space","Minus","Equals","Backspace","Insert","Home","Delete","End","Pageup","Pagedown","Print","Scrollock","Pause","Period","Slash","Semicolon","Leftbracket","Rightbracket","Backslash","Up","Down"}
local keylist = {}
local string = ""
for i = 1, #keys do
	if keys[i] == "G" then
		keylist[i] = {description = keys[i].." (Default)", data = "KEY_"..string.upper(keys[i])}
	else
		keylist[i] = {description = keys[i], data = "KEY_"..string.upper(keys[i])}
	end
end
local groundPoundCost = {}
for i = 0, 100, 10 do
	if groundPoundCost[i] == 30 then
		groundPoundCost[i] = {description = groundPoundCost[i].." (Default)", data = i}
	else
		groundPoundCost[i] = {description = groundPoundCost[i], data = i}
	end
end

configuration_options = {
    Title("Basic Stats"),
    {
		name = "amelia_health",
		label = "Health 󰀍",
		hover = "How much health Amelia has?",
		options =	
		{
			{description = "50", data = 50},
			{description = "75", data = 75},
			{description = "100", data = 100},
			{description = "125", data = 125},
			{description = "150 (Default)", data = 150},
			{description = "175", data = 175},
			{description = "200", data = 200},
			{description = "225", data = 225},
			{description = "250", data = 250},
			{description = "275", data = 275},
			{description = "300", data = 300},
		},
		default = 150,
	},
	{
		name = "amelia_hunger",
		label = "Hunger 󰀎",
		hover = "How much hunger Amelia has?",
		options =	
		{
			{description = "50", data = 50},
			{description = "75", data = 75},
			{description = "100", data = 100},
			{description = "125", data = 125},
			{description = "150 (Default)", data = 150},
			{description = "175", data = 175},
			{description = "200 ", data = 200},
			{description = "225", data = 225},
			{description = "250", data = 250},
			{description = "275", data = 275},
			{description = "300", data = 300},
		},
		default = 150,
	},
	{
		name = "amelia_sanity",
		label = "Sanity 󰀓",
		hover = "How much sanity Amelia has?",
		options =	
		{
			{description = "50", data = 50},
			{description = "75", data = 75},
			{description = "100", data = 100},
			{description = "125", data = 125},
			{description = "150", data = 150},
			{description = "175", data = 175},
			{description = "200 (Default)", data = 200},
			{description = "225", data = 225},
			{description = "250", data = 250},
			{description = "275", data = 275},
			{description = "300", data = 300},
		},
		default = 200,
	},
	{
		name = "amelia_hunger_rate",
		label = "Hunger Rate",
		hover = "How long Amelia takes to get hungry?",
		options =	
		{
			{description = "x0.1", data = 0.1},
			{description = "x0.2", data = 0.2},
			{description = "x0.3", data = 0.3},
			{description = "x0.4", data = 0.4},
			{description = "x0.5", data = 0.5},
			{description = "x0.6", data = 0.6},
			{description = "x0.7", data = 0.7},
			{description = "x0.8", data = 0.8},
			{description = "x0.9", data = 0.9},
			{description = "x1 (Default)", data = 1},
			{description = "x1.1", data = 1.1},
			{description = "x1.25", data = 1.25},
			{description = "x1.5", data = 1.5},
			{description = "x1.75", data = 1.75},
			{description = "x2", data = 2},
			{description = "x3", data = 3},
			{description = "x4", data = 4},
			{description = "x5", data = 5},
		},
		default = 1,	
	},
	{
		name = "amelia_speed",
		label = "Movement Speed",
		hover = "How fast Amelia can run?",
		options =	
		{
			{description = "x0.1", data = 0.1},
			{description = "x0.2", data = 0.2},
			{description = "x0.3", data = 0.3},
			{description = "x0.4", data = 0.4},
			{description = "x0.5", data = 0.5},
			{description = "x0.6", data = 0.6},
			{description = "x0.7", data = 0.7},
			{description = "x0.8", data = 0.8},
			{description = "x0.9", data = 0.9},
			{description = "x1", data = 1},
			{description = "x1.1 (Default)", data = 1.1, hover="She's zoomer!"},
			{description = "x1.25", data = 1.25},
			{description = "x1.5", data = 1.5},
			{description = "x1.75", data = 1.75},
			{description = "x2", data = 2},
			{description = "x3", data = 3},
			{description = "x4", data = 4},
			{description = "x5", data = 5},
		},
		default = 1.1,	
	},
	{
		name = "amelia_dmg",
		label = "Damage Multiplier",
		hover = "Amelia's attack damage multiplier.",
		options =	
		{
			{description = "x0.1", data = 0.1},
			{description = "x0.2", data = 0.2},
			{description = "x0.3", data = 0.3},
			{description = "x0.4", data = 0.4},
			{description = "x0.5", data = 0.5},
			{description = "x0.6", data = 0.6},
			{description = "x0.7", data = 0.7},
			{description = "x0.8", data = 0.8},
			{description = "x0.9", data = 0.9},
			{description = "x1 (Default)", data = 1},
			{description = "x1.1", data = 1.1},
			{description = "x1.25", data = 1.25},
			{description = "x1.5", data = 1.5},
			{description = "x1.75", data = 1.75},
			{description = "x2", data = 2},
			{description = "x3", data = 3},
			{description = "x4", data = 4},
			{description = "x5", data = 5},
		},
		default = 1,
	},
	Title(""),
	Title("Timeleap"),
	{
		name = "amelia_watch_recipe",
		label = "Time Traveller's Watch Recipe",
		hover = "How expensive is the watch?",
		options =	
		{
			{description = "Cheap", data = 0, hover = " 5 Salt Crystals + 2 Gold Nuggets + 2 Nightmare Fuels"},
			{description = "Regular (Default)", data = 1, hover = " 5 Salt Crystals + 2 Electrical Doodads + 3 Nightmare Fuels"},
			{description = "Expensive", data = 2, hover = " 7 Salt Crystals + 3 Electrical Doodads + 5 Nightmare Fuels"},
		},
		default = 1,
	},
	{
		name = "amelia_watch_timeleap_secs",
		label = "Timeleap's Rollback Seconds",
		hover = "How far in the past the timeleap will take Amelia back?",
		options =	
		{
			{description = "3 seconds", data = 3},
			{description = "4 seconds", data = 4},
			{description = "5 seconds (Default)", data = 5},
			{description = "6 seconds", data = 6},
			{description = "7 seconds", data = 7},
			{description = "8 seconds", data = 8},
			{description = "9 seconds", data = 9},
			{description = "10 seconds", data = 10},
		},
		default = 5,
	},
	{
		name = "amelia_watch_max_uses",
		label = "Timeleap Uses Per Watch",
		hover = "How many times Amelia could use timeleap per watch?",
		options =	
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3 (Default)", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
			{description = "9", data = 9},
			{description = "10", data = 10},
			{description = "Infinite", data = 9999}
		},
		default = 3,
	},
	Title(""),
	Title("Groundpound"),
	{
		name = "amelia_groundpound_key",
		label = "Groundpound HotKeys",
		hover = "What key to press to trigger groundpound?",
		options = keylist,
		default = "KEY_G",	
	},
	{
		name = "amelia_groundpound_dmg_multi",
		label = "Groundpound Damage Multiplier",
		hover = "How much damage groundpound do?",
		options =	
		{
			{description = "x0.1", data = 0},
			{description = "x0.5", data = 0.5},
			{description = "x1", data = 1},
			{description = "x1.5", data = 1.5},
			{description = "x2 (Default)", data = 2},
			{description = "x2.5", data = 2.5},
			{description = "x3", data = 3},
			{description = "x3.5", data = 3.5},
			{description = "x4", data = 4},
			{description = "x4.5", data = 4.5},
			{description = "x5", data = 5},
		},
		default = 2,
	},
	{
		name = "amelia_groundpound_radius",
		label = "Groundpound Radius",
		hover = "How large groundpound area of effect should be?",
		options =	
		{
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5 (Default)", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8", data = 8},
		},
		default = 5,
	},
	{
		name = "amelia_groundpound_hunger_cost",
		label = "Groundpound Hunger Cost",
		hover = "How much hunger does groundpound cost?",
		options = 
		{
            {description = "0", data = 0,},
			{description = "10", data = 10},
			{description = "20", data = 20},
			{description = "30 (Default)", data = 30},
			{description = "40", data = 40},
			{description = "50", data = 50},
			{description = "60", data = 60},
			{description = "70", data = 70},
			{description = "80", data = 80},
			{description = "90", data = 90},
			{description = "100", data = 100},
		},
		default = 30,
	},
	{
		name = "amelia_groundpound_destroy_structure_enabled", 
		label = "Enable Groundpound Destruction",
		hover = "Allows groundpound to destroy trees, rocks, structures and your mom?",
		options = 
		{
			{description = "ON", data = true},
			{description = "OFF (Default)", data = false},
		},
		default = false,
	},
	Title(""),
	Title("Watson Concoction"),
	{
		name = "watson_concoction_recipe",
		label = "Watson Concoction Recipe",
		hover = "How expensive is Watson concoction?",
		options =	
		{
			{description = "Regular (Default)", data = 0, hover = " 3 Salt Crystals + 1 Blue Cap + Stinger 1"},
			{description = "Expensive", data = 1, hover = " 3 Salt Crystals + 1 Moon Shroom + Stinger 1"},
		},
		default = 0,
	},
	{
		name = "watson_concoction_duration",
		label = "Concoction Buff & Debuff Duration",
		hover = "How long Watson concoction's buff and debuff last?",
		options =	
		{
			{description = "5 s", data = 5},
			{description = "10 s", data = 10},
			{description = "15 s", data = 15},
			{description = "20 s", data = 20},
			{description = "25 s (Default)", data = 25},
			{description = "30 s", data = 30},
			{description = "35 s", data = 35},
			{description = "40 s", data = 40},
			{description = "50 s", data = 50},
			{description = "60 s", data = 60},
			{description = "120 s", data = 120},
		},
		default = 25,
	},
	{
		name = "watson_concoction_filter",
		label = "Concoction's Visual Effect",
		hover = "Turn on the visuals?",
		options =	
		{
			{description = "No Filter", data = false},
			{description = "With Filter (Default)", data = true},
		},
		default = true,
	},
	Title(""),
	Title("Concoction - Buffs"),
	{
		name = "watson_concoction_attack_multiplier",
		label = "Buff's Damage Multiplier",
		hover = "How much Watson concoction increase user's attack damage?",
		options =	
		{
			{description = "x1.0 (No Change)", data = 1},
			{description = "x1.1", data = 1.1},
			{description = "x1.2", data = 1.2},
			{description = "x1.3 (Default)", data = 1.3},
			{description = "x1.4", data = 1.4},
			{description = "x1.5", data = 1.5},
			{description = "x1.7", data = 1.7},
			{description = "x2", data = 2},
			{description = "x2.5", data = 2.5},
			{description = "x3", data = 3},
		},
		default = 1.3,
	},
	{
		name = "watson_concoction_absorption_modifier",
		label = "Buff's Damage Reduction %",
		hover = "How many % of damage user received Watson concoction reduce?",
		options =	
		{
			{description = "0%", data = 0},
			{description = "10%", data = 0.1},
			{description = "20%", data = 0.2},
			{description = "30% (Default)", data = 0.3},
			{description = "40%", data = 0.4},
			{description = "50%", data = 0.5},
			{description = "60%", data = 0.6},
			{description = "70%", data = 0.7},
			{description = "80%", data = 0.8},
			{description = "90%", data = 0.9},
			{description = "100%", data = 1},
		},
		default = 0.3,
	},
	{
		name = "watson_concoction_movespeed_buff",
		label = "Buff's Movespeed Buff",
		hover = "How much Watson concoction increase user's movespeed?",
		options =	
		{
			{description = "x1.0 (No Change)", data = 1},
			{description = "x1.2", data = 1.2},
			{description = "x1.4", data = 1.4},
			{description = "x1.6 (Default)", data = 1.6},
			{description = "x1.8", data = 1.8},
			{description = "x2", data = 2},
			{description = "x2.5", data = 2.5},
			{description = "x3", data = 3},
		},
		default = 1.6,
	},
	{
		name = "watson_concoction_health_regen_amount",
		label = "Buff's Health Regen Amount",
		hover = "How much health regen Watson concoction give?",
		options =	
		{
			{description = "10", data = 10},
			{description = "20", data = 20},
			{description = "30", data = 30},
			{description = "40", data = 40},
			{description = "50", data = 50},
			{description = "60", data = 60},
			{description = "70 (Default)", data = 70},
			{description = "80", data = 80},
			{description = "90", data = 90},
			{description = "100", data = 100},
		},
		default = 70,
	},
	{
		name = "watson_concoction_sanity_regen_amount",
		label = "Buff's Sanity Regen Amount",
		hover = "How much sanity regen Watson concoction give?",
		options =	
		{
			{description = "10", data = 10},
			{description = "20", data = 20},
			{description = "30", data = 30},
			{description = "40", data = 40},
			{description = "50 (Default)", data = 50},
			{description = "60", data = 60},
			{description = "70", data = 70},
			{description = "80", data = 80},
			{description = "90", data = 90},
			{description = "100", data = 100},
		},
		default = 50,
	},
	Title(""),
	Title("Concoction - Side Effects"),
	{
		name = "watson_concoction_total_poison_dps",
		label = "Poisoning Damage Per Second",
		hover = "How much damage concoction's poison deal to user per second?",
		options =	
		{
			{description = "No Damage", data = 0},
			{description = "1/s (Default)", data = 1},
			{description = "2/s", data = 2},
			{description = "3/s", data = 3},
		},
		default = 1,
	},
	{
		name = "watson_concoction_headache_sanity_damage",
		label = "Headache Sanity Reduction",
		hover = "How much sanity reduces due to concoction's headache effect?",
		options =	
		{
			{description = "0", data = 0},
			{description = "10", data = 10},
			{description = "20", data = 20},
			{description = "30", data = 30},
			{description = "40", data = 40},
			{description = "50 (Default)", data = 50},
			{description = "60", data = 60},
			{description = "70", data = 70},
			{description = "80", data = 80},
			{description = "90", data = 90},
			{description = "100", data = 100},
		},
		default = 50,
	},
	{
		name = "watson_concoction_sweat_moisture_per_sec",
		label = "Sweating Wetness Per Second",
		hover = "How much wetness per second concoction's sweating apply on user?",
		options =	
		{
			{description = "0", data = 0},
			{description = "1/s (Default)", data = 1},
			{description = "2/s", data = 2},
			{description = "3/s", data = 3},
		},
		default = 1,
	},
	{
		name = "watson_concoction_stomachache_hunger_damage",
		label = "Stomachache Hunger Penalty",
		hover = "How much user loses hunger initially by concoction's stomachache?",
		options =	
		{
			{description = "0", data = 0},
			{description = "10", data = 10},
			{description = "20", data = 20},
			{description = "30", data = 30},
			{description = "40", data = 40},
			{description = "50 (Default)", data = 50},
			{description = "60", data = 60},
			{description = "70", data = 70},
			{description = "80", data = 80},
			{description = "90", data = 90},
			{description = "100", data = 100},
		},
		default = 50,
	},
	{
		name = "watson_concoction_stomachache_on_eat_damage",
		label = " Stomachache Damage When Eat",
		hover = "How much damage user takes when they eat while in stomachache effect?",
		options =	
		{
			{description = "0", data = 0},
			{description = "5 (Default)", data = 5},
			{description = "10", data = 10},
			{description = "15", data = 15},
			{description = "20", data = 20},
			{description = "25", data = 25},
		},
		default = 5,
	},
	{
		name = "watson_concoction_drowsiness_enable",
		label = "Enable Concoction's Drowsiness",
		hover = "Allow concoction's drowsiness?",
		options =	
		{
			{description = "No Drowsy", data = false},
			{description = "Drowsy (Default)", data = true},
		},
		default = true,
	},
	Title(""),
	Title("Bubba"),
	{
		name = "bubba_dig_enabled", 
		label = "Enable Bubba Item Digging",
		hover = "Allows Bubba to dig the ground and find items?",
		options = 
		{
			{description = "ON (Default)", data = true},
			{description = "OFF", data = false},
		},
		default = true,
	},
    {
		name = "bubba_dig_chance",
		label = "Bubba Item Digging Chance",
		hover = "Set the chance Bubba will dig the item.",
		options =	
		{
            {description = "Never", data = 0,},
			{description = "10%", data = 0.1},
			{description = "20%", data = 0.2},
			{description = "30% (Default)", data = 0.3},
			{description = "40%", data = 0.4},
			{description = "50%", data = 0.5},
			{description = "60%", data = 0.6},
			{description = "70%", data = 0.7},
			{description = "80%", data = 0.8},
			{description = "90%", data = 0.9},
			{description = "Always", data = 1},
		},
		default = 0.3,
	},
	{
		name = "bubba_dig_cooldown",
		label = "Bubba Item Digging Cooldown",
		hover = "Set the cooldown between Bubba dig chance checking.",
		options =	
		{
			{description = "5 s", data = 5},
			{description = "10 s", data = 10},
			{description = "15 s (Default)", data = 15},
			{description = "20 s", data = 20},
			{description = "25 s", data = 25},
			{description = "30 s", data = 30},
		},
		default = 15,
	},
	Title(""),
    Title("Magnifying Glass"),
	{
		name = "amelia_magnifying_glass_dur", 
		label = "Magnifying Glass' Durability",
		options = 
		{
			{description = "infinite", data = true},
			{description = "finite (Default)", data = false},
		},
		default = false,
	},
	Title(""),
    Title("Salty Gamer"),
    {
		name = "amelia_salt_droprate_attacked",
		label = "Salt Drop Chance When Attacked",
		hover = "Salt Crystal drop chance when Amelia get attacked.",
		options =	
		{
            {description = "Never", data = 0,},
			{description = "10%", data = 0.1},
			{description = "20%", data = 0.2},
			{description = "30% (Default)", data = 0.3},
			{description = "40%", data = 0.4},
			{description = "50%", data = 0.5},
			{description = "60%", data = 0.6},
			{description = "70%", data = 0.7},
			{description = "80%", data = 0.8},
			{description = "90%", data = 0.9},
			{description = "Always", data = 1},
		},
		default = 0.3,
	},
	{
		name = "amelia_sanity_penalty_on_salt",
		label = "Sanity Penalty On Salt Drops",
		hover = "How much sanity Amelia lost when she drops salt?",
		options =	
		{
			{description = "0", data = 0},
			{description = "3", data = 3},
			{description = "5", data = 5},
			{description = "7", data = 7},
			{description = "10 (Default)", data = 10},
			{description = "13", data = 13},
			{description = "15", data = 15},
			{description = "17", data = 17},
			{description = "20", data = 20},
		},
		default = 10,
	},
	{
		name = "amelia_toxic_gamer_lines_enabled", 
		label = "Toxic Gamer Dialogues",
		hover = "Allows Amelia to say salty gamer's phrases?",
		options = 
		{
			{description = "ON (Default)", data = true},
			{description = "OFF", data = false},
		},
		default = true,
	},
	Title(""),
    Title("Others"),
	{
		name = "amelia_starting", 
		label = "Starting items",
		hover = "What items should she being with?",
		options = 
		{
			{description = "Watch", data = 1},
			{description = "Watch and Concoctions", data = 2},
			{description = "Nothing", data = 3},
		},
		default = 2,
	},
	{
		name = "amelia_voice",
		label = "Character Voice",
		hover = "What voice should does she use?",
		options = soundOptions,
		default = "willow",
	},
    {
		name = "amelia_clothes", 
		label = "Hidden Ingame Armor",
		hover = "Hides your Armor/Outer Clothing and Hats",
		options = 
		{
			{description = "ON", data = true},
			{description = "OFF (Default)", data = false},
		},
		default = false,
	},
}
