name = "六格装备栏"
description = "(默认全开) 六格装备栏(武器 / 背包 / 服装 / 护符 / 头盔)"
author = "AndreyMZ / 搬运：白桃的爸爸"
version = "1.1.3"

api_version = 10

-- This mod is both server and client.
all_clients_require_mod = true
client_only_mod = false

-- This mod is functional with Don't Starve Together only.
dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true

-- These tags allow the server running this mod to be found with filters from the server listing screen.
server_filter_tags = {"equip equipment slot body backpack armor clothing amulet"}

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

-- Configuration options.
local slot_options_not_implemented = {
    {data = false       , description = "默认"},
}
local slot_options = {
    {data = false       , description = "不开启"},
    {data = "位置1", description = "位置1"},
    {data = "位置2", description = "位置2"},
    {data = "位置3", description = "位置3"},
}
configuration_options = {
    {
        name = "slot_heavy",
        label = "不可调",
        hover = "",
        default = false,
        options = slot_options_not_implemented,
    },
    {
        name = "slot_backpack",
        label = "不可调",
        hover = "",
        default = false,
        options = slot_options_not_implemented,
    },
    {
        name = "slot_band",
        label = "不可调",
        hover = "",
        default = false,
        options = slot_options_not_implemented,
    },
    {
        name = "slot_shell",
        label = "不可调",
        hover = "",
        default = false,
        options = slot_options_not_implemented,
    },
    {
        name = "slot_lifevest",
        label = "不可调",
        hover = "",
        default = false,
        options = slot_options_not_implemented,
    },
    {
        name = "slot_armor",
        label = "盔甲",
        hover = "",
        default = "位置1",
        options = slot_options,
    },
    {
        name = "slot_clothing",
        label = "服装",
        hover = "",
        default = "位置2",
        options = slot_options,
    },
    {
        name = "slot_amulet",
        label = "护身符",
        hover = "",
        default = "位置3",
        options = slot_options,
    },
    {
        name = "config_render",
        label = "是否可装备MOD装备",
        hover = "",
        default = true,
        options = {
            {data = false, description = "否"},
            {data = true,  description = "是"},
        },
    },
}
