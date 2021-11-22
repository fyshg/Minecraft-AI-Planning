require("api")

Initiate()

build_chest()

-- gets us enough time to put chests in storage system
for _= 1,4 do
    turn_left()
end

inventur()

for _ = 1,16 do
    PlaceChest()
end 