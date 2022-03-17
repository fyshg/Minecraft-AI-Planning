import java.io.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PlannnerOutputToLua {

    public static String buildAction(){
        return "PlaceFurnace()\n";
    }

    public static int FuelValue(String fuel){
        switch (fuel){
            case "coal" : return 8;
        }
        System.out.println("Fuel Value not Saved for fuel \""+fuel+"\"");
        return (int)Math.sqrt(-1);
    }

    public static String blockID(String blockName){
        switch (blockName){
            case "iron": return "minecraft:iron_ore";
            case "cobblestone": return "minecraft:cobblestone";
            case "diamond": return "minecraft:diamond";
            case "redstone": return "minecraft:redstone";
            case "coal": return "minecraft:coal";
            default: return "Unknown Block";
        }
    }

    public static String fuelID(String fuelName){
        switch (fuelName){
            case "coal": return "minecraft:coal";
            default: return "Unknown fuel";
        }
    }

    public static String smeltID(String name){
        switch (name){
            case "iron": return "minecraft:iron_ore";
            case "stone": return "minecraft:cobblestone";
            case "glass": return "minecraft:sand";
            default: return "Unknown Block";
        }
    }

    public static String craftID(String item){
        switch (item){
            case "diamond_pickaxe": return "\"minecraft:diamond_pickaxe\",1";
            case "chest": return "\"minecraft:chest\",1";
            case "planks": return "\"merged:planks\",4";
            case "computer": return "\"computercraft:computer_normal\",1";
            case "turtle": return "\"computercraft:turtle_normal\",1";
            case "glass_pane": return "\"minecraft:glass_pane\",16";
            case "mining_turtle": return "\"computercraft:turtle_mining\",1";
            case "crafty_turtle": return "\"computercraft:turtle_mining_crafty\",1";
            case "stick": return "\"minecraft:stick\",4";
            case "furnace": return "\"minecraft:furnace\",1";
            case "crafting_table": return "\"minecraft:crafting_bench\",1";
            default: return "Unknown Block";
        }
    }

    public static String woodAction(){
        return "Gather(\"log\",1)\n";
    }

    public static String sandAction(){
        return "Gather(\"sand\",1)\n";
    }

    public static String mineAction(String item){
        return "Mine(\""+blockID(item)+"\",1)\n";
    }


    public static String smeltAction(String itemName, String fuelName){
        return "Smelt(\""+smeltID(itemName)+"\","+FuelValue(fuelName)+",\""+fuelID(fuelName)+"\",1)\n";
    }

    public static String craftAction(String name){
        return "Craft("+craftID(name.split(" ")[0])+")\n";
    }

    public static void main(String[] args) throws Exception {
        //File in=new File("C:\\Users\\micha\\curseforge\\minecraft\\Instances\\Computercraft - Uni\\saves\\New World (1)\\computercraft\\Minecraft\\Planner\\plan.txt");
        //File out=new File("C:\\Users\\micha\\curseforge\\minecraft\\Instances\\Computercraft - Uni\\saves\\New World (1)\\computercraft\\Minecraft\\computer\\All\\plan.lua");
        File in=new File("Planner\\plan.txt");
        File out = new File("computer\\All\\plan.lua");
        System.out.println(out.getAbsolutePath());
        BufferedReader br = null;
        if (!out.exists()) {
            out.createNewFile();
        }
        System.out.println(in.getAbsolutePath());
        br=new BufferedReader(new FileReader(in));
        String ss;
        boolean afterPlanStart=false;
        boolean afterPlanEnd=false;
        //read the plan
        String plan="";
        while ((ss=br.readLine())!=null){
            plan+=ss+"\n";
        }
        br.close();
        plan=plan.trim();
        System.out.println(plan);
        System.out.println();

        //write lua code depending on plan

        /*possible lines:
        1) Waiting for time: in this case, start the specified processes (woodcutting, mining, ...) with the timediff as parameter
        2)crafting : start craft action



        Idea: Change the order so that the starting of processes is always directly before the next waiting period
        */
        Pattern buildAction=Pattern.compile("\\(build_furnace.*\\)");
        Pattern farmAction=Pattern.compile("\\(farm_wood.*\\)");
        Pattern sandAction=Pattern.compile("\\(farm_sand(.*)\\)");
        Pattern mineAction=Pattern.compile("\\(mine_(.*) (.*)\\)");
        Pattern craftAction=Pattern.compile("\\(craft_(.*)\\)");
        Pattern smeltAction=Pattern.compile("\\(smelt_(.*) (.*) (.*) (.*)\\)");
        Matcher farm, sand, mine, craft, smelt, build;
        String program="Require(\"api\")\nInitiate()\nInitiateChests()\n";
        for (String line:plan.split("\n")){

            build=buildAction.matcher(line);
            craft=craftAction.matcher(line);
            smelt=smeltAction.matcher(line);
            mine=mineAction.matcher(line);
            sand=sandAction.matcher(line);
            farm=farmAction.matcher(line);

            if (craft.matches()){
                program+=craftAction(craft.group(1));
            }
            if (smelt.matches()){
                program+=smeltAction(smelt.group(1), smelt.group(2));
            }
            if (mine.matches()){
                program+=mineAction(mine.group(1));
            }
            if (sand.matches()){
                program+=sandAction();
            }
            if (farm.matches()){
                program+=woodAction();
            }

            if (build.matches()){
                program+=buildAction();
            }
        }
        BufferedWriter bw=new BufferedWriter(new FileWriter(out));
        bw.write(program);
        bw.close();
    }
}
