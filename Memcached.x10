import x10.util.Timer; 
import x10.util.concurrent.AtomicBoolean;
import x10.util.ArrayList;
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
		val cache:Array[CacheParallel];
		//val cache:CacheParallel;
		val NUM_REQS:Int;
		val reqGen:Array[ReqGeneratorParallel];
		val dataGen:DataGeneratorParallel;
		val nworkers:Int;
		val queue:Array[ArrayList[Int]];
		def this(numOfReqs:Int, cacheSize:Int, reqExp:Double, reqStddev: Double, nworkers:Int){
			NUM_REQS = numOfReqs;	
			cache = new Array[CacheParallel](nworkers,(p:Int) => new CacheParallel(cacheSize/nworkers));
			//cache = new CacheParallel(cacheSize);
			reqGen= new Array[ReqGeneratorParallel](nworkers, (p:Int) => new ReqGeneratorParallel(reqExp, reqStddev));
			dataGen = new DataGeneratorParallel(8*(Math.floor(reqStddev) as Int));
			this.nworkers = nworkers;
			this.queue = new Array[ArrayList[Int]](nworkers,(p:Int) => new ArrayList[Int](numOfReqs/nworkers*2));
		}
		
		def description():String {
			return "Parallel Implementation";
			}
		
		def coreFunc() {

			finish for(var j:Int = 0; j < nworkers; j++){
				val index = j;
				async {
					for(var i:Int = 0; i < NUM_REQS/nworkers; i++){
						val req = reqGen(index).generate();
						var region:Int = req % nworkers;
						if (region < 0){
							region += nworkers;
						}
						
						this.queue(region).add(req);	
					}
				}
			}
			finish for(var i:Int = 0; i < nworkers; i++){
				val index = i;
				async{
					for(var k:Int = 0; k < queue(index).size();k++){
						val req = queue(index).get(k);
						val check = cache(index).search(req);
						if( check == -1){
							val resp = dataGen.generate(req);				
							cache(index).insert(req, resp);				
						}
					}		
				}	
			}
			for (var i:Int=0;i<nworkers;i++){
				Console.OUT.println(cache(i).freeSize+",");
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
		if (argv.size != 5) {
			Console.ERR.println("USAGE: Memcached <numOfReqs> <cacheSize> <reqExp> <reqStddev>");
			return;
		}
		val numOfReqs:Int = Int.parseInt(argv(0));
		val cacheSize:Int = Int.parseInt(argv(1));
		val reqExp:Int = Int.parseInt(argv(2));
		val reqStddev:Int = Int.parseInt(argv(3));
		val nworkers:Int = Int.parseInt(argv(4));
		var v:Version;
		Console.OUT.println("======numOfReqs:"+numOfReqs+" cacheSize:"+cacheSize+" reqExp:"+reqExp+" reqStddev:"+reqStddev+" ======");
		//v = new Memcached.SerialVer(numOfReqs,cacheSize,reqExp,reqStddev);
		//v.run();
		Console.OUT.println("======End======");
		v = new Memcached.ParallelVer(numOfReqs,cacheSize,reqExp,reqStddev,nworkers);
		v.run();
		
	}
}
