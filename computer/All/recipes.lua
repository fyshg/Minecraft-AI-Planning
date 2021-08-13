rec={6,6,6}
count=1
mult=1
name=""
itemsNeeded={} --itemsNeeded[<name>]=count of item <name> needed
maxCount=64 -- how many items of the current recipe can maximally be crafted (for example: 16 diamond pickaxes, as there is not space for 17 in turtle inventory)
-- but only 10 doors, as 11 need more than 1 stack of planks

function checkInventoryMatchesRecipe()
	-- returns: true, if inventory matches recipe, false, if not
	inventory.countInventory()
	logger.log("inv: "..textutils.serialize(inventory.inv)..", end")
	for i=1,3 do
		for j=1,3 do
			if rec[i][j]~=nil
			then
				if inventory.inv[rec[i][j]]==nil
				then
					logger.log("Doesn't Match!")
					logger.log(textutils.serialize(inventory.inv))
					logger.log(rec[i][j])
					return false
				else
					inventory.inv[rec[i][j]]=inventory.inv[rec[i][j]]-count
				end
			end
		end
	end
	for i in pairs(inventory.inv) do
		if inventory.inv[i]~=0 
		then
			logger.log("Too many or not enough items!")
			logger.log(inventory.inv[i])
			logger.log(i)
			return false
		end
	end
	logger.log("Matches!")
	return true
end

function craftIndexToInvIndex(y,x)
	return 4*(y-1)+x
end

function arrangeInventoryToRecipe()
	inventory.countInventory()
	for i=1,16 do
		if inventory.items[i]~=nil then
			turtle.select(i)
			for y=1,3 do
				for x=1,3 do
					if turtle.getItemDetail()~=nil and rec[y][x]==turtle.getItemDetail().name then
						turtle.transferTo(craftIndexToInvIndex(y,x),count)
					end
				end
			end
		end
	end
end

function craftRecipe()
end

function setRecipe(id,c)
	count=c or 1
	name=id
	--logger.log("Setting recipe to "..id.." x "..c)
 	if (id=="minecraft:diamond_pickaxe")
 		then
 		rec={{"minecraft:diamond","minecraft:diamond","minecraft:diamond"},{nil,"minecraft:stick",nil},{nil,"minecraft:stick",nil}}
 		maxCount=16
		--count=math.min(count,maxCount)
		recipes.mult=1
		recalculateItemsNeeded()
		return true;
	elseif (id=="minecraft:chest")
	then
		rec={{"minecraft:oak_planks","minecraft:oak_planks","minecraft:oak_planks"},{"minecraft:oak_planks",nil,"minecraft:oak_planks"},{"minecraft:oak_planks","minecraft:oak_planks","minecraft:oak_planks"}}
		maxCount=8
		--count=math.min(count,maxCount)
		recipes.mult=1
		recalculateItemsNeeded()
		return true;
	elseif (id=="minecraft:oak_planks")
	then
		rec={ { nil,nil,nil},{nil,"minecraft:oak_log",nil },{nil,nil,nil}}
		maxCount=256
		--count=math.min(count,maxCount)
		recipes.mult=4
		recalculateItemsNeeded()
		return true;
 	end
	logger.log("Recipe not found!")
	return false;
end 

function recalculateItemsNeeded()
	for i in pairs(itemsNeeded) do
		itemsNeeded[i]=nil
	end
	local c=math.ceil(count/recipes.mult)
	for i=1,3 do
		for j=1,3 do
			if rec[i][j]~=nil then
				if itemsNeeded[rec[i][j]]==nil then
					itemsNeeded[rec[i][j]]=c
				else
					itemsNeeded[rec[i][j]]=itemsNeeded[rec[i][j]]+c
				end
			end
		end
	end
	if count>maxCount then
		logger.log("Warning: Recipe set for "..count.." of "..name..", but maximum craftable in 1 batch is "..maxCount.."!")
	end
end