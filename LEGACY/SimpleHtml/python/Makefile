LEX_NAME=HtmlLexer
NAME=SimpleHtml
ANTLR4=../../../antlr4.sh
GRUN=../../../grun.sh

all: 
	$(ANTLR4) -Dlanguage=Python3 $(LEX_NAME).g4
	$(ANTLR4) -Dlanguage=Python3 -visitor $(NAME).g4

test1x:
	./Test$(LEX_NAME).py test1.html

test1l:
	./Test$(NAME)Listener.py test1.html

test1v:
	./Test$(NAME)Visitor.py test1.html

testx:
	./Test$(LEX_NAME).py SV.html

testl:
	./Test$(NAME)Listener.py SV.html

testv:
	./Test$(NAME)Visitor.py SV.html


clean:
	$(RM) $(LEX_NAME).py $(LEX_NAME)*.tokens $(LEX_NAME)*.interp
	$(RM) $(NAME).py $(NAME)Listener.py $(NAME)Visitor.py $(NAME)*.tokens $(NAME)*.interp
	$(RM) -rf __pycache__
