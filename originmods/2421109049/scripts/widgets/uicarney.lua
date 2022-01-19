local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local Widget = require "widgets/widget"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local AnimButton = require "widgets/animbutton"
local HoverText = require "widgets/hoverer"
local ttrstrs = STRINGS.TTRSTRINGS
local uistrs = STRINGS.TTRUI

local UITotooria = Class(Widget, function(self, owner)
	Widget._ctor(self, "uicarney")
	self.owner = owner
	----------------------------------------------------------------------------------------------------
    self.background = self:AddChild(Image("images/hud/background.xml", "background.tex"))
    self.background:SetTint(1,1,1,0.95)
    self.background:SetClickable(false)
    ----------------------------------------------------------------------------------------------------
    self.expindicator = self:AddChild(Widget("expindicator"))
	self.expindicator:SetPosition(12,28,0)
	
	self.exppercent = self.owner.currentexp:value()/100
	self.expindicator.anim = self.expindicator:AddChild(UIAnim())
	self.expindicator.anim:GetAnimState():SetBank("ttrexp")
	self.expindicator.anim:GetAnimState():SetBuild("ttrexp")
	self.expindicator.anim:GetAnimState():PlayAnimation("anim")
	self.expindicator.anim:GetAnimState():SetPercent("anim", self.exppercent)
	----------------------------------------------------------------------------------------------------
	local atlaslv = "images/hud/lv/0.xml"
    local imagelv = "0.tex"
    self.lvbutton = self:AddChild(Image(atlaslv, imagelv))
	self.lvbutton:SetPosition(-260.5,0,0)
	--self.lvbutton:MoveToFront()
	--self.lvbutton:SetImageNormalColour(1,1,1,1)
	--self.lvbutton:SetImageFocusColour(1,1,1,1)
	--self.lvbutton:SetNormalScale(1,1,1)
	--self.lvbutton:SetFocusScale(1.1,1.1,1.1)
    --self.lvbutton:SetOnClick( function() self:aaa(self,owner) end )
	----------------------------------------------------------------------------------------------------
	self.pointbg = self:AddChild(Image("images/hud/pointbg.xml", "pointbg.tex"))
    self.pointbg:SetTint(1,1,1,0)
    self.pointbg:SetPosition(-131,0,0)
    ----------------------------------------------------------------------------------------------------
	self.colorred = {201/255,78/255,78/255,.95}
	self.colorgreen = {120/255,166/255,7/255,.95}
	self.colorblue = {57/255,180/255,180/255,.95}
	self.colorwhite = {1,1,1,.95}
	self.colorgray = {187/255,164/255,131/255,1}

	self.point01 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point02 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point03 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point04 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point05 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point06 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point07 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point08 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point09 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point10 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point11 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point12 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point13 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point14 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point15 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point16 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point17 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point18 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point19 = self:AddChild(Image("images/hud/point.xml", "point.tex"))
	self.point20 = self:AddChild(Image("images/hud/point.xml", "point.tex"))

	self.point = 
	{
	self.point01,
	self.point02,
	self.point03,
	self.point04,
	self.point05,
	self.point06,
	self.point07,
	self.point08,
	self.point09,
	self.point10,
	self.point11,
	self.point12,
	self.point13,
	self.point14,
	self.point15,
	self.point16,
	self.point17,
	self.point18,
	self.point19,
	self.point20,
	}

	for i = 1, #self.point do
		self.point[i]:SetPosition(-227+i*10-10,0,0)
		self.point[i]:SetClickable(false)
		self.point[i]:Hide()
	end
	----------------------------------------------------------------------------------------------------
	if TUNING.ttrlan then
		self.explain = self:AddChild(Image("images/hud/explain_ch.xml", "explain_ch.tex"))
	else
		self.explain = self:AddChild(Image("images/hud/explain_en.xml", "explain_en.tex"))
	end
    self.explain:SetPosition(0,432,0)
    self.explain:SetTint(1,1,1,0.95)
    self.explain:SetClickable(false)
    self.explain:Hide()
    self.exopen = false

    local atlaseup = "images/hud/up.xml"
    local imageup = "up.tex"
    self.explainbutton = self:AddChild(ImageButton(atlaseup, imageup, imageup, imageup))
	self.explainbutton:SetPosition(-260,55,0)
	self.explainbutton:SetImageNormalColour(1,1,1,0.65)
	self.explainbutton:SetImageFocusColour(1,1,1,1)
	self.explainbutton:SetNormalScale(1,1,1)
	self.explainbutton:SetFocusScale(1.1,1.1,1.1)
	self.explainbutton:SetHoverText(uistrs[1])
    self.explainbutton:SetOnClick( function() self:ExplainOpen(self,owner) end )

	----------------------------------------------------------------------------------------------------
    if TUNING.ttrlan then
    	self.skillpoint = self:AddChild(Image("images/hud/skillpoint_ch.xml", "skillpoint_ch.tex"))
    else
    	self.skillpoint = self:AddChild(Image("images/hud/skillpoint_en.xml", "skillpoint_en.tex"))
    end
    self.skillpoint:SetPosition(0,177,0)
    self.skillpoint:SetTint(1,1,1,0.95)
    self.skillpoint:SetClickable(false)
    self.skillpoint:Hide()
    self.spopen = false

    local atlasleft = "images/hud/left.xml"
    local imagesleft = "left.tex"
    self.skillpointbutton = self:AddChild(ImageButton(atlasleft, imagesleft, imagesleft, imagesleft))
	self.skillpointbutton:SetPosition(-304,0,0)
	self.skillpointbutton:SetImageNormalColour(1,1,1,0.65)
	self.skillpointbutton:SetImageFocusColour(1,1,1,1)
	self.skillpointbutton:SetNormalScale(1,1,1)
	self.skillpointbutton:SetFocusScale(1.1,1.1,1.1)
	self.skillpointbutton:SetHoverText(uistrs[2])
    self.skillpointbutton:SetOnClick( function() self:SkillPointOpen(self,owner) end )

	----------------------------------------------------------------------------------------------------
    if TUNING.ttrlan then
    	self.specialskill = self:AddChild(Image("images/hud/specialskill_ch.xml", "specialskill_ch.tex"))
    else
    	self.specialskill = self:AddChild(Image("images/hud/specialskill_en.xml", "specialskill_en.tex"))
    end
    self.specialskill:SetPosition(0,235,0)
    self.specialskill:SetTint(1,1,1,0.95)
    self.specialskill:SetClickable(false)
    self.specialskill:Hide()
    self.ssopen = false

    local atlasright = "images/hud/right.xml"
    local imageright = "right.tex"
    self.specialskillbutton = self:AddChild(ImageButton(atlasright, imageright, imageright, imageright))
	self.specialskillbutton:SetPosition(304,0,0)
	self.specialskillbutton:SetImageNormalColour(1,1,1,0.65)
	self.specialskillbutton:SetImageFocusColour(1,1,1,1)
	self.specialskillbutton:SetNormalScale(1,1,1)
	self.specialskillbutton:SetFocusScale(1.1,1.1,1.1)
	self.specialskillbutton:SetHoverText(uistrs[3])
    self.specialskillbutton:SetOnClick( function() self:SpeicalSkillOpen(self,owner) end )

	----------------------------------------------------------------------------------------------------
    local atlasshixue = "images/hud/shixue_none.xml"
    local imageshixue = "shixue_none.tex"
    self.buttonshixue = self:AddChild(ImageButton(atlasshixue, imageshixue, imageshixue, imageshixue))
	self.buttonshixue:SetPosition(180,0,0)
	self.buttonshixue:SetImageNormalColour(1,1,1,0.95)
	self.buttonshixue:SetImageFocusColour(1,1,1,1)
	self.buttonshixue:SetNormalScale(1,1,1)
	self.buttonshixue:SetFocusScale(1.1,1.1,1.1)
	self.buttonshixue:SetHoverText(uistrs[4])
    self.buttonshixue:SetOnClick( function() self:aaa(self,owner) end )

    local atlasyonggan = "images/hud/yonggan_none.xml"
    local imageyonggan = "yonggan_none.tex"
    self.buttonyonggan = self:AddChild(ImageButton(atlasyonggan, imageyonggan, imageyonggan, imageyonggan))
	self.buttonyonggan:SetPosition(220,0,0)
	self.buttonyonggan:SetImageNormalColour(1,1,1,0.95)
	self.buttonyonggan:SetImageFocusColour(1,1,1,1)
	self.buttonyonggan:SetNormalScale(1,1,1)
	self.buttonyonggan:SetFocusScale(1.1,1.1,1.1)
	self.buttonyonggan:SetHoverText(uistrs[5])
    self.buttonyonggan:SetOnClick( function() self:aaa(self,owner) end )

    local atlaslingqiao = "images/hud/lingqiao_none.xml"
    local imagelingqiao = "lingqiao_none.tex"
    self.buttonlingqiao = self:AddChild(ImageButton(atlaslingqiao, imagelingqiao, imagelingqiao, imagelingqiao))
	self.buttonlingqiao:SetPosition(260,0,0)
	self.buttonlingqiao:SetImageNormalColour(1,1,1,0.95)
	self.buttonlingqiao:SetImageFocusColour(1,1,1,1)
	self.buttonlingqiao:SetNormalScale(1,1,1)
	self.buttonlingqiao:SetFocusScale(1.1,1.1,1.1)
	self.buttonlingqiao:SetHoverText(uistrs[6])
    self.buttonlingqiao:SetOnClick( function() self:aaa(self,owner) end )

    local atlasyoushan = "images/hud/youshan.xml"
    local imageyoushan = "youshan.tex"
    self.buttonyoushan = self:AddChild(ImageButton(atlasyoushan, imageyoushan, imageyoushan, imageyoushan))
	self.buttonyoushan:SetPosition(5,0,0)
	self.buttonyoushan:SetImageNormalColour(1,1,1,0.15)
	self.buttonyoushan:SetImageFocusColour(1,1,1,0.15)
	self.buttonyoushan:SetNormalScale(1,1,1)
	self.buttonyoushan:SetFocusScale(1.1,1.1,1.1)
	self.buttonyoushan:SetHoverText(uistrs[7])
    self.buttonyoushan:SetOnClick( function() self:YoushanTurn(self,owner) end )

    local atlasdachu = "images/hud/dachu.xml"
    local imagedachu = "dachu.tex"
    self.buttondachu = self:AddChild(ImageButton(atlasdachu, imagedachu, imagedachu, imagedachu))
	self.buttondachu:SetPosition(45,0,0)
	self.buttondachu:SetImageNormalColour(1,1,1,0.15)
	self.buttondachu:SetImageFocusColour(1,1,1,0.15)
	self.buttondachu:SetNormalScale(1,1,1)
	self.buttondachu:SetFocusScale(1.1,1.1,1.1)
	self.buttondachu:SetHoverText(uistrs[8])
    self.buttondachu:SetOnClick( function() self:DachuTurn(self,owner) end )

    local atlasqiaoshou = "images/hud/qiaoshou.xml"
    local imageqiaoshou = "qiaoshou.tex"
    self.buttonqiaoshou = self:AddChild(ImageButton(atlasqiaoshou, imageqiaoshou, imageqiaoshou, imageqiaoshou))
	self.buttonqiaoshou:SetPosition(85,0,0)
	self.buttonqiaoshou:SetImageNormalColour(1,1,1,0.15)
	self.buttonqiaoshou:SetImageFocusColour(1,1,1,0.15)
	self.buttonqiaoshou:SetNormalScale(1,1,1)
	self.buttonqiaoshou:SetFocusScale(1.1,1.1,1.1)
	self.buttonqiaoshou:SetHoverText(uistrs[9])
    self.buttonqiaoshou:SetOnClick( function() self:QiaoshouTurn(self,owner) end )

    local atlasxuezhe = "images/hud/xuezhe.xml"
    local imagexuezhe = "xuezhe.tex"
    self.buttonxuezhe = self:AddChild(ImageButton(atlasxuezhe, imagexuezhe, imagexuezhe, imagexuezhe))
	self.buttonxuezhe:SetPosition(125,0,0)
	self.buttonxuezhe:SetImageNormalColour(1,1,1,0.15)
	self.buttonxuezhe:SetImageFocusColour(1,1,1,0.15)
	self.buttonxuezhe:SetNormalScale(1,1,1)
	self.buttonxuezhe:SetFocusScale(1.1,1.1,1.1)
	self.buttonxuezhe:SetHoverText(uistrs[10])
    self.buttonxuezhe:SetOnClick( function() self:XuezheTurn(self,owner) end )
    ----------------------------------------------------------------------------------------------------
	self.specialskillbutton:MoveToFront()
	self.lvbutton:MoveToFront()
	self.skillpointbutton:MoveToFront()
	self.pointbg:MoveToFront()
	self.inst:DoTaskInTime(0.2, function()
		self.dengji = 0
		self.yijiajineng = -1
		self:StartUpdating()
	end)
end)

