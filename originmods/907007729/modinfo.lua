name = "Deluxe cooking pot [1.0.7]"
description = "Don't starve! Cook more and better!"
author = "JanKiwen"
version = "1.0.7"
forumthread = ""

api_version = 10
priority = -100.5437598423075384275324980

dst_compatible = true
all_clients_require_mod = true
client_only_mod = false

icon_atlas = "icon.xml"
icon = "icon.tex"
server_filter_tags = {"JanKiwen", "deluxe", "pot", "cookingpot"}

configuration_options =
{

	{
		name = "RECIPE",  label = "Recipe difficulty", default = "NORMAL",
		options =	{
						{description = "Easy",          data = "EASY",     hover = "A little of cutstone and marble"},
						{description = "Normal",        data = "NORMAL",   hover = "Some cutstones, gold nuggets and marble"},
						{description = "Harder",        data = "HARDER",   hover = "Some cutstones, marble and moonrock nuggets"},
						{description = "Hard",          data = "HARD",     hover = "Some steel wool, marble and moonrock nuggets"},
						{description = "Rockhard!",     data = "ROCKHARD", hover = "A lot of steel wool, marble and moonrock nuggets"},
				},
	},

	{
		name = "FRESHBONUS",  label = "Fresh bonus", default = 0.3,
		options =	{
						{description = "OFF",      data = 1  , hover = "Same freshness as in standard cooking pot"},
						{description = "Less",     data = 0.8, hover = "A little fresh bonus"},
						{description = "Normal",   data = 0.3, hover = "Medium fresh bonus"},
						{description = "More",     data = 0.1, hover = "Huge fresh bonus"},
						{description = "Super!",   data = 0  , hover = "Cooked food is 100% fresh even when cooked from unfresh ingredients"},
				},
	},

	{
		name = "COOKTIME",  label = "Cooking Time", default = 0.33,
		options =	{
						{description = "x2",      data = 2,    hover = "Cooking time is 2 times longer"},
						{description = "x1.5",    data = 1.5,  hover = "Cooking time is 50% longer"},
						{description = "x1.1",    data = 1.1,  hover = "Cooking time is 10% longer"},
						{description = "x1",      data = 1,    hover = "Standard cooking time"},
						{description = "x0.9",    data = 0.9,  hover = "Cooking time is 10% less"},
						{description = "x0.66",   data = 0.66, hover = "Cooking time is 33% less"},
						{description = "x0.5",    data = 0.5,  hover = "Cooking time is halfed"},
						{description = "x0.33",   data = 0.33, hover = "Cooking time is 66% less"},
						{description = "x0.1",    data = 0.1,  hover = "Super fast cooking. Only 10% of standard time."},

				},
	},	


	{
		name = "MININGREDIENTS",  label = "Minimum ingredients", hover="Minimum amount of ingredients needed to make something except of wet goop",default = 2,
		options =	{
						{description = "2",        data = 2    , hover = "Only 2 ingredients is needed for cooking"},
						{description = "3",        data = 3    , hover = "Only 3 ingredients is needed for cooking"},
						{description = "4",        data = 4    , hover = "Same amount as with standard cooking pot"},
				},
	},		


	{
		name = "AMOUNTBONUS",  label = "Amount bonus", default = 2,
		options =	{
						{description = "OFF",      data = 0    , hover = "Same amount as with standard cooking pot"},
						{description = "Less",     data = 1    , hover = "Sometimes you will get extra food items"},
						{description = "Normal",   data = 2    , hover = "Mostly you will get extra food items"},
						{description = "More",     data = 3    , hover = "You always get extra food items"},
				},
	},		



}