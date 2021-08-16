

--This class initializes a new turtle


function init_turtle(arg)
	if arg ~= nil and #arg == 4 then
		movement.current_pos = vector.new(arg[1], arg[2], arg[3])
		movement.current_dir = movement.directions[tostring(arg[4])]
	else
		movement.current_pos = vector.new(-460, 66,207)
		movement.current_dir = movement.directions["EAST"]
	end
	movement.write_pos()

	spiral = {}
	spiral["progress"] = 1
	spiral["dir"] = movement.directions["SOUTH"]  --default value
	spiral["ring"] = 4
	spiral["pos"] = movement.current_pos
	local w = fs.open("gathering.txt", "w")
	w.write(textutils.serialize(spiral))
	w.close()

	mining = {}
	mining["pos"] = vector.new(movement.current_pos.x,60,movement.current_pos.z) -- starting mining spot
	mining["heigth"] = 0
	local w = fs.open("mining.txt", "w")
	w.write(textutils.serialize(mining))
	w.close()
end



