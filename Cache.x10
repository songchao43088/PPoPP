import x10.util.HashMap;

public class Cache {
	
	val size:Int;
	var freeSize:Int;
	val heap:Heap;
	val map:HashMap[Int, Int];
	
	def this(size:Int){
		this.size = size;
		this.freeSize = size;
		this.heap = new Heap(size);
		this.map = new HashMap[Int, Int](size);
	}
	
	def search(key:Int):Int{
		
		var value:Int = 0;
		
		try{
			value = map.getOrThrow(key);
			heap.update(key);
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
	}
		
	
}