function UITotooria:LvChange()
	local atlaslv = 
	{
	"images/hud/lv/1.xml",
	"images/hud/lv/2.xml",
	"images/hud/lv/3.xml",
	"images/hud/lv/4.xml",
	"images/hud/lv/5.xml",
	"images/hud/lv/6.xml",
	"images/hud/lv/7.xml",
	"images/hud/lv/8.xml",
	"images/hud/lv/9.xml",
	"images/hud/lv/10.xml",
	"images/hud/lv/11.xml",
	"images/hud/lv/12.xml",
	"images/hud/lv/13.xml",
	"images/hud/lv/14.xml",
	"images/hud/lv/15.xml",
	"images/hud/lv/16.xml",
	"images/hud/lv/17.xml",
	"images/hud/lv/18.xml",
	"images/hud/lv/19.xml",
	"images/hud/lv/20.xml",
	"images/hud/lv/0.xml",
	}
	local imagelv = 
	{
	"1.tex",
	"2.tex",
	"3.tex",
	"4.tex",
	"5.tex",
	"6.tex",
	"7.tex",
	"8.tex",
	"9.tex",
	"10.tex",
	"11.tex",
	"12.tex",
	"13.tex",
	"14.tex",
	"15.tex",
	"16.tex",
	"17.tex",
	"18.tex",
	"19.tex",
	"20.tex",
	"0.tex",
	}
	local lv = self.owner.currentdengji:value()
	if lv ~= 0 then
		self.lvbutton:SetTexture(atlaslv[lv], imagelv[lv])
	else
		self.lvbutton:SetTexture(atlaslv[21], imagelv[21])
	end

	if self.owner.currentdengji:value() >=5 then
		self.buttonyoushan:SetImageNormalColour(1,1,1,0.95)
		self.buttonyoushan:SetImageFocusColour(1,1,1,1)
	else
		self.buttonyoushan:SetImageNormalColour(1,1,1,0.15)
		self.buttonyoushan:SetImageFocusColour(1,1,1,0.15)
	end

	if self.owner.currentdengji:value() >=10 then
		self.buttondachu:SetImageNormalColour(1,1,1,0.95)
		self.buttondachu:SetImageFocusColour(1,1,1,1)
	else
		self.buttondachu:SetImageNormalColour(1,1,1,0.15)
		self.buttondachu:SetImageFocusColour(1,1,1,0.15)
	end

	if self.owner.currentdengji:value() >=15 then
		self.buttonqiaoshou:SetImageNormalColour(1,1,1,0.95)
		self.buttonqiaoshou:SetImageFocusColour(1,1,1,1)
	else
		self.buttonqiaoshou:SetImageNormalColour(1,1,1,0.15)
		self.buttonqiaoshou:SetImageFocusColour(1,1,1,0.15)
	end

	if self.owner.currentdengji:value() >=20 then
		self.buttonxuezhe:SetImageNormalColour(1,1,1,0.95)
		self.buttonxuezhe:SetImageFocusColour(1,1,1,1)
	else
		self.buttonxuezhe:SetImageNormalColour(1,1,1,0.15)
		self.buttonxuezhe:SetImageFocusColour(1,1,1,0.15)
	end
	----------------------------------------------------------------------------------------------------
	for i = 1, #self.point do
		if self.owner.currentdengji:value() >=i then
			self.point[i]:Show()
		else
			self.point[i]:Hide()
		end
	end
