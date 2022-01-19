------------------------传送塔RPC---------------------------
AddModRPCHandler(
	"Functional_medal",
	"Delivery",--传送
	function(player, inst, index)
		local medal_delivery = inst.components.medal_delivery
		if medal_delivery ~= nil then
			medal_delivery:Delivery(player, index)
		end
	end
)

AddModRPCHandler(
	"Functional_medal",
	"RemoveMarkPos",--移除标记点
	function(player, inst, index)
		local medal_delivery = inst.components.medal_delivery
		if medal_delivery ~= nil then
			medal_delivery:RemoveMarkPos(index)
		end
	end
)

--获取物品信息RPC
AddModRPCHandler(
	"Functional_medal",
	"Showinfo",
	function(player, guid, item)
	if player.player_classified == nil then
		return
	end
	if item ~= nil and item.components ~= nil then
		local str=""
		--剩余可钓的鱼数量
		if item:HasTag("fishable") then
			if item.components.fishable then
				if item.components.fishable.bait_force then
					str=str.."\n"..STRINGS.MEDAL_INFO.BAIT_FORCE..item.components.fishable.bait_force
				end
				str=str.."\n"..STRINGS.MEDAL_INFO.FRONT..item.components.fishable.fishleft..STRINGS.MEDAL_INFO.AFTER
			end
		end
		--显示融合勋章内勋章
		if item:HasTag("multivariate_certificate") then
			if item.components.container then
				local numslots=item.components.container:GetNumSlots()
				local medalstr=""
				if numslots and numslots>0 then
					local medalcount=0
					for i=1,numslots do
						local medal=item.components.container:GetItemInSlot(i)
						if medal then
							local prefabname=medal:GetDisplayName() or medal.prefab
							if medalcount>0 and medalcount%3==0 then
								medalstr=medalstr.."\n"
							end
							medalstr=medalstr..prefabname.."|"
							medalcount=medalcount+1
						end
					end
				end
				if medalstr~="" then
					str=str.."\n"..string.sub(medalstr,1,-2)
				else
					str=str.."\n"..STRINGS.MEDAL_INFO.BLANK
				end
			end
		--显示女武神的考验记录
		elseif item.prefab=="valkyrie_test_certificate" then
			--警告次数
			if item.warningnum and item.warningnum>1 then
				str=str.."\n"..STRINGS.MEDAL_INFO.WARNING1..(item.warningnum-1)..STRINGS.MEDAL_INFO.WARNING2
			end
			--上次考验目标
			if item.lasttarget then
				local prefabname= STRINGS.NAMES[string.upper(item.lasttarget)] or item.lasttarget
				str=str.."\n"..STRINGS.MEDAL_INFO.LASTTARGET..prefabname
			end
		--显示女武神勋章的女武神之力
		elseif item.prefab=="valkyrie_certificate" then
			--女武神之力
			if item.valkyrie_power then
				str=str.."\n"..STRINGS.MEDAL_INFO.VALKYRIEPOWER..item.valkyrie_power
			end
		--显示虫木勋章的采摘目标、肥力
		elseif item.prefab=="plant_certificate" then
			if item.medal_fertility then
				str=str.."\n"..STRINGS.MEDAL_INFO.FERTILITY..item.medal_fertility
			end
			
			if item.picklist and #item.picklist>0 then
				local medalstr=""
				local count=0
				for _,v in ipairs(item.picklist) do
					local prefabname= STRINGS.NAMES[string.upper(v)] or v
					count=count+1
					medalstr=medalstr..prefabname..(count>=5 and "\n" or ",")
					count=count%5
				end
				str=str.."\n"..STRINGS.MEDAL_INFO.NEEDPICK.."\n"..string.sub(medalstr,1,-2)
			end
		--显示植物勋章、虫木花的肥力
		elseif item.prefab=="transplant_certificate" or item.prefab=="medal_wormwood_flower" then
			if item.medal_fertility then
				str=str.."\n"..STRINGS.MEDAL_INFO.FERTILITY..item.medal_fertility
			end
		--显示芦苇的魔法免疫力
		elseif item.prefab=="reeds" then
			if item.components.pickable and item.components.pickable.magic_immunity then
				str=str.."\n"..STRINGS.MEDAL_INFO.IMMUNITY..item.components.pickable.magic_immunity
			end
		--显示钓鱼勋章的池塘列表
		elseif item.prefab=="smallfishing_certificate" then
			str=str.."\n"..STRINGS.MEDAL_INFO.FISHINGPONDTIP
			if item.pondlist and GetTableSize(item.pondlist)>0 then
				local medalstr=STRINGS.MEDAL_INFO.FISHINGPOND
				local pondstr={
					pond_cave = STRINGS.MEDAL_INFO.PONDCAVE,
					pond_mos = STRINGS.MEDAL_INFO.PONDMOS,
				}
				for k,v in pairs(item.pondlist) do
					local addstr = pondstr[k] or ""
					medalstr=medalstr..addstr..(STRINGS.NAMES[string.upper(k)] or k)..":"..v..","
				end
				str=str.."\n"..string.sub(medalstr,1,-2)
			end
		--显示垂钓勋章的垂钓目标
		elseif item.prefab=="mediumfishing_certificate" then
			str=str.."\n"..STRINGS.MEDAL_INFO.NEEDFISHINGTIP
			if item.fishlist and #item.fishlist>0 then
				local medalstr=STRINGS.MEDAL_INFO.NEEDFISHING
				local count=0
				for _,v in ipairs(item.fishlist) do
					local prefabname= STRINGS.NAMES[string.upper(v)] or v
					count=count+1
					medalstr=medalstr..prefabname..(count>=5 and "\n" or ",")
					count=count%5
				end
				str=str.."\n"..string.sub(medalstr,1,-2)
			end
		--显示烹调勋章的料理列表
		elseif item.prefab=="cook_certificate" or item.prefab=="chef_certificate" then
			if item.needspicefood then
				str=str.."\n"..STRINGS.MEDAL_INFO.NEEDSPICE
			elseif item.foodlist then
				str=str.."\n"..(item.prefab=="cook_certificate" and STRINGS.MEDAL_INFO.FOODLOG or STRINGS.MEDAL_INFO.FOODLOG2)..#item.foodlist
			end
		--显示食人花手杖当前目标
		elseif item.prefab=="lureplant_rod" then
			if item.picktarget and #item.picktarget>0 then
				local medalstr=STRINGS.NAMES[string.upper(item.picktarget[1])]
				str=str.."\n"..STRINGS.MEDAL_INFO.PICKTARGET..medalstr
			end
		--显示制冰机剩余水量
		elseif item.prefab=="medal_ice_machine" then
			if item.store_up_water then
				str=str.."\n"..STRINGS.MEDAL_INFO.STOREUPWATER..item.store_up_water
			end
		--显示正义勋章荣誉
		elseif item.prefab=="justice_certificate" then
			if item.medal_honor then
				local medalstr=STRINGS.NAMES.KRAMPUS.."*"..item.medal_honor[1]..","
				medalstr=medalstr..STRINGS.NAMES.KLAUS.."*"..item.medal_honor[2]..","
				medalstr=medalstr..STRINGS.MEDAL_INFO.LOSSPACK.."*"..item.medal_honor[3]..","
				medalstr=medalstr..STRINGS.NAMES.MEDAL_MONSTER_ESSENCE.."*"..item.medal_honor[4]
				str=str.."\n"..STRINGS.MEDAL_INFO.HONOR..medalstr
			end
		--显示童心勋章的弹药列表
		elseif item.prefab=="childishness_certificate" then
			str=str.."\n"..STRINGS.MEDAL_INFO.CHILDISHNESSTIP
			if item.ammolist and GetTableSize(item.ammolist)>0 then
				local medalstr=STRINGS.MEDAL_INFO.CHILDISHNESSAMMO
				local count=0
				for k,v in pairs(item.ammolist) do
					count=count+1
					medalstr=medalstr..(STRINGS.NAMES[string.upper(k)] or k)..":"..v..(count>=4 and "\n" or ",")
					count=count%4
				end
				str=str.."\n"..string.sub(medalstr,1,-2)
			end
		--显示空间勋章绑定目标
		elseif item.prefab=="space_certificate" then
			if item.targetTeleporter and item.targetTeleporter.components.writeable then
				local tagetText=item.targetTeleporter.components.writeable:GetText() or STRINGS.DELIVERYSPEECH.NONAME
				str=str.."\n"..STRINGS.MEDAL_INFO.BINDTARGET..(tagetText=="" and STRINGS.DELIVERYSPEECH.NONAME or tagetText)
			end
		--显示时空勋章的时间之力
		elseif item.prefab=="space_time_certificate" then
			if item.timepower then
				str=str.."\n"..STRINGS.MEDAL_INFO.TIMEPOWER..item.timepower
			end
		end
		if str and str ~= "" then
			player.player_classified.net_medal_info:set(guid..";"..str)
		else
			player.player_classified.net_medal_info:set("")
		end
	end
end)

--存储容器坐标RPC
AddModRPCHandler(
	"Functional_medal",
	"SetDragPos",
	function(player, medal_drag_pos)
		player.medal_drag_pos:set(medal_drag_pos)
		--重置容器位置
		if medal_drag_pos=="" and player.components.inventory and player.components.inventory.opencontainers then
			for k, v in pairs(player.components.inventory.opencontainers) do
				if k.components.container then
					k.components.container:Close()
					k.components.container:Open(player)
				end
			end
		end
	end
)

--存储玩家摄像头方向RPC
AddModRPCHandler(
	"Functional_medal",
	"SetCameraHeading",
	function(player, camera_heading)
		-- TheNet:Announce("当前视角:"..camera_heading)
		if player and player.player_classified and player.player_classified.medalcameraheading then
			player.player_classified.medalcameraheading:set(camera_heading)
		end
	end
)