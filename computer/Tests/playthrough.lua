require("api")

Initiate()

InitiateChests()

goal = {}
goal["log"]=4
goal["sand"]=6
Gather(goal)


Mine("minecraft:diamond",3)
Mine("minecraft:cobblestone", 15)
Mine("minecraft:redstone",1)
Mine("minecraft:iron_ore",7)
Mine("minecraft:coal",3)



Craft("merged:planks",16)
Craft("minecraft:stick", 4)
Craft("minecraft:diamond_pickaxe",1)

Craft("minecraft:furnace",1)
PlaceFurnace()
Smelt("minecraft:iron_ore", 7, "minecraft:coal", 1)
Smelt("minecraft:cobblestone", 7, "minecraft:coal", 1)
Smelt("minecraft:sand", 6, "minecraft:coal", 1)




Craft("minecraft:glass_pane",16)

Craft("computercraft:computer_normal",1)
Craft("minecraft:chest",1)
Craft("computercraft:turtle_normal",1)

Craft("computercraft:turtle_mining",1)

Craft("minecraft:crafting_bench",1)
Craft("computercraft:turtle_mining_crafty",1)