end
----------------------------------------------------------------------------------------------------
function UITotooria:TintUpDate()
	local tintdataowner = 
	{
	self.owner.currenttintdata01:value(),
	self.owner.currenttintdata02:value(),
	self.owner.currenttintdata03:value(),
	self.owner.currenttintdata04:value(),
	self.owner.currenttintdata05:value(),
	self.owner.currenttintdata06:value(),
	self.owner.currenttintdata07:value(),
	self.owner.currenttintdata08:value(),
	self.owner.currenttintdata09:value(),
	self.owner.currenttintdata10:value(),
	self.owner.currenttintdata11:value(),
	self.owner.currenttintdata12:value(),
	self.owner.currenttintdata13:value(),
	self.owner.currenttintdata14:value(),
	self.owner.currenttintdata15:value(),
	self.owner.currenttintdata16:value(),
	self.owner.currenttintdata17:value(),
	self.owner.currenttintdata18:value(),
	self.owner.currenttintdata19:value(),
	self.owner.currenttintdata20:value(),
	}
	for i = 1, #tintdataowner do
		local tintdata
		if tintdataowner[i] == 0 then
			tintdata = self.colorgray
		end
		if tintdataowner[i] == 1 then
			tintdata = self.colorred
		end
		if tintdataowner[i] == 2 then
			tintdata = self.colorgreen
		end
		if tintdataowner[i] == 3 then
			tintdata = self.colorblue
		end
		if tintdataowner[i] == 4 then
			tintdata = self.colorwhite
		end
		self.point[i]:SetTint(unpack(tintdata))
	end
