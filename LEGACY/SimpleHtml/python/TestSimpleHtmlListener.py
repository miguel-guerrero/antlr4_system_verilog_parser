#!/usr/bin/env python3
from antlr4 import *
from HtmlLexer import HtmlLexer
from SimpleHtml import SimpleHtml as SimpleHtmlParser
from SimpleHtmlListener import *
import sys
import re


class MyPrinter(SimpleHtmlListener):     
    spanLevel = 0
    hidden = False

    def enterBodyStm(self, ctx):
        #print(f'enterBodyStm ctx="{ctx.getText()}"', ctx, 'start=', ctx.start, 'stop=', ctx.stop)
        self.out = ''

    def exitBodyStm(self, ctx):
        print(self.out)

    def enterPText(self, ctx):
        if not self.hidden:
            if ctx.TEXT():
                self.out += ctx.TEXT().getText()

    def enterSpan(self, ctx): 
        self.spanLevel += 1
        if ctx.attrib():
            attr = ctx.attrib().getText()
            attr = re.sub('\r?\n', '', attr)
            if attr.startswith("style='color:red") and not self.hidden:
                self.out += "'" 
            else:
                self.hidden = True

    def exitSpan(self, ctx):
        self.spanLevel -= 1
        if self.spanLevel == 0:
            self.hidden = False
        if ctx.attrib():
            attr = ctx.attrib().getText()
            attr = re.sub('\r?\n', '', attr)
            if attr.startswith("style='color:red") and not self.hidden:
                self.out += "'" 

def printTokens(argv):
    input = FileStream(argv[1])
    lexer = HtmlLexer(input)
    stream = CommonTokenStream(lexer)
    parser = SimpleHtmlParser(stream)
    tree = parser.top()
    for token in stream.tokens:
        print(token)


def parseAndWalk(argv):
    input = FileStream(argv[1])
    lexer = HtmlLexer(input)
    stream = CommonTokenStream(lexer)
    parser = SimpleHtmlParser(stream)
    tree = parser.top()
    #print(tree.toStringTree(recog=parser))
    printer = MyPrinter()
    walker = ParseTreeWalker()
    walker.walk(printer, tree)

if __name__ == '__main__':
    parseAndWalk(sys.argv)
    #printTokens(sys.argv)
