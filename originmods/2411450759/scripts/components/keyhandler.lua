local KeyHandler = Class(function(self, inst)
    self.inst = inst
    self.handler = TheInput:AddKeyHandler(function(key, down)
        self:OnRawKey(key, down) end )end)
        function KeyHandler:OnRawKey(key, down)
            local player = ThePlayer  	
            if (key and not down) and not IsPaused() then
                player:PushEvent("keypressed", {inst = self.inst, player = player, key = key})
            elseif (key and down) and not IsPaused() then
                player:PushEvent("keydown", {inst = self.inst, player = player, key = key})
            end
        end
    return KeyHandler

