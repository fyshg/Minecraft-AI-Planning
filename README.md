## Minecraft Turtle Planning

A Report of evrything, in German may be found in Minecraft.pdf

# Goal

This project will implement various scripts for Minecraft turtles, which will allow them to work on their own. 
For this we provide several files, which implement functionalities, that the turtle needs (e.g. mining, crafting, navigation).
The turtle than should be provided with a planner, that has been given several choices of actions. 
It should then make decisions on what to do on its own, based upon the costs and results of actions and towards the goal of replicating itself. 

For this the planner needs the following functionalities: 

1. Several routines for gathering and mining resources. Specifically, in order to craft a second crafty mining turtle,
we need wood, sand, cobblestone, redstone, diamonds, iron and some fuel to use in an furnace. 
2. The turtle needs to be able to craft several recipes on its own. These include an oven, a diamond pickaxe, a crafting table, a computer, planks, sticks and a turtle
3. The turtle must be able, to use an oven, to obtain, iron ingots, glass and clean stone.
4. The turtle needs several methods, which help to maintain its own inventory and chest storage system. 
5. The planner must only be provided with high level commands. The commands themself should manage the inventory and the navigation of the turtle. 

In total, the following high level commands are then needed: 

- The planner needs a mine and a gather method, which gather a specified amount of resources and manage the navigation themselves.
- A craft method, which crafts a specified recipe if the necessary resources are available.  
- A method, which allows for interaction with a furnace.

The turtle should also know the costs and the results of the specified actions.
Several new methods may be needed as we define new goals for the turtle.
Currently fuel consumption is disabled and we may include challenges, such as building a house or multi turtle mayhem in the future.

# Project Structure

Each turtle has its own subfolder in the computer directory. Their directory is named a specific number. 
A specific turtle can use all programs, that are in its own directory. 
For easier distribution of programs, we have the program spreader, which copies all necesscary script on all specified turtles. 
All scripts for the turtles are located in the /computer/all/ directory. Tests are contained within computer/Tests/ and computer/Old Tests




