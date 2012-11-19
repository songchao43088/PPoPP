public class Memcachedd {

    public static def main(argv:Array[String]{self.rank==1}) {

	val db = new DataGenerator();
	val rg = new ReqGenerator(1.0,1.0);
	Console.OUT.println(Math.log(Math.E));
	//-5 :0.01: 5
	var posi:Int = 0;
	var neg: Int = 0;
	var one: Int = 0;
	var two: Int = 0;
	var three: Int = 0;
	var four: Int = 0;
	var five: Int = 0;
	for(var i:Int = 0;i<100000;i++){
		val t = rg.generate();
		if (t>0){
			posi++;
		}else if (t<0){
			neg++;
		}
		if (t<1 && t>0){
			one++;
		}
		if (t<2 && t>1){
			two++;
		}
		if (t<3 && t>2){
			three++;
		}

		if (t<4 && t>3){
			four++;
		}

		if (t>4){
			five++;
		}

		//Console.OUT.println(t);
		
	}
	Console.OUT.println("result:");
	Console.OUT.println(posi+";"+neg);
	Console.OUT.println(one+";"+two+";"+three+";"+four+";"+five);
    }
}
