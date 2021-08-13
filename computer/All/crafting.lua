function itemsToCraftAvailable(itemname, count, recursion, useExistingItems, withCurrentReservations)
    if withCurrentReservations== nil then withCurrentReservations=false end
    if recursion==nil then recursion=true end
    if not withCurrentReservations then
        chestStorageSystem.resetReservations()
        chestStorageSystem.sumInventoryAndAllChests()
    end

    return itemsToCraftAvailableHelper(itemname, count, recursion, useExistingItems)
end

function itemsToCraftAvailableHelper(itemname, count, recursion, notFirstStep)
    logger.log("Checking for availability of "..count.."  "..itemname)
     if chestStorageSystem.itemsAvailable(itemname,count,true) and notFirstStep then
            chestStorageSystem.reserve(itemname, count)
        else
            if notFirstStep then
                local available=chestStorageSystem.maximumItemCountAvailable(itemname)
                chestStorageSystem.reserve(itemname, available)
                count=count-available;
            end
            if not recipes.setRecipe(itemname,count) then
                -- checks if recipe exists and ALSO sets it
                logger.log("No Recipe found for "..itemname)
                return false
            end
            local itemsWanted={}
            for i in pairs(recipes.itemsNeeded) do
                itemsWanted[i]=recipes.itemsNeeded[i]
            end
            for i in pairs(itemsWanted) do
                if recursion then
                    if not itemsToCraftAvailableHelper(i,itemsWanted[i],recursion,true) then
                        logger.log(i.." not available!")
                        return false
                    end
                else
                    if not chestStorageSystem.itemsAvailable(i, itemsWanted[i]) then
                        logger.log(i.." not available!")
                        return false
                    end
                end
            end
        end
    logger.log(itemname.." available!")
    return true
end

function craft(itemname, count, checkForAvailability, alsoGetAlreadyExistingItems)
    logger.log("Crafting "..itemname.." x "..count.." directly")
    checkForAvailability=checkForAvailability or false
    if checkForAvailability then
        if not itemsToCraftAvailable(itemname,count,false, alsoGetAlreadyExistingItems) then
            return false
        end
    end
    if (alsoGetAlreadyExistingItems) then
        max=chestStorageSystem.maximumItemCountAvailable(itemname)
        if max>=count then
            logger.log("Items already available in Chests/Inventory!")
            chestStorageSystem.getFromChests(itemname,count)
        else
            craft(itemname,count-max,false,false)
            chestStorageSystem.getFromChests(itemname,max)
        end
        return true
    end
    logger.log("Getting items!")
    -- if too many items need to be crafted, crafting needs to be repeated multiple times
    for i=1,math.floor(count/recipes.maxCount) do
        logger.log("Getting a full batch!")
        chestStorageSystem.getItemsFor(itemname,recipes.maxCount)
        turtle.craft(count)
    end
    logger.log("Getting items for "..itemname.." x "..(count%recipes.maxCount))
    chestStorageSystem.getItemsFor(itemname,count%recipes.maxCount)
    recipes.arrangeInventoryToRecipe()
    turtle.craft(count%recipes.maxCount)
    return true
end

function craftRecursively(itemname, count, checkForAvailability, alsoGetAlreadyExistingItems)
    checkForAvailability=checkForAvailability or false
    if checkForAvailability then
        if not itemsToCraftAvailable(itemname,count,true, alsoGetAlreadyExistingItems) then
            return false
        end
    end

    logger.log("Crafting "..itemname.." x "..count.." with recursion")

    if (alsoGetAlreadyExistingItems) then
        max=chestStorageSystem.maximumItemCountAvailable(itemname)
        if max>=count then
            logger.log("Items already available in Chests/Inventory!")
            chestStorageSystem.getFromChests(itemname,count)
            return true
        elseif max>0 then
            recipes.setRecipe(itemname,count-max)
            local willCraft=recipes.mult*(math.ceil((count-max)/recipes.mult))
            --logger.log("COUNTS: "..itemname.."  "..willCraft.."  "..count-willCraft.."  "..max.."  "..recipes.mult)
            logger.log("Crafting "..willCraft.." and getting the Rest from Chests")
            chestStorageSystem.reserve(itemname,max)
            craftRecursively(itemname,count-max,false,false)

            chestStorageSystem.getFromChests(itemname,count-willCraft)
            return true
        end
    end


--logger.log("Still trying to craft "..itemname.." x "..count)
    if itemsToCraftAvailable(itemname,count,false, false,true) then
        --can be crafted directly
        logger.log("Going to craft directly, ingredients available!")
        craft(itemname,count,false,false)
    else
        logger.log("Time to (re-)curse! From: "..itemname.." x "..count)
        --recursion needs to be done
        recipes.setRecipe(itemname,count)
        local tmpItemsNeeded={}
        for item in pairs(recipes.itemsNeeded) do
            tmpItemsNeeded[item]=recipes.itemsNeeded[item]
        end
        for item in pairs(tmpItemsNeeded) do
            if not chestStorageSystem.itemsAvailable(item,tmpItemsNeeded[item]) then
                -- if item is not in chests, it needs to be crafted first
                craftRecursively(item,tmpItemsNeeded[item],false,true)
            end
        end
        -- now call yourself again, this way:
        -- if now all items are ready, the wanted item will be crafted directly
        -- if one of the necessary items was used for crafting another necessary item, it will be crafted again
        chestStorageSystem.sumInventoryAndAllChests()
        logger.log("Should now have all ingredients. Retrying crafting!")
        craftRecursively(itemname,count,false, false)
    end
    return true
end