turtle.refuel()



-- lua hat keine enums deshalb diese komische Lösung -- 
directions = {} --{"NORTH", "EAST", "SOUTH", "WEST"}
directions["NORTH"] = 0
directions["EAST"] = 1
directions["SOUTH"] = 2
directions["WEST"] = 3


home = vector.new(-460, 66,207)

--only on first startup else it always gets overwritten by read_pos()
current_dir ={}
current_pos ={}


function write_pos()
	local pos = {}
	pos["position"] = current_pos
	pos["direction"] = current_dir
	local h = fs.open("pos.txt", "w")
	h.write(textutils.serialize(pos))
	h.close()
end

function read_pos()
	local h = fs.open("pos.txt", "r")
	local pos = textutils.unserialize(h.readAll())
	current_dir = pos["direction"]
	current_pos = pos["position"]
	h.close()
end

-- only needed when starting new turtle 
function init_turtle()

	current_dir = directions["EAST"]
	current_pos = vector.new(-460, 66,207)
	write_pos()
	spiral = {}
	spiral["progress"] = 1
	spiral["dir"] = directions["SOUTH"]  --default value
	spiral["ring"] = 2
	spiral["pos"] = current_pos
	local w = fs.open("gathering.txt", "w")
	w.write(textutils.serialize(spiral))
	w.close() 
end






-- gathers atleast the specified amount of wood 
-- spiral 0 is not accounted for but we should not neeed it because our starting area takes a significant amount up and we dont want to fuck it up
-- spiral logic is there progress is saved in the file gathering.txt
-- spiral[progress]
-- spiral[pos]
-- spiral[ring]
-- spiral[dir]
-- 



function gather_wood(quantity)
	local h = fs.open("gathering.txt", "r")
	local spiral = textutils.unserialize(h.readAll())
	h.close() 

	local wood = 0; 
	while wood < quantity do 
		wood = wood + gather_ring(quantity-wood,spiral)
	end
	local w = fs.open("gathering.txt", "w")
	w.write(textutils.serialize(spiral))
	w.close() 
end

-- goes mining in a specified spiral until it gets enough wood. returns true if it found the specified quantity of wood.... 
-- writes progress to the wood file ...
function gather_ring(quantity, spiral) 



	local wood = 0
	local upward = false
	
	go_towards(vector.new(spiral["pos"].x, spiral["pos"].y,spiral["pos"].z))
	turn(spiral["dir"])	
	local spiral_size = 4 + 8*spiral["ring"]

	for prog = spiral["progress"],spiral_size do
		-- turn turtle left if on one of the 4 edges 
		if math.fmod(prog, (spiral_size / 4)) == 2 + spiral["ring"]  then
			print("turning")
			turtle.turnLeft()
			current_dir = math.fmod(current_dir -1 +4 , 4)
		end 

		local success, data = turtle.inspect()
		--check for tree  and kill it
		print(data.name)
		if is_wood(data.name) then 
			move_forward()
			wood = wood+1
			for i = 1,6 do
				if is_wood(table.pack(turtle.inspectUp())[2].name) then
					wood = wood +1
				end
				move_up()
			end
			for i = 1,6 do
				move_down()
			end
		else 
			-- walk up and down until on a surface and then walk forward

			while not ((turtle.detectDown() and not turtle.detect()) or (upward and not turtle.detect())) do 
				if not turtle.detectDown() and not turtle.detect() and not upward then
					move_down()
				else
					move_up()
					upward = true
				end
			end
			move_forward()
			upward = false
		end
		if wood >= quantity then 
			print (current_dir)
			spiral["progress"] = prog +1
			spiral["dir"] = current_dir
			spiral["pos"] = vector.new(current_pos.x, current_pos.y, current_pos.z) -- doing it like this to obtain a copy
			return wood
		end
	end
	--next ring
	spiral["progress"] = 1
	spiral["dir"] = directions["SOUTH"]  --default value
	spiral["ring"] = spiral["ring"] +1
	spiral["pos"].x = current_pos.x -1   
	spiral["pos"].y = current_pos.y
	spiral["pos"].z = current_pos.z 


	return wood
end

