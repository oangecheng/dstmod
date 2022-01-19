-- local function OnResetBeard(inst)
--     inst.AnimState:ClearOverrideSymbol("beard")
-- end

local function CanShaveTest(inst, shaver)
    if inst.components.beard and inst.components.beard.bits > 0 then
        return true
    else
        return false
    end
end

--tune the beard economy...
local WOOL_DAYS = { 5, 10, 15 }  -- Grow wool every 5 days
local WOOL_BITS = { 1, 2, 3 }

local function OnGrowShortWool(inst, skinname)
    inst.components.beard.bits = WOOL_BITS[1]
end

local function OnGrowMediumWool(inst, skinname)
    inst.components.beard.bits = WOOL_BITS[2]
end

local function OnGrowLongWool(inst, skinname)
    inst.components.beard.bits = WOOL_BITS[3]
end

local function WoolGrowSetup(inst)
	inst:AddComponent("beard")
    -- inst.components.beard.onreset = OnResetBeard
    inst.components.beard.prize = "steelwool"
    inst.components.beard.is_skinnable = true
    inst.components.beard.canshavetest = CanShaveTest
    inst.components.beard:AddCallback(WOOL_DAYS[1], OnGrowShortWool)
    inst.components.beard:AddCallback(WOOL_DAYS[2], OnGrowMediumWool)
    inst.components.beard:AddCallback(WOOL_DAYS[3], OnGrowLongWool)
end

return WoolGrowSetup