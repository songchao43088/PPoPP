CC :=/opt/x10/bin/x10c++
CFLAGS := -nooutput -NO_CHECKS=true

all: Memcached functests

Memcached: Memcached.x10
	$(CC) $(CFLAGS) -o $@ $@.x10

functests: Functests.x10
	$(CC) $(CFLAGS) -o Functests Functests.x10
	./Functests 100 > fun.txt

perftests:
	$(CC) $(CFLAGS) -o Memcached Memcached.x10
	./Memcached 10 10000 3000 1000
	./Memcached 1000 10000 3000 1000
	./Memcached 10000 10000 3000 1000
	./Memcached 100000 10000 3000 1000
	./Memcached 10000 100 3000 1000
	./Memcached 10000 1000 3000 1000
	./Memcached 10000 10000 3000 1000
	./Memcached 100000 100 30 10
	./Memcached 100000 100 300 100
	./Memcached 100000 100 3000 1000

clean:
	rm -f Memcached
	rm -f *.h
