NAME=Sv
ANTLR4=../antlr4.sh
GRUN=../grun.sh

all: 
	$(ANTLR4) -Dlanguage=Python3 -visitor $(NAME).g4

$(NAME)Lexer.py, $(NAME)Parser.py: $(NAME).g4
	$(ANTLR4) -Dlanguage=Python3 -visitor $(NAME).g4

test1x:
	@./Test$(NAME)Lexer.py test1.t

test1v:
	@./Test$(NAME)Visitor.py test1.t

test2x:
	@./Test$(NAME)Lexer.py test2.t

test2v:
	@./Test$(NAME)Visitor.py test2.t

test3x:
	@./Test$(NAME)Lexer.py test3.t

%.v: %.vp
	vppreproc $< --simple > $@

%.vx: %.v $(NAME)Lexer.py ./Test$(NAME)Lexer.py
	./Test$(NAME)Lexer.py   $< > $@

%.json: %.v $(NAME)Visitor.py ./Test$(NAME)Visitor.py ./TreeUtils.py
	time pypy3 ./Test$(NAME)Visitor.py $< $@

%.lisp: %.v $(NAME)Visitor.py ./Test$(NAME)Visitor.py ./TreeUtils.py
	time pypy3 ./Test$(NAME)Visitor.py $< $@

clean:
	$(RM) $(NAME)Lexer.py $(NAME)Parser.py $(NAME)Listener.py $(NAME)Visitor.py $(NAME)*.tokens $(NAME)*.interp
	$(RM) -rf __pycache__ *.vs *.vx *.json

.PRECIOUS: %.v