function is_wood(blockid)
	return blockid == "minecraft:oak_log" or blockid == "minecraft:spruce_log" or 
		   blockid == "minecraft:birch_log" or blockid == "minecraft:jungle_log" or 
		   blockid == "minecraft:acacia_log" or blockid == "minecraft:dark_oak_log"
end

function is_ore(blockid)
	return blockid == "minecraft:diamond_ore" or blockid == "minecraft:iron_ore" or blockid == "minecraft:coal_ore"
end
--- 
function checkForRessources()
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
end



function mine(itemid, quantity)


	mining_spot = vector.new(current_pos.x, 55, current_pos.z)

	   


	for x = 1,2 do   --replace with while loop which checks for inventory containing certain items
		

		go_towards(mining_spot) --needs to be loaded from file later on 

		turn(directions["EAST"])
		for i = 0,20 do
			move_forward()
			checkForRessources()	
			turn(directions["EAST"])
		end
			move_forward()

		for i = 0,3 do 
			move_up()
		end
		
		--else calculate new mining spot 
		turn(directions["WEST"])

		for i = 0,20 do
			move_forward()
			checkForRessources()	
			turn(directions["EAST"])
		end


		--TODO calculate new mining spot
		  
	end


	

	--- mine y*x*z even
	--[[
	for y = 1,10  do
		for x = 1, 10 do
			if math.fmod(x, 2) == 1 then
				turn(directions["NORTH"])
			else 
				turn(directions["SOUTH"])
			end

			for z = 1, 10 do 
				move_forward()
			end
			if x ~= 10 then
					if math.fmod(y, 2) == 1 then
					move_up()
				else 
					move_down()
				end
			end
		end

		turn(directions["EAST"])
		move_forward()
	end
	--]]
	
	print("mining finished")
		--print(turtle.getItemCount())

		-- TODO actually mine for stuff
	
end


function move_forward()
	if turtle.detect() then
			turtle.dig()
		end
	 turtle.forward()

	if current_dir == directions["NORTH"] then
		current_pos.z = current_pos.z -1
	elseif current_dir == directions["EAST"] then 
		current_pos.x = current_pos.x +1
	elseif current_dir == directions["SOUTH"] then 
		current_pos.z = current_pos.z+1
	elseif current_dir == directions["WEST"] then
		current_pos.x = current_pos.x -1
	end
end

function move_up()
	if turtle.detectUp() then
		turtle.digUp()
	end
	turtle.up()
	current_pos.y = current_pos.y +1 
	
end

function move_down()
	if turtle.detectDown() then
		turtle.digDown()
	end
	turtle.down()
	current_pos.y = current_pos.y - 1 
end

function turn(dir)
	while current_dir ~= dir do
		turtle.turnLeft()
		current_dir = math.fmod(current_dir -1 +4 , 4)
	end
end


-- expects xyz as vector and then goes to this position

function go_towards(position)
	local offset = position - current_pos  --calculates the offset value
	print("going toward x: "..position.x.."y: "..position.y.."z: "..position.z)
	if offset.x > 0 then
		turn(directions["EAST"])
	elseif offset.x < 0 then 
		turn(directions["WEST"])
	end


	-- move in x -- 
	while offset.x ~= 0 do 
			move_forward()		
			if current_dir == directions["EAST"] then 
				offset.x= offset.x -1
			else 
				offset.x = offset.x+1
			end
		
	end
	-- move in y --

	if offset.y < 0 then 
		while offset.y ~= 0 do 
			move_down()
			offset.y = offset.y+1
		end
	else
		while offset.y ~= 0 do 
			move_up()
			offset.y = offset.y-1
			
		end
	end


	if offset.z > 0 then
		turn(directions["SOUTH"])
	elseif offset.z < 0 then 
		turn(directions["NORTH"])
	end
	-- move in z -- 
	while offset.z ~= 0 do 
		move_forward()
		
			if current_dir == directions["SOUTH"] then 
				offset.z = offset.z -1
			else 
				offset.z = offset.z +1
			end
		
	end
end


read_pos()


init_turtle()

gather_wood(3)
gather_wood(3)
gather_wood(3)
gather_wood(3)

go_towards(home)

write_pos()