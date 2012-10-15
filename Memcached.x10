import x10.util.Timer; 

public class Memcached {
	
	private static abstract class Version {
		
		static val NUM_REQS = 10000;
		val reqGen = new ReqGenerator();
		val dataGen = new DataGenerator();
		val heap = new Heap();
		val cache = new Cache();
		
		
		
		
		abstract def description():String;
		abstract def coreFunc();
		
		def run(){
			Console.OUT.println("============== " + description() + " ==============");
			val start = Timer.milliTime();
			coreFunc();
			val end = Timer.milliTime();
			val time = end - start;
			
			Console.OUT.println("Time: "+ time );
			
			
		}	
	}
	
	private static class SerialVer extends Version {
		def description():String {
			return "Serial Implementation";
			}
		
		def coreFunc() {
			
			var req:Int;		
			for(var i:Int = 0; i < NUM_REQS; i++){
				req = reqGen.generate();
			
				if(cache.search(req)){
					heap.update();
					
				}else{
					resp = dataGen.generate();
					
					heap.insert(req);
					cache.insert(req, resp);						
				}		
			}
						
			
		}
	}
	
	private static class ParallelVer extends Version {
		def description():String {
			return "Parallel Implementation";
			}
		
		def coreFunc() {
						
			
		}
		
	}
	
	public static def main(Array[String]) {
		
		var v:Version;
		
		v = new Memcached.SerialVer();
		v.run();
		
		v = new Memcached.ParallelVer();
		v.run();
		
	}
}