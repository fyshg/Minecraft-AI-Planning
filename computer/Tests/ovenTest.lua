require("api")
require("init")
-- turtle needs oven and coal and iron in invenotry for this test
init_turtle()
PlaceFurnace()
Smelt("minecraft:iron_ore", 1, "minecraft:coal", 1)
