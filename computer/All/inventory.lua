require("itemstacksizesAndMaxCounts")
inv={} --inv[itemname], contains count
items={} --array of itemdetails
slot={} --slot[itemname] tells in which slot <itemname> is

mined = {}

function resetInv()
	for i,_ in pairs(inv) do
		inv[i]=nil
	end
	for i,_ in pairs(slot) do
		slot[i]=nil
	end
	for i,_ in pairs(items) do
		items[i]=nil
	end
end

function countInventory()
	--inv={}
	resetInv()
	for i=1,16 do
		det=turtle.getItemDetail(i)
		items[i]=det
		if det~=nil then
			--log(det)
			if inv[det.name]==nil
			then 
				inv[det.name]=det.count
				slot[det.name]=i
			else
				before=inv[det.name]
				toPut=math.min(getStackSize(det.name)-before, det.count)
				inv[det.name]=inv[det.name]+det.count
				turtle.select(i)
				turtle.transferTo(slot[det.name])
				items[slot[det.name]].count=items[slot[det.name]].count+toPut
				items[i]=turtle.getItemDetail()
			end
		end
	end
	log("Counted inventory!")
end

function printInventoryNames()
	log("Printing Inventory Names")
	for i=1,16 do
		turtle.select(i)
		if (turtle.getItemDetail()~=nil)
		then
			log(turtle.getItemDetail().name)
		end
	end
end

function sortInventory(reverse)
	if reverse==nil then reverse = false end
	--items in the last slots, first slots empty
	countInventory()
	local j=16
	while items[j]~=nil do 
		j=j-1 
	end
	for i=1,16 do
		if i>=j then
			return
		end

		l=j
		k=i
		if reverse then k=17-i end
		if reverse then l=17-j end

		if items[k]~=nil then
			turtle.select(k)
			turtle.transferTo(l)
			items[l]=items[k]
			items[k]=nil
			while items[l]~=nil do
				l=l-1
			end
		end
	end
	countInventory()
end

function dropAbundantItems(withSorting)
	if withSorting==nil then withSorting=true end
	removed=false
	sumInventoryAndAllChests()
	for i=1,16 do
		id=turtle.getItemDetail(i)
		if id~=nil then
			c=id.count
			tot=totalItemCounts[id.name]
			if tot==nil then
				log("Something strange happened: DropAbundantItems says tot is nil")
			else
				dropCount=math.min(c,tot-maxCountToKeep(id.name))
				log(i.."   "..dropCount)
				if dropCount>0 then
					removed=true
					turtle.select(i)
					turtle.drop(dropCount)
					totalItemCounts[id.name]=totalItemCounts[id.name]-dropCount
				end
			end

		end
	end
	if withSorting and removed then sortInventory(true) end
end


function countLogs()
	countInventory()
	local logs = 0
	logs = logs + countOf("minecraft:spruce_log")
	logs = logs + countOf("minecraft:birch_log")
	logs = logs + countOf("minecraft:oak_log")
	logs = logs + countOf("minecraft:jungle_log")
	logs = logs + countOf("minecraft:acacia_log")
	logs = logs + countOf("minecraft:dark_oak_log")
	return logs
end
function countOf(itemname)
	if inv[itemname]==nil then return 0	end
	return inv[itemname]
end

function saveExtraMined(item, quantity)
	done = false
    countInventory()
    dropAbundantItems()
	for i = 1,16 do
		name = turtle.getItemDetail(i).name
		count = turtle.getItemDetail(i).count
		if name == item and count >= quantity and not done then
			addToStored(name, quantity - count )
			done = true
		else
			addToStored(name, count)
		end
	end
end

function addToStored(item, quantity)
	if stored[item] == nil then
		stored[item] = quantity
	else
		stored[item] = stored[item] + quantity
	end
end

function checkMined(item, quantity)
	if Mined[item] ~= nil and Mined[item] >= quantity then
		Mined[item] = Mined[item] - quantity
		return true
	end
	return false
end