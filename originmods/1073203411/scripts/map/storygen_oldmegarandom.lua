require("map/network")
require("map/lockandkey")
require("map/stack")
require("map/terrain")
local MapTags = require("map/maptags")
local Rooms = require("map/rooms")

function print_lockandkey_ex(...)
	--print(...)
end
function print_lockandkey(...)
	--print(...)
end

--[[ 

Example story for DS

Goals: 
	Kill ALL the Spiders (The pig village is in trouble, can you defend it and remove the threat?)
	
	1. To get to the pig village you must first pass through a mountain pass
		LOCK: 	Bolder blocks your path
		KEY:		You must build a pickaxe 
	
	2. You must gather enough meat for the pigs so that they have time to help you with the spiders
		LOCK: 	Pig friendship (Pig village)
		KEY:		Meat

Requirements:
	1. 	LOCK: 	Narrow area that can be blocked with boulders
		KEY:		Rocks on the ground, Twigs/grass, time to dig through the boulders
	2.	LOCK: 	Pig village with pigs and fireplace
		KEY:		Sources of meat and ways to get it; Carrots & Rabbits, wandering spiders
	
So working backwards: (create a random number of empty nodes between each)

Area 0
	1. Create evil spider dens
	2. Create pig village far enough away from spider dens, but close enough to annoy them
	3. Create Meat source close enough to pig village (this includes wood/etc to stay safe at night) it probably wants to stay away from spiders
	4. Lock all this behind LOCK 1
Area 1
	1. Add rock source
	2. Add twigs/grass source
	3. Add Starting position
--]]

Story = Class(function(self, id, tasks, terrain, gen_params, level)
	self.id = id
	self.loop_blanks = 1
	self.gen_params = gen_params
	self.impassible_value = gen_params.impassible_value or GROUND.IMPASSABLE
	self.level = level

	self.tasks = {}
	for k,task in pairs(tasks) do
		self.tasks[task.id] = task
	end

	self.region_link_tasks = 1
	self.region_tasksets = {}
	for task_id, task in pairs(self.tasks) do
		local region_id = task.region_id or "mainland"
		if self.region_tasksets[region_id] == nil then
			self.region_tasksets[region_id] = {}
		end
		self.region_tasksets[region_id][task_id] = task
	end


	self.GlobalTags = {}
	self.TERRAIN = {}
	self.terrain = terrain
	
	self.rootNode = Graph(id.."_root", {})
    if gen_params.wormhole_prefab ~= nil then
        self.rootNode.wormholeprefab = gen_params.wormhole_prefab
    end

	self.startNode = nil

	self.map_tags = MapTags()
end)

function Story:GenerationPipeline()
	self:GenerateNodesFromTasks()

	local min_bg = self.level.background_node_range and self.level.background_node_range[1] or 0
	local max_bg = self.level.background_node_range and self.level.background_node_range[2] or 2
	self:AddBGNodes(min_bg, max_bg)
	self:AddCoveNodes()
	self:InsertAdditionalSetPieces()
	self:ProcessExtraTags() -- deprecated but leaving in for modders
	self:ProcessOceanContent()
end

function Story:ModRoom(roomname, room)
	local modfns = ModManager:GetPostInitFns("RoomPreInit", roomname)
	for i,modfn in ipairs(modfns) do
		print("Applying mod to room '"..roomname.."'")
		modfn(room)
	end
	
end

function Story:GetRoom(roomname)
	local newroom = deepcopy(Rooms.GetRoomByName(roomname))
    if newroom == nil then
        return nil
    end
    newroom.name = roomname
    newroom.type = newroom.type or NODE_TYPE.Default
	self:ModRoom(roomname, newroom)
	return newroom
end

function Story:PlaceTeleportatoParts()
	-- This is deprecated
	local RemoveExitTag = function(node)
		local newtags = {}
		for i,tag in ipairs(node.data.tags) do
			if tag ~= "ExitPiece" then
				table.insert(newtags, tag)
			end
		end
		node.data.tags = newtags
	end

	local IsNodeAnExit = function(node)
		if not node.data.tags then
			return false
		end
		for i,tag in ipairs(node.data.tags) do
			if tag == "ExitPiece" then
				return true
			end
		end
		return false
	end

	local AddPartToTask = function(part, task)
		local nodeNames = shuffledKeys(task.nodes)
		for i,name in ipairs(nodeNames) do
			if IsNodeAnExit(task.nodes[name]) then
				local extra = task.nodes[name].data.terrain_contents_extra
				if not extra then
					extra = {}
				end
				if not extra.static_layouts then
					extra.static_layouts = {}
				end
				table.insert(extra.static_layouts, part)
				RemoveExitTag(task.nodes[name])
				return true
			end
		end
		return false
	end

	local InsertPartnumIntoATask = function(partnum, partSpread, part, tasks)
		for id,task in pairs(tasks) do
			if task.story_depth == math.ceil(partnum*partSpread) then
				local success = AddPartToTask(part, task)
				-- Not sure why we need this, was causeing crash
				--assert( success or task.id == "TEST_TASK"or task.id == "MaxHome", "Could not add an exit part to task "..task.id)
				return success
			end
		end
		return false
	end

	local parts = self.level.ordered_story_setpieces or {}
	local maxdepth = -1
	for id, task_node in pairs(self.rootNode:GetChildren()) do
		if task_node.story_depth > maxdepth then
			maxdepth = task_node.story_depth
		end
	end
	local partSpread = maxdepth/#parts

	for partnum = 1,#parts do
		InsertPartnumIntoATask(partnum, partSpread, parts[partnum], self.rootNode:GetChildren())
	end
end

function Story:ProcessExtraTags()
	-- This is deprecated
	self:PlaceTeleportatoParts()
end

