function getStackSize(name)
	if name=="minecraft:diamond" then return 64 end
	if name=="minecraft:stick" then return 64 end
	print("Itemstacksizes: Unknown item: ",name)
	return 64
end