import x10.util.HashMap;
import x10.io.File;
import x10.util.concurrent.Lock;

public class CacheParallel {
	
	val size:Int;
	var freeSize:Int;
	//val heap:Heap;
	val map:HashMap[Int, Int];
	val log:x10.io.FileWriter;
	val freeSizeLock:Lock;
	val mapLock:Lock;
	val heapLock:Lock;
	def this(size:Int){
		this.size = size;
		this.freeSize = size;
		//this.heap = new Heap(size);
		this.map = new HashMap[Int, Int](size);
		this.log  = (new File("logParallel")).openWrite();
		this.freeSizeLock = new Lock();
		this.mapLock = new Lock();
		this.heapLock = new Lock();
	}
	
	def search(key:Int):Int{
		
		var value:Int = 0;
		
		//Console.OUT.println("lock maplock 31");
		//mapLock.lock();

			
			return map.getOrElse(key,-1);
			//value = map.getOrThrow(key);
			
			//Console.OUT.println("lock:heap:37");
			//heapLock.lock();

			//heap.update(key);
			//Console.OUT.println("unlock:heap");
			//heapLock.unlock();
			//Console.OUT.println("unlock maplock");
			//mapLock.unlock();
			//log.write(("Key:"+key+" Value:"+value+" H/M:H\n").bytes());
			//log.flush();
	}
	
	def insert(key:Int, value:Int){

		

		/*if(freeSize > 0){

			//freeSize --;

			
		
			
			//map.put(key,value);
			
		}*/
		/*else{
			//Console.OUT.println("bu yinggai chuxian");
			//Console.OUT.println("unlock:freesizelock 79");
			//freeSizeLock.unlock();
			
			//Console.OUT.println("lock:heap 81");
			//heapLock.lock();

			//val oldKey = heap.remove();
			//val oldKey = 3000;
			//Console.OUT.println("unlock:heap 84");
			//heapLock.unlock();
			//Console.OUT.println("lock:map 86");
			//mapLock.lock();

			//map.remove(oldKey);
			map.put(key, value);
			
			//Console.OUT.println("lock:heap 91");
			//heapLock.lock();
			//heap.insert(key);
			//Console.OUT.println("unlock:heap 95");
			//heapLock.unlock();
			//Console.OUT.println("unlock:map 89");
			//mapLock.unlock();

			
		}*/
		//log.write(("Key:"+key+" Value:"+value+" H/M:M\n").bytes());
		//	log.flush();
	}
		
	
}
