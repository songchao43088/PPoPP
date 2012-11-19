import x10.util.Random; 
import x10.io.File;
import x10.util.HashMap;
import x10.util.concurrent.Lock;

public class DataGeneratorParallel {
	val rand:Random;
	val file:File;
	val MAX_INT:Int = 1000000;
	val db:HashMap[Int, Int];
	val dbLock:Lock;
	val randomLock:Lock;

	def this(size:Int){
		this.rand = new Random(System.nanoTime());
		this.file  = new File("~DB");
		this.db = new HashMap[Int, Int](size);
		this.dbLock = new Lock();
		this.randomLock = new Lock();
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
		/*try{
			//Console.OUT.println("lock:dblock 35");
			dbLock.lock();

			value = db.getOrThrow(key);
			//Console.OUT.println("unlock:dblock 39");
			dbLock.unlock();
		}
		catch(e:Exception){
			dbLock.unlock();
			//Console.OUT.println("lock:randomlock 43");
			randomLock.lock();		
			value = rand.nextInt(MAX_INT);
			//Console.OUT.println("unlock:randomlock 46");
			randomLock.unlock();
			//Console.OUT.println("lock:dblock 48");
			dbLock.lock();
			db.put(key,value);
			//Console.OUT.println("unlock:dblock 51");
			dbLock.unlock();
		}
		finally{
			
			return value;		
		}*/
		return key;
	}
}

