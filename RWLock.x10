import x10.io.Console; 

/**
 * Implementation overview:
 * I enhanced the Bakery algorithm to fit into the R/W lock
 * problem. Specially, I record the type of every lock. If
 * it's a reader trying to lock, it requires that there are
 * no writer got the lock and had smaller label. If it's a
 * writer trying to lock, it requires that there are no
 * any other threads, no matter readers or writers, got the
 * lock.
 *
 * P1:
 * Since the algorithm is based on bakery algorithm, which
 * set labels for threads and apply the first-come-first-serve
 * policy, there is no starvation occured.
 *
 * P2:
 * Conncurrent reads can procceed because for readers, my
 * implementation doesn't set restrictions. Readers only got
 * stuck when writer got the lock.
 *
 * P3:
 * While writer trying to lock, it need to check whether there
 * is any other writer labelled smaller than it. In this way,
 * mutual exclusiveness is guaranteed.
 */
public class RWLock {
	private var flag:Array[Boolean]{self.rank==1};
	private var label:Array[Long]{self.rank==1};
	private var isw:Array[Boolean]{self.rank==1};

	public def this(n:Int) {
		flag = new Array[Boolean](n, false);
		label = new Array[Long](n, 0L);
		isw = new Array[Boolean](n, false);
	}

	private def nextLabel() {
		var max:Long = 0;
		for (var i:Int=0; i<label.size; i++) {
			if (label(i) > max) max = label(i);
		}
		return max+1;
	}

	private def someoneElseFirst(i:Int) :Boolean {
		if (isw(i)) {
			// writer logic
			for (var k:Int=0; k<label.size; k++) {
				if (flag(k) && ((label(k) < label(i)) || ((label(k) == label(i)) && (k<i))))
					return true;
			}
		} else {
			// reader logic
			for (var k:Int=0; k<label.size; k++) {
				if (flag(k) && isw(k) && ((label(k) < label(i)) || ((label(k) == label(i)) && (k<i))))
					return true;
			}
		}
		return false;
	}

	public def lock(i:Int, w:Boolean) {
		flag(i) = true;
		label(i) = nextLabel();
		isw(i) = w;
		while (someoneElseFirst(i)) {}
	}

	public def unlock(i:Int) {
		flag(i) = false;
		isw(i) = false;
	}

	public static def main(argv:Array[String]) {
		var t:RWLock = new RWLock(10);
		finish {
			async {
				t.lock( 0, true );
				Console.OUT.println("writer 0 Lock");
				System.sleep( 1000 );
				Console.OUT.println("writer 0 Unlock");
				t.unlock( 0 );
			}
			for (var i:Int=1; i<6; i++) {
				val j = i;
				async {
					t.lock( j, false );
					Console.OUT.println("reader "+j+" Lock");
					System.sleep( 1000 );
					Console.OUT.println("reader "+j+" Unlock");
					t.unlock( j );
				}
			}
			for (var i:Int=6; i<10; i++) {
				val j = i;
				async {
					t.lock( j, true );
					Console.OUT.println("writer "+j+" Lock");
					System.sleep( 1000 );
					Console.OUT.println("writer "+j+" Unlock");
					t.unlock( j );
				}
			}
		}
	}
}

