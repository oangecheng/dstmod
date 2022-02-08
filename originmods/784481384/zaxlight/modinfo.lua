name = "Forever light"
description = "The light turn on at night and turn off during the day"
author = "look_through"
version = "1.1"
forumthread = ""

api_version = 10
priority = 5

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false

all_clients_require_mod = true
client_only_mod = false

icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
	{
		name = "LOOK_Language",
		label = "Language",
		options =	{
						{description = "English", data = "EN"},
						{description = "Chinese", data = "CH"},
					},

		default = "CH",

	},

	{
		name = "RecipenNeed",
		label = "Recipe",
		options =	{
						{description = "Firefly", data = "EASY"},
						{description = "Lightbulb", data = "HARD"},
					},

		default = "EASY",

	},

}