end

function UITotooria:SkillChange()
	if self.owner.currentshixue:value() == 1 then
		self.buttonshixue:SetTextures("images/hud/shixue.xml", "shixue.tex", "shixue.tex", "shixue.tex")
	end
	if self.owner.currentyonggan:value() == 1 then
		self.buttonyonggan:SetTextures("images/hud/yonggan.xml", "yonggan.tex", "yonggan.tex", "yonggan.tex")
	end
	if self.owner.currentlingqiao:value() == 1 then
		self.buttonlingqiao:SetTextures("images/hud/lingqiao.xml", "lingqiao.tex", "lingqiao.tex", "lingqiao.tex")
	end

	self:TintUpDate()
end
----------------------------------------------------------------------------------------------------
function UITotooria:OnUpdate(dt)
	if self.owner.currentdengji:value() ~= self.dengji then
		self:LvChange()
		self.dengji = self.owner.currentdengji:value()
	end
	if self.owner.currentyijiajineng:value() ~= self.yijiajineng then
		self:SkillChange()
		self.yijiajineng = self.owner.currentyijiajineng:value()
	end
	--self.lvbutton:SetHoverText(ttrstrs[18]..(self.owner.currentdengji:value()).."  "..ttrstrs[34]..(self.owner.currentjinengdian:value()).."  "..ttrstrs[49]..(self.owner.currentexp:value()).."\n"..ttrstrs[19]..(10*self.owner.currentxingyun:value())..ttrstrs[20].."  "..ttrstrs[21]..(math.ceil(self.owner.currentdamage:value()/100))..ttrstrs[20].."  "..ttrstrs[22]..(2.5*self.owner.currentsudu:value())..ttrstrs[20].."  "..ttrstrs[23]..(6.25*self.owner.currentxueliang:value()))
	self.lvbutton:SetHoverText(ttrstrs[17]..(self.owner.currentdengji:value()))
	self.expindicator:SetHoverText("EXP "..(self.owner.currentexp:value()).."/100")
	self.pointbg:SetHoverText(ttrstrs[34]..(self.owner.currentjinengdian:value()).."\n"..ttrstrs[19]..(10*self.owner.currentxingyun:value())..ttrstrs[20].."  "..ttrstrs[21]..(math.ceil(self.owner.currentdamage:value()/100))..ttrstrs[20].."  "..ttrstrs[22]..(2.5*self.owner.currentsudu:value())..ttrstrs[20].."  "..ttrstrs[23]..(6.25*self.owner.currentxueliang:value()))
	if self.owner.currentexp:value() <= 100 then
		self.exppercent = self.owner.currentexp:value()/100
		self.expindicator.anim:GetAnimState():SetPercent("anim", self.exppercent)
	end
