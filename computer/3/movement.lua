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

	print("offset: "..turn_offset.." dir: "..dir.."current_dir :".. current_dir)
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
	print(" turning left")
	turtle.turnLeft()
	current_dir = math.fmod(current_dir -1 +4 , 4)
end
function turn_right()
	turtle.turnRight()
	current_dir = math.fmod(current_dir +1 , 4)
	print(" turning right")
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
