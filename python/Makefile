NAME=Sv
ANTLR4=../antlr4.sh
GRUN=../grun.sh

all: 
	$(ANTLR4) -Dlanguage=Python3 -visitor $(NAME).g4

$(NAME)Lexer.py, $(NAME)Parser.py: $(NAME).g4
	$(ANTLR4) -Dlanguage=Python3 -visitor $(NAME).g4

test1: CORPUS/rstgen.sv
	@./Test$(NAME)Visitor.py $<

test1x: CORPUS/rstgen.sv
	@./Test$(NAME)Lexer.py $<

%.v: %.vp
	../sv_preproc.sh $< $@

%.vx: %.v $(NAME)Lexer.py ./Test$(NAME)Lexer.py
	./Test$(NAME)Lexer.py   $< > $@

%.json: %.v $(NAME)Visitor.py ./Test$(NAME)Visitor.py ./TreeUtils.py
	time pypy3 ./Test$(NAME)Visitor.py $< $@

%.lisp: %.v $(NAME)Visitor.py ./Test$(NAME)Visitor.py ./TreeUtils.py
	time pypy3 ./Test$(NAME)Visitor.py $< $@

clean:
	$(RM) $(NAME)Lexer.py $(NAME)Parser.py $(NAME)Listener.py 
	$(RM) $(NAME)Visitor.py $(NAME)*.tokens $(NAME)*.interp
	$(RM) -rf __pycache__ *.vs *.vx *.json

.PRECIOUS: %.v
