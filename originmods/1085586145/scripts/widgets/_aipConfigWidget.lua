--V2C: THIS IS A SCREEN NOT A WIDGET


local Screen=require "widgets/screen"
local Widget=require "widgets/widget"
local Text=require "widgets/text"
local TextEdit=require "widgets/textedit"
local Menu=require "widgets/menu"
local UIAnim=require "widgets/uianim"
local ImageButton=require "widgets/imagebutton"

local TEMPLATES=require "widgets/templates"

local function onaccept(inst,doer,widget)
if not widget.isopen then
return
end

--strip leading/trailing whitespace
local msg=widget:GetText()
local processed_msg=msg:match("^%s*(.-%S)%s*$") or ""
if msg~=processed_msg or #msg <=0 then
widget.edit_text:SetString(processed_msg)
widget.edit_text:SetEditing(true)
return
end

local writeable=inst.replica.writeable
if writeable~=nil then
writeable:Write(doer,msg)
end

if widget.config.acceptbtn.cb~=nil then
widget.config.acceptbtn.cb(inst,doer,widget)
end

doer.HUD:CloseAIPAutoConfigWidget()
end

local function oncancel(inst,doer,widget)
if not widget.isopen then
return
end

local writeable=inst.replica.writeable
if writeable~=nil then
writeable:Write(doer,nil)
end

if widget.config.cancelbtn.cb~=nil then
widget.config.cancelbtn.cb(inst,doer,widget)
end

doer.HUD:CloseAIPAutoConfigWidget()
end

local AutoConfigWidget=Class(Screen,function(self,owner,writeable,config)
Screen._ctor(self,"AIP_AutoConfig")

self.owner=owner
self.writeable=writeable
self.config=config

self.isopen=false

self._scrnw,self._scrnh=TheSim:GetScreenSize()

self:SetScaleMode(SCALEMODE_PROPORTIONAL)
self:SetMaxPropUpscale(MAX_HUD_SCALE)
self:SetPosition(0,0,0)
self:SetVAnchor(ANCHOR_MIDDLE)
self:SetHAnchor(ANCHOR_MIDDLE)

self.scalingroot=self:AddChild(Widget("aipConfigWidgetScalingRoot"))
self.scalingroot:SetScale(TheFrontEnd:GetHUDScale())
self.inst:ListenForEvent("continuefrompause",function()
if self.isopen then
self.scalingroot:SetScale(TheFrontEnd:GetHUDScale())
end
end,TheWorld)
self.inst:ListenForEvent("refreshhudsize",function(hud,scale)
if self.isopen then
self.scalingroot:SetScale(scale)
end
end,owner.HUD.inst)

self.root=self.scalingroot:AddChild(Widget("aipConfigWidgetRoot"))
self.root:SetScale(.6,.6,.6)


self.black=self.root:AddChild(Image("images/global.xml","square.tex"))
self.black:SetVRegPoint(ANCHOR_MIDDLE)
self.black:SetHRegPoint(ANCHOR_MIDDLE)
self.black:SetVAnchor(ANCHOR_MIDDLE)
self.black:SetHAnchor(ANCHOR_MIDDLE)
self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
self.black:SetTint(0,0,0,0)
self.black.OnMouseButton=function() oncancel(self.writeable,self.owner,self) end

self.bganim=self.root:AddChild(UIAnim())
self.bganim:SetScale(1,1,1)


self.shield=self.root:AddChild(TEMPLATES.CurlyWindow(40,365,1,1,67,-41))

self.shield.fill=self.root:AddChild(Image("images/fepanel_fills.xml","panel_fill_tall.tex"))
self.shield.fill:SetScale(.64,-.57)
self.shield.fill:SetPosition(8,12)
self.shield:SetPosition(0,0,0)














self.buttons={}
table.insert(self.buttons,{ text=config.cancelbtn.text,cb=function() oncancel(self.writeable,self.owner,self) end,control=config.cancelbtn.control })
table.insert(self.buttons,{ text=config.acceptbtn.text,cb=function() onaccept(self.writeable,self.owner,self) end,control=config.acceptbtn.control })







local menuoffset=config.menuoffset or Vector3(0,0,0)
if TheInput:ControllerAttached() then
local spacing=150
self.menu=self.root:AddChild(Menu(self.buttons,spacing,true,"none"))
self.menu:SetTextSize(40)
local w=self.menu:AutoSpaceByText(15)
self.menu:SetPosition(menuoffset.x-.5*w,menuoffset.y,menuoffset.z)
else
local spacing=110
self.menu=self.root:AddChild(Menu(self.buttons,spacing,true,"small"))
self.menu:SetTextSize(35)
self.menu:SetPosition(menuoffset.x-.5*spacing*(#self.buttons-1),menuoffset.y,menuoffset.z)
end

local defaulttext=""
if self.config.defaulttext~=nil then
if type(self.config.defaulttext)=="string" then
defaulttext=self.config.defaulttext
elseif type(self.config.defaulttext)=="function" then
defaulttext=self.config.defaulttext(self.writeable,self.owner)
end
end

self:OverrideText(defaulttext)







if config.animbank~=nil then
self.bganim:GetAnimState():SetBank(config.animbank)
end

if config.animbuild~=nil then
self.bganim:GetAnimState():SetBuild(config.animbuild)
end

if config.pos~=nil then
self.root:SetPosition(config.pos)
else
self.root:SetPosition(0,150,0)
end

self.isopen=true
self:Show()

self.bganim:GetAnimState():PlayAnimation("open")
end)

function AutoConfigWidget:OnBecomeActive()
self._base.OnBecomeActive(self)
--self.edit_text:SetFocus()
--self.edit_text:SetEditing(true)
end

function AutoConfigWidget:Close()
if self.isopen then
self.writeable=nil

self.bganim:GetAnimState():PlayAnimation("close")

self.black:Kill()
--self.edit_text:SetEditing(false)
--self.edit_text:Kill()
self.menu:Kill()

self.isopen=false

self.inst:DoTaskInTime(.3,function() TheFrontEnd:PopScreen(self) end)
end
end

function AutoConfigWidget:OverrideText(text)
--self.edit_text:SetString(text)
--self.edit_text:SetFocus()
end

function AutoConfigWidget:GetText()
--return self.edit_text:GetString()
return ""
end

function AutoConfigWidget:SetValidChars(chars)
--self.edit_text:SetCharacterFilter(chars)
end

function AutoConfigWidget:OnControl(control,down)
if AutoConfigWidget._base.OnControl(self,control,down) then return true end

if not down then
for i,v in ipairs(self.buttons) do
if control==v.control and v.cb~=nil then
v.cb()
return true
end
end
if control==CONTROL_OPEN_DEBUG_CONSOLE then
return true
end
end
end

return AutoConfigWidget
