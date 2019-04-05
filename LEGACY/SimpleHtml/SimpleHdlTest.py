#!/usr/bin/env python3
from antlr4 import *
from shdlLexer import shdlLexer
from shdlParser import shdlParser
from shdlListener import *
import sys

class KeyPrinter(shdlListener):     
    def enterSentence(self, ctx):
        lst0 = ctx.str_list(0)
        lst1 = ctx.str_list(1)
        args = ctx.args()
        print("enterSentence:", ctx.ins_name().ID())
        if args != None:
           print(" args:", args.arg())
        for i in lst0.ID():
           print(" lst0:", i)
        if lst1 != None:
           for i in lst1.ID():
              print(" lst1:", i)

    def enterInput_decl(self, ctx):
        print("input decl:", ctx.ID()) 
        if ctx.width_decl() != None:
            ce = ctx.width_decl().const_expr()
            ce_int = ce.INT()
            ce_id = ce.ID()
            if ce_int != None:
                print(" width_decl INT:", ce_int)
            if ce_id != None:
                print(" width_decl ID:", ce_id)


    def enterWidth_decl(self, ctx):
        print("Entering width_decl", ctx.const_expr());
    def exitWidth_decl(self, ctx):
        print("Leaving width_decl", ctx.const_expr());

def tokens(argv):
    input = FileStream(argv[1])
    lexer = shdlLexer(input)
    stream = CommonTokenStream(lexer)
    #for token in stream:
    #    print(token)


def main(argv):
    input = FileStream(argv[1])
    lexer = shdlLexer(input)
    stream = CommonTokenStream(lexer)
    parser = shdlParser(stream)
    tree = parser.top()
    print('tree:', repr(tree))
    printer = KeyPrinter()
    walker = ParseTreeWalker()
    walker.walk(printer, tree)

if __name__ == '__main__':
    main(sys.argv)
    #tokens(sys.argv)
