NAME=Sv
ANTLR4=../antlr4.sh
GRUN=../grun.sh
SETCP=CLASSPATH=".:/usr/local/lib/antlr-4.7.1-complete.jar:${CLASSPATH}" 
ARGS?=-tree -tokens
AUTO_SRC=\
  $(NAME)Visitor.java \
  $(NAME)Parser.java \
  $(NAME)Lexer.java \

SRC=\
   TreeUtils.java \
   Testjson.java \
   Testlisp.java \

AUTO_OBJ=$(AUTO_SRC:.java=.class)
OBJ=$(SRC:.java=.class)

all: 
	$(ANTLR4) -visitor $(NAME).g4
	make -C . -j $(AUTO_OBJ)
	make -C . -j $(OBJ)

javac:
	$(SETCP) javac -Xlint *.java

test1: TESTS/rstgen.sv
	$(SETCP) time $(GRUN) $(NAME) source_text $(ARGS) $<

test1g: TESTS/rstgen.sv
	$(SETCP) $(GRUN) $(NAME) source_text $(ARGS) -gui $<

%.class: %.java
	$(SETCP) javac -Xlint $<

%.json: %.sv Testjson.class TreeUtils.class
	@$(SETCP) java Testjson $< > $@

%.lisp: %.sv Testlisp.class TreeUtils.class $(NAME)Visitor.class
	@$(SETCP) java Testlisp $< > $@

clean:
	$(RM) $(NAME)*.java *.class $(NAME)*.interp $(NAME)*.tokens TreeUtils.class
	$(RM) *.json *.lisp
