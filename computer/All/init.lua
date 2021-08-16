
--This class initializes a new turtle


function init_turtle(arg)
	if arg ~= nil and #arg == 4 then
		current_pos = vector.new(arg[1], arg[2], arg[3])
		current_dir = directions[tostring(arg[4])]
	else
		current_pos = vector.new(-460, 66,207)
		current_dir = directions["EAST"]
	end
	write_pos()

	spiral = {}
	spiral["progress"] = 1
	spiral["dir"] = directions["SOUTH"]  --default value
	spiral["ring"] = 5
	spiral["pos"] = vector.new(current_pos.x -5, current_pos.y, current_pos.z)
	local w = fs.open("gathering.txt", "w")
	w.write(textutils.serialize(spiral))
	w.close()

	mining = {}
	mining["pos"] = vector.new(current_pos.x,60,current_pos.z) -- starting mining spot
	mining["heigth"] = 0
	local wm = fs.open("mining.txt", "w")
	wm.write(textutils.serialize(mining))
	wm.close()
end



