function getStackSize(name)
	if name=="minecraft:diamond" then return 64 end
	if name=="minecraft:stick" then return 64 end
	if name=="minecraft:cobblestone" then return 64 end
	logger.log("Itemstacksizes: Unknown item: "..name)
	return 64
end

function maxCountToKeep(name)
	return 128;
end