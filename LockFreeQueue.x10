import x10.util.concurrent.AtomicReference;

public class LockFreeQueue {

	private static class Node {
		var data:Int = 0;
		var next:AtomicReference[Node] = AtomicReference.newAtomicReference[Node](null);
		public def this(data:Int, next:Node) {
			this.data = data;
			this.next = AtomicReference.newAtomicReference[Node](next);
		}
	}

	private var head:AtomicReference[Node];
	private var tail:AtomicReference[Node];

	public def this() {
		val sentinel = new Node(0, null);
		head = AtomicReference.newAtomicReference[Node](sentinel);
		tail = AtomicReference.newAtomicReference[Node](sentinel);
	}

	public def enq(data:Int) {
		var d:Node = new Node(data, null);
		var t:Node = null;
		var n:Node = null;

		do {
			t = tail.get();
			n = t.next.get();
			if (tail.get()!=t) continue;
			if (n!= null) {
				tail.compareAndSet(t, n);
				continue;
			}
			if (t.next.compareAndSet(null, d)) break;
		} while (true);
		tail.compareAndSet(t, d);	
	}

	public def deq() : Int {
		var d:Int = 0;
		var h:Node = null;
		var t:Node = null;
		var n:Node = null;

		do {
			h = head.get();
			t = tail.get();
			n = h.next.get();
			if (head.get() !=h) continue;
			if (n==null)
				throw new Exception("Empty");
			if (t==h)
				tail.compareAndSet(t, n);
			else
				if (head.compareAndSet(h, n)) break;
		} while (true);
		d = n.data;
		n.data = 0; 
		h.next = null;
		return d;
	}

	public static def main( argv : Array[String]{self.rank==1} ) {
	}
}

