-- tier 1 is the rariest
local tier_1_dig_gacha_table = {
    "houndstooth",
    "boneshard",
    "goldnugget",
    "pigskin",
    "stinger",
    "potato",
    "silk",
    "spidergland",
}
local tier_2_dig_gacha_table = {
    "poop",
    "pinecone",
    "acorn",
    "cutreeds",
    "carrot",
    "charcoal",
    "red_cap",
    "green_cap",
    "blue_cap",
    "nitre",
}
local tier_3_dig_gacha_table = {
    "twigs",
    "cutgrass",
    "flint",
    "log",
    "rocks",
}

local function tablelength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

local function roll_dig_gacha()
    local tier_1_ladder = 5  -- 5%
    local tier_2_ladder = 25  -- 20%
    -- tier_3_ladder is anything else (75%)
    
    local chosen_table = tier_3_dig_gacha_table
    local rng = math.random(0, 100)

    if rng <= tier_1_ladder then
        chosen_table = tier_1_dig_gacha_table
    elseif rng <= tier_2_ladder then
        chosen_table = tier_2_dig_gacha_table
    end

    local item_idx = math.random(1, tablelength(chosen_table))
    return chosen_table[item_idx]
end

local function OwnerGatheringResource(inst)
    return inst.components.follower.leader ~= nil and
            inst.components.follower.leader.sg ~= nil and
            ( inst.components.follower.leader.sg:HasStateTag("chopping") or
              inst.components.follower.leader.sg:HasStateTag("mining") or 
              inst.components.follower.leader.sg:HasStateTag("digging") or 
              inst.components.follower.leader.sg:HasStateTag("netting") or 
              inst.components.follower.leader.sg:HasStateTag("reeling")
            )
end

local function SpawnDirtFx(inst)
    local dirt_fx = SpawnPrefab("groundpound_fx")
    dirt_fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    dirt_fx.Transform:SetScale(0.8,0.8,0.8)
end

local BubbaDigItem = 
function(inst)
    if TUNING.BUBBA_DIG_ENABLED and OwnerGatheringResource(inst) then
        if inst.components.timer ~= nil  then
            if inst.components.timer:TimerExists("dig_check_cooldown") ~= true then
                if math.random() <= TUNING.BUBBA_DIG_CHANCE then
                    inst.sg:GoToState("nuzzle")
                    -- TODO: fix sound not working or just remove it
                    inst:DoTaskInTime(0, function ()inst.components.locomotor:StopMoving() end)
                    inst:DoTaskInTime(0.2, function ()inst.SoundEmitter:PlaySound("dontstarve/creatures/together/pupington/pant") end) -- ! Not working
                    inst:DoTaskInTime(0.2, function () SpawnDirtFx(inst) end)
                    inst:DoTaskInTime(0.5, function () SpawnDirtFx(inst) end)
                    inst:DoTaskInTime(1, function () SpawnDirtFx(inst) end)
                    inst:DoTaskInTime(1, function ()inst.components.follower.leader.components.lootdropper:SpawnLootPrefab(roll_dig_gacha(), inst:GetPosition()) end) 
                    -- Above line works to make item spawns on Bubba even it has follower.leader.components
                    inst:DoTaskInTime(0, function ()inst.components.locomotor:WantsToRun() end)
                end
                inst.components.timer:StartTimer("dig_check_cooldown", TUNING.BUBBA_DIG_CHECK_CD)
            end
        end
    end
end

return BubbaDigItem
