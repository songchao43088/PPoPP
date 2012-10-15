import x10.util.Random; 
import x10.io.File;


public class ReqGenerator {
	val rand:Random;
	val mu:Double;
	val sigma:Double;
	def this(mu:Double, sigma:Double){
		rand = new Random(System.nanoTime());
		this.mu = mu;
		this.sigma = sigma;
	}
	def generate(){
		return Math.sqrt(-2*(Math.log(rand.nextDouble())))*Math.cos(2*Math.PI*rand.nextDouble());
	}
}
