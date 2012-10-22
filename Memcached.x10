import x10.util.Timer; 

public class Memcached {
	
	private static abstract class Version {
		
		static val NUM_REQS = 10000;
		val reqGen = new ReqGenerator();
		val dataGen = new DataGenerator();
		//FIXME need to specify the maximum number of the pairs of (key, val) the cache could have, Heap(Int)
		val heap = new Heap();
		val cache = new Cache();
		
		abstract def description():String;
		abstract def coreFunc():void;
		
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
		
		val cache:Cache;
		
		def this(cacheSize:Int){		
			cache = new Cache(cacheSize);
		}
		
		def description():String {
			return "Serial Implementation";
			}
		
		def coreFunc() {
			
			var req:Int, resp:Int;		
			for(var i:Int = 0; i < NUM_REQS; i++){
				req = reqGen.generate();
			
				if(cache.search(req) == -1){
		
					resp = dataGen.generate(req);
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
	
	public static def main(argv:Array[String]{self.rank==1}) {
		
		if (argv.size != 1) {
			Console.ERR.println("USAGE: Memcached <cacheSize>");
			return;
		}
		val cacheSize:Int = Int.parseInt(argv(0));
		
		var v:Version;
		
		v = new Memcached.SerialVer(cacheSize);
		v.run();
		
		//v = new Memcached.ParallelVer(cacheSize);
		//v.run();
		
	}
}
