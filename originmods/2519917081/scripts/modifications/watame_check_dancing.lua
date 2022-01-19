local function IsDancing(inst)
    
    -- return (inst.AnimState:IsCurrentAnimation("emoteXL_loop_dance0")   -- /dance
    --         or inst.AnimState:IsCurrentAnimation("emoteXL_loop_dance1")  -- Unknown dance emote ??
    --         or inst.AnimState:IsCurrentAnimation("emoteXL_loop_dance2")  -- Unknown dance emote ??
    --         or inst.AnimState:IsCurrentAnimation("emoteXL_loop_dance3")  -- Unknown dance emote ??
    --         or inst.AnimState:IsCurrentAnimation("emoteXL_loop_dance4")  -- Unknown dance emote ??
    --         or inst.AnimState:IsCurrentAnimation("emoteXL_loop_dance5")  -- Unknown dance emote ??
    --         or inst.AnimState:IsCurrentAnimation("emoteXL_loop_dance6")  -- /chicken
    --         or inst.AnimState:IsCurrentAnimation("emoteXL_loop_dance7")  -- /step
    --         or inst.AnimState:IsCurrentAnimation("emoteXL_loop_dance8")  -- /robot
    --         or inst.AnimState:IsCurrentAnimation("emote_loop_toast")  -- /toast
    -- )
    local gesture = string.match(inst.entity:GetDebugString(), "anim: ([^ ]+) ")
    return string.find(gesture, "dance") or string.find(gesture, "toast")
end

return IsDancing