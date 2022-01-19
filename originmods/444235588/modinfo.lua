-- This information tells other players more about the mod
name = 'Deluxe Campfires DST Fix - Beta'
description = 'Its a remarkable improvement! Code Cleaned up and Possible Fixes to burn rate has been committed. Hitbox issue is already known. ( I just do not know how to fix it for now ) '
author = 'Fuzzy Logic. Hamlet changes patched by KreygasmTR'
version = "2.14"
-- Compatibility checks
dst_compatible = true
client_only_mod = false
all_clients_require_mod = true
forumthread = ""

api_version = 10


icon_atlas = "deluxe_firepit.xml"
icon = "deluxe_firepit.tex"
icon_atlas = "endo_firepit.xml"
icon = "endo_firepit.tex"
icon_atlas = "deluxe_endofirepit.xml"
icon = "deluxe_endofirepit.tex"
icon_atlas = "ice_star.xml"
icon = "ice_star.tex"
icon_atlas = "heat_star.xml"
icon = "heat_star.tex"

configuration_options =
{
    {
        name = "deluxeFirepitBurnRate",
        label = "Firepit Burn Rate",
        options =
        {
            {description = "25\% longer burn", data = 0.75, hover = "25\% longer burn (default)"},
            {description = "50\% longer burn", data = 0.5, hover = "50\% longer burn"},
            {description = "75\% longer burn", data = 0.25, hover = "75\% longer burn"}
       },
        default = 0.75,
    },
    {
        name = "deluxeEndoFirepitBurnRate",
        label = "Endothermic Firepit Burn Rate",
        options =
        {
            {description = "25\% longer burn", data = 0.75, hover = "25\% longer burn (default)"},
            {description = "50\% longer burn", data = 0.5, hover = "50\% longer burn"},
            {description = "75\% longer burn", data = 0.25, hover = "75\% longer burn"}
       },
        default = 0.75,
    },
    {
        name = "iceStarBurnRate",
        label = "Ice Star Burn Rate",
        options =
        {
            {description = "25\% longer burn", data = 0.75, hover = "25\% longer burn (default)"},
            {description = "50\% longer burn", data = 0.5, hover = "50\% longer burn"},
            {description = "75\% longer burn", data = 0.25, hover = "75\% longer burn"}
       },
        default = 0.75,
    },
    {
        name = "heatStarBurnRate",
        label = "Heat Star Burn Rate",
        options =
        {
            {description = "25\% longer burn", data = 0.75, hover = "25\% longer burn (default)"},
            {description = "50\% longer burn", data = 0.5, hover = "50\% longer burn"},
            {description = "75\% longer burn", data = 0.25, hover = "75\% longer burn"}
       },
        default = 0.75,
    },
    {
        name = "recipeCost",
        label = "Recipe Cost",
        options =
        {
            {description = "Beginner", data = "cheap", hover = "Cheap Recipe Costs"},
            {description = "Standard", data = "standard", hover = "Standart Recipe Costs (default)"},
            {description = "Advanced", data = "expensive", hover = "Expensive Recipe Costs"}
      },
        default = "standard",
    },
    {
        name = "dropLoot",
        label = "FirePit - Drop Loot?",
        options =
        {
            {description = "No", data = "no"},
            {description = "Yes", data = "yes"}
      },
        default = "yes",
    },
    {
        name = "endoDropLoot",
        label = "Endothermic - Drop Loot?",
        options =
        {
            {description = "No", data = "no"},
            {description = "Yes", data = "yes"}
      },
        default = "yes",
    },
    {
        name = "iceStarDropLoot",
        label = "Ice Star - Drop Loot?",
        options =
        {
            {description = "No", data = "no"},
            {description = "Yes", data = "yes"}
      },
        default = "yes",
    },
    {
        name = "heatStarDropLoot",
        label = "Heat Star - Drop Loot?",
        options =
        {
            {description = "No", data = "no"},
            {description = "Yes", data = "yes"}
      },
        default = "yes",
    },
    {
        name = "starsSpawnHounds",
        label = "Stars Spawn Hounds?",
        options =
        {
            {description = "No", data = "no"},
            {description = "Yes", data = "yes"}
      },
        default = "no",
    },
}