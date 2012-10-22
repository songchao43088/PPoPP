CC :=${X10_HOME}/bin/x10c++
CFLAGS := -nooutput -NO_CHECKS=true

all: Heap 

Heap: Heap.x10
	$(CC) $(CFLAGS) -o $@ $@.x10


clean:
	rm -f Heap 
	rm -f *.h

