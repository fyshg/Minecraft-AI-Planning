require("movement")
require("chestStorageSystem")

function smelt(itemname, itemcount, fuelname, fuelcount)
    smeltingTime=10

    for i,_ in pairs(itemsWanted) do
        itemsWanted[i]=nil
    end
    itemsWanted[itemname]=itemcount;
    if (fuelcount>0) then
        itemsWanted[fuelname]=fuelcount;
    end
    storeRest() 
    getmissing()


    turn(directions["EAST"])
    for _ = 1,3 do
        move_forward()
    end
    move_up()
    turn(directions["WEST"])

    if (fuelcount>0) then
        turtle.select(inventory.slog(fuelname))
        turtle.drop()
    end
    move_up()
    move_forward()
    turtle.select(inventory.slog(itemname))
    turtle.dropDown()
    move_back()
    move_down()
    move_down()
    move_forward()
    sleep(itemcount*smeltingTime)
    turtle.suckUp()




end