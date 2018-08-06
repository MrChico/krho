BUILD_DIR:=$(CURDIR)/.build
K_BIN=$(CURDIR)/k/k-distribution/target/release/k/bin

default: build

deps: deps-k

deps-k:
	git submodule update --init
	cd k \
		&& mvn package

build: kompile-java

kompile-java:
	$(K_BIN)/kompile rho.k --verbose --directory .build/$*/ \
	  --syntax-module RHO-SYNTAX rho.k --backend java


kompile-ocaml:
	eval $$(opam config env)
	$(K_BIN)/kompile --debug --main-module RHO --verbose --directory .build/$*/ \
	  --syntax-module RHO-SYNTAX rho.k

test: 
	for x in $(test_files); do \
		$(K_BIN)/krun --directory $(BUILD_DIR) $$x  ; \
	done

test_files = $(shell ls -d $(pwd)tests/*)

clean:
	rm -fdR rho-kompiled/*


