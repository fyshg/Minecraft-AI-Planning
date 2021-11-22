require("movement")
require("chestStorageSystem")
-- requirement is, that there is a furnace in the storage system
function build_furnace()


    turn(directions["EAST"])
    move_forward()
    move_forward()

    local _ , data = turtle.inspectUp()

    if data.name == "minecraft:furnace" then
        go_towards(home)
        return
    end

    turtle.digUp()
    select("minecraft:furnace")
    turtle.placeUp()
end
-- requirement is, that there is a chest in the storage system
function build_chest()


    dir =  ( (chests["count"] % 4) +1) % 4
    turn(dir)
    height = math.floor(chests["count"] / 4) + 1
    for _ = 1, height do
        move_up()
    end

    turtle.dig()
    select("minecraft:chest")
    turtle.place()

    addChestToData()

    for _ = 1, height do
        move_down()
    end


end

function select(itemid)
    for i = 1,16 do
        if turtle.getItemDetail(i) ~= nil and turtle.getItemDetail(i).name == itemid then
            turtle.select(i)
            return
        end
    end
    error("Expected item: ".. itemid.." not in inventory")
end