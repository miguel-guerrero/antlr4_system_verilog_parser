#!/usr/bin/env python3
from antlr4 import *
from SvSpecLexer import SvSpecLexer as MyLexer
from SvSpecParser import SvSpecParser as MyParser
from SvSpecListener import *
import sys
import re

class MyPrinter(SvSpecListener):     
    spanLevel = 0
    hidden = False

    def getAllText(self, ctx):  # include hidden channel
        tokenStream = ctx.parser.getTokenStream()
        lexer = tokenStream.tokenSource
        start = ctx.start.start
        stop = ctx.stop.stop
        return lexer.inputStream.getText(start, stop)

    def enterSentence(self, ctx):
        #print(f'enterSentence ctx="{ctx.getText()}"', ctx, 'start=', ctx.start, 'stop=', ctx.stop)
        self.out = ''

    def exitSentence(self, ctx):
        #print(self.getAllText(ctx))
        print(self.out + ';')

    def enterRuleName(self, ctx):
        self.out += ctx.ID().getText() + ':\n'

    def enterTerminal(self, ctx):
        self.out += ' '+ctx.QUOTED_STR().getText()+' '

    def enterNonTerminal(self, ctx):
        self.out += ' '+ctx.ID().getText()+' '

    def enterZeroOrMoreExpr(self, ctx):
        self.out += '('

    def exitZeroOrMoreExpr(self, ctx):
        self.out += ')* '

    def enterOptionalExpr(self, ctx):
        self.out += '('

    def exitOptionalExpr(self, ctx):
        self.out += ')?'

    def enterOredExpr(self, ctx):
        self.out += '##<'

    def exitOredExpr(self, ctx):
        self.out += '##>'


def printTokens(argv):
    input = FileStream(argv[1])
    lexer = MyLexer(input)
    stream = CommonTokenStream(lexer)
    parser = MyParser(stream)
    tree = parser.top()
    for token in stream.tokens:
        print(token)


def parseAndWalk(argv):
    input = FileStream(argv[1])
    lexer = MyLexer(input)
    stream = CommonTokenStream(lexer)
    parser = MyParser(stream)
    tree = parser.top()
    #print(tree.toStringTree(recog=parser))
    printer = MyPrinter()
    walker = ParseTreeWalker()
    walker.walk(printer, tree)

if __name__ == '__main__':
    parseAndWalk(sys.argv)
    #printTokens(sys.argv)
