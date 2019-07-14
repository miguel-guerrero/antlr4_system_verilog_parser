NAME=SvSpec
ANTLR4=../../antlr4.sh
GRUN=../../grun.sh

BIN:=../../bin
JAR:=$(shell ls ${BIN}/antlr*.jar)
export CLASSPATH:=.:${JAR}:${CLASSPATH}

all: 
	$(ANTLR4) -Dlanguage=Python3 -visitor $(NAME).g4

test1x:
	@./Test$(NAME)Lexer.py test1.t

test1l:
	@./Test$(NAME)Listener.py test1.t

test1v:
	@./Test$(NAME)Visitor.py test1.t

test2v:
	@./Test$(NAME)Visitor.py test2.t

test3v:
	@./Test$(NAME)Visitor.py test3.t

sv:
	@./Test$(NAME)Visitor.py test3.t > ../../Sv.g4

clean:
	$(RM) $(NAME)Lexer.py $(NAME)Parser.py $(NAME)Listener.py $(NAME)Visitor.py $(NAME)*.tokens $(NAME)*.interp
	$(RM) -rf __pycache__
