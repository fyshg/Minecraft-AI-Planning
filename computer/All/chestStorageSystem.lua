require("logger")
require("inventory")
require("generalHelpingFunctions")
require("itemstacksizesandMaxCounts")
chests={} --contains all information about the count of chests and their content
totalItemCounts={} -- total item counts over all chests
itemsWanted={} -- itemsWanted[itemname]=count
reserved ={} --contains items reserved for crafting and thus not available
function writeChestFile()
	--saves the chests table to file
	log(" Writing Chest File ")
	local h=fs.open("chests.michi","w")
	h.write(textutils.serialize(chests))
	h.close()
end

function readChestFile()
	--read the chests table from file
	local h=fs.open("Chests.michi","r")
	chests=textutils.unserialize(h.readAll())
	h.close()
end

function setupChests()
	--sets up a "empty" chests table
	chests={}
	chests["count"]=0
	chests["pos"]=0
	chests["rot"]=0
end

function addChestToData()
	--adds a chest to the table
	chests["count"]=chests["count"]+1
	chests[chests["count"]]={}
	chests[chests["count"]]["stackCount"]=0 --count of stacks of items in the chest
	chests[chests["count"]]["items"]={}
end

function addChest()
	addChestToData()
end


--a few methods for moving arount and saving the position in order to be able to go back to the start
function moveForward()
	while not turtle.up() do
		turtle.attackUp()
		turtle.digUp()
	end
	chests["pos"]=chests["pos"]+1
end

function moveBackwards()
	while not turtle.down() do
		--turtle.turnLeft()
		--turtle.turnLeft()
		--turtle.attack()
		--turtle.dig()
		--turtle.turnLeft()
		--turtle.turnLeft()
		turtle.digDown()
		turtle.attackDown()
	end
	chests["pos"]=chests["pos"]-1
end

function turnLeft()
	turtle.turnLeft()
	chests["rot"]=chests["rot"]-1
end

function turnRight()
	turtle.turnRight()
	chests["rot"]=chests["rot"]+1
end

function gotoChest(index)
	while chests["pos"]<index/4 do
		moveForward()
	end
	while chests["pos"]>(index+3)/4 do
		moveBackwards()
	end

	lr=(index-1)%4
	k=(lr-chests["rot"]+8)%4
	if k==3 then turnLeft()
	else
		while k>0 do
			turnRight()
			k=k-1
		end
	end
	--obvious
	--while chests["rot"]<0 do
	--	turnRight()
	--end
	--while chests["rot"]>0 do
	--	turnLeft()
	--end
end

function gotoStart()
	--return to the start
	if chests["rot"]==3 then chests["rot"]=-1 end
	if chests["rot"]==-3 then chests["rot"]=1 end
	while chests["rot"]<0 do
		turnRight()
	end
	while chests["rot"]>0 do
		turnLeft()
	end
	while chests["pos"]>0	do
		moveBackwards()
	end
end

function start()
	-- read chests file
	if fs.exists("Chests.michi") then
		readChestFile()
	else
		setupChests()
	end
end

function inventur()
	--turtle should have empty inventory when using this methods
	--counts chests, checks their content, saves all info to file
	i=1
	setupChests()
	while true do
		gotoChest(i)
		turtle.select(1)
		suc, dat=turtle.inspect()
		if suc and dat.name=="minecraft:chest" then
			addChestToData()
			for _=1,8 do turtle.suck() end
			for j=1,8 do
				turtle.select(j)
				d=turtle.getItemDetail()
				if d~=nil then
					chests[i].items[j]=d
					turtle.drop()
					chests[i].stackCount=j
				end
			end
			i=i+1
		else
			gotoStart()
			writeChestFile()
			return
		end
	end
	
end

function storeRest()
	countInventory()
	log("Dropping rest in Chests")
	--stores everything, which is not needed for the recipe, in chests
	itemsDesignatedForChest={} --itemsDesignatedForChest[3]=List of items, which should be put in Chest 3
	itemsToStoreInAnyChest={}
	tmp={} -- List of items needed for crafting, local copy
	for i,_ in pairs(itemsWanted) do
		tmp[i]=itemsWanted[i]
	end


--check, in which chests to put which items
	for i=1,16 do
		local it=items[i]
		if it~=nil then
			local putCount=it.count
			if tmp[it["name"]]~=nil then
				putCount=math.max(putCount-tmp[it["name"]],0)
				if putCount~=0 then
					tmp[it["name"]]=tmp[it["name"]]-putCount
					if tmp[it["name"]]==0 then
						tmp[it["name"]]=nil
					end

				end
			end
			if putCount~=0 then
				-- look for a chest to put "it" in
				local target=findChestFor(it.name,putCount)
				if target==nil then
					itemsToStoreInAnyChest[i]=putCount
				else
					if itemsDesignatedForChest[target.chestIndex]==nil then itemsDesignatedForChest[target.chestIndex]={} end
					itemsDesignatedForChest[target.chestIndex][i]=target["count"]
				end
			end
		end
	end


