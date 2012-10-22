CC :=${X10_HOME}/bin/x10c++
CFLAGS := -nooutput -NO_CHECKS=true

all: Memcached

Memcached: 
	$(CC) $(CFLAGS) -o $@ $@.x10

clean:
	rm -f Memcached
	rm -f *.h

