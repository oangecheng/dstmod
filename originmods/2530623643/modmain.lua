GLOBAL.setmetatable(
	env,
	{
		__index = function(t, k)
			return GLOBAL.rawget(GLOBAL, k)
		end
	}
)

local ENABLE_AUTO_FUEL = GetModConfigData("enable_auto_fuel")

if ENABLE_AUTO_FUEL then
	Assets = {
		Asset("ANIM", "anim/ui_chest_3x3.zip")
	}

	local containers = require "containers"

	local params = {}

	local function Make3x3Chest()
		local chest = {
			widget = {
				slotpos = {},
				animbank = "ui_chest_3x3",
				animbuild = "ui_chest_3x3",
				pos = GLOBAL.Vector3(0, 200, 0),
				side_align_tip = 160
			},
			type = "chest"
		}

		for y = 2, 0, -1 do
			for x = 0, 2 do
				table.insert(chest.widget.slotpos, GLOBAL.Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
			end
		end

		return chest
	end

	local old_containers_widgetsetup = containers.widgetsetup
	function containers.widgetsetup(container, prefab, data, ...)
		local t = params[prefab or container.inst.prefab]
		if t ~= nil then
			for k, v in pairs(t) do
				container[k] = v
			end
			container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
		else
			old_containers_widgetsetup(container, prefab, data, ...)
		end
	end

	params.firesuppressor = Make3x3Chest()
	function params.firesuppressor.itemtestfn(container, item, slot)
		return item and item.prefab == "redgem" or item:HasTag(FUELTYPE.BURNABLE .. "_fuel") or
			item:HasTag(FUELTYPE.CHEMICAL .. "_fuel")
	end

	for _, v in pairs(params) do
		containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
	end

	local function PrintItemsInContainer(inst)
		if inst and inst.components and inst.components.container then
			for slot = 1, inst.components.container:GetNumSlots() do
				local item = inst.components.container:GetItemInSlot(slot)
				if item and item.components then
					if item.components.stackable then
						print(
							"########## " ..
								string.format(
									"in slot: %d, item: %s, stackable: true, stack size: %d",
									slot,
									item.prefab,
									item.components.stackable:StackSize()
								) ..
									" ##########"
						)
					else
						print(
							"########## " .. string.format("in slot: %d, item: %s, stackable: false", slot, item.prefab) .. " ##########"
						)
					end
				end
			end
		end
	end

	local function AddFuel(inst)
		local fuel_added = 0
		if inst and inst.components and inst.components.fueled and inst.components.container then
			if not inst.components.container:IsEmpty() then
				local fuel2add = inst.components.fueled.maxfuel
				for slot = 1, inst.components.container:GetNumSlots() do
					local item = inst.components.container:GetItemInSlot(slot)
					if item and item.components and item.components.fuel then
						local fuelvalue = inst.components.fueled.bonusmult * item.components.fuel.fuelvalue
						local amount_needed = math.floor(fuel2add / fuelvalue)
						if amount_needed <= 0 then
							return fuel_added
						end
						local amount_taken = 1

						if item.components.stackable then
							local stack_size = item.components.stackable:StackSize()
							amount_taken = math.min(amount_needed, stack_size)
							item.components.stackable:Get(amount_taken):Remove()
						else
							item:Remove()
						end

						local fuel_in_this_slot = amount_taken * fuelvalue
						fuel_added = fuel_added + fuel_in_this_slot
						fuel2add = fuel2add - fuel_in_this_slot
					end
				end
			end
		end
		return fuel_added
	end

	local function OnFuelEmpty(inst)
		local fuel_added = AddFuel(inst)
		if fuel_added == 0 then
			inst.components.machine:TurnOff()
		else
			inst.components.fueled:DoDelta(fuel_added)
		end
	end

	local function IsFuelEmpty(inst)
		if inst and inst.components then
			if inst.components.fueled and not inst.components.fueled:IsEmpty() then
				return false
			end
			if inst.components.container then
				for slot = 1, inst.components.container:GetNumSlots() do
					local item = inst.components.container:GetItemInSlot(slot)
					if
						item and item.components and item.components.fuel and
							(item.components.fuel.fueltype == FUELTYPE.BURNABLE or item.components.fuel.fueltype == FUELTYPE.CHEMICAL)
					 then
						return false
					end
				end
			end
		end
		return true
	end

	local function OnOpen(inst)
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
	end

	local function OnClose(inst)
		inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
	end

	AddPrefabPostInit(
		"firesuppressor",
		function(inst)
			if inst and TheWorld.ismastersim then
				inst:AddComponent("container")
				inst.components.container:WidgetSetup("firesuppressor")
				inst.components.container.onopenfn = OnOpen
				inst.components.container.onclosefn = OnClose
				inst.components.container.skipclosesnd = true
				inst.components.container.skipopensnd = true

				if inst.components then
					if inst.components.machine then
						local old_turnon = inst.components.machine.turnonfn
						inst.components.machine.turnonfn = function(_inst, _instant)
							if _inst.components.fueled and _inst.components.fueled:GetPercent() <= 0 then
								local fuel_added = AddFuel(_inst)
								_inst.components.fueled:DoDelta(fuel_added)
							end
							if old_turnon then
								old_turnon(_inst, _instant)
							end
						end
					end

					if inst.components.fueled then
						inst.components.fueled:SetDepletedFn(OnFuelEmpty)
					end

					if inst.components.workable then
						local old_onhammered = inst.components.workable.onfinish
						inst.components.workable:SetOnFinishCallback(
							function(_inst, _worker)
								if _inst.components.container then
									_inst.components.container:DropEverything()
								end

								if old_onhammered then
									old_onhammered(_inst, _worker)
								end
							end
						)
					end
				end

				inst:ListenForEvent(
					"seasontick",
					function(src, data)
						if inst and inst.components and inst.components.container then
							local last_slot = inst.components.container:GetNumSlots()
							local item = inst.components.container:GetItemInSlot(last_slot)
							if data and item and item.prefab == "redgem" and inst.components.machine then
								if data.season == "summer" and data.elapseddaysinseason == 0 and not inst.on and not IsFuelEmpty(inst) then
									inst.components.machine:TurnOn()
								elseif data.season == "autumn" and data.elapseddaysinseason == 0 and inst.on then
									inst.components.machine:TurnOff()
								end
							end
						end
					end,
					TheWorld
				)

				inst:ListenForEvent(
					"itemget",
					function(inst)
						if not IsFuelEmpty(inst) then
							inst:RemoveTag("fueldepleted")
						end
					end
				)

				inst:ListenForEvent(
					"itemlose",
					function(inst)
						if IsFuelEmpty(inst) then
							inst:AddTag("fueldepleted")
						end
					end
				)
			end
		end
	)
end
