require("req")

init_turtle()
inventur()

print("Mining Coal")
Mine("minecraft:coal", 1)
print("Mining Iron")
Mine("minecraft:iron_ore", 1)
print("Mining Redstone")
Mine("minecraft:redstone", 1)

print_table(mined)