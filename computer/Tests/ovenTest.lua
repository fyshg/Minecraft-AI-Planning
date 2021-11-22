require("api")
require("init")
-- turtle needs oven and coal and iron in invenotry for this test
Initiate()
build_chest()

-- gets us enough time to put oven in storage system
for _= 1,4 do
    turn_left()
end
inventur()

PlaceFurnace()
Smelt("minecraft:iron_ore", 1, "minecraft:coal", 1)
