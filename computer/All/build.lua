require("movement")
-- requirement is, that there is a furnace in the inventory
function build_furnace()
    if not current_pos == home then
        go_towards(home)
    end
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
    go_towards(home)


end


function select(itemid)
    for i = 1,16 do
        if turtle.getItemDetail(i) ~= nil and turtle.getItemDetail(i).name == itemid then
            log(" Selected Item: " .. turtle.getItemDetail(i).name .." at Inventory place: "..i)
            turtle.select(i)
            return
        end
    end
    error("Expected item not in inventory")
end