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
	
	def display() {
		Console.OUT.print("Cache: \n [ \n");
		var print_helper : Long = 0;
		for (i in map.keySet()) {
			if ((print_helper % 6) as Int == 0) Console.OUT.println();
			print_helper += 1;
			Console.OUT.print( "\t("+ i + ",\t"+ map.get(i)+")" );
		}
		Console.OUT.println("\n ]");
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
