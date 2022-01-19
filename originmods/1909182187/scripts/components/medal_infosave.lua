local medal_infosave = Class(function(self, inst)
    self.inst = inst
	self.pytrade_loot={
		medal_statue_marble_gugugu={},--鸽子py交易列表
		medal_statue_marble_saltfish={},--咸鱼py交易列表
		medal_statue_marble_stupidcat={},--猫猫py交易列表
	}
	self.pickernum=0
end)

--和雕像进行py交易
function medal_infosave:DoPyTrade(statue,player)
	if statue and player and player.userid and not table.contains(self.pytrade_loot[statue.prefab],player.userid) then
		local pytimes=#self.pytrade_loot[statue.prefab]+1--第几次py交易
		self.pytrade_loot[statue.prefab][pytimes]=player.userid
		-- table.insert(self.pytrade_loot[statue.prefab],player.userid)
		if statue.pyTradeFn then
			statue:pyTradeFn(pytimes)
		end
	end
end
--是否已经py交易过
function medal_infosave:IsPyTraded(statue,player)
	return statue and player and player.userid and table.contains(self.pytrade_loot[statue.prefab],player.userid)
end

function medal_infosave:OnSave() 
	return  {pytrade_loot=deepcopy(self.pytrade_loot)}
end

function medal_infosave:OnLoad(data)       
	if data and data.pytrade_loot then
        self.pytrade_loot = deepcopy(data.pytrade_loot)
	end
end

return medal_infosave