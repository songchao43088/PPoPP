import x10.util.Random; 
import x10.io.File;


public class DataGenerator {
	val rand:Random;
	val file:File;
	def this(){
		rand = new Random(System.nanoTime());
		file  = new File("~DB");
	}
	def generate(key:Int){
		val streamWrite  = file.openWrite();
	  	streamWrite.writeByte(0 as Byte);
	  	streamWrite.flush();
	  	streamWrite.close();
	  
	  	val streamRead  = file.openRead();
	  	streamRead.readByte();
	  	streamRead.close();
		return rand.nextInt();
	}
}

