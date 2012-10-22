import x10.util.Timer; 

public class Memcached {
	
	private static abstract class Version {
		
		static val NUM_REQS = 100000d;
		val reqGen:ReqGenerator = new ReqGenerator(3000.00, 1000.00);
		val dataGen:DataGenerator = new DataGenerator();

		
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
