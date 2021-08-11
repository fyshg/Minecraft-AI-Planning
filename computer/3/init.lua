require 'movement'
require 'farming'

--This class initializes a new turtle


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
	mining = {}
	mining["pos"] = vector.new(current_pos.x,60,current_pos.z) -- starting mining spot
	mining["heigth"] = 0
	local w = fs.open("mining.txt", "w")
	w.write(textutils.serialize(mining))
	w.close()
end

read_pos()


init_turtle()


mine()
go_towards(home)
mine()

write_pos()