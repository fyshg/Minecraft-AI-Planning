require("movement")
-- requirement is, that there is a furnace in the inventory
function build_furnace()

    turn(directions["EAST"])
    move_forward()
    move_forward()

    local _ , data = turtle.inspectUp()

    if data.name == "minecraft:furnace" then
        go_towards(home)
        return
    end

    select("minecraft:furnace")
    turtle.placeUp()
end


function select(itemid)
    for i = 1,16 do
        if turtle.getItemDetail(i) ~= nil and turtle.getItemDetail(i).name == itemid then
            turtle.select(i)
            return
        end
    end
    error("Expected item not in inventory")
end