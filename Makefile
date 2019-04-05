
all:
	make -C Ebnf all
	make -C python all
	make -C java all

clean:
	make -C Ebnf clean
	make -C python clean
	make -C java clean
