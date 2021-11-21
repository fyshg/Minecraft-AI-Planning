require("farming")
require("movement")
require("build")
require("smelting")


function Mine(goal)
    -- drop inventory in chests before and after
    mine(goal)
    navigate(home)
end

function Gather(goal)
    -- drop inventory in chests before and after
    gather_wood(goal)
    navigate(home)
end


-- Requirement:  Furnace in inventory
-- Reward: Smelting is now available
function PlaceFurnace()
    build_furnace()
end

function Craft()

end

function Smelt(itemname, itemcount, fuelname, fuelcount)
    smelt(itemname, itemcount, fuelname, fuelcount)
end