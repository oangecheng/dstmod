name = "Tsunomaki Watame"
description = [[
󰀁 HololiveJP: Tsunomaki Watame 󰀁

Stats:
	󰀍 125 󰀎 200 󰀓 150

Perks:
    󰀧 Watame night fever
	󰀉 Respawn every 8 seconds
	󰀞 Growing wools

There is a config if you want to change her perks and other stats

Join Watamate here 󰀁:
"https://www.youtube.com/channel/UCqm3BQLlJfvkTsX_hvm0UmA"
]]
author = "Stalyvul3fu03, ZeroRyuk, CoolChilli"
version = "2.1.5"

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
"watame",
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

configuration_options = {
	Title(""),
	Title("Language/言語"),
	{
		name = "watame_language", 
		label = "Language settings/言語設定",
		hover = "Set language for some speechs and descriptions.",
		options =
		{
			{description = "Auto (Default)", data = "AUTO"},
			{description = "日本語", data = "JP", hover="固有パーク及びアイテムの台詞と説明のみ日本語翻訳対応"},
			{description = "中文", data = "CN", hover="僅將部分特殊對話以及道具中文化"}, -- TODO: Watiing for Corneille to translates these
			{description = "English", data = "EN"},
		},
		default = "AUTO",
	},
    Title("Basic Stats"),
    {
		name = "watame_health",
		label = "Health 󰀍",
		hover = "How much health Watame has?",
		options =	
		{
			{description = "50", data = 50},
			{description = "75", data = 75},
			{description = "100", data = 100},
			{description = "125 (Default)", data = 125},
			{description = "150", data = 150},
			{description = "175", data = 175},
			{description = "200", data = 200},
			{description = "225", data = 225},
			{description = "250", data = 250},
			{description = "275", data = 275},
			{description = "300", data = 300},
		},
		default = 125,
	},
	{
		name = "watame_hunger",
		label = "Hunger 󰀎",
		hover = "How much hunger Watame has?",
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
		name = "watame_sanity",
		label = "Sanity 󰀓",
		hover = "How much sanity Watame has?",
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
		name = "watame_hunger_rate",
		label = "Hunger Rate",
		hover = "How long Watame takes to get hungry?",
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
		name = "watame_speed",
		label = "Movement Speed",
		hover = "How fast Watame can run?",
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
		name = "watame_dmg",
		label = "Damage Multiplier",
		hover = "Watame's attack damage multiplier.",
		options =	
		{
			{description = "x0.1", data = 0.1},
			{description = "x0.2", data = 0.2},
			{description = "x0.3", data = 0.3},
			{description = "x0.4", data = 0.4},
			{description = "x0.5", data = 0.5},
			{description = "x0.6", data = 0.6},
			{description = "x0.7", data = 0.7},
			{description = "x0.8 (Default)", data = 0.8, hover="Yasasheep"},
			{description = "x0.9", data = 0.9},
			{description = "x1", data = 1},
			{description = "x1.1", data = 1.1},
			{description = "x1.25", data = 1.25},
			{description = "x1.5", data = 1.5},
			{description = "x1.75", data = 1.75},
			{description = "x2", data = 2},
			{description = "x3", data = 3},
			{description = "x4", data = 4},
			{description = "x5", data = 5},
		},
		default = 0.8,
	},
	Title(""),
	Title("Auto Respawn"),
	{
		name = "watame_auto_respawn_delay",
		label = "Auto Respawn Delay",
		hover = "How many seconds after death before Watame auto-respawn?",
		options =	
		{
			{description = "1", data = 1},
			{description = "2", data = 2},
			{description = "3", data = 3},
			{description = "4", data = 4},
			{description = "5", data = 5},
			{description = "6", data = 6},
			{description = "7", data = 7},
			{description = "8 (Default)", data = 8, hover="According to meme"},
			{description = "9", data = 9},
			{description = "10", data = 10},
			{description = "11", data = 11},
			{description = "12", data = 12},
			{description = "13", data = 13},
			{description = "14", data = 14},
			{description = "15", data = 15},
		},
		default = 8,
	},
    {
		name = "watame_auto_respawn_frequency",
		label = "Auto Respawn Frequency",
		hover = "How often Watame get her chance to auto-respawn?",
		options =	
		{
			{description = "1", data = 1, hover="Always auto-respawn"},
			{description = "2 (Default)", data = 2, hover="Once every 2 deaths"},
			{description = "3", data = 3, hover="Once every 3 deaths"},
			{description = "4", data = 4, hover="Once every 4 deaths"},
			{description = "5", data = 5, hover="Once every 5 deaths"},
		},
		default = 2,
	},
    {
		name = "enable_watame_auto_respawn", 
		label = "Enable Auto Respawn",
		hover = "Allows Watame to auto-respawn?",
		options = 
		{
			{description = "Enable (Default)", data = true},
			{description = "Disable", data = false},
		},
		default = true,
	},
	Title(""),
	Title("Watame Shogun Helm"),
	{
		name = "watame_shogun_atk_buff",
		label = "Watame Shogun Helm Damage Buff",
		hover = "Damage buff while equipping Watame Shogun Helm.",
		options =	
		{
			{description = "0%", data = 1.00, hover="No bonus damage"},
			{description = "5%", data = 1.05},
			{description = "10%", data = 1.10},
			{description = "15% (Default)", data = 1.15},
			{description = "20%", data = 1.20},
			{description = "25%", data = 1.25},
			{description = "30%", data = 1.30},
			{description = "35%", data = 1.35},
			{description = "40%", data = 1.40},
			{description = "45%", data = 1.45},
			{description = "50%", data = 1.50},
			{description = "55%", data = 1.55},
			{description = "60%", data = 1.60},
			{description = "65%", data = 1.65},
			{description = "70%", data = 1.70},
			{description = "75%", data = 1.75},
			{description = "80%", data = 1.80},
			{description = "85%", data = 1.85},
			{description = "90%", data = 1.90},
			{description = "95%", data = 1.95},
			{description = "100%", data = 2.00},
		},
		default = 1.15,
	},
	{
		name = "watame_shogun_durability",
		label = "Watame Shogun Helm Durability",
		hover = "How durable Watame Shogun Helm should be?",
		options =	
		{
			{description = "210", data = 210},
			{description = "315", data = 315, hover="Same as Football Helmet"},
			{description = "420", data = 420},
			{description = "525", data = 525},
			{description = "630", data = 630},
			{description = "840 (Default)", data = 840, hover="Same as Thulecite Crown"},
			{description = "1050", data = 1050},
			{description = "1300", data = 1300},
			{description = "1500", data = 1500},
			{description = "2000", data = 2000},
			{description = "Infinite", data = 99999},
		},
		default = 840,
	},
	{
		name = "watame_shogun_absoption",
		label = "Watame Shogun Helm Armor",
		hover = "How much Watame Shogun Helm reduces incoming damage?",
		options =	
		{
			{description = "0%", data = 0, hover="Reduce no damage"},
			{description = "10%", data = 0.1},
			{description = "20%", data = 0.2},
			{description = "30%", data = 0.3},
			{description = "40%", data = 0.4},
			{description = "50%", data = 0.5},
			{description = "60% (Default)", data = 0.6},
			{description = "70%", data = 0.7},
			{description = "80%", data = 0.8, hover="Same as Football Helmet"},
			{description = "90%", data = 0.9, hover="Same as Thulecite Crown"},
			{description = "100%", data = 1, hover="Reduce all damage"},
		},
		default = 0.6,
	},
	{
		name = "watame_shogun_cold_insulation", 
		label = "Watame Shogun Helm Cold Insulation",
		hover = "How much cold insulation Watame Shogun Helm provides?",
		options = 
		{
			{description = "None", data = 0},
			{description = "Little", data = 30},
			{description = "Small (Default)", data = 60, hover="Same as Earmuffs"},
			{description = "Medium", data = 120, hover="Same as Winter Hat"},
			{description = "Medium High", data = 180},
			{description = "High", data = 240, hover="Same as Beefalo Hat"},
		},
		default = 60,
	},
	Title(""),
    Title("Watame Katana"),
	{
		name = "watame_katana_atk_damage",
		label = "Watame Katana Attack Damage",
		hover = "How much damage Watame Katana deal?",
		options =	
		{
			{description = "20", data = 20},
			{description = "24", data = 24},
			{description = "28", data = 28},
			{description = "34 (Default)", data = 34, hover="Same as Spear"},
			{description = "40", data = 40},
			{description = "46", data = 46},
			{description = "52", data = 52},
			{description = "58", data = 58},
			{description = "64", data = 64},
			{description = "70", data = 70},
		},
		default = 34,
	},
	{
		name = "watame_katana_crit_multi1",
		label = "Watame Katana Critical Multiplier",
		hover = "How much critical damage Watame Katana deal?",
		options =	
		{
			{description = "x1", data = 1, hover="No different from normal damage"},
			{description = "x1.5", data = 1.5},
			{description = "x2", data = 2, hover="2 times of normal damage"},
			{description = "x2.5 (Default)", data = 2.5},
			{description = "x3", data = 3, hover="3 times of normal damage"},
			{description = "x3.5", data = 3.5},
			{description = "x4", data = 4, hover="4 times of normal damage"},
			{description = "x4.5", data = 4.5},
			{description = "x5", data = 5, hover="5 times of normal damage"},
		},
		default = 2.5,
	},
	{
		name = "watame_katana_crit_chance1",
		label = "Watame Katana Critical Chance",
		hover = "How often Watame Katana deal critical damage?",
		options =	
		{
			{description = "0%", data = 0, hover="No critical chance"},
			{description = "5-10%", data = 5, hover="10% while wearing Shogun Helm"},
			{description = "10-20%", data = 10, hover="20% while wearing Shogun Helm"},
			{description = "15-30%", data = 15, hover="30% while wearing Shogun Helm"},
			{description = "20-40% (Default)", data = 20, hover="40% while wearing Shogun Helm"},
			{description = "25-50%", data = 25, hover="50% while wearing Shogun Helm"},
			{description = "30-60%", data = 30, hover="60% while wearing Shogun Helm"},
			{description = "35-70%", data = 35, hover="70% while wearing Shogun Helm"},
			{description = "40-80%", data = 40, hover="80% while wearing Shogun Helm"},
			{description = "45-90%", data = 45, hover="90% while wearing Shogun Helm"},
			{description = "50-100%", data = 50, hover="100% while wearing Shogun Helm"},
		},
		default = 20,
	},
	{
		name = "enable_watame_katana_crit_shogun_set", 
		label = "Enable More Critical Chance Shogun Set",
		hover = "Enable 2 times critical chance when wearing Watame Shogun Helm?",
		options = 
		{
			{description = "Enable (Default)", data = true},
			{description = "Disable", data = false},
		},
		default = true,
	},
	{
		name = "watame_katana_usage",
		label = "Watame Katana Usage",
		hover = "How many times Watame Katana can be used before break?",
		options =	
		{
			{description = "50", data = 50},
			{description = "80", data = 80},
			{description = "100", data = 100},
			{description = "120", data = 120},
			{description = "150 (Default)", data = 150, hover="Same as Spear"},
			{description = "180", data = 180},
			{description = "210", data = 210},
			{description = "240", data = 240},
			{description = "300", data = 300},
			{description = "Infinite", data = 99999},
		},
		default = 150,
	},
	Title(""),
    Title("Others"),
	{
		name = "watame_immune_to_cold", 
		label = "Immune to cold",
		options = 
		{
			{description = "Immune", data = true},
			{description = "Small insulation (Default)", data = false},
		},
		default = false,
	},
	{
		name = "watame_starting", 
		label = "Starting items",
		hover = "What items should she being with?",
		options = 
		{
			{description = "Nothing", data = 1},
			{description = "Shogun Set", data = 2},
			{description = "Katana only", data = 3},
		},
		default = 2,
	},
	{
		name = "watame_voice",
		label = "Character Voice",
		hover = "What voice should does she use?",
		options = soundOptions,
		default = "willow",
	},
    {
		name = "watame_clothes", 
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
