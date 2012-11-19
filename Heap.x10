import x10.util.Random;

// minimum heap
public class Heap {
	private class Records {
		var t : Int;
		var key : Int;
		public def clone() : Records {
			return new Records(t, key);
		}
		public def this( tIn : Int, keyIn : Int ) {
			t = tIn;
			key = keyIn;
		}
		public def set( tIn : Int, keyIn : Int ) {
			t = tIn;
			key = keyIn;
		}
	}

	static val rand:Random = new Random( System.nanoTime() );
	// the heap structure
	var h : Array[Records];
	var hsize : Int;
	// time stamp
	var ts : Int;

	public def this( size : Int ) {
		h = new Array[Records]( size );
		hsize = 0;
		ts = 0;
	}

	public def swap( a : Int, b : Int ) {
		var temp : Records = new Records(0, 0);
		temp.t = h(a).t;
		temp.key = h(a).key;
		h(a).t = h(b).t;
		h(a).key = h(b).key;
		h(b).t = temp.t;
		h(b).key = temp.key;
	}

	public def get_left( cur : Int ) : Int {
		return 2 * cur + 1;

	}

	public def get_right( cur : Int ) : Int {
		return 2 * cur + 2;

	}

	public def get_parent( cur : Int ) : Int {
		return ( cur - 1 ) / 2;
	}

	public def heap_down( cur : Int ) {
		if (cur >= hsize) return;
		var left : Int = get_left( cur );
		var right : Int = get_right( cur );
		var smallest : Int = cur;

		if ( left < hsize ) {
			if ( right >= hsize ) {
				if ( h(cur).t > h(left).t ) smallest = left;
			} else {
				if ( h(cur).t > h(left).t && h(right).t > h(left).t ) smallest = left;
				if ( h(cur).t > h(right).t && h(left).t > h(right).t ) smallest = right;
			}
			
			if ( smallest != cur ) {
				swap( cur, smallest );
				heap_down( smallest );
			}
		}
	}

	public def heap_up( cur : Int ) {
		if ( cur == 0 ) return;
		var parent : Int = get_parent( cur );
		
		if ( h(parent).t > h(cur).t ) {
			swap( parent, cur );
			heap_up( parent );
		}
	}	

	public def insert( key : Int ) {
		hsize++;
		ts++;
		//Console.OUT.println("insert\t(" + ts + ", " + key + ")");

		if (h(hsize-1) == null) {
			h(hsize-1) = new Records( ts, key );
		} else {
			h(hsize-1).set( ts, key );
		}
		heap_up( hsize - 1 );	

		//display();
	}

	public def display() {
		for (var i:Int = 0; i< hsize; i++) {
			Console.OUT.print("\t"+i);
		}
		Console.OUT.println();
		for (var i:Int = 0; i< hsize; i++) {
			Console.OUT.print("\t("+h(i).t+", "+h(i).key+")");
		}
		Console.OUT.println();
		Console.OUT.println();

	}

	public def update( key : Int ) {
		var cur : Int = -1;
		for (var i : Int = 0; i < h.size; i++) {
			if (h(i).key == key) {
				cur = i;
				break;
			}
		}
		if (cur == -1) {
			//Console.OUT.println("The record you are trying to update is not exist.\n");
			return;
		}
		ts++;
		h(cur).t = ts;
		var parent : Int = get_parent( cur );
		if ( h(parent).t > h(cur).t ) {
			heap_up( cur );
		} else {
			heap_down( cur );
		}
	}

	public def remove() : Int {
		val ret : Int = h(0).key;
		//Console.OUT.println("removed\t(" + h(0).t + ", " + h(0).key + ")");
		//display();
		
		h(0) = h(hsize-1).clone();
		hsize--;

		
		heap_down( 0 );

		//display();
		return ret;
	}

	public static def main( argv:Array[String] ) {
		
		val hh : Heap = new Heap(100);
		var arr : Array[Int] = new Array[Int](10);

		for (var i : Int = 0; i < 10; i++) {
			var num : Int = rand.nextInt(10);
			hh.insert( num );
			arr(i) = num;
		}

		for (var i : Int = 0; i < 10; i++) {
			hh.remove();
		}
	}
}
