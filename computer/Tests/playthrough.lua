require("api")

Initiate()

InitiateChests()

goal = {}
goal["log"]=1
Gather(goal)

target = {}
target["minecraft:diamond"]=3
Mine(target)


Craft("merged:planks",4)
Craft("minecraft:stick", 4)
Craft("minecraft:diamond_pickaxe",1)

