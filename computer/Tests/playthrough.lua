require("api")

Initiate()

InitiateChests()

goal = {}
goal["log"]=4
goal["sand"]=6
Gather(goal)

target = {}
target["minecraft:diamond"]=3
target["minecraft:cobblestone"]=15
target["minecraft:redstone"]=1
target["minecraft:iron_ore"]=7
target["minecraft:coal"]=3
Mine(target)


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

Craft("minecraft:stick", 4)
Craft("minecraft:diamond_pickaxe",1)
Craft("computercraft:turtle_mining",1)

Craft("minecraft:crafting_bench",1)
Craft("computercraft:turtle_mining_crafty",1)


