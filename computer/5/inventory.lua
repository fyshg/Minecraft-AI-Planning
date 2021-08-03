inv={} --inv[itemname], contains name, count
items={} --array of itemdetails
slot={} --slot[itemname] tells in which slot <itemname> is

function resetInv()
	for i in pairs(inv) do
		inv[i]=nil
	end
	for i in pairs(slot) do
		slot[i]=nil
	end
	for i in pairs(items) do
		items[i]=nil
	end
end
function countInventory()
	--inventory.inv={}
	resetInv()
	for i=1,16 do
		turtle.select(i)
		det=turtle.getItemDetail()
		items[i]=det
		if det~=nil then
			--print(det)
			if inv[det.name]==nil
			then 
				inv[det.name]=det.count
				slot[det.name]=i
			else
				before=inv[det.name]
				toPut=math.min(itemstacksizes.getStackSize(det.name)-before, det.count)
				inv[det.name]=inv[det.name]+toPut
				turtle.transferTo(slot[det.name])
				items[slot[det.name]].count=items[slot[det.name]].count+toPut
				items[i]=turtle.getItemDetail()
			end
		end
	end
	print("Counted inventory!")
end


function printInventoryNames()
	for i=1,16 do
		turtle.select(i)
		if (turtle.getItemDetail()~=nil)
		then
			print(turtle.getItemDetail().name)
		end
	end
end


function sortInventory()
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
		if items[i]~=nil then
			turtle.select(i)
			turtle.transferTo(j)
			items[j]=items[i]
			items[i]=nil
			while items[j]~=nil do 
				j=j-1 
			end
		end
	end
end