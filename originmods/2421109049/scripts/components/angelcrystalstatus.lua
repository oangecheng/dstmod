local angelcrystalstatus = Class(function(self, inst)
    self.inst = inst
    self.SCIENCE = 1        ---1/2
    self.MAGIC = 1          ---1/2/3
    self.ANCIENT = 0        ---2/4
    self.SEAFARING = 0      --2
    self.CELESTIAL = 0      --1
    self.MOON_ALTAR = 0     --2
    self.FIRE_STATE = 0     --1/-1
    self.CARTOGRAPHY = 0    --2
end,
nil,
{
})

function angelcrystalstatus:OnSave()
    local data = {
        SCIENCE = self.SCIENCE,
        MAGIC = self.MAGIC,
        ANCIENT = self.ANCIENT,
        SEAFARING = self.SEAFARING,
        CELESTIAL = self.CELESTIAL,
        MOON_ALTAR = self.MOON_ALTAR,
        FIRE_STATE = self.FIRE_STATE,
        CARTOGRAPHY = self.CARTOGRAPHY,
    }
    return data
end

function angelcrystalstatus:OnLoad(data)
    self.SCIENCE = data.SCIENCE or 0
    self.MAGIC = data.MAGIC or 0
    self.ANCIENT = data.ANCIENT or 0
    self.SEAFARING = data.SEAFARING or 0
    self.CELESTIAL = data.CELESTIAL or 0
    self.MOON_ALTAR = data.MOON_ALTAR or 0
    self.FIRE_STATE = data.FIRE_STATE or 0
    self.CARTOGRAPHY = data.CARTOGRAPHY or 0
end

return angelcrystalstatus