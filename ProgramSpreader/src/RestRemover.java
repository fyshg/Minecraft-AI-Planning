import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.stream.IntStream;

public class RestRemover {
    public static void main(String[] args) {
        for (int i=0;i<Spreader.TURTLECOUNT;i++){
            File tf=new File("computer\\"+i);
            File inAll;
            File inTest;
            if (tf.exists()){
                for (File f:tf.listFiles()){
                    System.out.println(f.getName());
                    String [] nameparts=f.getName().split("[.]");
                    String endung=nameparts[nameparts.length-1];
                    System.out.println(endung);
                    if (endung.equals("lua")){
                        inAll=new File("computer\\All\\"+f.getName());
                        inTest=new File("computer\\All\\"+f.getName());
                        int finalI = i;
                        //if file is not in "All" and not a test or a test, but this turtle gets no tests, remove it
                        if (!(inAll.exists() || (inTest.exists()&& IntStream.of(Spreader.TURTLESWHICHGETTESTS).anyMatch(x -> x == finalI)))){
                            f.delete();
                        }
                    }
                }
            }
        }
    }
}
