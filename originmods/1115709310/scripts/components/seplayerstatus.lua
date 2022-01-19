require "SEscripts/itemlist"

local function seccoin(self,coin) self.inst.seccoin:set(coin) end
local function secexp(self,exp) self.inst.secexp:set(exp) end
local function seclevel(self,level) self.inst.seclevel:set(level) end
local function secvip(self,vip) self.inst.secvip:set(vip) end
local function secprecious(self,precious) self.inst.secprecious:set(precious) end
local function secpreciouschange(self,preciouschange) self.inst.secpreciouschange:set(preciouschange) end
local function secsoundm(self,soundm) self.inst.secsoundm:set(soundm) end

local seplayerstatus = Class(function(self, inst)
    self.inst = inst
    self.coin = 200
    self.exp = 0
    self.level = 1
    self.vip = 0
    self.discount = (1-self.level*5/100)^self.vip
    self.slist = {}
    self.precious = {}
    self:preciousbuild()

    self.alreadyspawn = false

    self.preciouschange = false
    self.soundm = false
    self.day = 0
    --self:GetDataFromTheWorld() --重生保留数据
    --因为不同TheWorld不同数据，故在其他世界重生后并不加载该世界的数据，而加载主世界的数据，暂时找不到解决办法
    --为防止下地洞买东西后重生刷新金币，暂不开启此功能
end,
nil,
{
	coin = seccoin,
	exp = secexp,
	level = seclevel,
	vip = secvip,
	precious = secprecious,
	preciouschange = secpreciouschange,
	soundm = secsoundm,
})

