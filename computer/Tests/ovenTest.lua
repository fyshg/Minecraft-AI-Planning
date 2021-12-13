require("api")
require("init")
-- turtle needs oven and coal and iron in invenotry for this test
Initiate()
inventur()
Craft("minecraft:furnace",1)

-- gets us enough time to put oven in storage system



PlaceFurnace()
Smelt("minecraft:iron_ore", 1, "minecraft:coal", 1)
