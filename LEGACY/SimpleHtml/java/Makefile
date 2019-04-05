NAME=SimpleHtml
LEX_NAME=HtmlLexer
ANTLR4=../../antlr4.sh
GRUN=../../grun.sh
SETCP=CLASSPATH=".:/usr/local/lib/antlr-4.7.1-complete.jar:${CLASSPATH}" 

all: 
	$(ANTLR4) $(LEX_NAME).g4
	$(ANTLR4) $(NAME).g4
	$(SETCP) javac *.java

test1l:
	$(SETCP) $(GRUN) HtmlLexer tokens -tokens test1.html

test1:
	$(SETCP) $(GRUN) $(NAME) top -tokens test1.html

test2:
	$(SETCP) $(GRUN) $(NAME) top -tree -tokens test2.html

testsv:
	$(SETCP) $(GRUN) $(NAME) top -tree SV.html

clean:
	$(RM) $(NAME)*.java *.class $(NAME)*.interp $(NAME)*.tokens
	$(RM) $(LEX_NAME)*.java $(LEX_NAME)*.interp $(LEX_NAME)*.tokens
