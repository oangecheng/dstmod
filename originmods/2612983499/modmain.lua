-- Utility functions.

local mytable = {}

function mytable.invert(t)
    local result = {}
    for k, v in pairs(t) do
        local values = result[v]
        if values == nil then
            values = {}
            result[v] = values
        end
        table.insert(values, k)
    end
    return result
end

function mytable.contains_all(t, elements)
    for _, v in pairs(elements) do
        if not table.contains(t, v) then
            return false
        end
    end
    return true
end


-- Assets.

local IMAGE = "images/equip_slots.tex"
local ATLAS = "images/equip_slots.xml"
Assets = {
    Asset("IMAGE", IMAGE),
    Asset("ATLAS", ATLAS),
}


-- Some global variables.

EQUIP_TYPES = {
    HEAVY    = "heavy",
    BACKPACK = "backpack",
    BAND     = "band",
    SHELL    = "shell",
    LIFEVEST = "lifevest",
    ARMOR    = "armor",
    CLOTHING = "clothing",
    AMULET   = "amulet",
}

EQUIPSLOTS_MAP = {
    HEAVY    = GetModConfigData("slot_heavy"   ) or GLOBAL.EQUIPSLOTS.BODY,
    BACKPACK = GetModConfigData("slot_backpack") or GLOBAL.EQUIPSLOTS.BODY,
    BAND     = GetModConfigData("slot_band"    ) or GLOBAL.EQUIPSLOTS.BODY,
    SHELL    = GetModConfigData("slot_shell"   ) or GLOBAL.EQUIPSLOTS.BODY,
    LIFEVEST = GetModConfigData("slot_lifevest") or GLOBAL.EQUIPSLOTS.BODY,
    ARMOR    = GetModConfigData("slot_armor"   ) or GLOBAL.EQUIPSLOTS.BODY,
    CLOTHING = GetModConfigData("slot_clothing") or GLOBAL.EQUIPSLOTS.BODY,
    AMULET   = GetModConfigData("slot_amulet"  ) or GLOBAL.EQUIPSLOTS.BODY,
}

EQUIPSLOTS_MAP_INVERSE = mytable.invert(EQUIPSLOTS_MAP)

EXTRA_EQUIPSLOTS = table.getkeys(EQUIPSLOTS_MAP_INVERSE)
table.removearrayvalue(EXTRA_EQUIPSLOTS, GLOBAL.EQUIPSLOTS.BODY)
table.sort(EXTRA_EQUIPSLOTS)


-- 1. Add new equip slots.
-- See `scripts/constants.lua:473`.

for _, v in ipairs(EXTRA_EQUIPSLOTS) do
    GLOBAL.EQUIPSLOTS[string.upper(v)] = v
end


-- 2. Add the new equip slots to the inventory bar.
-- See `scripts/widgets/inventorybar.lua:92`.

local function get_eslot_image(eslot)
    local types = EQUIPSLOTS_MAP_INVERSE[eslot]
    if mytable.contains_all(types, {'BACKPACK', 'ARMOR'}) then
        return {ATLAS, "backpack+armor.tex"}
    elseif table.contains(types, 'BACKPACK') then
        return {ATLAS, "backpack.tex"}
    elseif table.contains(types, 'ARMOR') then
        return {ATLAS, "armor.tex"}
    elseif table.contains(types, 'CLOTHING') then
        return {ATLAS, "clothing.tex"}
    elseif table.contains(types, 'AMULET') then
        return {ATLAS, "amulet.tex"}
    else
        return {GLOBAL.HUD_ATLAS, "equip_slot_body.tex"}
    end
end

Inv = require "widgets/inventorybar"

