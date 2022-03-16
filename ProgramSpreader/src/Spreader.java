import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;

public class Spreader {
    final static int TURTLECOUNT=10;
    final static int [] TURTLESWHICHGETTESTS={0,1,2,3,4,5,6,7,8,9};
    final static boolean REMOVEREST=true;
    public static void main(String[] args) {
        if (REMOVEREST){
            RestRemover.removeRest();
        }
        File folder= new File("computer\\All");
        for (int i=0;i<TURTLECOUNT;i++){
            File tf=new File("computer\\"+i);
            if (!tf.exists()){
                tf.mkdirs();
            }
            for (File f:folder.listFiles()){
                try {
                    Files.copy(f.toPath(),Path.of("computer\\"+i+"\\"+f.getName()), StandardCopyOption.REPLACE_EXISTING);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }



        folder= new File("computer\\Tests");
        for (int i:TURTLESWHICHGETTESTS){
            File tf=new File("computer\\"+i);
            if (!tf.exists()){
                tf.mkdirs();
            }
            for (File f:folder.listFiles()){
                try {
                    Files.copy(f.toPath(),Path.of("computer\\"+i+"\\"+f.getName()), StandardCopyOption.REPLACE_EXISTING);
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