end

function UITotooria:ExplainOpen(self,owner)
	if self.exopen ~= true then
		self.explain:Show()
		self.explainbutton:SetTextures("images/hud/down.xml", "down.tex", "down.tex", "down.tex")
		self.exopen = true
	else
		self.explain:Hide()
		self.explainbutton:SetTextures("images/hud/up.xml", "up.tex", "up.tex", "up.tex")
		self.exopen = false
	end
end

function UITotooria:SkillPointOpen(self,owner)
	if self.spopen ~= true then
		self.skillpoint:Show()
		self.skillpointbutton:SetTextures("images/hud/right.xml", "right.tex", "right.tex", "right.tex")
		self.spopen = true
	else
		self.skillpoint:Hide()
		self.skillpointbutton:SetTextures("images/hud/left.xml", "left.tex", "left.tex", "left.tex")
		self.spopen = false
	end
end

function UITotooria:SpeicalSkillOpen(self,owner)
	if self.ssopen ~= true then
		self.specialskill:Show()
		self.specialskillbutton:SetTextures("images/hud/left.xml", "left.tex", "left.tex", "left.tex")
		self.ssopen = true
	else
		self.specialskill:Hide()
		self.specialskillbutton:SetTextures("images/hud/right.xml", "right.tex", "right.tex", "right.tex")
		self.ssopen = false
	end
