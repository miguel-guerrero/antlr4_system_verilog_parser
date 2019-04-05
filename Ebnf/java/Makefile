NAME=SvSpec
ANTLR4=../../antlr4.sh
GRUN=../../grun.sh
SETCP=CLASSPATH=".:/usr/local/lib/antlr-4.7.1-complete.jar:${CLASSPATH}" 

all: 
	$(ANTLR4) $(NAME).g4
	$(SETCP) javac *.java

test1l:
	$(SETCP) $(GRUN) $(NAME) tokens -tokens test1.t

test1:
	$(SETCP) $(GRUN) $(NAME) top -trace -tokens -gui test1.t

clean:
	$(RM) $(NAME)*.java *.class $(NAME)*.interp $(NAME)*.tokens
