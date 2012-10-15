CC :=${X10_HOME}/bin/x10c++
CFLAGS := -nooutput -NO_CHECKS=true

all: Memcachedd

Memcachedd: 
	$(CC) $(CFLAGS) -o $@ $@.x10

clean:
	rm -f Memcachedd
	rm -f *.h

