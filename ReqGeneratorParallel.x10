import x10.util.Random; 
import x10.io.File;
import x10.util.concurrent.Lock;

public class ReqGeneratorParallel {
	val rand:Random;
	val exp:Double;
	val standardDev:Double;
	val reqlock:Lock;
	def this(exp:Double, standardDev:Double){
		rand = new Random(System.nanoTime());
		this.exp = exp;
		this.standardDev = standardDev;
		this.reqlock = new Lock();
	}
	def generate():Int{
		//Console.OUT.println("req:17");
		reqlock.lock();
		val retval:Int = Math.floor(exp+Math.floor(standardDev * Math.sqrt(-2*(Math.log(rand.nextDouble())))*Math.cos(2*Math.PI*rand.nextDouble()))) as Int;
		//Console.OUT.println("req:20");
		reqlock.unlock();
		return retval;
	}
}
