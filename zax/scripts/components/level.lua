local Level = Class(function(self, inst)
	self.inst = inst
	self.level = 0
	self.maxlevel = 10
end, nil, {})


function Level:GetLevel()
	return self.level
end

-- 人物升级
-- 等级+count，并且触发升级回调给使用方
function Level:IncrLevel(count)
	if self.level >= self.maxlevel then 
		return
	end
	self.level = self.level + count
	self.onlevelupfn(self.inst)
end

-- 设置升级函数
function Level:OnLevelUp(fn)
	self.onlevelupfn = fn
end


-- 等级重置
function Level:ResetLevel()
	self.level = 0
	self.onlevelupfn(self.inst)
end


-- 保存等级
function Level:OnSave()
	return {
		level = self.level,
		maxlevel = self.maxlevel
	}
end

-- 恢复等级
function Level:OnLoad(data)
	if data.level then
		self.level = data.level
	end
	if data.maxlevel then
		self.maxlevel = data.maxlevel
	end

	self.onlevelupfn(self.inst)
end

return Level









