--NOTE: This is a client side component. No server
--      logic should be driven off this component!

local function PushAlpha(self, alpha, most_alpha)
    self.inst.AnimState:OverrideMultColour(alpha, alpha, alpha, alpha)
    if self.inst.SoundEmitter ~= nil then
        self.inst.SoundEmitter:OverrideVolumeMultiplier(alpha / most_alpha)
    end
	if self.onalphachangedfn ~= nil then
		self.onalphachangedfn(self.inst, alpha, most_alpha)
	end
end

local amelia_transparent = Class(function(self, inst)
    self.inst = inst
    self.offset = math.random()
    self.osc_speed = .25 + math.random() * 2
    self.osc_amp = .25 --amplitude
    self.alpha = 0
    self.most_alpha = 1
    self.target_alpha = nil

    PushAlpha(self, 0, 1)
    inst:StartUpdatingComponent(self)
end)

function amelia_transparent:OnUpdate(dt)
    local player = ThePlayer
    if player == nil then
        self.target_alpha = 0
    else
        self.offset = self.offset + dt
        if player:HasTag("detective_glasses") then
            self.target_alpha = self.most_alpha
        else
            self.target_alpha = 0
        end
    end

    if self.alpha ~= self.target_alpha then
        self.alpha = self.alpha > self.target_alpha and
            math.max(self.target_alpha, self.alpha - dt) or
            math.min(self.target_alpha, self.alpha + dt)
        PushAlpha(self, self.alpha, self.most_alpha)
    end
end

function amelia_transparent:GetDebugString()
	return "alpha = "..self.alpha
end

return amelia_transparent