end

local function SendCommand(fnstr)
	local x, _, z = TheSim:ProjectScreenPos(TheSim:GetPosition())
	TheNet:SendRemoteExecute(fnstr, x, z)
end

function UITotooria:GetCharacter(self,owner)
	return "UserToPlayer('"..self.owner.userid.."')"
end

local youshanon = 1
function UITotooria:YoushanTurn(self,owner)
	if self.owner.currentdengji:value() >=5 then
		if youshanon == 1 then
			SendCommand(string.format('local player = %s local v = player.components.totooriastatus if player and not player:HasTag("playerghost") and v then v:DoDeltaYoushan(-1) end', self:GetCharacter(self,owner)))
			self.buttonyoushan:SetTextures("images/hud/youshanoff.xml", "youshanoff.tex", "youshanoff.tex", "youshanoff.tex")
			self.owner.components.talker:Say(uistrs[17].."\n"..uistrs[21])
			youshanon = 0
		else
			SendCommand(string.format('local player = %s local v = player.components.totooriastatus if player and not player:HasTag("playerghost") and v then v:DoDeltaYoushan(1) end', self:GetCharacter(self,owner)))
			self.buttonyoushan:SetTextures("images/hud/youshan.xml", "youshan.tex", "youshan.tex", "youshan.tex")
			self.owner.components.talker:Say(uistrs[13].."\n"..uistrs[22])
			youshanon = 1
		end
	else
		self.owner.components.talker:Say(uistrs[23].."Lv5"..uistrs[24])
	end
end

local dachuon = 1
function UITotooria:DachuTurn(self,owner)
	if self.owner.currentdengji:value() >=10 then
		if dachuon == 1 then
			SendCommand(string.format('local player = %s local v = player.components.totooriastatus if player and not player:HasTag("playerghost") and v then v:DoDeltaDachu(-1) end', self:GetCharacter(self,owner)))
			self.buttondachu:SetTextures("images/hud/dachuoff.xml", "dachuoff.tex", "dachuoff.tex", "dachuoff.tex")
			self.owner.components.talker:Say(uistrs[18].."\n"..uistrs[21])
			dachuon = 0
		else
			SendCommand(string.format('local player = %s local v = player.components.totooriastatus if player and not player:HasTag("playerghost") and v then v:DoDeltaDachu(1) end', self:GetCharacter(self,owner)))
			self.buttondachu:SetTextures("images/hud/dachu.xml", "dachu.tex", "dachu.tex", "dachu.tex")
			self.owner.components.talker:Say(uistrs[14].."\n"..uistrs[22])
			dachuon = 1
		end
	else
		self.owner.components.talker:Say(uistrs[23].."Lv10"..uistrs[24])
	end
end

