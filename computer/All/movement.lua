-- This class implements every neccessary movement function and tracks the position of the turtle
-- Use the here defined methods instead of the turtle api to avoid weird side-effects



directions = {} --{"NORTH", "EAST", "SOUTH", "WEST"}

-- lua hat keine enums deshalb diese komische Lösung -- 
directions["NORTH"] = 0
directions["EAST"] = 1
directions["SOUTH"] = 2
directions["WEST"] = 3

home = vector.new(-460, 66,207)

current_dir ={}
current_pos ={}


function write_pos()
	local pos = {}
	pos["position"] = movement.current_pos
	pos["direction"] = movement.current_dir
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
	local turn_offset = math.fmod((dir - current_dir) + 4, 4)

	if turn_offset == 3 then
		turn_left()  --distance between directions  
	elseif turn_offset == 1 then 
		turn_right()
	elseif turn_offset == 2 then
		turn_left()
		turn_left()
	end
end

function turn_left()

	turtle.turnLeft()
	current_dir = math.fmod(current_dir -1 +4 , 4)
end
function turn_right()
	turtle.turnRight()
	current_dir = math.fmod(current_dir +1 , 4)
end




-- does not navigate in the house ... needs to be added later according to needs

function navigate(position)   -- must use furthest away first tactic ... 

	local offset = position - current_pos

	if in_house(position) and not in_house(current_pos) then
		print("goal in house and not inside house")
		--go towards the straight line of the next entrance.
		if math.abs(offset.x) >= math.abs(offset.y) and math.abs(offset.x) >= math.abs(offset.z) then 
			go_towards(vector.new(current_pos.x, home.y, home.z))	
		elseif math.abs(offset.y) >= math.abs(offset.x) and math.abs(offset.y) >= math.abs(offset.z) then 
			go_towards(vector.new(home.x, current_pos.y, home.z))	
		elseif math.abs(offset.z) >= math.abs(offset.x) and math.abs(offset.z) >= math.abs(offset.y) then 
			go_towards(vector.new(home.x, home.y, current_pos.z))
		end
		go_towards(home)
		go_towards(position)

	elseif not in_house(position) and not in_house(current_pos) then
		print("goal not in house and not inside house")
		-- walk while avoiding the hose ... 
		if house_in_the_way(position) then
			navigate(home)
			navigate(position)
		else
			go_towards(position)
		end
	elseif not in_house(position) and in_house(current_pos) then
		print("goal not in house and currently in house")
		-- go to the entrance where the offset bigger than the house (5) and 2 for y
		go_towards(home) --middle to avoid weird collisions
		if math.abs(offset.x) >= 5 then
			go_towards(vector.new(position.x, current_pos.y, current_pos.z))
		elseif  math.abs(offset.y) >= 5 then
			go_towards(vector.new(current_pos.x, current_pos.y, position.z))
		elseif offset.y <= 2 or offset.y >= 10 then
			go_towards(vector.new(current_pos.x, position.y, current_pos.z))
		end
		go_towards(position)
	end

end

-- expects xyz as vector and then goes to this position



--naively implements navigation going towards a position with prioity x y z ...
-- please use navigate instead unless you know what you are doing 
function go_towards(position)
	print("going towards x: "..position.x.." y: "..position.y.." z: "..position.z)
	print("from"..current_pos.x)
	local offset = position - current_pos  --calculates the offset value
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
	print("going finished")
end


--returns true if the turtle is in the starting areal boundary box
function in_house(pos)
	return pos.x < home.x + 5  and pos.x > home.x - 5 and
		   pos.z < home.z + 5  and pos.z > home.z - 5 and
		   pos.y < home.y + 10 and pos.y > home.y - 2
end

--determines if for a given goal the house is in the way. 
-- hopefully finds all cases
function house_in_the_way(pos)
	-- three cases if house is straight in the way
	if in_house(vector.new(home.x,pos.y, pos.z)) and in_house(vector.new(home.x,current_pos.y, current_pos.z))
		and ((pos.x >= home.x +5 and current_pos.x <= home.x -5) or (current_pos.x >= home.x +5 and pos.x <= home.x -5)) then
			return true
	elseif in_house(vector.new(pos.x,home.y, pos.z)) and in_house(vector.new(current_pos.x,home.y, current_pos.z)) 
		and ((pos.y >= home.y + 10 and current_pos.y <= home.y -2) or (current_pos.y >= home.y +10 and pos.y <= home.y -2)) then
			return true
	elseif in_house(vector.new(pos.x, pos.y, home.z)) and in_house(vector.new(current_pos.x,current_pos.y, home.z)) 
		and ((pos.z >= home.z +5 and current_pos.z <= home.z -5) or (current_pos.z >= home.z +5 and pos.z <= home.z -5)) then
			return true
	end

	-- case if turtle would walk x first and then walk in to the house while traversing the z - axis 
	print("is goal in square")
	print(in_house(vector.new(pos.x, home.y, pos.z)))
	print(in_house(vector.new(home.x, home.y, current_pos.z)))

	if  in_house(vector.new(home.x, pos.y, pos.z)) and 
		in_house(vector.new(home.x, current_pos.y, home.z)) and
		((current_pos.x < home.x+5 and pos.x >= home.x +5) or (pos.x <= home.x -5 and current_pos.x > home.x -5)) then
		return true
	elseif  in_house(vector.new(pos.x, home.y, pos.z)) and 
		in_house(vector.new(home.x, home.y, current_pos.z)) and
		((current_pos.y < home.y +10 and pos.y >= home.y +10) or (pos.y <= home.y -2 and current_pos.y > home.y -2)) then
		return true
	end
	return false   




end		   
