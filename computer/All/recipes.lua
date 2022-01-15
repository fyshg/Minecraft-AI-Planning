rec={6,6,6}
count=1
mult=1
woods={"minecraft:oak_log","minecraft:spruce_log","minecraft:birch_log","minecraft:jungle_log","minecraft:acacia_log","minecraft:dark_oak_log","minecraft:crimson_log","minecraft:warped_log"}
planks={"minecraft:oak_planks","minecraft:spruce_planks","minecraft:birch_planks","minecraft:jungle_planks","minecraft:acacia_planks","minecraft:dark_oak_planks","minecraft:crimson_planks","minecraft:warped_planks"}
name=""
itemsNeeded={} --itemsNeeded[<name>]=count of item <name> needed
maxCount=64 -- how many items of the current recipe can maximally be crafted (for example: 16 diamond pickaxes, as there is not space for 17 in turtle inventory)
-- but only 10 doors, as 11 need more than 1 stack of planks

function craftIndexToInvIndex(y,x)
	return 4*(y-1)+x
end

function arrangeInventoryToRecipe()
	--Arranges the inventory to the shape of the recipe
	countInventory()
	log("Arranging Inventory to craft "..count.." times.")
	verbose=true
	for i=1,16 do
		if items[i]~=nil then
			turtle.select(i)
			for y=1,3 do
				for x=1,3 do
					if turtle.getItemDetail()~=nil and has_value(rec[y][x],turtle.getItemDetail().name) then
						if verbose then
							log("Moving "..(count/mult).." items from slot"..i.." to slot "..craftIndexToInvIndex(y,x))
						end
						turtle.transferTo(craftIndexToInvIndex(y,x),count/mult)
					end
				end
			end
		end
	end
end

function setRecipe(id,c)
	count=c or 1
	name=id
	--log("Setting recipe to "..id.." x "..c)
	if (id=="minecraft:diamond_pickaxe")
	then
		rec={{{"minecraft:diamond"},{"minecraft:diamond"},{"minecraft:diamond"}},{nil,{"minecraft:stick"},nil},{nil,{"minecraft:stick"},nil}}
		maxCount=16
		--count=math.min(count,maxCount)
		mult=1
		recalculateItemsNeeded()
		return true;
	elseif (id=="minecraft:chest")
	then
		rec={{planks,planks,planks},{planks,nil,planks},{planks,planks,planks}}
		maxCount=1
		--count=math.min(count,maxCount)
		mult=1
		recalculateItemsNeeded()
		return true;
	elseif (id=="merged:planks")
	then
		rec={ { nil,nil,nil},{nil,woods,nil },{nil,nil,nil}}
		maxCount=4
		--count=math.min(count,maxCount)
		mult=4
		recalculateItemsNeeded()
		return true;
	elseif (id=="minecraft:startChest")
	then
		rec={{planks,planks,planks},{planks,nil,planks},{planks,planks,planks}}
		maxCount=3
		--count=math.min(count,maxCount)
		mult=1
		recalculateItemsNeeded()
		return true;
	elseif (id=="minecraft:startPlanks")
	then
		rec={ { nil,nil,nil},{nil,wood,nil },{nil,nil,nil}}
		maxCount=256
		--count=math.min(count,maxCount)
		mult=4
		recalculateItemsNeeded()
		return true;
	elseif (id=="computercraft:computer_normal")
	then
		rec={ { {"minecraft:stone"},{"minecraft:stone"},{"minecraft:stone"}},{{"minecraft:stone"},{"minecraft:redstone"},{"minecraft:stone" }},{{"minecraft:stone"},{"minecraft:glass_pane"},{"minecraft:stone"}}}
		maxCount=9
		--count=math.min(count,maxCount)
		mult=1
		recalculateItemsNeeded()
		return true;
	elseif (id=="computercraft:turtle_normal")
	then
		rec={ { {"minecraft:iron_ingot"},{"minecraft:iron_ingot"},{"minecraft:iron_ingot"}},{{"minecraft:iron_ingot"},{"computercraft:computer_normal"},{"minecraft:iron_ingot" }},{{"minecraft:iron_ingot"},{"minecraft:chest"},{"minecraft:iron_ingot"}}}
		maxCount=9
		--count=math.min(count,maxCount)
		mult=1
		recalculateItemsNeeded()
		return true;
	elseif (id=="minecraft:glass_pane")
	then
		rec={ { {"minecraft:glass"},{"minecraft:glass"},{"minecraft:glass"}},{{"minecraft:glass"},{"minecraft:glass"},{"minecraft:glass"}},{nil,nil,nil}}
		maxCount=160
		--count=math.min(count,maxCount)
		mult=16
		recalculateItemsNeeded()
		return true;
	elseif (id=="computercraft:turtle_mining")
	then
		rec={ { nil, nil, nil},{{"minecraft:diamond_pickaxe"},{"computercraft:turtle_normal"},nil },{nil, nil, nil}}

		maxCount=8
		--count=math.min(count,maxCount)
		mult=1
		recalculateItemsNeeded()
		return true;
	elseif (id=="computercraft:turtle_mining_crafty")
	then
		rec={ { nil, nil, nil},{{"minecraft:crafting_table"},{"computercraft:turtle_mining"},nil },{nil, nil, nil}}

		maxCount=8
		--count=math.min(count,maxCount)
		mult=1
		recalculateItemsNeeded()
		return true;
	elseif (id=="minecraft:stick") then
		rec = {{nil,planks,nil},{nil,planks, nil},{nil,nil,nil}}
		maxCount=4
		mult=4
		recalculateItemsNeeded()
		return true;
	elseif (id=="minecraft:furnace") then
		rec = {{{"minecraft:cobblestone"},{"minecraft:cobblestone"},{"minecraft:cobblestone"}},{{"minecraft:cobblestone"},nil,{"minecraft:cobblestone"}},{{"minecraft:cobblestone"},{"minecraft:cobblestone"},{"minecraft:cobblestone"}}}
		maxCount=64
		mult=1
		recalculateItemsNeeded()
		return true;
	elseif (id=="minecraft:crafting_bench")
	then
		rec={{nil, nil, nil},{planks,planks,nil},{planks,planks,nil}}
		maxCount=64
		--count=math.min(count,maxCount)
		mult=1
		recalculateItemsNeeded()
		return true;
	end
	log("Recipe not found!")
	return false;
end

function recalculateItemsNeeded()
	for i,_ in pairs(itemsNeeded) do
		itemsNeeded[i]=nil
	end
	local c=math.ceil(count/mult)
	for i=1,3 do
		for j=1,3 do
			if rec[i][j]~=nil then


				index=""


				if
				(rec[i][j]==woods)
				then
					index="woods"
				elseif (rec[i][j]==planks)
				then
					index="planks"
				else
					index=rec[i][j][1]
				end


				if itemsNeeded[index]==nil then
					itemsNeeded[index]=c
				else
					itemsNeeded[index]=itemsNeeded[index]+c
				end
			end
		end
	end
	if count>maxCount then
		log("Warning: Recipe set for "..count.." of "..name..", but maximum craftable in 1 batch is "..maxCount.."!")
	end
end