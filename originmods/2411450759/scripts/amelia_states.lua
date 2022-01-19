local FRAMES = GLOBAL.FRAMES
local function ShakeIfClose_Pound(inst)
    GLOBAL.ShakeAllCameras(GLOBAL.CAMERASHAKE.VERTICAL, .7, .025, 1.25, inst, 40)
end

-- Dialogues to pick randomly when Amelia do a ground pound
local groundpound_dialogues = {
	"**Gremlin laughs**",
    "Fast and easy.",
    "Just like ur mom last night!",
    "Nothing beats a ground pound.",
    "GGEZ",
    "This is too EZ.",
    "Heh heh heh."
}

local function ame_gpound_pre()
    return 
    GLOBAL.State{
        name = "ame_pound_pre",
        tags = {"aoe", "doing", "busy", "nointerrupt", "nomorph","nopredict"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
            inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("superjump_pre")
            inst.AnimState:PushAnimation("superjump_lag", false)
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(false)
            end
            if not inst.components.health.invincible then
                inst._gp_invincible:set(true)
                inst:DoTaskInTime(1,function (inst)
                    if inst._gp_invincible:value() then
                        inst._gp_invincible:set(false)
                    end
                end)
            end
        end,

        timeline =
        {},
        events =
        {
            GLOBAL.EventHandler("animover", function(inst)
                inst.sg:GoToState("ame_gpound")
			end),
        },

        onexit = function(inst)end,
    }
end
local function ame_gpound()
    return 
    GLOBAL.State{
        name = "ame_gpound",
        tags = {"aoe", "doing", "busy", "nointerrupt", "nomorph","nopredict"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
            inst.AnimState:PlayAnimation("superjump")
            inst.AnimState:PushAnimation("superjump",false)
        end,

        timeline =
        {},
        events =
        {
            GLOBAL.EventHandler("animover", function(inst)
                inst.sg:GoToState("ame_gpound_ur_mom")
			end),
        },
        onexit = function(inst)end,
    }
end
local function ame_gpound_ur_mom()
    return
    GLOBAL.State{
        name = "ame_gpound_ur_mom",
        tags = {"aoe", "doing", "busy", "nointerrupt", "nomorph","nopredict"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.locomotor:Clear()
            inst.AnimState:PlayAnimation("superjump_land")
        end,

        timeline =
        {
            GLOBAL.TimeEvent(FRAMES * 5, function(inst)
                if inst.components.groundpounder then
                    inst.components.groundpounder:GroundPound()
                    ShakeIfClose_Pound(inst)
                end
            end),
        },
        events =
        {
            GLOBAL.EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
			end),
        },

        onexit = function(inst)
            inst.components.talker:Say(groundpound_dialogues[math.random(#groundpound_dialogues)])
            if inst.components.playercontroller ~= nil then
                inst.components.playercontroller:Enable(true)
            end
            if inst._gp_invincible:value() then
                inst._gp_invincible:set(false)
            end
        end,
    }
end

-- Server
AddStategraphState("wilson",ame_gpound_pre())
AddStategraphState("wilson",ame_gpound())
AddStategraphState("wilson",ame_gpound_ur_mom())
-- Client
AddStategraphState("wilson_client",ame_gpound_pre())
AddStategraphState("wilson_client",ame_gpound())
AddStategraphState("wilson_client",ame_gpound_ur_mom())