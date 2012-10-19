import x10.util.Random; 
import x10.io.File;


public class ReqGenerator {
	val rand:Random;
	val exp:Double;
	val standardDev:Double;
	def this(exp:Double, standardDev:Double){
		rand = new Random(System.nanoTime());
		this.exp = exp;
		this.standardDev = standardDev;
	}
	def generate():Int{
		return Math.floor(exp+Math.floor(standardDev * Math.sqrt(-2*(Math.log(rand.nextDouble())))*Math.cos(2*Math.PI*rand.nextDouble()))) as Int;
	}
}
