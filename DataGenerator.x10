import x10.util.Random; 
import x10.io.File;
import x10.util.HashMap;

public class DataGenerator {
	val rand:Random;
	val file:File;
	val MAX_INT:Int = 1000000;
	val db:HashMap[Int, Int];

	def this(size:Int){
		this.rand = new Random(System.nanoTime());
		this.file  = new File("~DB");
		this.db = new HashMap[Int, Int](size);
	}
	def generate(key:Int){
		/*val streamWrite  = file.openWrite();
	  	streamWrite.writeByte(0 as Byte);
	  	streamWrite.flush();
	  	streamWrite.close();
	  
	  	val streamRead  = file.openRead();
	  	streamRead.readByte();
	  	streamRead.close();*/
		
		var value:Int = 0;
		
		System.sleep(1);
		try{
			value = db.getOrThrow(key);
		}
		catch(e:Exception){		
			value = rand.nextInt(MAX_INT);
			db.put(key,value);
		}
		finally{
			
			return value;		
		}
	}
}

