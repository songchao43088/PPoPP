CC :=${X10_HOME}/bin/x10c++
CFLAGS := -nooutput -NO_CHECKS=true

all: Memcached functests

Memcached: Memcached.x10
	$(CC) $(CFLAGS) -o $@ $@.x10

functests: Functests.x10
	$(CC) $(CFLAGS) -o Functests Functests.x10
	./Functests 100 > fun.txt

clean:
	rm -f Memcached
	rm -f *.h