AddClassPostConstruct("widgets/inventorybar", function(self)
    if GLOBAL.TheNet:GetServerGameMode() == "quagmire" then
        return
    end

    -- Change the image for the old equip slot.
    for _, info in ipairs(self.equipslotinfo) do
        if info.slot == GLOBAL.EQUIPSLOTS.BODY then
            local atlas_and_image = get_eslot_image(info.slot)
            info.atlas = atlas_and_image[1]
            info.image = atlas_and_image[2]
        end
    end

    -- Add the new equip slots.
    local sortkey_start = 1.0 -- After the 1st slot ("body").
    local sortkey_delta = 1.0 / (#EXTRA_EQUIPSLOTS + 1)
    for i, eslot in ipairs(EXTRA_EQUIPSLOTS) do
        local atlas_and_image = get_eslot_image(eslot)
        self:AddEquipSlot(eslot, atlas_and_image[1], atlas_and_image[2], sortkey_start + i * sortkey_delta)
    end

    -- Fix the width of the background of the inventory bar.
    local Inv_Rebuild_Base = Inv.Rebuild
    function Inv:Rebuild()
        Inv_Rebuild_Base(self)

        local num_slots = self.owner.replica.inventory:GetNumSlots()
        local do_self_inspect = not (self.controller_build or GLOBAL.GetGameModeProperty("no_avatar_popup"))

        local total_w_default = self:CalcTotalWidth(num_slots, 3, 1)
        local total_w_real    = self:CalcTotalWidth(num_slots, #self.equipslotinfo, do_self_inspect and 1 or 0)
        local scale_default = 1.22 -- See `scripts/widgets/inventorybar.lua:261-262`.
        local scale_real = scale_default *  total_w_real / total_w_default
        self.bg:SetScale(scale_real, 1, 1)
        self.bgcover:SetScale(scale_real,1, 1)
    end

    function Inv:CalcTotalWidth(num_slots, num_equip, num_buttons)
        -- See `scripts/widgets/inventorybar.lua:212-217`.
        local W = 68
        local SEP = 12
        local INTERSEP = 28
        local num_slotintersep = math.ceil(num_slots / 5)
        local num_equipintersep = num_buttons > 0 and 1 or 0
        return (num_slots + num_equip + num_buttons) * W + (num_slots + num_equip + num_buttons - num_slotintersep - num_equipintersep - 1) * SEP + (num_slotintersep + num_equipintersep) * INTERSEP
    end
end)


-- 3. Assign the new equip slots to the items.
-- See `scripts/prefabs/*.lua`.

local items_types = {
    -- Life vests
    ["balloonvest"]       = EQUIP_TYPES.LIFEVEST, -- Inflatable Vest

    -- Armors
    ["armor_bramble"]     = EQUIP_TYPES.ARMOR, -- Bramble Husk
    ["armordragonfly"]    = EQUIP_TYPES.ARMOR, -- Scalemail
    ["armorgrass"]        = EQUIP_TYPES.ARMOR, -- Grass Suit
    ["armormarble"]       = EQUIP_TYPES.ARMOR, -- Marble Suit
    ["armorruins"]        = EQUIP_TYPES.ARMOR, -- Thulecite Suit
    ["armor_sanity"]      = EQUIP_TYPES.ARMOR, -- Night Armour
    ["armorskeleton"]     = EQUIP_TYPES.ARMOR, -- Bone Armor
    ["armorwood"]         = EQUIP_TYPES.ARMOR, -- Log Suit

    -- Armors: from the mod "More Armor" (<https://steamcommunity.com/sharedfiles/filedetails/?id=1153998909>)
    ["armor_bone"]        = EQUIP_TYPES.ARMOR, -- Bone Suit
    ["armor_stone"]       = EQUIP_TYPES.ARMOR, -- Stone Suit

    -- Clothing
    ["armorslurper"]     = EQUIP_TYPES.CLOTHING, -- Belt of Hunger
    ["beargervest"]      = EQUIP_TYPES.CLOTHING, -- Hibearnation Vest
    ["hawaiianshirt"]    = EQUIP_TYPES.CLOTHING, -- Floral Shirt
    ["raincoat"]         = EQUIP_TYPES.CLOTHING, -- Rain Coat
    ["reflectivevest"]   = EQUIP_TYPES.CLOTHING, -- Summer Frest
    ["sweatervest"]      = EQUIP_TYPES.CLOTHING, -- Dapper Vest
    ["trunkvest_summer"] = EQUIP_TYPES.CLOTHING, -- Breezy Vest
    ["trunkvest_winter"] = EQUIP_TYPES.CLOTHING, -- Puffy Vest

    -- Amulets
    ["amulet"]       = EQUIP_TYPES.AMULET, -- Life Giving Amulet
    ["blueamulet"]   = EQUIP_TYPES.AMULET, -- Chilled Amulet
    ["purpleamulet"] = EQUIP_TYPES.AMULET, -- Nightmare Amulet
    ["orangeamulet"] = EQUIP_TYPES.AMULET, -- The Lazy Forager
    ["greenamulet"]  = EQUIP_TYPES.AMULET, -- Construction Amulet
    ["yellowamulet"] = EQUIP_TYPES.AMULET, -- Magiluminescence
}

AddPrefabPostInitAny(function(inst)
    -- Add the type as a tag if it is missing.
    local type = items_types[inst.prefab]
    if type ~= nil and not inst:HasTag(type) then
        inst:AddTag(type)
    end

    -- Get an equip slot by the type/tag.
    local eslot = nil
    for k, v in pairs(EQUIP_TYPES) do
        if inst:HasTag(v) then
            eslot = EQUIPSLOTS_MAP[k]
            break
        end
    end

    if (eslot ~= nil) and (eslot ~= GLOBAL.EQUIPSLOTS.BODY) then
        -- Assign the new equip slot.
        -- See `scripts/prefabs/*.lua`.
        if GLOBAL.TheWorld.ismastersim then
            inst.components.equippable.equipslot = eslot
        end

        -- 4. Fix the wet prefix.
        -- See `scripts/entityscript.lua:594`.
        if not inst.no_wet_prefix and inst.wet_prefix == nil then
            inst.wet_prefix = GLOBAL.STRINGS.WET_PREFIX.CLOTHING
        end
    end
end)


if EQUIPSLOTS_MAP.CLOTHING ~= GLOBAL.EQUIPSLOTS.BODY then

    -- 5. When you give Crabby Hermit a coat, she tries to use the old equip slot. Let's use the new one too.
    -- See `scripts/prefabs/hermitcrab.lua`.
    AddPrefabPostInit("hermitcrab", function(inst)
        if not GLOBAL.TheWorld.ismastersim then
            return
        end

        local function iscoat(item)
            return item.components.insulator and
                    item.components.insulator:GetInsulation() >= GLOBAL.TUNING.INSULATION_SMALL and
                    item.components.insulator:GetType() == GLOBAL.SEASONS.WINTER and
                    item.components.equippable and
                    item.components.equippable.equipslot == EQUIPSLOTS_MAP.CLOTHING
        end

        local function getcoat(inst1)
            local equipped = inst1.components.inventory:GetEquippedItem(EQUIPSLOTS_MAP.CLOTHING)
            return inst1.components.inventory:FindItem(function(testitem) return iscoat(testitem) end)
                    or (equipped and iscoat(equipped) and equipped)
        end

        -- Add an extra "itemget" listener.
        -- See `scripts/prefabs/hermitcrab.lua:1011`.
        inst:ListenForEvent("itemget", function(_, data)
            if iscoat(data.item) and GLOBAL.TheWorld.state.issnowing then
                local TASKS_GIVE_PUFFY_VEST = 11 -- Copy from `prefabs/hermitcrab.lua:57`.
                inst.components.inventory:Equip(data.item)
                inst.components.friendlevels:CompleteTask(TASKS_GIVE_PUFFY_VEST)
            end
        end)

        -- Override `ShouldAcceptItem`.
        -- See `scripts/prefabs/hermitcrab.lua:122-123,127`.
        local ShouldAcceptItem_Base = inst.components.trader.test
        inst.components.trader:SetAcceptTest(function(inst1, item)
            return (iscoat(item) and GLOBAL.TheWorld.state.issnowing and not getcoat(inst1))
                    or ShouldAcceptItem_Base(inst1, item)
        end)

        -- Override `OnRefuseItem`.
        -- See `scripts/prefabs/hermitcrab.lua:144-146`.
        local OnRefuseItem_Base = inst.components.trader.onrefuse
        inst.components.trader.onrefuse = function(inst1, giver, item)
            if iscoat(item) then
                if getcoat(inst1) then
                    inst1.components.npc_talker:Say(GLOBAL.STRINGS.HERMITCRAB_REFUSE_COAT_HASONE[math.random(#GLOBAL.STRINGS.HERMITCRAB_REFUSE_COAT_HASONE)])
                elseif not GLOBAL.TheWorld.state.issnowing then
                    inst1.components.npc_talker:Say(GLOBAL.STRINGS.HERMITCRAB_REFUSE_COAT[math.random(#GLOBAL.STRINGS.HERMITCRAB_REFUSE_COAT)])
                end
            end
            OnRefuseItem_Base(inst, giver, item)
        end

        -- Override `iscoat`.
        -- See `scripts/prefabs/hermitcrab.lua:1363`.
        inst.iscoat = iscoat
        inst.getcoat = getcoat
    end)


    -- 6. Crabby Hermit has a brain which allows her to equip/unequip a coat to/from the old equip slot. Let's use the new one too.
    -- See `scripts/brains/hermitcrabbrain.lua`.
    AddBrainPostInit("hermitcrabbrain", function(brain)
        local function using_coat(inst)
            local equipped = inst.components.inventory:GetEquippedItem(EQUIPSLOTS_MAP.CLOTHING)
            return equipped and inst.iscoat(equipped) or nil
        end

        local function has_coat(inst)
            return inst.components.inventory:FindItem(function(testitem) return inst.iscoat(testitem) end)
        end

        local function EquipCoat(inst)
            local coat = inst.getcoat(inst)
            if coat then
                inst.components.inventory:Equip(coat)
            end
        end

        local function UnequipCoat(inst)
            local item = inst.components.inventory:Unequip(EQUIPSLOTS_MAP.CLOTHING)
            inst.components.inventory:GiveItem(item)
        end

        local new_children = {}
        for _, child in ipairs(brain.bt.root.children) do
            if child.name == "Sequence" and child.children[1].name == "coat" then
                table.insert(new_children,
                        GLOBAL.IfNode(function() return not brain.inst.sg:HasStateTag("busy") and GLOBAL.TheWorld.state.issnowing and has_coat(brain.inst) and not using_coat(brain.inst) end,
                                "coat",
                                GLOBAL.DoAction(brain.inst, EquipCoat, "coat", true))
                )
            elseif child.name == "Sequence" and child.children[1].name == "stop coat" then
                table.insert(new_children,
                        GLOBAL.IfNode(function() return not brain.inst.sg:HasStateTag("busy") and not GLOBAL.TheWorld.state.issnowing and using_coat(brain.inst) end,
                                "stop coat",
                                GLOBAL.DoAction(brain.inst, UnequipCoat, "stop coat", true))
                )
            else
                table.insert(new_children, child)
            end
        end
        brain.bt = GLOBAL.BT(brain.inst, GLOBAL.PriorityNode(new_children, 0.5))
    end)

end


if EQUIPSLOTS_MAP.AMULET ~= GLOBAL.EQUIPSLOTS.BODY then

    -- 7. There is a state related to the Life Giving Amulet equipped in the old slot. Let's use the new slot too.
    -- See `scripts/stategraphs/SGwilson.lua`.
    AddStategraphPostInit("wilson", function(self)
        local amulet_rebirth_state = self.states["amulet_rebirth"]

        -- Override `onenter` for the "amulet_rebirth" state.
        -- See `scripts/stategraphs/SGwilson.lua:9372`.
        local amulet_rebirth_state_onenter_base = amulet_rebirth_state.onenter
        amulet_rebirth_state.onenter = function(inst)
            amulet_rebirth_state_onenter_base(inst)
            local item = inst.components.inventory:GetEquippedItem(EQUIPSLOTS_MAP.AMULET)
            if item ~= nil and item.prefab == "amulet" then
                item = inst.components.inventory:RemoveItem(item)
                if item ~= nil then
                    item:Remove()
                    inst.sg.statemem.usedamulet_2 = true -- Mod note: `usedamulet_2` is set instead of `usedamulet`.
                end
            end
        end

        -- Override `onexit` for the "amulet_rebirth" state.
        -- See `scripts/stategraphs/SGwilson.lua:9414`.
        local amulet_rebirth_state_onexit_base = amulet_rebirth_state.onexit
        amulet_rebirth_state.onexit = function(inst)
            -- Mod note: `usedamulet_2` is checked instead of `usedamulet`.
            if inst.sg.statemem.usedamulet_2 and inst.components.inventory:GetEquippedItem(EQUIPSLOTS_MAP.AMULET) == nil then
                inst.AnimState:ClearOverrideSymbol("swap_body")
            end
            amulet_rebirth_state_onexit_base(inst)
        end
    end)


    -- 8. In the recipe popup the icon of the Construction Amulet is shown when it is equipped in the old slot. Let's use the new slot too.
    -- See `scripts/widgets/recipepopup.lua:334`.

    RecipePopup = GLOBAL.require "widgets/recipepopup"

    AddGlobalClassPostConstruct("widgets/recipepopup", "RecipePopup", function(self)
        local RecipePopup_Refresh_Base = RecipePopup.Refresh
        function RecipePopup:Refresh()
            RecipePopup_Refresh_Base(self)
            if self.button:IsVisible() then
                local equipped = self.owner.replica.inventory:GetEquippedItem(EQUIPSLOTS_MAP.AMULET)
                local showamulet = equipped and equipped.prefab == "greenamulet"
                if showamulet then
                    self.amulet:Show()
                end
            end
        end
    end)

end


-- 9. Render items from the new equip slots.
if GetModConfigData("config_render") then

    local anim_build_symbols = {
        -- Backpacks
        ["backpack"]     = {"swap_backpack",     "swap_body"}, -- Backpack
        ["candybag"]     = {"candybag",          "swap_body"}, -- Candybag
        ["icepack"]      = {"swap_icepack",      "swap_body"}, -- Insulated Pack
        ["krampus_sack"] = {"swap_krampus_sack", "swap_body"}, -- Krampus Sack
        ["piggyback"]    = {"swap_piggyback",    "swap_body"}, -- Piggyback
        ["seedpouch"]    = {"seedpouch",         "swap_body"}, -- Seed Pack-It
        ["spicepack"]    = {"swap_chefpack",     "swap_body"}, -- Chef Pouch

        -- Band
        ["onemanband"]        = {"swap_one_man_band",  "swap_body_tall"}, -- One-man Band

        -- Shell
        ["armorsnurtleshell"] = {"armor_slurtleshell", "swap_body_tall"}, -- Snurtle Shell Armor

        -- Life vests
        ["balloonvest"]     = {"balloonvest",     "swap_body"}, -- Inflatable Vest

        -- Armors
        ["armor_bramble"]   = {"armor_bramble",   "swap_body"}, -- Bramble Husk
        ["armordragonfly"]  = {"torso_dragonfly", "swap_body"}, -- Scalemail
        ["armorgrass"]      = {"armor_grass",     "swap_body"}, -- Grass Suit
        ["armormarble"]     = {"armor_marble",    "swap_body"}, -- Marble Suit
        ["armorruins"]      = {"armor_ruins",     "swap_body"}, -- Thulecite Suit
        ["armor_sanity"]    = {"armor_sanity",    "swap_body"}, -- Night Armour
        ["armorskeleton"]   = {"armor_skeleton",  "swap_body"}, -- Bone Armor
        ["armorwood"]       = {"armor_wood",      "swap_body"}, -- Log Suit

        -- Armors: from the mod "More Armor" (<https://steamcommunity.com/sharedfiles/filedetails/?id=1153998909>)
        ["armor_bone"]  = {"armor_bone",  "armor_my_folder"}, -- Bone Suite
        ["armor_stone"] = {"armor_stone", "armor_my_folder"}, -- Stone Suite

        -- Clothing
        ["armorslurper"]     = {"armor_slurper",          "swap_body"}, -- Belt of Hunger
        ["beargervest"]      = {"torso_bearger",          "swap_body"}, -- Hibearnation Vest
        ["hawaiianshirt"]    = {"torso_hawaiian",         "swap_body"}, -- Floral Shirt
        ["raincoat"]         = {"torso_rain",             "swap_body"}, -- Rain Coat
        ["reflectivevest"]   = {"torso_reflective",       "swap_body"}, -- Summer Frest
        ["sweatervest"]      = {"armor_sweatervest",      "swap_body"}, -- Dapper Vest
        ["trunkvest_summer"] = {"armor_trunkvest_summer", "swap_body"}, -- Breezy Vest
        ["trunkvest_winter"] = {"armor_trunkvest_winter", "swap_body"}, -- Puffy Vest

        -- Amulets
        ["amulet"]       = {"torso_amulets", "redamulet"   }, -- Life Giving Amulet
        ["blueamulet"]   = {"torso_amulets", "blueamulet"  }, -- Chilled Amulet
        ["purpleamulet"] = {"torso_amulets", "purpleamulet"}, -- Nightmare Amulet
        ["orangeamulet"] = {"torso_amulets", "orangeamulet"}, -- The Lazy Forager
        ["greenamulet"]  = {"torso_amulets", "greenamulet" }, -- Construction Amulet
        ["yellowamulet"] = {"torso_amulets", "yellowamulet"}, -- Magiluminescence

        -- Heavy
        ["cavein_boulder"]       = {"swap_cavein_boulder", "swap_body"}, -- Boulder -- TODO: variations.
        ["glassspike_short"]     = {"swap_glass_spike", "swap_body_short"}, -- Glass Spike - Short
        ["glassspike_med"]       = {"swap_glass_spike", "swap_body_med"},   -- Glass Spike - Medium
        ["glassspike_tall"]      = {"swap_glass_spike", "swap_body_tall"},  -- Glass Spike - Tall
        ["glassblock"]           = {"swap_glass_block", "swap_body"},       -- Glass Castle
        ["moon_altar_idol"]      = {"swap_altar_idolpiece",  "swap_body"}, -- Celestial Altar Idol
        ["moon_altar_glass"]     = {"swap_altar_glasspiece", "swap_body"}, -- Celestial Altar Base
        ["moon_altar_seed"]      = {"swap_altar_seedpiece",  "swap_body"}, -- Celestial Altar Orb
        ["moon_altar_crown"]     = {"swap_altar_crownpiece", "swap_body"}, -- Inactive Celestial Tribute
        ["moon_altar_ward"]      = {"swap_altar_wardpiece",  "swap_body"}, -- Celestial Sanctum Ward
        ["moon_altar_icon"]      = {"swap_altar_iconpiece",  "swap_body"}, -- Celestial Sanctum Icon
        ["sculpture_knighthead"] = {"swap_sculpture_knighthead", "swap_body"}, -- Suspicious Marble - Knight Head
        ["sculpture_bishophead"] = {"swap_sculpture_bishophead", "swap_body"}, -- Suspicious Marble - Bishop Head
        ["sculpture_rooknose"]   = {"swap_sculpture_rooknose",   "swap_body"}, -- Suspicious Marble - Rook Nose
        ["shell_cluster"]        = {"singingshell_cluster", "swap_body"}, -- Shell Cluster
        ["sunkenchest"]          = {"swap_sunken_treasurechest", "swap_body"}, -- Sunken Chest

        -- Heavy: from the mod "Moving Box" (<https://steamcommunity.com/sharedfiles/filedetails/?id=1079538195>)
        ["moving_box_full"]      = {"swap_box_full", "swap_body"} -- Moving Box (Full)
    }

    -- Heavy: chess pieces
    local CHESS_PIESES = {
        "pawn", "rook", "knight", "bishop", "muse", "formal", "hornucopia", "pipe", "deerclops", "bearger",
        "moosegoose", "dragonfly", "clayhound", "claywarg", "butterfly", "anchor", "moon", "carrat", "crabking",
        "malbatross", "toadstool", "stalker", "klaus", "beequeen", "antlion", "minotaur"
    }
    local CHESS_MATERIALS = {"marble", "stone", "moonglass"}
    for p = 1, #CHESS_PIESES do
        anim_build_symbols["chesspiece_" .. p] = {"swap_chesspiece_" .. p, "swap_body"}
        for m = 1, #CHESS_MATERIALS do
            anim_build_symbols["chesspiece_" .. p .. "_" .. m] = {"swap_chesspiece_" .. p .. "_" .. m, "swap_body"}
        end
    end

    -- Heavy: veggies
    local PLANT_DEFS = require("prefabs/farm_plant_defs").PLANT_DEFS
    for name, def in pairs(PLANT_DEFS) do
        local build_symbol = {def.build or "farm_plant_" .. name, "swap_body"}
        anim_build_symbols[name .. "_oversized"]       = build_symbol
        anim_build_symbols[name .. "_oversized_waxed"] = build_symbol
    end

    local function get_equipped_item(inventory, type)
        local candidate = inventory:GetEquippedItem(EQUIPSLOTS_MAP[string.upper(type)])
        return ((candidate ~= nil) and candidate:HasTag(type)) and candidate or nil
    end

    local function render_equipped_item(owner, render_slot, item)
        if item ~= nil then
            local build_symbol = anim_build_symbols[item.prefab]
            if build_symbol ~= nil then
                local skin_build = item:GetSkinBuild()
                if skin_build ~= nil then
                    owner.AnimState:OverrideItemSkinSymbol(render_slot, skin_build, "swap_body", item.GUID, build_symbol[1])
                else
                    owner.AnimState:OverrideSymbol(render_slot, build_symbol[1], build_symbol[2])
                end
            end
        else
            owner.AnimState:ClearOverrideSymbol(render_slot)
        end
    end

    local function render_body_equipment(owner)
        local inventory = owner.replica.inventory

        local item1 =
                   get_equipped_item(inventory, EQUIP_TYPES.BACKPACK)
                or get_equipped_item(inventory, EQUIP_TYPES.BAND)
                or get_equipped_item(inventory, EQUIP_TYPES.SHELL)
        local item2 =
                   get_equipped_item(inventory, EQUIP_TYPES.HEAVY)
                or get_equipped_item(inventory, EQUIP_TYPES.LIFEVEST)
                or get_equipped_item(inventory, EQUIP_TYPES.ARMOR)
                or get_equipped_item(inventory, EQUIP_TYPES.CLOTHING)
                or get_equipped_item(inventory, EQUIP_TYPES.AMULET)

        render_equipped_item(owner, "swap_body_tall", item1)
        render_equipped_item(owner, "swap_body",      item2)
    end

    local function on_equip_or_unequip(owner, data)
        if (data.eslot == GLOBAL.EQUIPSLOTS.BODY) or table.contains(EXTRA_EQUIPSLOTS, data.eslot) then
            render_body_equipment(owner)
        end
    end

    AddComponentPostInit("inventory", function(_, inst)
        inst:ListenForEvent("equip",   on_equip_or_unequip)
        inst:ListenForEvent("unequip", on_equip_or_unequip)
    end)

end
