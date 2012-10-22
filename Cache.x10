import x10.util.HashMap;
import x10.io.File;

public class Cache {
	
	val size:Int;
	var freeSize:Int;
	val heap:Heap;
	val map:HashMap[Int, Int];
	val log:x10.io.FileWriter;

	def this(size:Int){
		this.size = size;
		this.freeSize = size;
		this.heap = new Heap(size);
		this.map = new HashMap[Int, Int](size);
		this.log  = (new File("log")).openWrite();
	}
	
	def search(key:Int):Int{
		
		var value:Int = 0;
		
		try{
			value = map.getOrThrow(key);
			heap.update(key);
			log.write(("Key:"+key+" Value:"+value+" H/M:H\n").bytes());
			log.flush();
		}
		catch(e:Exception){	
			
			value = -1;
		}
		finally{
			
			return value;		
		}
	}
	
	def insert(key:Int, value:Int){
		
		if(freeSize > 0){
			
			map.put(key,value);
			heap.insert(key);
			freeSize --;
		}
		else{
			
			val oldKey = heap.remove();
			map.remove(oldKey);
			map.put(key, value);
			heap.insert(key);
			
		}
		log.write(("Key:"+key+" Value:"+value+" H/M:M\n").bytes());
			log.flush();
	}
		
	
}
