local whiteberetstatus = Class(function(self, inst)
    self.inst = inst
    self.Walrushat = 0
    self.Beefalohat = 0
    self.Eyebrellahat = 0
end,
nil,
{
})

function whiteberetstatus:OnSave()
    local data = {
        Walrushat = self.Walrushat,
        Beefalohat = self.Beefalohat,
        Eyebrellahat = self.Eyebrellahat,
    }
    return data
end

function whiteberetstatus:OnLoad(data)
    self.Walrushat = data.Walrushat or 0
    self.Beefalohat = data.Beefalohat or 0
    self.Eyebrellahat = data.Eyebrellahat or 0
end

return whiteberetstatus