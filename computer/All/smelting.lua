function smelt(itemname, itemcount, fuelname, fuelcount)
    smeltingTime=10
    for i in pairs(chestStorageSystem.itemsWanted) do
        chestStorageSystem.itemsWanted[i]=nil
    end
    chestStorageSystem.itemsWanted[itemname]=itemcount;
    if (fuelcount>0) then
        chestStorageSystem.itemsWanted[fuelname]=fuelcount;
    end
    chestStorageSystem.storeRest()
    chestStorageSystem.getmissing()

    --TOGO: Go to furnace

    if (fuelcount>0) then
        turtle.select(inventory.slog(fuelname))
        turtle.drop()
    end
    movement.move_up()
    movement.move_forward()
    turtle.select(inventory.slog(itemname))
    turtle.dropDown()
    movement.move_back()
    movement.move_down()
    movement.move_down()
    movement.move_forward()
    sleep(itemcount*smeltingTime)
    turtle.suckUp()
    movement.move_back()
    movement.move_up();
end