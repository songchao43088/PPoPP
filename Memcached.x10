import x10.util.Timer; 

public class Memcached {
	
	private static abstract class Version {
		abstract def description():String;
		abstract def coreFunc():void;
		
		def run(){
			Console.OUT.println("\t============== " + description() + " ==============");
			val start = Timer.milliTime();
			coreFunc();
			val end = Timer.milliTime();
			val time = end - start;
			
			Console.OUT.println("\tTime: "+ time );			
		}	
	}
	
	private static class SerialVer extends Version {
		
		val cache:Cache;
		val NUM_REQS:Int;
		val reqGen:ReqGenerator;
		val dataGen:DataGenerator;
		def this(numOfReqs:Int, cacheSize:Int, reqExp:Double, reqStddev: Double){
			NUM_REQS = numOfReqs;	
			cache = new Cache(cacheSize);
			reqGen= new ReqGenerator(reqExp, reqStddev);
			dataGen = new DataGenerator(8*(Math.floor(reqStddev) as Int));
			
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
					cache.insert(req,resp);	
				}
			}						
			
		}
	}
	
	private static class ParallelVer extends Version {
		val cache:CacheParallel;
		val NUM_REQS:Int;
		val reqGen:ReqGeneratorParallel;
		val dataGen:DataGeneratorParallel;
		def this(numOfReqs:Int, cacheSize:Int, reqExp:Double, reqStddev: Double){
			NUM_REQS = numOfReqs;	
			cache = new CacheParallel(cacheSize);
			reqGen= new ReqGeneratorParallel(reqExp, reqStddev);
			dataGen = new DataGeneratorParallel(8*(Math.floor(reqStddev) as Int));
			
		}
		
		def description():String {
			return "Parallel Implementation";
			}
		
		def coreFunc() {
			
			finish for(var i:Int = 0; i < NUM_REQS; i++){
				async{
					val req = reqGen.generate();
					val check = cache.search(req);
					if( check == -1){
						val resp = dataGen.generate(req);
						cache.insert(req, resp);					
					if (resp != req){
						throw new Exception ("wrong");
					}
					} else {
						if (req != check){
							throw new Exception ("wrong");
						}
					}
				}	
/*
				async{
					val req = reqGen.generate();
					if(cache.search(req) == -1){
						val resp = dataGen.generate(req);
						cache.insert(req, resp);					
					}
				}	
*/
			}						
			
		}
		
	}
	
	public static def main(argv:Array[String]{self.rank==1}) {
		/*
			numOfReqs is the number of requests to be tested.
			cacheSize is the size of cache in terms of key-value pairs.
			reqExp is the expectation of the requests generated.
			reqStddev is the standard deviation of the request generated.
			The request keys generated are integers following normal distribution. 
		*/
		if (argv.size != 4) {
			Console.ERR.println("USAGE: Memcached <numOfReqs> <cacheSize> <reqExp> <reqStddev>");
			return;
		}
		val numOfReqs:Int = Int.parseInt(argv(0));
		val cacheSize:Int = Int.parseInt(argv(1));
		val reqExp:Int = Int.parseInt(argv(2));
		val reqStddev:Int = Int.parseInt(argv(3));
		
		var v:Version;
		Console.OUT.println("======numOfReqs:"+numOfReqs+" cacheSize:"+cacheSize+" reqExp:"+reqExp+" reqStddev:"+reqStddev+" ======");
		v = new Memcached.SerialVer(numOfReqs,cacheSize,reqExp,reqStddev);
		v.run();
		Console.OUT.println("======End======");
		v = new Memcached.ParallelVer(numOfReqs,cacheSize,reqExp,reqStddev);
		v.run();
		
	}
}
