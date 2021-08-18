
-- This class contains methods implementing strategies for farming ressources

-- only needed when starting new turtle 



-- gathers atleast the specified amount of wood 
-- spiral 0 is not accounted for but we should not neeed it because our starting area takes a significant amount up and we dont want to fuck it up
-- spiral logic is there progress is saved in the file gathering.txt
-- spiral[progress]
-- spiral[pos]
-- spiral[ring]
-- spiral[dir]
--


function gather_wood(quantity)
	local h = fs.open("./gathering.txt", "r")
	local spiral = textutils.unserialize(h.readAll())
	h.close() 

	local wood = 0; 
	while wood < quantity do
		gather_ring(quantity, spiral)
		wood = countLogs()
	end
	local w = fs.open("gathering.txt", "w")
	w.write(textutils.serialize(spiral))
	w.close()
	navigate(home)
end

function kill_tree()
	move_forward()
	for i = 1,6 do
		move_up()
	end
	for i = 1,6 do
		move_down()
	end
end

-- goes mining in a specified spiral until it gets enough wood. returns true if it found the specified quantity of wood.... 
-- writes progress to the wood file ...
-- also mines sand when encountering it
function gather_ring(quantity, spiral)


	local upward = false
	
	go_towards(vector.new(spiral["pos"].x, spiral["pos"].y,spiral["pos"].z))
	turn(spiral["dir"])
	local spiral_size = 4 + 8*spiral["ring"]

	for prog = spiral["progress"],spiral_size do
		if f.mod(spiral["progress"], 64) == 0 then   --drops abundant items all 64 steps
			dropAbundantItems()
		end
		if table.pack(turtle.inspectDown())[2].name == "minecraft:sand" then
			turtle.digDown()
		end
		-- turn turtle left if on one of the 4 edges 
		if math.fmod(prog, (spiral_size / 4)) == 2 + spiral["ring"]  then
			turn_left()
		end 


		--check for tree  and kill it

		if is_wood(table.pack(turtle.inspect())[2].name) then
			kill_tree()
		else 
			-- walk up and down until on a surface and then walk forward
			local tree = false
			while not ((turtle.detectDown() and not turtle.detect()) or (upward and not turtle.detect())) do
				if not turtle.detectDown() and not turtle.detect() and not upward then
					move_down()
					if is_wood(table.pack(turtle.inspect())[2].name) then
						kill_tree()
						tree = true
						break
					end
				else
					move_up()
					upward = true
					if is_wood(table.pack(turtle.inspect())[2].name) then
						kill_tree()
						tree = true
						break
					end
				end
			end
			if not tree then
				move_forward()
			end
			upward = false
		end
		if countLogs() >= quantity then
			spiral["progress"] = prog +1
			spiral["dir"] = current_dir
			spiral["pos"] = vector.new(current_pos.x, current_pos.y, current_pos.z) -- doing it like this to obtain a copy
			return true
		end
	end
	--next ring
	spiral["progress"] = 1
	spiral["dir"] = directions["SOUTH"]  --default value
	spiral["ring"] = spiral["ring"] +1
	spiral["pos"].x = current_pos.x -1
	spiral["pos"].y = current_pos.y
	spiral["pos"].z = current_pos.z
	return false
end

function is_wood(blockid)	
	return blockid == "minecraft:oak_log" or blockid == "minecraft:spruce_log" or 
		   blockid == "minecraft:birch_log" or blockid == "minecraft:jungle_log" or 
		   blockid == "minecraft:acacia_log" or blockid == "minecraft:dark_oak_log"
end

function is_ore(blockid)
	return blockid == "minecraft:diamond_ore" or blockid == "minecraft:iron_ore" or
	blockid == "minecraft:coal_ore" or blockid == "minecraft:redstone_ore" or 
	blockid == "minecraft:deepslate_redstone_ore"
end
--- 
function checkForResources()
	dir = current_dir
	turn(directions["NORTH"])
	if is_ore(table.pack(turtle.inspect())[2].name) then
		turtle.dig()
	end
	turn(directions["SOUTH"])
	if is_ore(table.pack(turtle.inspect())[2].name) then
		turtle.dig()
	end
	if is_ore(table.pack(turtle.inspectUp())[2].name) then 
		turtle.digUp()
	end
	if is_ore(table.pack(turtle.inspectDown())[2].name) then 
		turtle.digDown()
	end
	turn(dir)
end



-- expects a dictionary with neccessary items to mite
-- goal is a table which maps item ids to count
function mine(goal)

	local h = fs.open("mining.txt", "r")
	local mining = textutils.unserialize(h.readAll())
	h.close() 

	local tunnel_length = mining["tunnel_length"] --low value for testing
	local mining_height = mining["mining_height"] -- corresponds to 4 tunnels per walk upwards ....
	mining_spot = vector.new(mining["pos"].x, mining["pos"].y, mining["pos"].z)  -- 60

	local height = mining["height"] --load from file later

	go_towards(mining_spot)
	while not goal_met(goal) do   --replace with while loop which checks for inventory containing certain items

		turn(directions["EAST"])
		for i = 0,tunnel_length do
			move_forward()
			checkForResources()	
		end
		 --make row in same field
		height = height + 2;
		for i = 1,2 do 
			move_up()
		end	
		turn(directions["NORTH"])
		move_forward()
		
		--else calculate new mining spot 
		turn(directions["WEST"])

		for i = 0,tunnel_length do
			move_forward()
			checkForResources()	
		end


		if height + 4 < mining_height then  --make row in same field
			height = height + 2;
			for i = 1,2 do 
				move_up()
			end	
			turn(directions["NORTH"])
			move_forward()
		else 
			local down = 0; 
			if height - 7 < 0 then 
				down = 5
			else 
				down = 7 
			end
			for i = 1,down do 
				move_down()
			end
			height = height -down
		end
		  print("reached end of while")
	end
	
	mining["pos"] = current_pos
	mining["height"] = height
	local w = fs.open("mining.txt", "w")
	w.write(textutils.serialize(mining))
	w.close()
		
	navigate(home)
end

function goal_met(goal)
	dropAbundantItems()
	countInventory()
	for k,v in next, goal do
		log(" item: "..k.." goal  quantity "..v.." in inventory :"..countOf(k))
		if countOf(k) < v then

			return false
		end
	end
	return true

end



