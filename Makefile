default: build

deps: deps-k

deps-k:
	git submodule update --init
	cd k \
		&& mvn package

build:
	k/k-distribution/bin/kompile rho.k --backend java

test: build
	for x in $(test_files); do \
		k/k-distribution/bin/krun $$x ; \
	done

test_files = $(shell ls -d $(pwd)tests/*)

clean:
	rm -fdR rho-kompiled/*
