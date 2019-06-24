NAME=SvSpec
ANTLR4=../../antlr4.sh
GRUN=../../grun.sh
export CLASSPATH:=.:../../bin/antlr-4.7.1-complete.jar:$(CLASSPATH)

all: 
	$(ANTLR4) $(NAME).g4
	javac *.java

test1l:
	$(GRUN) $(NAME) tokens -tokens test1.t

test1:
	$(GRUN) $(NAME) top -trace -tokens -gui test1.t

clean:
	$(RM) $(NAME)*.java *.class $(NAME)*.interp $(NAME)*.tokens