function Story:ProcessOceanContent()
	if self.level.ocean_population then
		print("[Ocean] Processing ocean fake room content.")

		if self.ocean_population == nil then
			self.ocean_population = {}
		end

		for _, room in pairs(self.level.ocean_population) do
			local data = self:GetRoom(room)
			if data then
				table.insert(self.ocean_population, {data = data})
			end
		end

		if self.level.ocean_population_setpieces then
			for k,v in ipairs(self.level.ocean_population_setpieces) do
				local content = self.ocean_population[math.random(#self.ocean_population)]
				if content.data.contents.countstaticlayouts == nil then
					content.data.contents.countstaticlayouts = {}
				end
				if content.data.contents.countstaticlayouts[v] == nil then
					content.data.contents.countstaticlayouts[v] = 0
				end
				content.data.contents.countstaticlayouts[v] = content.data.contents.countstaticlayouts[v] + 1
			end
		end
	end
end

function Story:InsertAdditionalSetPieces(task_nodes)
	local tasks = task_nodes or self.rootNode:GetChildren()
	for id, task in pairs(tasks) do
		if task.set_pieces ~= nil and #task.set_pieces >0 then
			for i,setpiece_data  in ipairs(task.set_pieces) do

				local is_entrance = function(room)
					-- return true if the room is an entrance
					return room.data.entrance ~= nil and room.data.entrance == true
				end
				local is_background_ok = function(room)
					-- return true if the piece is not backround restricted, or if it is but we are on a background
					return setpiece_data.restrict_to ~= "background" or room.data.type == "background"
				end
				local isnt_blank = function(room)
					return room.data.type ~= "blank" and room.data.value ~= GROUND.IMPASSABLE
				end

				local choicekeys = shuffledKeys(task.nodes)
				local choice = nil
				for i, choicekey in ipairs(choicekeys) do
					if not is_entrance(task.nodes[choicekey]) and is_background_ok(task.nodes[choicekey]) and isnt_blank(task.nodes[choicekey]) then
						choice = choicekey
						break
					end
				end

				if choice == nil then
					print("Warning! Couldn't find a spot in "..task.id.." for "..setpiece_data.name)
					break
				end

				--print("Setpiece Placing "..setpiece_data.name.." in "..task.id..":"..task.nodes[choice].id)

				if task.nodes[choice].data.terrain_contents.countstaticlayouts == nil then
					task.nodes[choice].data.terrain_contents.countstaticlayouts = {}
				end
				--print ("Set peice", name, choice, room_choices._et[choice].contents, room_choices._et[choice].contents.countstaticlayouts[name])
				task.nodes[choice].data.terrain_contents.countstaticlayouts[setpiece_data.name] = 1
			end		
		end
		if task.random_set_pieces ~= nil and #task.random_set_pieces > 0 then
			for k,setpiece_name in ipairs(task.random_set_pieces) do
				local choicekeys = shuffledKeys(task.nodes)
				local choice = nil
				for i, choicekey in ipairs(choicekeys) do
					local is_entrance = function(room)
						-- return true if the room is an entrance
						return room.data.entrance ~= nil and room.data.entrance == true
					end
					local isnt_blank = function(room)
						return room.data.type ~= NODE_TYPE.Blank
					end

					if not is_entrance(task.nodes[choicekey]) and isnt_blank(task.nodes[choicekey]) then
						choice = choicekey
						break
					end
				end

				if choice == nil then
					print("Warning! Couldn't find a spot in "..task.id.." for "..setpiece_name)
					break
				end

				--print("Random Placing "..setpiece_name.." in "..task.id..":"..task.nodes[choice].id)

				if task.nodes[choice].data.terrain_contents.countstaticlayouts == nil then
					task.nodes[choice].data.terrain_contents.countstaticlayouts = {}
				end
				-- print ("Set peice", name, choice, room_choices._et[choice].contents, room_choices._et[choice].contents.countstaticlayouts[name])
				task.nodes[choice].data.terrain_contents.countstaticlayouts[setpiece_name] = 1
			end
		end
	end
end

function Story:RestrictNodesByKey(startParentNode, unusedTasks)
    print("[Story Gen] RestrictNodesByKey")

	local lastNode = startParentNode
		
	local usedTasks = {}
	usedTasks[startParentNode.id] = startParentNode
	startParentNode.story_depth = 0
	local story_depth = 1
	local currentNode = nil

    local last_parent = 1 -- this is a desperate attempt to distribute the nodes better

    local function FindAttachNodes(taskid, node, target_tasks)

        local unlockingNodes = {}

        for target_taskid, target_node in pairs(target_tasks) do

            local locks = {}
            for i,v in ipairs(self.tasks[taskid].locks) do
                local lock = {keys=LOCKS_KEYS[v], unlocked = false}
                locks[v] = lock
            end

            local availableKeys = {} --What are we allowed to connect to this task?

            for i, v in ipairs(self.tasks[target_taskid].keys_given) do --Get the keys that the last area we generated gives
                availableKeys[v] = {}
                table.insert(availableKeys[v], target_node)
            end

            for lock, lockData in pairs(locks) do 						--For each lock:
                for key, keyNodes in pairs(availableKeys) do 			--Do we have a key...
                    for reqKeyIdx, reqKey in ipairs(lockData.keys) do 	--...for this lock?
                        if reqKey == key then 							--If yes, get the nodes
                            lockData.unlocked = true 					--Unlock the lock.
                        end
                    end
                end
            end

            local unlocked = true
            for lock, lockData in pairs(locks) do
                if lockData.unlocked == false then
                    unlocked = false
                    break
                end
            end

            if unlocked then
                unlockingNodes[target_taskid] = target_node
            else
            end
        end

        return unlockingNodes
    end

    while GetTableSize(unusedTasks) > 0 do
        local effectiveLastNode = lastNode
        print_lockandkey_ex("\n\n_______Attempting new connection_______")

        local candidateTasks = {}

        print_lockandkey_ex("Gathering new batch:")

        for taskid, node in pairs(unusedTasks) do
            local unlockingNodes = FindAttachNodes(taskid, node, usedTasks)

            if GetTableSize(unlockingNodes) > 0 then
                print_lockandkey_ex(taskid, GetTableSize(unlockingNodes))
                candidateTasks[taskid] = unlockingNodes
            end
        end

        local function AppendNode(in_node, parents)

            print_lockandkey_ex("#############Success! Making connection.#############")
            print_lockandkey_ex(string.format("Trying to connect %s", in_node.id))
            currentNode = in_node

            local lowest = {i = 999, node = nil}
            local highest = {i = -1, node = nil}
            for id, node in pairs(parents) do
                if node.story_depth >= highest.i then
                    highest.i = node.story_depth
                    highest.node = node
                end
                if node.story_depth < lowest.i then
                    lowest.i = node.story_depth
                    lowest.node = node
                end
            end

            if self.gen_params.branching == nil or self.gen_params.branching == "default" then
                last_parent = ((last_parent-1) % GetTableSize(parents)) + 1
                local parent_i = 1
                for k,v in pairs(parents) do
                    if parent_i < last_parent then
                        parent_i = parent_i + 1
                    else
                        last_parent = last_parent + 1
                        effectiveLastNode = v
                        break
                    end
                end
                 print_lockandkey_ex("\tAttaching "..currentNode.id.." to next key", effectiveLastNode.id)
            elseif self.gen_params.branching == "random" then
				local num_parents = GetTableSize(parents)
				if num_parents == 1 then
					local dummy
					dummy, effectiveLastNode = next(parents)
				else
					local choice = last_parent
					while (choice == last_parent) do
						choice = math.random(num_parents)
					end
					last_parent = choice
					for _, v in pairs(parents) do
						effectiveLastNode = v
						choice = choice - 1
						if choice <= 0 then
							break
						end
					end
				end
                print_lockandkey_ex("\tAttaching "..currentNode.id.." to random key" .. effectiveLastNode.id)
            elseif self.gen_params.branching == "most" then
                effectiveLastNode = lowest.node
                print_lockandkey_ex("\tAttaching "..currentNode.id.." to lowest key" .. effectiveLastNode.id)
            elseif self.gen_params.branching == "least" then
                effectiveLastNode = highest.node
                print_lockandkey_ex("\tAttaching "..currentNode.id.." to highest key" .. effectiveLastNode.id)
            elseif self.gen_params.branching == "never" then
                effectiveLastNode = lastNode
                print_lockandkey_ex("\tAttaching "..currentNode.id.." to end of chain" .. effectiveLastNode.id)
            end

            print_lockandkey_ex(string.format("Connected it to %s", effectiveLastNode.id))

            currentNode.story_depth = story_depth
            story_depth = story_depth + 1

            local lastNodeExit = effectiveLastNode:GetRandomNodeForExit()
            local currentNodeEntrance = currentNode.entrancenode or currentNode:GetRandomNodeForEntrance()

            assert(lastNodeExit)
            assert(currentNodeEntrance)

            if self.gen_params.island_percent ~= nil 
                and self.gen_params.island_percent >= math.random()
                and currentNodeEntrance.data.entrance == false then
                self:SeperateStoryByBlanks(lastNodeExit, currentNodeEntrance)
            else
                self.rootNode:LockGraph(effectiveLastNode.id..'->'..currentNode.id, lastNodeExit, currentNodeEntrance, {type="none", key=self.tasks[currentNode.id].locks, node=nil})
            end		

            -- print_lockandkey_ex("\t\tAdding keys to keyring:")
            -- for i,v in ipairs(self.tasks[currentNode.id].keys_given) do
            -- 	if availableKeys[v] == nil then
            -- 		availableKeys[v] = {}
            -- 	end
            -- 	table.insert(availableKeys[v], currentNode)
            -- 	print_lockandkey_ex("\t\t",KEYS_ARRAY[v])
            -- end

            unusedTasks[currentNode.id] = nil
            usedTasks[currentNode.id] = currentNode
            lastNode = currentNode
            currentNode = nil

        end

        if next(candidateTasks) == nil then
            print_lockandkey_ex("We aint found nothin'!! Making a random connection :( -- ")
            AppendNode( self:GetRandomNodeFromTasks(unusedTasks), usedTasks )
        else
            for taskid, unlockingNodes in pairs(candidateTasks) do
		        print_lockandkey_ex("Current Node: " .. taskid)
                print_lockandkey_ex("  PARENTS:")
                for k,v in pairs(unlockingNodes) do
                    print_lockandkey_ex("    " .. k)
                end
                AppendNode( unusedTasks[taskid], unlockingNodes )
            end
        end


    end

	return lastNode:GetRandomNodeForExit()
end

function Story:LinkNodesByKeys(startParentNode, unusedTasks)
    print("[Story Gen] LinkNodesByKeys")
	print_lockandkey_ex("\n\n### START PARENT NODE:",startParentNode.id)
	local lastNode = startParentNode
	local availableKeys = {}
	for i,v in ipairs(self.tasks[startParentNode.id].keys_given) do
		availableKeys[v] = {}
		table.insert(availableKeys[v], startParentNode)
	end
	local usedTasks = {}

	startParentNode.story_depth = 0
	local story_depth = 1
	local currentNode = nil
	
	while GetTableSize(unusedTasks) > 0 do
		local effectiveLastNode = lastNode

		print_lockandkey_ex("\n\n### About to insert a node. Last node:", lastNode.id)

		print_lockandkey_ex("\tHave Keys:")
		for key, keyNodes in pairs(availableKeys) do
			print_lockandkey_ex("\t\t",KEYS_ARRAY[key], GetTableSize(keyNodes))
		end

		for taskid, node in pairs(unusedTasks) do

			print_lockandkey_ex("  TASK: "..taskid)
			print_lockandkey_ex("\t Locks:")

			local locks = {}
			for i,v in ipairs(self.tasks[taskid].locks) do
				local lock = {keys=LOCKS_KEYS[v], unlocked=false}
				locks[v] = lock
				print_lockandkey_ex("\t\tLock:",LOCKS_ARRAY[v],tabletoliststring(lock.keys, function(x) return KEYS_ARRAY[x] end))
			end


			local unlockingNodes = {}

			for lock,lockData in pairs(locks) do						-- For each lock:
				print_lockandkey_ex("\tUnlocking",LOCKS_ARRAY[lock])
				for key, keyNodes in pairs(availableKeys) do			-- Do we have any key for
					for reqKeyIdx,reqKey in ipairs(lockData.keys) do	   -- this lock?
						if reqKey == key then							-- If yes, get the nodes with
																		   -- that key so that we
							for i,node in ipairs(keyNodes) do			   -- can potentially attach
								unlockingNodes[node.id] = node			   -- to one.
							end
							lockData.unlocked = true					-- Also unlock the lock
							print_lockandkey_ex("\t\t\tUnlocked!", KEYS_ARRAY[key])
						end
					end
				end
			end

			local unlocked = true
			for lock,lockData in pairs(locks) do
				print_lockandkey_ex("\tDid we unlock ", LOCKS_ARRAY[lock])
				if lockData.unlocked == false then
					print_lockandkey_ex("\t\tno.")
					unlocked = false
					break
				end
			end

			if unlocked then
				-- this task is presently unlockable!
				currentNode = node
				print_lockandkey_ex ("StartParentNode",startParentNode.id,"currentNode",currentNode.id)

				local lowest = {i=999,node=nil}
				local highest = {i=-1,node=nil}
				for id,node in pairs(unlockingNodes) do
					if node.story_depth >= highest.i then
						highest.i = node.story_depth
						highest.node = node
					end
					if node.story_depth < lowest.i then
						lowest.i = node.story_depth
						lowest.node = node
					end
				end

				if self.gen_params.branching == nil or self.gen_params.branching == "default" or self.gen_params.branching == "random" then
					effectiveLastNode = GetRandomItem(unlockingNodes)
					print_lockandkey("\tAttaching "..currentNode.id.." to random key", effectiveLastNode.id)
				elseif self.gen_params.branching == "most" then
					effectiveLastNode = lowest.node
					print_lockandkey("\tAttaching "..currentNode.id.." to lowest key", effectiveLastNode.id)
				elseif self.gen_params.branching == "least" then
					effectiveLastNode = highest.node
					print_lockandkey("\tAttaching "..currentNode.id.." to highest key", effectiveLastNode.id)
				elseif self.gen_params.branching == "never" then
					effectiveLastNode = lastNode
					print_lockandkey("\tAttaching "..currentNode.id.." to end of chain", effectiveLastNode.id)
				end

				break
			end

		end

		if currentNode == nil then
			currentNode = self:GetRandomNodeFromTasks(unusedTasks)
			print_lockandkey("\t\tAttaching random node "..currentNode.id.." to last node", effectiveLastNode.id)
		end

		currentNode.story_depth = story_depth
		story_depth = story_depth + 1

		local lastNodeExit = effectiveLastNode:GetRandomNodeForExit()
		local currentNodeEntrance = currentNode.entrancenode or currentNode:GetRandomNodeForEntrance()

		assert(lastNodeExit)
		assert(currentNodeEntrance)

		if self.gen_params.island_percent ~= nil and self.gen_params.island_percent >= math.random() and currentNodeEntrance.data.entrance == false then
			self:SeperateStoryByBlanks(lastNodeExit, currentNodeEntrance )
		else
			self.rootNode:LockGraph(effectiveLastNode.id..'->'..currentNode.id, lastNodeExit, currentNodeEntrance, {type="none", key=self.tasks[currentNode.id].locks, node=nil})
		end		

		print_lockandkey_ex("\t\tAdding keys to keyring:")
		for i,v in ipairs(self.tasks[currentNode.id].keys_given) do
			if availableKeys[v] == nil then
				availableKeys[v] = {}
			end
			table.insert(availableKeys[v], currentNode)
			print_lockandkey_ex("\t\t",KEYS_ARRAY[v])
		end

		unusedTasks[currentNode.id] = nil
		usedTasks[currentNode.id] = currentNode
		lastNode = currentNode
		currentNode = nil
	end

	return lastNode:GetRandomNodeForExit()
end

function Story:LinkNodesCustom(startParentNode, unusedTasks)
	print_lockandkey_ex("\n\n### START PARENT NODE:",startParentNode.id)
	local lastNode = startParentNode
	local availableKeys = {}
	for i,v in ipairs(self.tasks[startParentNode.id].keys_given) do
		availableKeys[v] = {}
		table.insert(availableKeys[v], startParentNode)
	end
	local usedTasks = {}

	startParentNode.story_depth = 0
	local story_depth = 1
	local currentNode = nil
	
	self.nodeList[0] = startParentNode
	
	
	while GetTableSize(unusedTasks) > 0 do
		local effectiveLastNode = lastNode

		print_lockandkey_ex("\n\n### About to insert a node. Last node:", lastNode.id)

		print_lockandkey_ex("\tHave Keys:")
		for key, keyNodes in pairs(availableKeys) do
			print_lockandkey_ex("\t\t",KEYS_ARRAY[key], GetTableSize(keyNodes))
		end

		if story_depth >= #self.level.central_tasks then
		
		for taskid, node in pairs(unusedTasks) do

			print_lockandkey_ex("  TASK: "..taskid)
			print_lockandkey_ex("\t Locks:")

			local locks = {}
			for i,v in ipairs(self.tasks[taskid].locks) do
				local lock = {keys=LOCKS_KEYS[v], unlocked=false}
				locks[v] = lock
				print_lockandkey_ex("\t\tLock:",LOCKS_ARRAY[v],tabletoliststring(lock.keys, function(x) return KEYS_ARRAY[x] end))
			end


			local unlockingNodes = {}

			for lock,lockData in pairs(locks) do						-- For each lock:
				print_lockandkey_ex("\tUnlocking",LOCKS_ARRAY[lock])
				for key, keyNodes in pairs(availableKeys) do			-- Do we have any key for
					for reqKeyIdx,reqKey in ipairs(lockData.keys) do	   -- this lock?
						if reqKey == key then							-- If yes, get the nodes with
																		   -- that key so that we
							for i,node in ipairs(keyNodes) do			   -- can potentially attach
								unlockingNodes[node.id] = node			   -- to one.
							end
							lockData.unlocked = true					-- Also unlock the lock
							print_lockandkey_ex("\t\t\tUnlocked!", KEYS_ARRAY[key])
						end
					end
				end
			end

			local unlocked = true
			for lock,lockData in pairs(locks) do
				print_lockandkey_ex("\tDid we unlock ", LOCKS_ARRAY[lock])
				if lockData.unlocked == false then
					print_lockandkey_ex("\t\tno.")
					unlocked = false
					break
				end
			end

			if unlocked then
				-- this task is presently unlockable!
				currentNode = node
				print_lockandkey_ex ("StartParentNode",startParentNode.id,"currentNode",currentNode.id)

				local lowest = {i=999,node=nil}
				local highest = {i=-1,node=nil}
				for id,node in pairs(unlockingNodes) do
					if node.story_depth >= highest.i then
						highest.i = node.story_depth
						highest.node = node
					end
					if node.story_depth < lowest.i then
						lowest.i = node.story_depth
						lowest.node = node
					end
				end

				if self.gen_params.branching == nil or self.gen_params.branching == "default" then
					effectiveLastNode = GetRandomItem(unlockingNodes)
					print_lockandkey("\tAttaching "..currentNode.id.." to random key", effectiveLastNode.id)
				elseif self.gen_params.branching == "most" then
					effectiveLastNode = lowest.node
					print_lockandkey("\tAttaching "..currentNode.id.." to lowest key", effectiveLastNode.id)
				elseif self.gen_params.branching == "least" then
					effectiveLastNode = highest.node
					print_lockandkey("\tAttaching "..currentNode.id.." to highest key", effectiveLastNode.id)
				elseif self.gen_params.branching == "never" then
					effectiveLastNode = lastNode
					print_lockandkey("\tAttaching "..currentNode.id.." to end of chain", effectiveLastNode.id)
				end

				break
			end

		end -- regular for loop

		
		else
			-- CENTRAL TASKS
			currentNode = unusedTasks[self.level.central_tasks[story_depth+1]]
		end -- central tasks

		
	
		
		if currentNode == nil then
			currentNode = self:GetRandomNodeFromTasks(unusedTasks)
			print_lockandkey("\t\tAttaching random node "..currentNode.id.." to last node", effectiveLastNode.id)
		end
		
		
		print("[Megarandom] ["..story_depth.."] TASK: "..currentNode.id)
		
		-- needed for custom world generation
		self.nodeList[story_depth] = currentNode
		
		currentNode.story_depth = story_depth
		story_depth = story_depth + 1
		
		local lastNodeExit = effectiveLastNode:GetRandomNode()
		local currentNodeEntrance = currentNode:GetRandomNode()
		if currentNode.entrancenode then
			currentNodeEntrance = currentNode.entrancenode
		end

		assert(lastNodeExit)
		assert(currentNodeEntrance)

		--TODO
		--if self.gen_params.island_percent ~= nil and self.gen_params.island_percent >= math.random() and currentNodeEntrance.data.entrance == false then
		--	self:SeperateStoryByBlanks(lastNodeExit, currentNodeEntrance )
		--else
		--	self.rootNode:LockGraph(effectiveLastNode.id..'->'..currentNode.id, lastNodeExit, currentNodeEntrance, {type="none", key=self.tasks[currentNode.id].locks, node=nil})
		--end		

		print_lockandkey_ex("\t\tAdding keys to keyring:")
		for i,v in ipairs(self.tasks[currentNode.id].keys_given) do
			if availableKeys[v] == nil then
				availableKeys[v] = {}
			end
			table.insert(availableKeys[v], currentNode)
			print_lockandkey_ex("\t\t",KEYS_ARRAY[v])
		end

		unusedTasks[currentNode.id] = nil
		usedTasks[currentNode.id] = currentNode
		lastNode = currentNode
		currentNode = nil
		
		-- debug
		--if 	story_depth == 2 then
		--	node2_debug = lastNode
		--end
		--if 	story_depth == 5 then
		--	node1_debug = lastNode
		--	local node1Exit = node1_debug:GetRandomNode()
		--	local node2Entrance = node2_debug:GetRandomNode()
		--	self.rootNode:LockGraph(node1_debug.id..'->'..node2_debug.id, node1Exit, node2Entrance, {type="none", key=self.tasks[node2_debug.id].locks, node=nil})
		--end
		
	end

	return story_depth-1
	--return lastNode:GetRandomNode()
end


function Story:GetRandomNodeFromTasks(taskSet)
	local sz = GetTableSize(taskSet)
	local task = nil
	if sz > 0 then
		local choice = math.random(sz) -1

		
		for taskid,_ in pairs(taskSet) do -- special order
			task = taskid
			if choice<= 0 then
				break
			end
			choice = choice -1
		end
	end
	--print("G2 task ", task)
	return self.TERRAIN[task]
end

function Story:GenerateNodesFromTasks()	
	--print("Story:GenerateNodesFromTasks creating stories")

	-- remove invalid central tasks
	local valid_central_tasks = {}
	local tasks_set = {}
	for _,task in pairs(self.tasks) do
		tasks_set[task.id] = true
	end

	for _,task in ipairs(self.level.central_tasks) do
		if tasks_set[task] then
			table.insert(valid_central_tasks,task)
		else
			print("[Megarandom] WARNING: removing invalid central task "..task)
		end
	end
	
	self.level.central_tasks = valid_central_tasks
	
	
	local unusedTasks = {}
	
	-- Generate all the TERRAIN
	for k,task in pairs(self.tasks) do
		if self.level.ignore_tasks[task.id] then
			print("[Megarandom] Task ",task.id,"ignored.")
		else
			--print("Story:GenerateNodesFromTasks k,task",k,task,  GetTableSize(self.TERRAIN))
			local node = self:GenerateNodesFromTask(task, task.crosslink_factor or 1)--0.5)
			self.TERRAIN[task.id] = node
			unusedTasks[task.id] = node
		end
	end
		
	--print("Story:GenerateNodesFromTasks lock terrain")
	
	local foldername = KnownModIndex:GetModActualName("Megarandom world")
	--print("foldername = ", foldername)
	
	local random_spawn = GetModConfigData("RandomSpawn", foldername)
	
	
	local startTasks = {}
	
	local task0_name = "Make a pick"
	-- If there are central tasks, let them have the task 0 instead
	if #self.level.central_tasks > 0 then
		task0_name = self.level.central_tasks[1]
	end
	
	for k,task in pairs(self.tasks) do
		--print("Found task ", task.id)
		if task.id == task0_name then
			--print("Added !")
			startTasks[task.id] = self.TERRAIN[task.id]
		end
	end
	
	--print("Story:GenerateNodesFromTasks finding start parent node")

	local startParentNode = GetRandomItem(self.TERRAIN)
	if  #self.level.central_tasks > 0 or (not random_spawn and GetTableSize(startTasks) > 0) then
		startParentNode = GetRandomItem(startTasks)
		print("[Megarandom] Regular start task:", startParentNode.id)
	else
		print("[Megarandom] Random start task:", startParentNode.id)
	end

	
	unusedTasks[startParentNode.id] = nil

	local finalNode = startParentNode
    assert(self.gen_params.layout_mode ~= nil, "Must specify a layout mode for your level.")
	
	local world_shape = GetModConfigData("WorldShape", foldername)
	print("[Megarandom] World shape = ", world_shape)
	
	if world_shape > 0 and self.level.location == "forest" then
	
		-- custom world generation !
		
-----------------------------------------------------------------------------------------
------- STEP 1: Task arrangement (Locks & keys)
------------------------------------------------------------------------------------------

		print("[Megarandom] calling LinkNodesCustom ...")
		
		-- this function creates the nodes according to locks/keys
		-- but does not connect them (unlike the original function called here)
		local numNodes = self:LinkNodesCustom(startParentNode, unusedTasks)
		print("[Megarandom] numNodes=",numNodes)
		-- Now listNodes contains the tasks. Example:
		--   listnodes[0]          = root task
		--   listnodes[numNodes]   = last task
		
		-- do not touch, needed later in generateNodesFromTask
		finalNode = self.nodeList[numNodes]:GetRandomNode()
		
		-- Check that we have enough nodes
		local user_forgot_to_enable_preset = false
		local user_uses_default_settings = GetModConfigData("CaveTasksEnabled", foldername) and GetModConfigData("MultiTasksEnabled", foldername) and GetModConfigData("MultiTasksSlimeyEnabled", foldername) and GetModConfigData("MultiTasksGrayEnabled", foldername) and GetModConfigData("MultiTasksSnowEnabled", foldername) and GetModConfigData("MultiTasksBeachEnabled", foldername) and GetModConfigData("MultiTasksBeaverEnabled", foldername) and GetModConfigData("MultiTasksJungleEnabled", foldername) and GetModConfigData("MultiTasksCuteEnabled", foldername)
		if user_uses_default_settings and (numNodes < (34+GetModConfigData("InfusedWorldsRandomOptionalBiomes", foldername))) then
			-- if he chose all these options and we don't have enough biomes at this stage,
			-- that's probably because he did not choose the preset
			user_forgot_to_enable_preset = true
			print("[Megarandom] Internal error: Not enough biomes found even though the user has enabled correct options")
		end
		
		
		
		--assert( not user_forgot_to_enable_preset, "\n\n-----------------------------------------------------------------------------------------------------------------------------------------------------------------\n*\n                                                                               YOU MUST ENABLE THE MEGARANDOM PRESET !\n*\n                                                     You must enable the Megarandom preset in the WORLD tab if you want new biomes.\n                                               Please see the Megarandom mod page on the Steam Workshop, there are pictures showing how to do it !\n*\n*\n               ↑                  ↑                 ↑               ↑                  ↑                 ↑               ↑                  ↑                 ↑           ↑\n*\n-----------------------------------------------------------------------------------------------------------------------------------------------------------------\n-----------------------------------------------------------------------------------------------------------------------------------------------------------------\n\n\n\n\n\n\n")
		-- If someone ever reads this, you can perfectly remove that assert and the code will work fine.
		-- I just want to make sure the mod does what it's supposed to do for newbies
	
		
------------------------------------------------------------------------------	
------- STEP2: Task connection (custom shapes)
------------------------------------------------------------------------------
		
		print("[Megarandom] generating custom shape "..world_shape.." ...")
		
		-- Now that we have task nodes in correct arrangement, we will use the following
		-- function to connect them:
		
		local function connectNodes(i,j)
			if i<=numNodes and j<=numNodes then
				print("[Megarandom] Connecting task "..i.." ("..self.nodeList[i].id..") with "..j.." ("..self.nodeList[j].id..") ...")
				local effectiveLastNode=self.nodeList[i]
				local currentNode=self.nodeList[j]
				local currentNodeEntrance=currentNode:GetRandomNode()
				local lastNodeExit=effectiveLastNode:GetRandomNode()
				--if self.gen_params.island_percent ~= nil and self.gen_params.island_percent >= math.random() and currentNodeEntrance.data.entrance == false then
				--	self:SeperateStoryByBlanks(lastNodeExit, currentNodeEntrance )
				--else
					self.rootNode:LockGraph(effectiveLastNode.id..'->'..currentNode.id, lastNodeExit, currentNodeEntrance, {type="none", key=self.tasks[currentNode.id].locks, node=nil})
				--end
			else
				-- not sure that we should alllow this, but it's simpler for coding
				-- TODO
				print("[Megarandom] Warning: Trying to connect unexisting nodes "..i..") with "..j)

			end
		end
	
		-- Here you can create your custom shape !
		
		-- EXAMPLE SHAPE 1: Simple line
		-- Tasks will be arranged in a simple line
		if world_shape == 1 then
			for i=1,numNodes     
			do
				connectNodes(i-1,i)
			end
		end
	
		-- EXAMPLE SHAPE 2: Original algorithm
		-- The original algorithm used to randomly connect each node to an other one.
		if world_shape == -1 then
			for i=1,numNodes     
			do
				connectNodes(math.random(0,i-1),i) -- or something like this
			end
		end
		
		-- EXAMPLE 3: Loops
		-- Let's add 2 loops to our world
		-- Beware, when there are too many loops, the worldgen will give a weird and unexpected result. I don't know why.
		if world_shape == 2 then
			for i=1,numNodes     
			do
				connectNodes(i-1,i)
			end
			connectNodes(math.floor(numNodes/2 + 0.5),0)
			connectNodes(numNodes,0)
		end
		
		-- quadruple loop
		if world_shape == 3 then
		assert(numNodes > 7, "Error: The shape you selected requires at least 8 biomes and you only have "..numNodes..". Please find a way to add more biomes or choose an other shape !")
			for i=1,numNodes     
			do
				connectNodes(i-1,i)
			end
			connectNodes(math.floor(numNodes*0.25 + 0.5),0)
			connectNodes(math.floor(numNodes*0.5 + 0.5),0)
			connectNodes(math.floor(numNodes*0.75 + 0.5),0)
			connectNodes(numNodes,0)
		end
		
		
		-- multiple loop with branches
		if world_shape == 12 or world_shape == 14 or world_shape == 15 then
			
			
			local num_sides=world_shape-10
			local num_branches_per_side=0
			
			assert(numNodes > 2*num_sides, "Error: The shape you selected requires at least "..2*num_sides.." biomes and you only have "..numNodes..". Please find a way to add more biomes or choose an other shape !")
			
			if (world_shape == 15 and numNodes < 3*num_sides) then
				num_sides = 5
			end
			if (numNodes >= 5*num_sides) then
				num_branches_per_side = 1
			end
			
			if numNodes >= num_sides*6 then
				num_branches_per_side=math.floor((numNodes-num_sides*4)/(2*num_sides))+1
			end
			local num_main=numNodes-num_branches_per_side*num_sides

		assert(num_main>=num_sides*4, "Internal error: there are not enough tasks to satisfy the desired shape. Please report this bug and choose an other shape.")
	
		-- otherwise it might result in poor map generation.
		-- If this is a problem try reducing num_branches_per_side.
		
			print("[Megarandom] Generating a ", num_sides, "x loop with ", num_branches_per_side, " branches per side")
		
			for i=1,num_main
			do
				connectNodes(i-1,i)
			end
			
			local lower_extremity= -42
			local upper_extremity= 0
			for side=1,num_sides
			do
				lower_extremity = upper_extremity
				upper_extremity = math.floor(side/num_sides*num_main+ 0.5)
				connectNodes(upper_extremity,0)
				assert(((upper_extremity-1)-(lower_extremity+1)+1) >= num_branches_per_side, "Error in custom map generation: could not generate all branches. Reduce num_branches_per_side or add more biomes !")
				-- ^ well, actually why not. But it must be >= 1
				
				for branch=1,num_branches_per_side,1
				do
					local task_to_branch=lower_extremity+math.random(upper_extremity-lower_extremity-1)
					connectNodes(task_to_branch,num_main+branch+(side-1)*num_branches_per_side)
				end
				
			end
		end
		
		-- polygon -- at the moment I am not completely sure why this shape does what it does
		if world_shape == 5 then
		
			
		    local number_of_sides=4    -- you can also put 4
			
			if (numNodes < 4*number_of_sides+1) then
				number_of_sides=3
				print("[Megarandom] Warning: Polygon shape has not enough biomes for n=4. Switching to n=3...")
			end
			
			local num_branches= math.floor(numNodes/(number_of_sides*2))
			
			assert(numNodes >= 4*number_of_sides+1, "Error: The shape you selected requires at least"..(4*number_of_sides+1).." biomes and you only have "..numNodes..". Please find a way to add more biomes or choose a different shape !")
			
			local num_main=numNodes-num_branches
			local length_of_diagonals=math.floor(num_main/number_of_sides*0.65+0.5)
			
			local nodes_for_basis= number_of_sides -- lets ignore task 0
			local nodes_for_diagonals= length_of_diagonals*number_of_sides
			
			-- diagonals
			--connectNodes(0,1)
			for i=1,number_of_sides
			do
				connectNodes(0,i)
			end
			for i=nodes_for_basis+1,num_main
			do
				connectNodes(i-number_of_sides,i)
			end
			
			-- curve diagonals by linking them properly
			for i=1,number_of_sides
			do
				--old version, i dont know why I've put this
				--connectNodes(nodes_for_diagonals+i-number_of_sides,num_main-number_of_sides+i)
				connectNodes(num_main+1-(i%number_of_sides)-(number_of_sides+1),num_main+1-i)
			end
			
			-- add branches
			for branch=1,num_branches
			do
				local task_to_branch=num_main-number_of_sides*2-branch
				connectNodes(task_to_branch,num_main+branch)
			end
			
		end
		
		-- continental
		-- Succession of rings
		-- This shape looks like this: https://bersoantik.com/media/uploads/original_ship_steering_wheel_1_35_919.jpg
		if world_shape == 6 then
		
		
			local number_of_sides=4
			
			local length_of_diagonals=2
			local n=1
			
			local length_of_diagonals_lvl2=2
			local length_of_diagonals_lvl3=2
						
			assert(numNodes > 2*number_of_sides, "Error: The shape you selected requires at least 12 biomes and you only have "..numNodes..". Please find a way to add more biomes or choose an other shape !")
			
			-- One solid block in the center
			-- diagonals
			for i=1,number_of_sides
			do
				connectNodes(0,n)
				n=n+1
				for j=1,length_of_diagonals-1,1
				do
				connectNodes(n-1,n)
				n=n+1
				end
			end
			-- n == length_of_diagonals * number_of_sides + 1
			
			assert(n == number_of_sides*length_of_diagonals+1, "Internal error. Please change the world shape in the mod settings.")
			-- joints lvl 1
			local av=n
			n=n+number_of_sides
			for i=1,number_of_sides
			do
				local extremity1=i*length_of_diagonals
				local extremity2=((i%number_of_sides)+1)*length_of_diagonals
				connectNodes(extremity1,av)
				connectNodes(extremity2,av)
				av=av+1
				if not self.level.megarandom.volcano_central_ocean then
					connectNodes(extremity1,n)
				end
				n=n+1
				connectNodes(av-1,n)
				n=n+1
			end
			
			-- n == (length_of_diagonals+3) * number_of_sides + 1
			
			-- joints lvl 2
			for i=1,number_of_sides*2
			do
				for l=1,length_of_diagonals_lvl2-1,1
				do
					connectNodes(n-2*number_of_sides,n)
					n=n+1
				end
			end
			
			-- n == (2*length_of_diagonals_lvl2 + length_of_diagonals+1) * number_of_sides + 1
			print("Debug: Continental 0 n=",n, " expected ", (2*length_of_diagonals_lvl2 + length_of_diagonals+1) * number_of_sides + 1)
			
			-- add a ring
				for i=1,number_of_sides*2
				do
					local extremity1=n-2*number_of_sides
					local extremity2=n+1-2*number_of_sides
					if i==number_of_sides*2 then
						extremity2=extremity2-number_of_sides*2
					end
					connectNodes(extremity1,n)
					connectNodes(extremity2,n)
					n=n+1
				end
			
			-- n == (2*length_of_diagonals_lvl2 + length_of_diagonals+3) * number_of_sides + 1
			print("Debug: Continental 1 n=",n, " expected ", (2*length_of_diagonals_lvl2 + length_of_diagonals+3) * number_of_sides + 1)
			
			-- joints lvl 3
			for i=1,number_of_sides*2
			do
				for l=1,length_of_diagonals_lvl3,1
				do
					if l<=1 or number_of_sides == 3 or (36+l*number_of_sides*2+i<=numNodes) then
					connectNodes(n-2*number_of_sides,n)
					n=n+1
					else
					-- we must keep number_of_sides*2 biomes for the last ring
					-- do nothing
					end
				end
			end
			
			print("Debug: Continental 2 n=",n)
			-- add one inner branch task
			local number_of_inner_branches=0
			--for i=1,number_of_sides*2,2
			--do
			--	connectNodes(n-2*number_of_sides*length_of_diagonals_lvl3,n)
			--	n=n+1
			--	number_of_inner_branches=number_of_inner_branches+1
			--end
			
			-- add a ring
				for i=1,number_of_sides*2
				do
					local extremity1=n-number_of_inner_branches-2*number_of_sides
					local extremity2=n-number_of_inner_branches+1-2*number_of_sides
					if i==number_of_sides*2 then
						extremity2=extremity2-number_of_sides*2
					end
					connectNodes(extremity1,n)
					connectNodes(extremity2,n)
					n=n+1
				end
			
			--local num_rings_to_add = math.floor((numNodes-30)/8)
			--if num_rings_to_add >2 then num_rings_to_add=2 end
			--if num_rings_to_add <0 then num_rings_to_add=0 end
			--
			--for t=1,num_rings_to_add,1
			--do
			--	-- add a ring
			--	for i=1,number_of_sides*2
			--	do
			--		local extremity1=n-2*number_of_sides
			--		local extremity2=n+1-2*number_of_sides
			--		connectNodes(extremity1,n)
			--		connectNodes(extremity2,n)
			--		n=n+1
			--	end
			--end
			
			--[[
			print("[Megarandom] Adding "..math.max(0,numNodes+1-n).." random branches...")
			
			local tasks_with_free_space_new = {}
			local tasks_with_free_space_old = {}
			for i=1,number_of_sides*2
			do
				tasks_with_free_space_new[i]=n-i-number_of_sides*2
				tasks_with_free_space_old[i]=n-i-number_of_sides*2
			end
			
			--randomly dispatch the last tasks
			
			local i_to_give=1
			for task_to_dispatch=n,numNodes,1
			do
				--assert( number_of_sides == 3, "This function should not be executed if n != 3. Please reduce the number of biomes.")
				if math.random() > 0.5 then
					-- give to new
					connectNodes(tasks_with_free_space_new[i_to_give],task_to_dispatch)
				else
					-- give to old
					connectNodes(tasks_with_free_space_old[i_to_give],task_to_dispatch)
				end
				tasks_with_free_space_old[i_to_give]=tasks_with_free_space_new[i_to_give]
				tasks_with_free_space_new[i_to_give]=task_to_dispatch
				i_to_give=(i_to_give%(number_of_sides*2)) +1
			end
			]]--
			local outer_ring_length = number_of_sides*2
			while n <= numNodes do
				local nmax1 = math.min(n+outer_ring_length-1,numNodes)
				while n <= nmax1
				do
					-- connect with previous ring (new bridges)
					connectNodes(n-outer_ring_length,n)
					n=n+1
				end
				local nmax2 = math.min(n+outer_ring_length-1,numNodes)
				while n <= nmax2
				do
					-- connect twice with previous ring (new ring)
					connectNodes(n-outer_ring_length,n)
					connectNodes(n-outer_ring_length+1,n)
					n=n+1
				end
			end
			
		end
		
		if world_shape == 7 then
			connectNodes(0,1)
			for i=2,numNodes     
			do
				connectNodes(i-2,i)
				connectNodes(i-1,i)
			end
		end
		
		-- TODO expore this kind of shapes
		if world_shape == 8 then
			connectNodes(0,1)
			connectNodes(1,2)
			for i=3,numNodes     
			do
				connectNodes(i-3,i)
				connectNodes(i-2,i)
			end
		end
		
	-------------------------------------------------------------------------	
		
		--local node2_debug = self.startNode
			--local node2_debug = self.nodeList[8]:GetRandomNode()--self.startNode --self.startNode.GetChildren()[1]
			--local node1_debug = self.nodeList[2]:GetRandomNode() --finalNode
			--local node1Exit = node1_debug --:GetRandomNode()
			--local node2Entrance = node2_debug --:GetRandomNode()
			--self.rootNode:LockGraph(node1_debug.id..'->'..node2_debug.id, node1Exit, node2Entrance, {type="none", key=KEYS.NONE, node=nil})
		
	else
	
		if self.level.location ~= "forest" then
			print("Megarandom: Found special unhandled level "..self.level.name.." in "..self.level.location)
		end
	
		if string.upper(self.gen_params.layout_mode) == string.upper("RestrictNodesByKey") then

			print("RestrictNodesByKey")
			finalNode = self:RestrictNodesByKey(startParentNode, unusedTasks)
		else
			print("LinkNodesByKeys")
			finalNode = self:LinkNodesByKeys(startParentNode, unusedTasks)
		end
	end
	
	
	
    local randomStartTask = nil
	local randomStartNode = nil
	
	if random_spawn ~= "Madness" then
	
    if self.level.valid_start_tasks ~= nil then
        print("Finding valid start task...")
        local validKeys = shuffleArray(deepcopy(self.level.valid_start_tasks))
        local targetTask = nil
        while targetTask == nil and #validKeys > 0 do
            for id,task in pairs(self.rootNode:GetChildren()) do
                if id == validKeys[1] then
                    targetTask = task
                    break
                end
            end
            table.remove(validKeys, 1)
        end
        if targetTask ~= nil then
            print("   ...picked ", targetTask.id)
            randomStartTask = targetTask
            randomStartNode = targetTask:GetRandomNode()
        end
    end

    if randomStartNode == nil then
        print("No valid start node, using first task.")
        randomStartTask = startParentNode
        randomStartNode = startParentNode:GetRandomNode()
    end
	
	else
		local valid_madness_start_tasks = {}
		for _,task in pairs(self.tasks) do
			if task.id:sub(1, 6) ~= "WATER_" then
				table.insert(valid_madness_start_tasks,task.id)
			else
				print("[Megarandom] Preventing start task "..task.id)
			end
		end
		local MRstarttask = GetRandomItem(valid_madness_start_tasks)
		print("[Megarandom] Start task: "..MRstarttask)
		randomStartTask = self.TERRAIN[MRstarttask]
		randomStartNode = randomStartTask:GetRandomNode()
	end
	
	local start_node_data = {id="START"}

	if self.gen_params.start_node ~= nil then
		print("Has start node", self.gen_params.start_node)
		start_node_data.data = self:GetRoom(self.gen_params.start_node)
		start_node_data.data.terrain_contents = start_node_data.data.contents		
	else
		print("No start node!")
		start_node_data.data = {
								value = GROUND.GRASS,								
								terrain_contents={
									countprefabs = {
										spawnpoint=1,
										sapling=1,
					                    twiggytree=1,
										flint=1,
										berrybush=1, 
										berrybush_juicy = 0.5,
										grass=function () return 2 + math.random(2) end
									} 
								}
							 }
	end

	start_node_data.data.name = "START"
	start_node_data.data.colour = {r=0,g=1,b=1,a=.80}
	
	if self.gen_params.start_setpeice ~= nil then
		start_node_data.data.terrain_contents.countstaticlayouts = {}
		start_node_data.data.terrain_contents.countstaticlayouts[self.gen_params.start_setpeice] = 1
		
		if start_node_data.data.terrain_contents.countprefabs ~= nil then
			start_node_data.data.terrain_contents.countprefabs.spawnpoint = nil
		end
	end

	self.startNode = randomStartTask:AddNode(start_node_data)
											
	--print("Story:GenerateNodesFromTasks adding start node link", self.startNode.id.." -> "..randomStartNode.id)
	randomStartTask:AddEdge({node1id=self.startNode.id, node2id=randomStartNode.id})	

		--local node2_debug = self.startNode
		--local node2_debug = self.nodeList[8]:GetRandomNode()--self.startNode --self.startNode.GetChildren()[1]
		--local node1_debug = self.nodeList[2]:GetRandomNode() --finalNode
		--local node1Exit = node1_debug --:GetRandomNode()
		--local node2Entrance = node2_debug --:GetRandomNode()
		--self.rootNode:LockGraph(node1_debug.id..'->'..node2_debug.id, node1Exit, node2Entrance, {type="none", key=KEYS.NONE, node=nil})
		----self.rootNode:LockGraph(node1_debug.id..'->'..node2_debug.id, node1Exit, node2Entrance, {type="none", key=self.tasks[node2_debug.id].locks, node=nil})
		
		--node2_debug = self.nodeList[10]:GetRandomNode()--self.startNode --self.startNode.GetChildren()[1]
		--node1_debug = self.nodeList[14]:GetRandomNode() --finalNode
		--node1Exit = node1_debug --:GetRandomNode()
		--node2Entrance = node2_debug --:GetRandomNode()
		--self.rootNode:LockGraph(node1_debug.id..'->'..node2_debug.id, node1Exit, node2Entrance, {type="none", key=KEYS.NONE, node=nil})
		----self.rootNode:LockGraph(node1_debug.id..'->'..node2_debug.id, node1Exit, node2Entrance, {type="none", key=self.tasks[node2_debug.id].locks, node=nil})
		

		--node2_debug = self.nodeList[4]:GetRandomNode()--self.startNode --self.startNode.GetChildren()[1]
		--node1_debug = self.nodeList[12]:GetRandomNode() --finalNode
		--node1Exit = node1_debug --:GetRandomNode()
		--node2Entrance = node2_debug --:GetRandomNode()
		--self.rootNode:LockGraph(node1_debug.id..'->'..node2_debug.id, node1Exit, node2Entrance, {type="none", key=KEYS.NONE, node=nil})
		----self.rootNode:LockGraph(node1_debug.id..'->'..node2_debug.id, node1Exit, node2Entrance, {type="none", key=self.tasks[node2_debug.id].locks, node=nil})
		

	
	if world_shape <= 0 then	
	-- form the map into a loop!
		if self.gen_params.loop_percent ~= nil then
			if math.random() < self.gen_params.loop_percent then
				print("Adding map loop")
				self:SeperateStoryByBlanks(self.startNode, finalNode )
			end
		else
			if math.random() < 0.5 then
				print("Adding map loop")
				self:SeperateStoryByBlanks(self.startNode, finalNode )
			end
		end
	end

	
end

function Story:AddBGNodes(min_count, max_count)
	local tasksnodes = self.rootNode:GetChildren(false)
	local bg_idx = 0

	for taskid, task in pairs(tasksnodes) do
		local background_template = self:GetRoom(task.data.background)
		assert(background_template, "Couldn't find room with name "..(task.data.background or "<nil>").." from "..task.id)
		local blocker_blank_template = self:GetRoom(self.level.blocker_blank_room_name)
		if blocker_blank_template == nil then
			blocker_blank_template = {
				type=NODE_TYPE.Blank,
                name="blocker_blank",
				tags = {"RoadPoison", "ForceDisconnected"},
				colour={r=0.3,g=.8,b=.5,a=.50},
				value = self.impassible_value
			}
            ArrayUnion(blocker_blank_template.tags, task.data.room_tags)
		end
		

        if background_template.contents == nil then
            background_template.contents = {}
        end
        self:RunTaskSubstitution(task, background_template.contents.distributeprefabs)

		for nodeid,node in pairs(task:GetNodes(false)) do

			if not node.data.entrance then

				local count = math.random(min_count,max_count)
				local prevNode = nil
				for i=1,count do

					local new_room = deepcopy(background_template)
					new_room.id = task.id..":BG_"..bg_idx..":"..new_room.name
					new_room.task = task.id


					-- this has to be inside the inner loop so that things like teleportato tags
					-- only get processed for a single node.
					local extra_contents, extra_tags = self:GetExtrasForRoom(new_room)

					
					local newNode = task:AddNode({
										id=new_room.id, 
										data={
												type=(new_room.type == NODE_TYPE.Room and NODE_TYPE.BackgroundRoom)
                                                    or (new_room.type == NODE_TYPE.Default and NODE_TYPE.Background)
                                                    or new_room.type,
                                                task = new_room.task,
                                                name="background",
												colour = new_room.colour,
												value = new_room.value,
												internal_type = new_room.internal_type,
												tags = ArrayUnion(extra_tags, task.room_tags),
												terrain_contents = new_room.contents,
												terrain_contents_extra = extra_contents,
												terrain_filter = self.terrain.filter,
												entrance = new_room.entrance,
												required_prefabs = new_room.required_prefabs
											  }										
										})

					task:AddEdge({node1id=newNode.id, node2id=nodeid})
					-- This will probably cause crushng so it is commented out for now
					-- if prevNode then
					-- 	task:AddEdge({node1id=newNode.id, node2id=prevNode.id})
					-- end

					bg_idx = bg_idx + 1
					prevNode = newNode
				end
			else -- this is an entrance node
				for i=1,2 do
					local new_room = deepcopy(blocker_blank_template)
					new_room.task = task.id

					local extra_contents, extra_tags = self:GetExtrasForRoom(new_room)

					local blank_subnode = task:AddNode({
											id=nodeid..":BLOCKER_BLANK_"..tostring(i), 
											data={
													type= new_room.type or NODE_TYPE.Blank,
                                                    task = new_room.task,
													colour = new_room.colour,
													value = new_room.value,
													internal_type = new_room.internal_type,
													tags = ArrayUnion(extra_tags, task.room_tags),
													terrain_contents = new_room.contents,
													terrain_contents_extra = extra_contents,
													terrain_filter = self.terrain.filter,
													blocker_blank = true,
													required_prefabs = new_room.required_prefabs
												  }										
										})

					task:AddEdge({node1id=nodeid, node2id=blank_subnode.id})
				end
			end

		end

	end
end

function Story:AddCoveNodes(task_nodes) 
	print("[Story Gen] Adding Cove Nodes")
	task_nodes = task_nodes or self.rootNode:GetChildren(false)
	local bg_idx = 0

	for taskid, task_node in pairs(task_nodes) do
		local task_def = self.tasks[taskid]
		if task_def ~= nil then -- generated tasks like LOOP_BLANK_X and REGION_LINK_X do not need coves added to them
			local cove_room_name = task_def.cove_room_name or "Blank"
			local cove_room_template = self:GetRoom(cove_room_name)
			assert(cove_room_template, "Couldn't find blank room with name "..(cove_room_name).." from "..taskid)

			if cove_room_template.contents == nil then
				cove_room_template.contents = {}
			end

			local cove_room_chance = task_def.cove_room_chance ~= nil and task_def.cove_room_chance or 0.35
			local cove_room_max_edges = task_def.cove_room_max_edges ~= nil and task_def.cove_room_max_edges or 1
			if cove_room_chance == 0 or cove_room_max_edges == 0 then
				return
			end

			self:RunTaskSubstitution(task_node, cove_room_template.contents.distributeprefabs)

			for nodeid, node in pairs(task_node:GetNodes(false)) do
				if not node.data.entrance and node.data.type ~= NODE_TYPE.Blank and node.data.type ~= NODE_TYPE.BackgroundRoom and node.id ~= "START"
					and (node.edges ~= nil and GetTableSize(node.edges) <= cove_room_max_edges) and math.random() < cove_room_chance then

					local new_room = deepcopy(cove_room_template)
					new_room.id = taskid..":COVE_"..bg_idx..":"..new_room.name
					new_room.task = taskid
					local extra_contents, extra_tags = self:GetExtrasForRoom(new_room)
					local newNode = task_node:AddNode({
										id=new_room.id, 
										data={
												type=(new_room.type == NODE_TYPE.Room and NODE_TYPE.BackgroundRoom)
													or (new_room.type == NODE_TYPE.Default and NODE_TYPE.Background)
													or new_room.type,
												task = new_room.task,
												name="background",
												colour = new_room.colour,
												value = new_room.value,
												internal_type = new_room.internal_type,
												tags = ArrayUnion(extra_tags, task_node.room_tags),
												terrain_contents = new_room.contents,
												terrain_contents_extra = extra_contents,
												terrain_filter = self.terrain.filter,
												entrance = new_room.entrance,
												required_prefabs = new_room.required_prefabs
												}										
										})

					task_node:AddEdge({node1id=newNode.id, node2id=nodeid})

					bg_idx = bg_idx + 1
				end
			end

			bg_idx = 0
		end
	end
end

function Story:SeperateStoryByBlanks(startnode, endnode )	
	local blank_node = Graph("LOOP_BLANK"..tostring(self.loop_blanks), {parent=self.rootNode, default_bg=GROUND.IMPASSABLE, colour = {r=0,g=0,b=0,a=1}, background="BGImpassable" })
	WorldSim:AddChild(self.rootNode.id, "LOOP_BLANK"..tostring(self.loop_blanks), GROUND.IMPASSABLE, 0, 0, 0, 1, "blank")
	local blank_subnode = blank_node:AddNode({
											id="LOOP_BLANK_SUB "..tostring(self.loop_blanks), 
											data={
													type=NODE_TYPE.Blank,
                                                    name="LOOP_BLANK_SUB",
													tags = {"RoadPoison", "ForceDisconnected"},					 
													colour={r=0.3,g=.8,b=.5,a=.50},
													value = self.impassible_value
												  }										
										})

	self.loop_blanks = self.loop_blanks + 1
	self.rootNode:LockGraph(startnode.data.task..'->'..blank_subnode.id, 	startnode, 	blank_subnode, {type="none", key=KEYS.NONE, node=nil})
	self.rootNode:LockGraph(endnode.data.task..'->'..blank_subnode.id, 	endnode, 	blank_subnode, {type="none", key=KEYS.NONE, node=nil})
end

function Story:GetExtrasForRoom(next_room)
	local extra_contents = {}
	local extra_tags = {}
	if next_room.tags ~= nil then
		for i,tag in ipairs(next_room.tags) do
			local type, extra = self.map_tags.Tag[tag](self.map_tags.TagData)
			if type == "STATIC" then
				if extra_contents.static_layouts == nil then
					extra_contents.static_layouts = {}
				end
				table.insert(extra_contents.static_layouts, extra)
			end
			if type == "ITEM" then
				if extra_contents.prefabs == nil then
					extra_contents.prefabs = {}
				end
				table.insert(extra_contents.prefabs, extra)
			end
			if type == "TAG" then
				table.insert(extra_tags, extra)
			end
			if type == "GLOBALTAG" then
				if self.GlobalTags[extra] == nil then
					self.GlobalTags[extra] = {}
				end
				if self.GlobalTags[extra][next_room.task] == nil then
					self.GlobalTags[extra][next_room.task] = {}
				end
				--print("Adding GLOBALTAG", extra, next_room.task, next_room.id)
				table.insert(self.GlobalTags[extra][next_room.task], next_room.id)
			end
		end
	end

	return extra_contents, extra_tags
end

function Story:RunTaskSubstitution(task, items )
	if task.substitutes == nil or items == nil then
		return items
	end

	for k,v in pairs(task.substitutes) do 
		if items[k] ~= nil then 
			if v.percent == 1 or v.percent == nil then
				items[v.name] = items[k]
				items[k] = nil
			else
				items[v.name] = items[k] * v.percent
				items[k] = items[k] * (1.0-v.percent)
			end
		end
	end

	return items
end

-- Generate a subgraph containing all the items for this story
function Story:GenerateNodesFromTask(task, crossLinkFactor, starting_node_name)
	--print("Story:GenerateNodesFromTask", task.id)
	-- Create stack of rooms
	local room_choices = Stack:Create()

	if task.entrance_room then
		local r = math.random()
		if task.entrance_room_chance == nil or task.entrance_room_chance > r then
			if type(task.entrance_room) == "table" then
				task.entrance_room = GetRandomItem(task.entrance_room)
			end
			--print("\tAdding entrance: ",task.entrance_room,"rolled:",r,"needed:",task.entrance_room_chance)
			local new_room = self:GetRoom(task.entrance_room)
			assert(new_room, "Couldn't find entrance room with name "..task.entrance_room)

			if new_room.contents == nil then
				new_room.contents = {}
			end

			if new_room.contents.fn then					
				new_room.contents.fn(new_room)
			end
			new_room.entrance = true
			room_choices:push(new_room)
		--else
		--	print("\tHad entrance but didn't use it. rolled:",r,"needed:",task.entrance_room_chance)
		end
	end

	if task.room_choices then
		for room, count in pairs(task.room_choices) do
			--print("Story:GenerateNodesFromTask adding "..count.." of "..room, Rooms.GetRoomByName(room).contents.fn)
            if type(count) == "function" then
                count = count()
            end
			for id = 1, count do
				local new_room = self:GetRoom(room)

				assert(new_room, "Couldn't find room with name "..room)
				if new_room.contents == nil then
					new_room.contents = {}
				end			
				
				-- Do any special processing for this room
				if new_room.contents.fn then					
					new_room.contents.fn(new_room)
				end
				room_choices:push(new_room)
			end
		end
	end

	local task_node = Graph(task.id, {parent=self.rootNode, default_bg=task.room_bg, colour = task.colour, background=task.background_room, set_pieces=task.set_pieces, random_set_pieces=task.random_set_pieces, maze_tiles=task.maze_tiles, maze_tile_size=task.maze_tile_size, room_tags=task.room_tags, required_prefabs=task.required_prefabs})
	task_node.substitutes = task.substitutes
	--print ("Adding Voronoi Child", self.rootNode.id, task.id, task.backround_room, task.room_bg, task.colour.r, task.colour.g, task.colour.b, task.colour.a )

	WorldSim:AddChild(self.rootNode.id, task.id, task.room_bg, task.colour.r, task.colour.g, task.colour.b, task.colour.a)
	
	local newNode = nil
	local prevNode = nil
	-- TODO: we could shuffleArray here on rom_choices_.et to make it more random
	local roomID = 0
	local hub_node = nil
	local starting_node_picked = false
	--print("Story:GenerateNodesFromTask adding "..room_choices:getn().." rooms")
	while room_choices:getn() > 0 do
		local next_room = room_choices:pop()
		
		local is_starting_room = starting_node_name == next_room.name and not starting_node_picked
		
		if is_starting_room then
			print("Found starting task " .. task.id .. ", picked existing room " .. next_room.name)
			starting_node_picked = true
			next_room.id = "START"
		else
			next_room.id = task.id..":"..roomID..":"..next_room.name	-- TODO: add room names for special rooms
		end
	
		next_room.task = task.id

		self:RunTaskSubstitution(task, next_room.contents.distributeprefabs)
		
		-- TODO: Move this to 
		local extra_contents, extra_tags = self:GetExtrasForRoom(next_room)

		local next_room_data = {
								type = next_room.entrance and NODE_TYPE.Blocker or next_room.type, 
                                task = next_room.task,
                                name = next_room.name,
								colour = next_room.colour,
								value = next_room.value,
								internal_type = next_room.internal_type,
								tags = ArrayUnion(extra_tags, task.room_tags),
								custom_tiles = next_room.custom_tiles,
								custom_objects = next_room.custom_objects,
								terrain_contents = next_room.contents,
								terrain_contents_extra = extra_contents,
								terrain_filter = self.terrain.filter,
								entrance = next_room.entrance,
								required_prefabs = next_room.required_prefabs,
								random_node_exit_weight = next_room.random_node_exit_weight,
								random_node_entrance_weight = next_room.random_node_entrance_weight,
							  }										

		if is_starting_room then
			next_room_data.name = "START"
			next_room_data.colour = {r=0,g=1,b=1,a=.80}
			next_room_data.random_node_exit_weight = 0
			next_room_data.random_node_entrance_weight = 0
			self:AddStartingSetPiece(next_room_data)
		end

		newNode = task_node:AddNode({
										id=next_room.id, 
										data=next_room_data,
									})
		
		if task.hub_room ~= nil and hub_node == nil and next_room.name == task.hub_room then
			hub_node = newNode
			hub_node.data.random_node_exit_weight = 0
			hub_node.data.random_node_entrance_weight = 0
		end
		
		-- Dont add edges if there is a hub room, this will hapen later in MakeHub, if we want to make a loop, then just dont add the hub to it.
		if task.hub_room == nil or task.make_loop then
			if newNode ~= hub_node then
				if prevNode then
					--dumptable(prevNode)
					--print("Story:GenerateNodesFromTask Adding edge "..newNode.id.." -> "..prevNode.id)
					local edge = task_node:AddEdge({node1id=newNode.id, node2id=prevNode.id})
				end
				
				--dumptable(newNode)
				-- This will make long line of nodes
				prevNode = newNode
			end
		end
		roomID = roomID + 1
	end
	
	if task.make_loop then
		task_node:MakeLoop()
	end

	if hub_node ~= nil then
		task_node:MakeHub(hub_node.id)
	end

	if crossLinkFactor then
		--print("Story:GenerateNodesFromTask crosslinking")
		-- do some extra linking.
		task_node:CrosslinkRandom(crossLinkFactor)
	end
	--print("Story:GenerateNodesFromTask done", task_node.id)
	return task_node
end
------------------------------------------------------------------------------------------
---------             TESTING                   --------------------------------------
------------------------------------------------------------------------------------------

function BuildStory(tasks, story_gen_params, level)
    --print("Building TEST STORY", tasks)
    local start_time = GetTimeReal()

    local story = Story("GAME", tasks, terrain, story_gen_params, level)
    story:GenerationPipeline()

    --print("\n------------------------------------------------")
    --story.rootNode:Dump()
    --print("\n------------------------------------------------")

    return {root=story.rootNode, startNode=story.startNode, GlobalTags = story.GlobalTags}, story
end