local qiaoshouon = 1
function UITotooria:QiaoshouTurn(self,owner)
	if self.owner.currentdengji:value() >=15 then
		if qiaoshouon == 1 then
			SendCommand(string.format('local player = %s local v = player.components.totooriastatus if player and not player:HasTag("playerghost") and v then v:DoDeltaQiaoshou(-1) end', self:GetCharacter(self,owner)))
			self.buttonqiaoshou:SetTextures("images/hud/qiaoshouoff.xml", "qiaoshouoff.tex", "qiaoshouoff.tex", "qiaoshouoff.tex")
			self.owner.components.talker:Say(uistrs[19].."\n"..uistrs[21])
			qiaoshouon = 0
		else
			SendCommand(string.format('local player = %s local v = player.components.totooriastatus if player and not player:HasTag("playerghost") and v then v:DoDeltaQiaoshou(1) end', self:GetCharacter(self,owner)))
			self.buttonqiaoshou:SetTextures("images/hud/qiaoshou.xml", "qiaoshou.tex", "qiaoshou.tex", "qiaoshou.tex")
			self.owner.components.talker:Say(uistrs[15].."\n"..uistrs[22])
			qiaoshouon = 1
		end
	else
		self.owner.components.talker:Say(uistrs[23].."Lv15"..uistrs[24])
	end
end

local xuezheon = 1
function UITotooria:XuezheTurn(self,owner)
	if self.owner.currentdengji:value() >=20 then
		if xuezheon == 1 then
			SendCommand(string.format('local player = %s local v = player.components.totooriastatus if player and not player:HasTag("playerghost") and v then v:DoDeltaXuezhe(-1) end', self:GetCharacter(self,owner)))
			self.buttonxuezhe:SetTextures("images/hud/xuezheoff.xml", "xuezheoff.tex", "xuezheoff.tex", "xuezheoff.tex")
			self.owner.components.talker:Say(uistrs[20].."\n"..uistrs[21])
			xuezheon = 0
		else
			SendCommand(string.format('local player = %s local v = player.components.totooriastatus if player and not player:HasTag("playerghost") and v then v:DoDeltaXuezhe(1) end', self:GetCharacter(self,owner)))
			self.buttonxuezhe:SetTextures("images/hud/xuezhe.xml", "xuezhe.tex", "xuezhe.tex", "xuezhe.tex")
			self.owner.components.talker:Say(uistrs[16].."\n"..uistrs[22])
			xuezheon = 1
		end
	else
		self.owner.components.talker:Say(uistrs[23].."Lv20"..uistrs[24])
	end
end

function UITotooria:aaa(self,owner)
	self.owner.components.talker:Say(uistrs[11].."\n"..uistrs[12])
end

--function UITotooria:OnGainFocus()
--	self.background:SetTint(1,1,1,1)
--end

--function UITotooria:OnLoseFocus()
--	self.background:SetTint(1,1,1,.75)
--end

--function UITotooria:OnControl (control, down)
--	if control == CONTROL_ACCEPT then
--		if down then
--			self:StartDrag()
--		else
--			self:EndDrag()
--		end
--	elseif control == CONTROL_SCROLLBACK then
--		self:Scale_DoDelta(-0.05)
--	elseif control == CONTROL_SCROLLFWD then
--		self:Scale_DoDelta(0.05)
--	end
--end

--function UITotooria:SetDragPosition(x, y, z)
--	local pos
--	if type(x) == "number" then
--		pos = Vector3(x, y, z)
--	else
--		pos = x
--	end
--	self:SetPosition(pos + self.dragPosDiff)
--end
--function UITotooria:StartDrag()
	-- based on Widget:FollowMouse()
--	if not self.followhandler then
--		local mousepos = TheInput:GetScreenPosition()
--		self.dragPosDiff = self:GetPosition() - mousepos
--		self.followhandler = TheInput:AddMoveHandler(function(x,y) self:SetDragPosition(x,y) end)
--		self:SetDragPosition(mousepos)
--	end
--end

--function UITotooria:EndDrag()
	-- based on Widget:StopFollowMouse()
--	if self.followhandler then
--		self.followhandler:Remove()
--	end
--	self.followhandler = nil
--	self.dragPosDiff = nil
--end
--function UITotooria:Scale_DoDelta(delta)
--	self.scale = math.max(self.scale+delta,0.1)
--	print("self.scale",self.scale)
--	self:SetScale(self.scale,self.scale,self.scale)
--end

return uicarney