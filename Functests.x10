import x10.util.Timer; 

public class Functests {
	
	private static abstract class Version {
		
		static val NUM_REQS = 10000;
		val reqGen:ReqGenerator = new ReqGenerator(3000.00, 50.00);
		val dataGen:DataGenerator = new DataGenerator(10000);

		
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
		val csize:Int;
		
		def this(cacheSize:Int){		
			cache = new Cache(cacheSize);
			csize = cacheSize;
		}
		
		def description():String {
			return "Serial Implementation";
			}
		
		def coreFunc() {
			var hit_cnt : Long = 0;
			var miss_cnt : Long = 0;
			
			var req:Int, resp:Int;		
			for(var i:Int = 0; i < NUM_REQS; i++){
				req = reqGen.generate();
			
				var result:Int = cache.search(req);
				if( result == -1){
		
					resp = dataGen.generate(req);
					cache.insert(req, resp);	
					Console.OUT.println("\n(" + req + ", " + resp + ")  Cache MISS.");	
					miss_cnt += 1;
				} else {
					Console.OUT.println("\n(" + req + ", " + result + ")  Cache HIT.");	
					hit_cnt += 1;
				}
				cache.display();
			}						
			miss_cnt -= csize;
			Console.OUT.println(NUM_REQS + " requests, " + hit_cnt + " HIT, and " + miss_cnt + " MISS.");
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
			Console.ERR.println("USAGE: Functests <cacheSize>");
			return;
		}
		val cacheSize:Int = Int.parseInt(argv(0));
		
		var v:Version;
		
		v = new Functests.SerialVer(cacheSize);
		v.run();
		
		//v = new Functests.ParallelVer(cacheSize);
		//v.run();
	}
}
