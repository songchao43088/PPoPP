CC :=/opt/x10/bin/x10c++
CFLAGS := -nooutput -NO_CHECKS=true

all: Memcached

Memcached: Memcached.x10
	$(CC) $(CFLAGS) -o $@ $@.x10

functests: Functests.x10
	$(CC) $(CFLAGS) -o Functests Functests.x10
	./Functests 100 > fun.txt

perftests:
	$(CC) $(CFLAGS) -o Memcached Memcached.x10
	./Memcached 10 10000 3000 1000 1
	./Memcached 1000 10000 3000 1000 1
	./Memcached 10000 10000 3000 1000 1
	./Memcached 100000 10000 3000 1000 1
	./Memcached 10000 100 3000 1000 1
	./Memcached 10000 1000 3000 1000 1
	./Memcached 10000 10000 3000 1000 1
	./Memcached 100000 100 30 10 1
	./Memcached 100000 100 300 100 1
	./Memcached 100000 100 3000 1000 1
	./Memcached 10 10000 3000 1000 4
	./Memcached 1000 10000 3000 1000 4
	./Memcached 10000 10000 3000 1000 4
	./Memcached 100000 10000 3000 1000 4
	./Memcached 10000 100 3000 1000 4
	./Memcached 10000 1000 3000 1000 4
	./Memcached 10000 10000 3000 1000 4
	./Memcached 100000 100 30 10 4
	./Memcached 100000 100 300 100 4
	./Memcached 100000 100 3000 1000 4
clean:
	rm -f Memcached
	rm -f *.h
