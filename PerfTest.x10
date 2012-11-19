import x10.util.Timer; 

public class PerfTest {
	public static def main(argv:Array[String]{self.rank==1}) {
		
		if (argv.size != 4) {
			Console.ERR.println("USAGE: Memcached <numOfReqs> <cacheSize> <reqExp> <reqStddev>");
			return;
		}
		val numOfReqs:Int = Int.parseInt(argv(0));
		val cacheSize:Int = Int.parseInt(argv(1));
		val reqExp:Int = Int.parseInt(argv(2));
		val reqStddev:Int = Int.parseInt(argv(3));
		
		var v:Memcached.Version;
		
		v = new Memcached.SerialVer(numOfReqs,cacheSize,reqExp,reqStddev);
		v.run();
		
		//v = new Memcached.ParallelVer(cacheSize);
		//v.run();
		
	}
}
