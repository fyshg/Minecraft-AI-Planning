recipe={{0,0,0},{0,0,0},{0,0,0}}


inv={}

function countInventory()
	inv={}
	for i=1,16 do
		turtle.select(i)
		det=turtle.getItemDetail()
		if inv[det.name]==nil
		then
			inv[det.name]=det.count
		else
			inv[det.name]=inv[det.name]+det.count
		end
	end
	print(inv)
end

	
function setRecipe(id)
 if (id=="minecraft:diamond_pickaxe")
 	then print("Crafting Axe")
 end
end