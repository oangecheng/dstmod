name = " Multi Rocks"
version = "170823.10:40" 
desc_variant = ("Mod version: "..version..
    "\n More rocks. Make the mines have more duration, more mines for players. Avoid boulders depletion. "..
    "\n  ++ Added ++\n    Added a configuration option - probability of Golds"..
    "\n    Depleted boulders renewable, such as don't want to regeneration? With a shovel cut can!")
description = desc_variant
author = "Shang"
forumthread = ""
api_version = 10
dst_compatible = true
dont_starve_compatible = true
reign_of_giants_compatible = true
all_clients_require_mod = false
client_only_mod = false
server_only_mod = true
icon_atlas = "rocksmodicon.xml"
icon = "rocksmodicon.tex"

configuration_options = 
{
    {
        name = "wajuecishu",
        label = "Number of Pick",
        hover = "How many times after mining a boulders.",
        options =
        {
            {description = "33", data = 1, hover = ""},
            {description = "66", data = 2, hover = ""},
            {description = "99", data = 3, hover = ""},
            {description = "132", data = 4, hover = ""},
            {description = "165", data = 5, hover = ""},
            {description = "198", data = 6, hover = ""}
        },
        default = 2,
    },
    {
        name = "shishengzhang",
        label = "Growth of boulders",
        hover = "Let the pebbles grow and never disappear.",
        options =
        {
            {description = "Off", data = 0, hover = "Select this option to invalidate this option."},
            {description = "1/2 Day", data = .5, hover = ""},
            {description = "1 Day", data = 1, hover = ""},
            {description = "2 Day", data = 2, hover = ""},
            {description = "3 Day", data = 3, hover = ""},
            {description = "4 Day", data = 4, hover = ""},
            {description = "5 Day", data = 5, hover = ""},
            {description = "6 Day", data = 6, hover = ""},
            {description = "7 Day", data = 7, hover = ""},
            {description = "10 Day", data = 10, hover = ""},
            {description = "15 Day", data = 15, hover = ""},
            {description = "20 Day", data = 20, hover = ""}
        },
        default = 0,
    },
    {
        name = "shitoubaolv",
        label = "Probability of Rocks",
        hover = "You can adjust the probability of mining the rocks.",
        options =
        {
            {description = "None", data = 0, hover = ""},
            {description = "Low", data = .3, hover = ""},
            {description = "Normal", data = .6, hover = ""},
            {description = "Default", data = 1, hover = ""},
            {description = "2 x", data = 2, hover = ""},
            {description = "3 x", data = 3, hover = ""}
        },
        default = 1,
    },
    {
        name = "huangjinbaolv",
        label = "Probability of Gold",
        hover = "You can adjust the probability of mining the Gold.",
        options =
        {
            {description = "None", data = 0, hover = ""},
            {description = "Low", data = .3, hover = ""},
            {description = "Normal", data = .6, hover = ""},
            {description = "Default", data = 1, hover = ""},
            {description = "2 x", data = 2, hover = ""},
            {description = "3 x", data = 3, hover = ""}
        },
        default = 1,
    },
    {
        name = "baoshibaolv",
        label = "Probability of Gem",
        hover = "You can adjust the probability of mining the gem.",
        options =
        {
            {description = "None", data = 0, hover = ""},
            {description = "Low", data = .3, hover = ""},
            {description = "Normal", data = .6, hover = ""},
            {description = "Default", data = 1, hover = ""},
            {description = "2 x", data = 2, hover = ""},
            {description = "4 x", data = 4, hover = ""},
            {description = "8 x", data = 8, hover = ""},
            {description = "16 x", data = 16, hover = ""},
            {description = "32 x", data = 32, hover = ""},
            {description = "100x", data = 100, hover = "It's crazy!"}
        },
        default = 1,
    },
    {
        name = "SHENGDANSHI",
        label = "Christmas boulders",
        hover = "Random colored boulders.",
        options =
        {
            {description = "No", data = false, hover = ""},
            {description = "Yes", data = true, hover = ""},
        },
        default = false,
    },
    {
        name = "RUOYINXIAN",
        label = "Random transparent",
        hover = "The boulders random transparency.",
        options =
        {
            {description = "No", data = false, hover = ""},
            {description = "Yes", data = true, hover = ""},
        },
        default = false,
    },

    {
        name = "er_shuoming",
        label = "",
        hover = "",
        options =
        {
            {description = "", data = 0, hover = ""},
        },
        default = 0,
    },
    {
        name = "yi_shuoming",
        label = "Gems",
        hover = "",
        options =
        {
            {description = "Single probability", data = 0, hover = ""},
        },
        default = 0,
    },
    {
        name = "blue_baoshi",
        label = "Blue Gem",
        hover = "Probability of Blue gem.",
        options =
        {
            {description = "None", data = 0, hover = ""},
            {description = "Low", data = .3, hover = ""},
            {description = "Normal", data = .6, hover = ""},
            {description = "Default", data = 1, hover = ""},
            {description = "2 x", data = 2, hover = ""},
            {description = "4 x", data = 4, hover = ""},
            {description = "6 x", data = 6, hover = ""},
            {description = "10 x", data = 10, hover = ""}
        },
        default = 1,
    },
    {
        name = "red_baoshi",
        label = "Red Gem",
        hover = "Probability of Red gem.",
        options =
        {
            {description = "None", data = 0, hover = ""},
            {description = "Low", data = .3, hover = ""},
            {description = "Normal", data = .6, hover = ""},
            {description = "Default", data = 1, hover = ""},
            {description = "2 x", data = 2, hover = ""},
            {description = "4 x", data = 4, hover = ""},
            {description = "8 x", data = 8, hover = ""},
            {description = "16 x", data = 16, hover = ""}
        },
        default = 1,
    },
    {
        name = "orange_baoshi",
        label = "Orange Gem",
        hover = "Probability of Orange gem.",
        options =
        {
            {description = "None", data = 0, hover = ""},
            {description = "Low", data = .3, hover = ""},
            {description = "Normal", data = .6, hover = ""},
            {description = "Default", data = 1, hover = ""},
            {description = "2 x", data = 2, hover = ""},
            {description = "4 x", data = 4, hover = ""},
            {description = "8 x", data = 8, hover = ""},
            {description = "16 x", data = 16, hover = ""}
        },
        default = 1,
    },
    {
        name = "yellow_baoshi",
        label = "Yellow Gem",
        hover = "Probability of Yellow gem.",
        options =
        {
            {description = "None", data = 0, hover = ""},
            {description = "Low", data = .3, hover = ""},
            {description = "Normal", data = .6, hover = ""},
            {description = "Default", data = 1, hover = ""},
            {description = "2 x", data = 2, hover = ""},
            {description = "4 x", data = 4, hover = ""},
            {description = "8 x", data = 8, hover = ""},
            {description = "12 x", data = 12, hover = ""}
        },
        default = 1,
    },
    {
        name = "green_baoshi",
        label = "Green Gem",
        hover = "Probability of Green gem.",
        options =
        {
            {description = "None", data = 0, hover = ""},
            {description = "Low", data = .3, hover = ""},
            {description = "Normal", data = .6, hover = ""},
            {description = "Default", data = 1, hover = ""},
            {description = "2 x", data = 2, hover = ""},
            {description = "4 x", data = 4, hover = ""},
            {description = "8 x", data = 8, hover = ""},
            {description = "16 x", data = 16, hover = ""}
        },
        default = 1,
    },
    {
        name = "purple_baoshi",
        label = "Purple Gem",
        hover = "Probability of Purple gem.",
        options =
        {
            {description = "None", data = 0, hover = ""},
            {description = "Low", data = .3, hover = ""},
            {description = "Normal", data = .6, hover = ""},
            {description = "Default", data = 1, hover = ""},
            {description = "2 x", data = 2, hover = ""},
            {description = "4 x", data = 4, hover = ""},
            {description = "8 x", data = 8, hover = ""},
            {description = "12 x", data = 12, hover = ""}
        },
        default = 1,
    },
    {
        name = "thulecite_xiukuang",
        label = "Thulium ore",
        hover = "Probability of Thulium ore.",
        options =
        {
            {description = "None", data = 0, hover = ""},
            {description = "Low", data = .3, hover = ""},
            {description = "Normal", data = .6, hover = ""},
            {description = "Default", data = 1, hover = ""},
            {description = "2 x", data = 2, hover = ""},
            {description = "4 x", data = 4, hover = ""},
            {description = "8 x", data = 8, hover = ""},
            {description = "16 x", data = 16, hover = ""},
            {description = "32 x", data = 32, hover = ""}
        },
        default = 1,
    },
    {
        name = "marble_suipian",
        label = "Marble and...",
        hover = "Marble and Thulium-pieces",
        options =
        {
            {description = "None", data = 0, hover = ""},
            {description = "Low", data = .3, hover = ""},
            {description = "Normal", data = .6, hover = ""},
            {description = "Default", data = 1, hover = ""},
            {description = "2 x", data = 2, hover = ""},
            {description = "4 x", data = 4, hover = ""},
            {description = "8 x", data = 8, hover = ""},
            {description = "16 x", data = 16, hover = ""}
        },
        default = 1,
    },
}