--go from one chest to the next and store the items there
	for i=1,chests.count do
		if chests[i]["stackCount"]<8 and tableSize(itemsToStoreInAnyChest)~=0 or itemsDesignatedForChest[i]~=nil then
			gotoChest(i)
			if itemsDesignatedForChest[i]~=nil then
				for j in pairs(itemsDesignatedForChest[i]) do
					--log("Putting designated items to chest ",i)
					turtle.select(j)
					turtle.drop(itemsDesignatedForChest[i][j])
					addItemToChest(i,items[j].name,itemsDesignatedForChest[i][j])
					itemsDesignatedForChest[i][j]=nil
				end
			end
			for j in pairs(itemsToStoreInAnyChest) do
				if chests[i]["stackCount"]<8 then
					--log("Putting undesignated items to chest",i)
					turtle.select(j)
					turtle.drop(itemsToStoreInAnyChest[j])
					addItemToChest(i,items[j].name,itemsToStoreInAnyChest[j])
					itemsToStoreInAnyChest[j]=nil
				else
					break
				end
			end
		end
	end
	--return to start and save changes
	gotoStart()
	writeChestFile()
end

function getFromChests(itemname, count)
	if count==0 then return end
	log("Getting "..count.." of "..itemname.." from chests")
	sortInventory()
	for i,_ in pairs(itemsWanted) do
		itemsWanted[i]=nil
	end
	if inv[itemname]==nil then
		itemsWanted[itemname]=count
	else
		itemsWanted[itemname]=inv[itemname]+count
	end
	getmissing()
end

function getmissing()
	log("Getting missing items!")
	sortInventory()
	local tmp={} -- List of items needed for crafting, local copy
	for i,_ in pairs(itemsWanted) do
		log("Item Wanted: "..i.." count "..itemsWanted[i])
		tmp[i]=itemsWanted[i]
		if inv[i]~=nil then
			tmp[i]=tmp[i]-inv[i]
			if tmp[i]==0 then
				tmp[i]=nil
			end
		end
	end

	--check, in which chests the searched items are
	toGet={}-- toGet[i][j]= count of items to take from chest i, slot j
	for i = 1,chests["count"] do
		toGet[i]={}
		for j=1,8 do
			if chests[i].items[j]~=nil then
				local c=tmp[chests[i].items[j].name]
				if c~=nil then
					toGet[i][j]=math.min(c,chests[i].items[j].count)
					tmp[chests[i].items[j].name]=math.max(0,c-chests[i].items[j].count)
				end
			end
		end
		if tableSize(toGet[i])==0 then
			toGet[i]=nil
		end
		if tableSize(tmp)==0 then
			break
		end
	end

--get the items
	for i =  1,chests.count do
		--if a searched item is in chest i go there
		if toGet[i]~=nil then
			log("Getting from chest "..i)
			log(toGet[i],"from "..i)
			gotoChest(i)
			turtle.select(1)
			-- take all items
			for _=1,8 do turtle.suck() end
			-- a second counter is needed, as it could happen, that the turtle keeps all items from slot 3, therefore the items from the 4th slot move to the 3rd, the ones from the 5th to the 4th and so on0
			local ind=1
			for j=1,8 do
				--if the j-th item is nil, then we are already done
				if chests[i].items[j]==nil then 
					break 
				end
				turtle.select(j)
				--if toGet[i][j] is nil, then put everything back, else keep some items
				if toGet[i][j]==nil then
					chests[i].items[ind]=chests[i].items[j]
					turtle.drop()
					ind=ind+1
				else
					--in case of equality, keep all items and therefore don't change anything
					-- elsewise return the rest
					if chests[i].items[j].count~=toGet[i][j] then
						chests[i].items[ind]=chests[i].items[j]
						local dropCount=chests[i].items[j].count-toGet[i][j]
						log("Dropcount: "..dropCount)
						turtle.drop(dropCount)
						local it={}
						it.name=chests[i].items[j].name
						it.count=dropCount
						chests[i].items[ind]=it
						ind=ind+1
					end
				end
			end
			for j=ind,chests[i].stackCount do
				chests[i][j]=nil
			end
			chests[i].stackCount=ind-1
			sortInventory()
		end
	end
	gotoStart()
	print_table(chests)
	writeChestFile()
