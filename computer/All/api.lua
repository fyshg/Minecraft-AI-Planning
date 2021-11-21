require("farming")
require("movement")
require("build")
require("smelting")
require("init")
require("logger")

-- shall be called by the planner at the start once
-- args[0] = x, args[1] = y, args[2] = z, args[3] = direction. If args are empty, default values are used
function Initiate(args)
    init_turtle(args)
    turn(directions["EAST"])
end


function Mine(goal)
    -- drop inventory in chests before and after
    dropInventory()
    mine(goal)
    navigate(home)
    turn(directions["EAST"])
    dropInventory()
end

function Gather(goal)
    -- drop inventory in chests before and after
    dropInventory()
    gather_wood(goal)
    navigate(home)
    turn(directions["EAST"])
    dropInventory()
end


-- Requirement:  Furnace in inventory
-- Reward: Smelting is now available
function PlaceFurnace()
    build_furnace()
    go_towards(home)
    turn(directions["EAST"])
end

function PlaceChests()

    -- TODO
end

function Craft()
 -- TODO
end

-- Requirement: Furnace placed, Items in Inventory
-- Reward: new Materials
function Smelt(itemname, itemcount, fuelname, fuelcount)
    smelt(itemname, itemcount, fuelname, fuelcount)
    go_towards(home)
    turn(directions["EAST"])
end