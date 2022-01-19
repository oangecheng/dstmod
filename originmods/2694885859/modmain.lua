GLOBAL.setmetatable(env,{__index=function(t,k) return GLOBAL.rawget(GLOBAL,k) end})

PrefabFiles = {
	"portablebag",
}

local lang = LanguageTranslator.defaultlang
if lang == "zh" then
	STRINGS.NAMES.PORTABLEBAG = "便携袋子"
	STRINGS.RECIPE_DESC.PORTABLEBAG = "背包格子永远都不够用"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.PORTABLEBAG = "感谢大自然的馈赠"
else
	STRINGS.NAMES.PORTABLEBAG = "Portable Bag"
	STRINGS.RECIPE_DESC.PORTABLEBAG = "The backpack grid will never be enough"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.PORTABLEBAG = "Thank nature for its gifts"
end

AddRecipe(
    "portablebag",
    {Ingredient("dragon_scales", 1), Ingredient("bearger_fur", 1), Ingredient("shroom_skin", 1)},
    RECIPETABS.MAGIC,
    TECH.MAGIC_TWO,
    nil, nil, nil, nil, nil,
    "images/portablebag.xml",
    "portablebag.tex"
)

-----------------------------------------read persistent pt-------------------------------------

local function getdragpt(inst)
	TheSim:GetPersistentString("portablebag", function(load_success, str)
		if load_success == true and str ~= nil then
			inst.portablebag_dragpt = json.decode(str)
		end
	end)
end

AddPlayerPostInit(function(inst)

	if not TheWorld.ismastersim then
		getdragpt(inst)
		return inst
	end
end)

-----------------------------------------drag and drop------------------------------------------

AddClassPostConstruct("widgets/containerwidget", function(self)

	local function MOD_EndDrag(self, container)
		if self.mod_draghandler ~= nil then
			self.mod_draghandler:Remove()
			self.mod_draghandler = nil
		end

		local pt = self:GetPosition()
		if ThePlayer.portablebag_dragpt == nil then
			ThePlayer.portablebag_dragpt = {}
		end
		ThePlayer.portablebag_dragpt = {x = pt.x, y = pt.y, z = pt.z}
		TheSim:SetPersistentString("portablebag", json.encode(ThePlayer.portablebag_dragpt))
	end

	local function MOD_StartDrag(self, container, offset)
		if self.mod_draghandler == nil then
			self.mod_draghandler = TheInput:AddMoveHandler(function(x,y)
				if ThePlayer.HUD and ThePlayer.HUD.mod_candrag then
					self:SetPosition(Vector3(x, y, 0) + offset)
				else
					MOD_EndDrag(self, container)
				end
			end)
		end
	end

	local _Open = self.Open
	function self:Open(container, doer)
		_Open(self, container, doer)

		if container.prefab == "portablebag" then
			if ThePlayer.portablebag_dragpt ~= nil then
				local pt = ThePlayer.portablebag_dragpt
				local pot = Vector3(pt.x, pt.y, pt.z)
				self:SetPosition(pot)
			end
			self.OnMouseButton = function(self, button, down, x, y)
				if button == MOUSEBUTTON_LEFT and ThePlayer.HUD and ThePlayer.HUD.mod_candrag then
					local mousept = TheInput:GetScreenPosition()
					local widgetpt = self:GetPosition()
					local offset = widgetpt - mousept
					MOD_StartDrag(self, container, offset)
				else
					MOD_EndDrag(self, container)
				end
			end
		end
	end
end)

AddClassPostConstruct("widgets/widget", function(self)
	local _OnControl = self.OnControl
	function self:OnControl(control, down)
		if control == CONTROL_FORCE_STACK and down then
			self.mod_candrag = true
		elseif control == CONTROL_FORCE_STACK and not down then
			self.mod_candrag = false
		end
		return _OnControl(self, control, down)
	end
end)


