local Widget = require "widgets/widget"
local Image = require "widgets/image"
local Text = require "widgets/text"
local ImageButton = require "widgets/imagebutton"
local UIAnimButton = require "widgets/uianimbutton"

local UIAnim = require "widgets/uianim"

local function IsHUDScreen()
	local defaultscreen = false
	if TheFrontEnd:GetActiveScreen() and TheFrontEnd:GetActiveScreen().name and type(TheFrontEnd:GetActiveScreen().name) == "string" and TheFrontEnd:GetActiveScreen().name == "HUD" then
		defaultscreen = true
	end
	return defaultscreen
end

local blackdragon_sword_button = Class(Widget, function(self, owner)
	Widget._ctor(self, "blackdragon_sword_button")
	
	self.owner = owner
	self.inst:ListenForEvent("onremove", function()
		if self.handler ~= nil then
			self.handler:Remove()
		end
	end)
	
	self.handler = 
	TheInput:AddKeyDownHandler(KEY_R, function() 
		if not IsHUDScreen() then return end
		if self.owner and self.owner.replica.inventory and self.owner.replica.inventory:EquipHasTag("blackdragon_sword") then
			SendModRPCToServer( MOD_RPC["blackdragon_sword"]["blackdragon_sword"])
		end
	end)
end)

return blackdragon_sword_button