function seplayerstatus:numget()
	local num = math.random(#selist_precious)
	local check = false
    for i=1, #self.slist do
    	if num == self.slist[i] then
    		check = true
		end
	end
	if check == true then
		return self:numget()
	else
		return num
	end
end

function seplayerstatus:preciousbuild()
	self.slist = {}
	for i=1, 10+4*self.level do
		if i == 1 then
			table.insert(self.slist, 1)
		else
	    	table.insert(self.slist, self:numget())
	    end
	end
	self.precious = self.slist
end

function seplayerstatus:SendDataToTheWorld()
    if not TheWorld.ismastersim then return end
    if TheWorld and TheWorld.components.seworldstatus then
        local data = {
            coin = self.coin,
            exp = self.exp,
            level = self.level,
            alreadyspawn = self.alreadyspawn,
            precious = self.precious,
            day = self.day,
        }
        TheWorld.components.seworldstatus.playerdata[self.inst.userid] = data
    end
end

function seplayerstatus:GetDataFromTheWorld()
    if not TheWorld.ismastersim then return end
    self.inst:DoTaskInTime(0, function()
        if TheWorld and TheWorld.components.seworldstatus
        and TheWorld.components.seworldstatus.playerdata[self.inst.userid] and not self.alreadyspawn then
            local worlddata = TheWorld.components.seworldstatus.playerdata[self.inst.userid]
            self.coin = worlddata.coin
            self.exp = worlddata.exp
            self.level = worlddata.level
            --self.alreadyspawn = worlddata.alreadyspawn --重生不给法杖
            if worlddata.precious and #worlddata.precious ~= 0 then
                self.precious = worlddata.precious
            else
                self:preciousbuild()
            end
            self.day = worlddata.day
        end
    end)
end

function seplayerstatus:OnSave()
    local data = {
        coin = self.coin,
        exp = self.exp,
        level = self.level,
        alreadyspawn = self.alreadyspawn,
        precious = self.precious,
        day = self.day,
    }
    return data
end

function seplayerstatus:OnLoad(data)
    self.coin = data.coin or 0
    self.exp = data.exp or 0
    self.level = data.level or 0
    self.alreadyspawn = data.alreadyspawn or false
    if data.precious and #data.precious ~= 0 then
    	self.precious = data.precious
	else
    	self:preciousbuild()
    end
    self.day = data.day or 0
end

function seplayerstatus:DoDeltaCoin(amount, multi)
    if not multi then multi = 1 end
	if amount < 0 then
		self.coin = self.coin - math.ceil(-amount*self.discount)*multi
	else
		self.coin = self.coin + amount
		self.inst.components.talker:Say(STRINGS.SIMPLEECONOMY[9]..amount..STRINGS.SIMPLEECONOMY[18])
	end
	if self.coin >= 999999 then self.coin = 999999 end
	self.inst:PushEvent("SEDoDeltaCoin")

    if self.soundm == false then
        self.soundm = true
    else
        self.soundm = false
    end

	self:DoDeltaExp(math.abs(amount)*multi)
end

function seplayerstatus:DoDeltaExp(amount)
	if self.level < 5 then
		self.exp = self.exp + amount
		self.inst:PushEvent("SEDoDeltaExp")
		if self.exp >= (self.level+1)^3*1000 then
			local a = self.exp-(self.level+1)^3*1000
			self.exp = 0
			self.level = self.level + 1
			self.inst:PushEvent("SELevelUp")
			self.inst:DoTaskInTime(1, function()
				self.inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")
				self.inst.components.talker:Say(STRINGS.SIMPLEECONOMY[13])
			end)
			self:OnVIP(self.vip)
			self:DoDeltaExp(a)
		end
	else
		self.exp = 125000
	end
    self:SendDataToTheWorld()
end

function seplayerstatus:OnVIP(value)
	self.vip = value
	self.discount = (1-self.level*5/100)^self.vip
end

local function findinventory(owner)
    local item = {}
    if owner.components.inventory then
        for k_i, v_i in pairs(owner.components.inventory.itemslots) do
            if v_i then table.insert(item, v_i) end
        end
        for k_e, v_e in pairs(owner.components.inventory.equipslots) do
            if v_e then table.insert(item, v_e) end
        end
        if owner.components.inventory.activeitem then
        	table.insert(item, owner.components.inventory.activeitem)
        end
    elseif owner.components.container then
        for k_x, v_x in pairs(owner.components.container.slots) do
            if v_x then table.insert(item, v_x) end
        end
    end
    for k_a, v_a in pairs(item) do
        if v_a and v_a.components and v_a.components.container then
            for k_c, v_c in pairs(findinventory(v_a)) do
                if v_c then table.insert(item, v_c) end
            end
        end
    end
    return item
end

local function findcard(owner)
    local cards = {}
    if not owner then return end
    for k,v in pairs(findinventory(owner)) do
        if v and v.prefab == "vipcard" then
            table.insert(cards, v)
        end
    end
    return cards
end

function seplayerstatus:checkvip(data)
    local cards = findcard(self.inst)
    self:OnVIP(#cards ~= 0 and 1 or 0)
    for k,v in pairs(cards) do
    	if v then
    		v.components.finiteuses:SetUses(self.level*5)
    	end
    end
end

function seplayerstatus:givesecoin(secoin)
	local price = 0
	if secoin ~= nil then
		price = secoin.components.secoin.amount
        local x1,y1,z1 = self.inst.Transform:GetWorldPosition()
        local x0,y0,z0 = secoin.Transform:GetWorldPosition()
        local x,y,z = Vector3(0,0,0)
        local maxtime = 5
        for i=1, maxtime do
        	self.inst:DoTaskInTime(FRAMES*i, function()
        		if secoin == nil then return end
        		x1,y1,z1 = self.inst.Transform:GetWorldPosition()
        		x0,y0,z0 = secoin.Transform:GetWorldPosition()
        		x = x1 - x0
        		y = y1 - y0
        		z = z1 - z0
        		secoin.Transform:SetPosition(x/(maxtime-i)+x0,y/(maxtime-i)+y0,z/(maxtime-i)+z0)
        		if i == maxtime then
					self:DoDeltaCoin(price)
                    if secoin then
            			secoin:Remove()
                    end
        		end
    		end)
        end
	end
end

function seplayerstatus:Init(inst)
    inst:DoTaskInTime(5, function()
        if inst.components.seplayerstatus.alreadyspawn ~= true then
            inst.components.seplayerstatus.alreadyspawn = true
            self:SendDataToTheWorld()
            local item = SpawnPrefab("goldstaff")
            inst.components.inventory:GiveItem(item, nil, inst:GetPosition())
            inst.components.talker:Say(STRINGS.SIMPLEECONOMY[1])
        end
    end)
    inst:ListenForEvent("cycleschanged", function()
    	self.day = self.day + 1
    	if self.day >= 3 then
    		self.day = 0
	    	self:preciousbuild()
	    	if self.preciouschange == true then
	    		self.preciouschange = false
	    	else
	    		self.preciouschange = true
	    	end
	    end
        self:SendDataToTheWorld()
	end, TheWorld)

	--监听身上vip卡变化
    local checkvipfn = function(_, data)
        self:checkvip(data)
    end
	inst:ListenForEvent("SELevelUp", checkvipfn)
    inst:ListenForEvent("equip", checkvipfn)
    inst:ListenForEvent("unequip", checkvipfn)
end

return seplayerstatus