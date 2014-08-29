COMPILER ?= compiler.jar
JAVA_CMD ?= java

.PHONY: all clean

all: ints.js

Ints.js: Ints.purs $(shell find */src -name '*.purs')
	psc -m Ints $^ -o $@

ints.js: Ints.js wrapper.js
	$(JAVA_CMD) -jar $(COMPILER) -O ADVANCED --js_output_file=$@ $^

clean:
	rm -f Ints.js ints.js
