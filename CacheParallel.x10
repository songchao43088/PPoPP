import x10.util.HashMap;
import x10.io.File;
import x10.util.concurrent.Lock;
import x10.util.Map;
public class CacheParallel {
	
	private static class Record{
		var value:Int;
		var timeStamp:Long;

		def this(value:Int, timeStamp:Long){
			this.value = value;
			this.timeStamp = timeStamp;
		}	
	}

	val size:Int;
	var freeSize:Int;
	val map:HashMap[Int, Record];
	//val log:x10.io.FileWriter;
	//val rwlock:RWLock;
	def this(size:Int){
		this.size = size;
		this.freeSize = size;
		this.map = new HashMap[Int, Record](size);
		//this.log = (new File("logParallel")).openWrite();
		//this.rwlock = new RWLock();
	}

	def update_timestamp(key:Int) {
		

	}
	
	def search(key:Int):Int{
		
		var value:Int = 0;
		val target = map.getOrElse(key,new Record(-1, 0));
		if (target.value == -1){
			
			return -1;
		} else {
			target.timeStamp = System.currentTimeMillis();

			//log.write(("Key:"+key+" Value:"+target.value+" H/M:H timestamp = "+ target.timeStamp+"\n").bytes());
			//log.flush();
			return target.value;
		}
		
		
	}
	
	def insert(key:Int, value:Int){

		
		var tmp:Long=0;;

		if(freeSize > 0){

			freeSize --;
			tmp = System.currentTimeMillis();
			map.put(key,new Record(value, tmp));
			
		}
		else{
			var minKey:Int=0;
			var minTimestamp:Long=Long.MAX_VALUE;
			for ( i:Map.Entry[Int,Record] in map.entries()){
				if (i.getValue().timeStamp < minTimestamp){
					minTimestamp = i.getValue().timeStamp;
					minKey = i.getKey();
				} 
			}
			map.remove(minKey);
			//log.write(("kick:"+minKey+"\n").bytes());
			tmp = System.currentTimeMillis();
			map.put(key,new Record(value, tmp));
		
		}

		//log.write(("Key:"+key+" Value:"+value+" H/M:M timestamp = "+ tmp + "\n").bytes());
		//log.flush();
	}
			
}
