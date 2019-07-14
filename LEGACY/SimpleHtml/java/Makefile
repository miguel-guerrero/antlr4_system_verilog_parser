NAME=SimpleHtml
LEX_NAME=HtmlLexer
ANTLR4=../../antlr4.sh
GRUN=../../grun.sh

BIN:=../../bin
JAR:=$(shell ls ${BIN}/antlr*.jar)
export CLASSPATH:=.:${JAR}:${CLASSPATH}

all: 
	$(ANTLR4) $(LEX_NAME).g4
	$(ANTLR4) $(NAME).g4
	javac *.java

test1l:
	$(GRUN) HtmlLexer tokens -tokens test1.html

test1:
	$(GRUN) $(NAME) top -tokens test1.html

test2:
	$(GRUN) $(NAME) top -tree -tokens test2.html

testsv:
	$(GRUN) $(NAME) top -tree SV.html

clean:
	$(RM) $(NAME)*.java *.class $(NAME)*.interp $(NAME)*.tokens
	$(RM) $(LEX_NAME)*.java $(LEX_NAME)*.interp $(LEX_NAME)*.tokens