end

function addItemToChest(chest,name,count)
	-- 
	for i=1,8 do
		t=chests[chest].items[i]
		if t==nil then
			chests[chest].stackCount=chests[chest].stackCount+1
			chests[chest].items[i]={name=name,count=count}
			return true
		else
			if chests[chest].items[i].name==name and chests[chest].items[i].count<getStackSize(name) then
				chests[chest].items[i].count=chests[chest].items[i].count+count
				return true
			end
		end
	end
	log("Couldn't find where to put "..count.." "..name.." in chest"..chest)
	return false
end

function findChestFor(item,count)
	for i=1,chests["count"] do
		for j=1,chests[i]["stackCount"] do
			if chests[i]["items"][j]~=nil and chests[i]["items"][j]["name"]==item then
				if chests[i]["items"][j]["count"]<getStackSize(item) then
					return {chestIndex=i, count=math.min(count, getStackSize(item)-chests[i]["items"][j]["count"])}
				end
			end
		end
	end
	return nil
end

function getItemsFor( itemname, count )
	log("Getting items from chests: for "..itemname.." x "..count)
	count=count or 1
	setRecipe(itemname, count)
	countInventory()
	--check Which items are needed
	for i,_ in pairs(itemsWanted) do
		itemsWanted[i]=nil
	end
	for i,_ in pairs(itemsNeeded) do
		if i=="woods" then
			local tmp=itemsNeeded[i]
			for _,k in pairs(woods) do
				if (tmp>0 and totalItemCounts[k]~=nil and totalItemCounts[k]>0) then
					itemsWanted[k]=math.min(totalItemCounts[k],tmp)
					tmp=tmp-itemsWanted[k]
				end
			end
		elseif i=="planks" then
			local tmp=itemsNeeded[i]
			for _,k in pairs(planks) do
				if (tmp>0 and totalItemCounts[k]~=nil and totalItemCounts[k]>0) then
					itemsWanted[k]=math.min(totalItemCounts[k],tmp)
					tmp=tmp-itemsWanted[k]
				end
			end
		else
			itemsWanted[i]=itemsNeeded[i]
		end
	end
	--store the rest in chests
	storeRest()
	--get the missing items
	getmissing()
end

function sumInventoryAndAllChests()
	log("Summing up inventory and Chests")
	countInventory()
	--reset totalitemcounts
	for t,_ in pairs(totalItemCounts) do
		totalItemCounts[t]=nil
	end
	--log("Counting in inventory")
	--count from inventory
	for i,_ in pairs(inv) do
		--log(i)
		--log(items[i])
		totalItemCounts[i]=inv[i]
	end
	--log("Counting in chests")
	--count from chests
	for i = 1,(chests["count"]) do
		for j in pairs(chests[i].items) do
			local ct=chests[i].items[j]
			if totalItemCounts[ct.name]==nil then
				totalItemCounts[ct.name]=ct.count
			else
				totalItemCounts[ct.name]=totalItemCounts[ct.name]+ct.count
			end
		end
	end
end

function maximumItemCountAvailable(itemname, mindReservations)
	mindReservations = mindReservations or false
	if totalItemCounts[itemname]==nil then return 0 end
	if not mindReservations or reserved[itemname]==nil then return totalItemCounts[itemname] end
	return totalItemCounts[itemname]-reserved[itemname]
end

function itemsAvailable(itemname, count, mindReservations)
	mindReservations = mindReservations or false
	--for i,_ in pairs(totalItemCounts) do
	--	log(i.."  "..totalItemCounts[i])
	--end
	if totalItemCounts[itemname]==nil then
		log(count.." of "..itemname.." wanted, have none")
	else
		log(count.." of "..itemname.." wanted, have "..totalItemCounts[itemname])
	end
	if mindReservations then
		if reserved[itemname]==nil then
		--	log("None are reserved")
		else
			log(reserved[itemname].." are already reserved")
		end
	end
	if totalItemCounts[itemname]==nil
		then return false
		else
		if mindReservations and not reserved[itemname]==nil then
			return  totalItemCounts[itemname]-reserved[itemname]>=count
		else
			return  totalItemCounts[itemname]>=count
		end

	end
end

function reserve(itemname, count)
	if reserved[itemname]==nil then
		reserved[itemname]=count
	else
		reserved[itemname]=reserved[itemname]+count
	end
end

function resetReservations()
	for t in pairs(reserved) do
		reserved[t]=nil
	end
end

function dropInventory()
	for k,_ in pairs(itemsWanted) do
		itemsWanted[k]=nil
	end
	storeRest()
end