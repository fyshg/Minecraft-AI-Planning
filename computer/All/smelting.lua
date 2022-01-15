require("movement")
require("chestStorageSystem")
require("inventory")

function smelt(itemname, itemcount, fuelname, fuelcount)
    storeRest()
    smeltingTime=10

    for i,_ in pairs(itemsWanted) do
        itemsWanted[i]=nil
    end

    itemsWanted[itemname]=itemcount;
    if (fuelcount>0) then
        itemsWanted[fuelname]=fuelcount;
    end

    getmissing()


    turn(directions["EAST"])
    for _ = 1,3 do
        move_forward()
    end
    move_up()
    turn(directions["WEST"])

    countInventory()
    if (fuelcount>0) then
        turtle.select(slot[fuelname])
        turtle.drop()
    end
    move_up()
    move_forward()
    countInventory()
    turtle.select(slot[itemname])
    turtle.dropDown()
    turn(directions["EAST"])
    move_forward()
    turn(directions["WEST"])
    move_down()
    move_down()
    move_forward()
    sleep(itemcount*smeltingTime)
    turtle.suckUp()




end