import x10.io.*;
import x10.util.*;
import x10.lang.*;

// minimum heap
public class Heap {
	private class Records {
		var t : Int;
		var key : Int;
		public def this( tIn : Int, keyIn : Int ) {
			t = tIn;
			key = keyIn;
		}
		public def set( tIn : Int, keyIn : Int ) {
			t = tIn;
			key = keyIn;
		}
	}
	static val rand:Rancom = new Random( System.nanoTime() );
	// the heap structure
	static var h : Array[records];
	static var hsize : Int;
	// time stamp
	static var ts : Int;

	public def this( size : Int ) {
		h = new Array[Int]( size );
		hsize = 0;
	}

	public def swap( a : Int, b : Int ) {
		var temp : Records = h[a];
		h[a] = h[b];
		b[b] = temp;
	}

	public static def get_left( cur : Int ) : Int {
		return 2 * cur + 1;

	}

	public static def get_right( cur : Int ) : Int {
		return 2 * cur + 2;

	}

	public static def get_parent( cur : Int ) : Int {
		return ( cur - 1 ) / 2;
	}

	public static def heap_down( cur : Int ) {
		if (cur + 1 > hsize) return;
		var left : Int = get_left( cur );
		var right : Int = get_right( cur );
		var largest : Int = cur;

		if ( h[cur].t < h[left].t && h[right].t < h[left].t ) {
			largest = left;
		}
		if ( h[cur].t < h[right].t && h[left].t < h[right].t ) {
			largest = right;
		}
		if ( largest != cur ) {
			swap( cur, largest );
			heap_down( largest );
		}
	}

	public static def heap_up( cur : Int ) {
		if ( cur == 0 ) return;
		var parent : Int = get_parent( cur );
		
		if ( h[parent].t > h[cur].t ) {
			swap( parent, cur );
			heap_up( parent );
		}
	}	

	public static def insert( key : Int ) {
		hsize++;
		ts++;
		if (h[hsize-1] == NULL) {
			h[hsize-1] = new Records( ts, key );
		} else {
			h[hsize-1].set( ts, key );
		}
		heap_up( hsize - 1 );	
	}

	public static def update( key : Int ) {
		var cur : Int = -1;
		for (var i : Int = 0; i < h.size(); i++) {
			if (h[i].key = key) {
				cur = i;
				break;
			}
		}
		if (cur == -1) {
			Console.OUT.println("The record you are trying to update is not exist.\n");
			return;
		}
		var parent : Int = get_parent( cur );
		if ( h[parent].t > h[cur].t ) {
			heap_up( cur );
		} else {
			heap_down( cur );
		}
	}

	public static def remove() : Int {
		val ret : Int = h[0].key;
		h[0] = h[hsize-1];
		hsize--;
		heap_down( 0 );
		return ret;
	}

	public static def main( argv:Array[String] ) {
		val heap : Heap = new Heap();

		for (var i : Int = 0; i < 10; i++) {
			heap.insert( rand.nextInt(10) );
		}

		for (var i : Int = 0; i < 10; i++) {
			Console.OUT.println( heap.remove() );
		}
	}
}
