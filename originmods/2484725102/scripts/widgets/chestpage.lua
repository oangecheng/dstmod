local Widget = require("widgets/widget")
local Image = require("widgets/image")
local ImageButton = require("widgets/imagebutton")
local Text = require("widgets/text")

local ChestPage = Class(Widget, function(self, chestupgrade)
    Widget._ctor(self, "ChestPage")
	self.chestupgrade = chestupgrade

	self.pagebg = self:AddChild(ImageButton("images/hud.xml", "craft_slot.tex"))
	self.pagebg:SetScale(.8)
--	self.pagebg:SetPosition(0, -80, 0)
	self.pagebg.scale_on_focus = false
	self.pagebg.move_on_click = false
	self.pagebg:SetOnClick(function()
		SendModRPCToServer(GetModRPC("RPC_UPGCHEST", "sortcontent"), self.chestupgrade.inst)
	end)

	self.pgupbtn = self:AddChild(ImageButton("images/hud.xml", "craft_end_normal.tex", "craft_end_normal_mouseover.tex", "craft_end_normal_disabled.tex", nil, nil, {-.7}, {0,0}))
	self.pgupbtn:SetPosition(0, 60, 0)
	self.pgupbtn:SetOnClick(function()
		self:PageChange(-1)
	end)

	self.pgdnbtn = self:AddChild(ImageButton("images/hud.xml", "craft_end_normal.tex", "craft_end_normal_mouseover.tex", "craft_end_normal_disabled.tex", nil, nil, {.7}, {0,0}))
	self.pgdnbtn:SetPosition(0, -60, 0)
	self.pgdnbtn:SetOnClick(function()
		self:PageChange(1)
	end)

	self.currentpage = 1

	self.pagenum = self:AddChild(Text(TALKINGFONT, 35, string.format("%2d", self.currentpage), UICOLOURS.SILVER))
	self.pagenum:SetPosition(0, -3, 0)
end)

function ChestPage:SortContent()
	local x, y, z = self.chestupgrade:GetLv()
	local container = self.chestupgrade.inst.replica.container
end

function ChestPage:PageChange(delta)
	local inv = self:GetParent().inv

	--clamp currentpage between 1 and chestlv.z
	self.currentpage = math.clamp(self.currentpage + delta, 1, self.chestupgrade.chestlv.z)

	local x, y = self.chestupgrade:GetLv()
	local z = self.currentpage
	--hide the all slots widget, save resources(may be...)
	for i = 1, #inv do
		inv[i]:Hide()
	end
	--show the slots from the targeted page
	if self:GetParent().dragwidget then
		self:GetParent().dragwidget:ShowSection()
	else
		for i = x * y * (z - 1) + 1, x * y * z do
			inv[i]:Show()
			inv[i]:MoveToFront()
		end
	end
	self.pagenum:SetString(string.format("%2d", self.currentpage))
end

function ChestPage:SetPage(page)
	self.currentpage = page
	self:PageChange(0)
end

return ChestPage