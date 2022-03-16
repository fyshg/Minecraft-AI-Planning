import java.io.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PlannnerOutputToLua {

    public static int FuelValue(String fuel){
        switch (fuel){
            case "coal" : return 8;
        }
        System.out.println("Fuel Value not Saved for fuel \""+fuel+"\"");
        return (int)Math.sqrt(-1);
    }

    public static String doFarmingAction(String lastChangeType, double from, double to){
        switch (lastChangeType){
            case "farming_wood": return "Gather("+Math.round(to-from)+")\n";
            case "mining": return "Mine("+Math.round(to-from)+")\n";
            case "farming_sand": return "Farm_Sand("+Math.round(to-from)+")\n";
        }
        System.out.println("Unknown type of action: \""+lastChangeType+"\"");
        return ""+Math.sqrt(-1);
    }

    public static String smeltAction(String itemName, String fuelName){
        return "Smelt("+itemName+","+FuelValue(fuelName)+","+fuelName+",1)\n";
    }

    public static String craftAction(String name){
        return "Craft("+name+",1)\n";
    }

    public static void main(String[] args) throws Exception {
        File in=new File("planner/output.txt");
        File out=new File("planner/plan.lua");
        String s="";
        BufferedReader br = null;
        br=new BufferedReader(new FileReader(in));
        String ss;
        boolean afterPlanStart=false;
        boolean afterPlanEnd=false;
        //read the plan
        String plan="";
        while ((ss=br.readLine())!=null){
            s+=ss+"\n";
            if (ss.contains("Resolution for validation"))
                afterPlanEnd=true;
            if (afterPlanStart&&!afterPlanEnd)
                plan+=ss+"\n";
            if (ss.contains("Epsilon set to be"))
                afterPlanStart=true;
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

        String lastChangeType="";
        Pattern stateChange=Pattern.compile(".*\\((.*)\\).*start_(.*) Parameters:.*");
        Pattern craftAction=Pattern.compile(".*\\((.*)\\).*craft_(.*) Parameters:.*");
        Pattern smeltAction=Pattern.compile(".*\\((.*)\\).*smelt_(.*) Parameters: (\\w*).*");
        Pattern waiting=Pattern.compile(".*\\((.*),(.*)\\).*------>waiting.*");
        Matcher state, craft, smelt, wait;
        String program="";
        for (String line:plan.split("\n")){
            state=stateChange.matcher(line);
            craft=craftAction.matcher(line);
            smelt=smeltAction.matcher(line);
            wait=waiting.matcher(line);


            if (state.matches()){
                lastChangeType=state.group(2);
            }

            if (craft.matches()){
                program+=craftAction(craft.group(2));
            }

            if (smelt.matches()){
                program+=smeltAction(smelt.group(2), smelt.group(3));
            }

            if (wait.matches()){
                program+=doFarmingAction(lastChangeType,Double.parseDouble(wait.group(1)), Double.parseDouble(wait.group(2)));
            }
        }
        BufferedWriter bw=new BufferedWriter(new FileWriter(out));
        bw.write(program);
        bw.close();
    }
}
