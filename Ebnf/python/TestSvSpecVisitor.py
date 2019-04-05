#!/usr/bin/env python3
from antlr4 import *
from SvSpecLexer import SvSpecLexer as MyLexer
from SvSpecParser import SvSpecParser as MyParser
from SvSpecVisitor import *
import sys
import TreeUtils
from collections import Counter

class KeyPrinterVisitor(SvSpecVisitor):

    pass_ = 1
    orNestingLevel = 0
    sequentialComments = 0
    tokenCountInRule = 0
    numOred = 0
    defined = set()
    used = set()
    recursive = set()
    inline = {}
    inlineWithName = {}
    countInlinesThisRule = Counter()

    def setPass(self, x):
        self.pass_ = x
        orNestingLevel = 0
        sequentialComments = 0
        tokenCountInRule = 0
        numOred = 0

    def visitSentence(self, ctx):
        self.countInlinesThisRule = Counter()
        inlined = ctx.equals().getText()[-1] == '='
        if inlined:
            ruleName = ctx.ruleName().getText()
            self.orNestingLevel += 1
            self.numOred = 0
            body = self.visitOredExpr(ctx.oredExpr())
            self.orNestingLevel -= 1
            self.inlineWithName[ruleName] = ctx.equals().getText()[0]=='=' and self.numOred > 1
            self.inline[ruleName] = '('+body+')'
        
        self.orNestingLevel = 0
        val = self.visitRuleName(ctx.ruleName()) + ' :\n      ' + self.visitOredExpr(ctx.oredExpr()) + '\n;\n'
        if self.pass_==2 and not inlined:
            if self.sequentialComments > 0:
                print()
            print(val)
        self.sequentialComments = 0

    def visitComment(self, ctx):
        if self.pass_==2:
            if self.sequentialComments == 0:
                print()
            val = ctx.COMMENT().getText()
            if val[2] == '@':
                print(val[3:], end='')
            else:
                print(val, end='')
        self.sequentialComments += 1

    def visitRuleName(self, ctx):
        self.tokenCountInRule = 0
        self.currentRule = ctx.ID().getText()
        self.defined.add(self.currentRule)
        return ctx.ID().getText()

    def visitTerminal(self, ctx):
        self.tokenCountInRule += 1
        return ctx.QUOTED_STR().getText()

    def visitNonTerminal(self, ctx):
        nonTermName = ctx.ID().getText()
        self.tokenCountInRule += 1
        if self.pass_==2:
            if self.inline.get(nonTermName):
                self.countInlinesThisRule[nonTermName] += 1
                if self.inlineWithName[nonTermName]:
                    cnt = self.countInlinesThisRule[nonTermName]
                    if cnt == 1:
                        return nonTermName+'='+self.inline[nonTermName]
                    else:
                        return nonTermName+str(cnt)+'='+self.inline[nonTermName]
                else:
                    return self.inline[nonTermName]
        else:
            if nonTermName == self.currentRule:
                self.recursive.add(nonTermName)
            self.used.add(nonTermName)
        return nonTermName

    def visitZeroOrMoreExpr(self, ctx):
        c = self.tokenCountInRule
        val = self.visitOredExpr(ctx.oredExpr())
        if self.tokenCountInRule==c+1:
            return val + '*' 
        return '(' + val + ')*'

    def visitOptionalExpr(self, ctx):
        c = self.tokenCountInRule
        val = self.visitOredExpr(ctx.oredExpr())
        if self.tokenCountInRule==c+1:
            return val + '?' 
        return '('+ val + ')?'

    def visitAttribExpr(self, ctx):
        attr = ''
        if ctx.attrib():
            attr = ctx.attrib().getText() + ' '
        val = self.visitExpr(ctx.expr())
        return attr + val

    def visitOredExpr(self, ctx):
        self.orNestingLevel += 1
        res = []
        for e in ctx.expr():
            res.append(self.visitExpr(e))
            self.numOred += 1
        self.orNestingLevel -= 1
        if  self.orNestingLevel == 0:
            return '\n    | '.join(res)
        return ' | '.join(res)

    def visitExpr(self, ctx):
        if ctx.getChildCount() == 2: 
            assert len(ctx.expr())==2 #concatExpr
            return self.visitExpr(ctx.expr(0)) + ' ' + self.visitExpr(ctx.expr(1))
        elif ctx.getChildCount() == 3: 
            return '(' + self.visitOredExpr(ctx.oredExpr()) + ')'
        return self.visitChildren(ctx)

    def check(self):
        print('Number of Rules', len(self.defined), file=sys.stderr)
        print('Number of inline Rules', len(self.inline), file=sys.stderr)
        print('Unused (expected to be root rules)', self.defined - self.used, file=sys.stderr)
        print('Undefined (expected to be lexer rules)', self.used - self.defined, file=sys.stderr)
        print('Recursive', self.recursive, file=sys.stderr)


def parseAndVisit(argv):
    print('Starting', file=sys.stderr)
    input = FileStream(argv[1])
    lexer = MyLexer(input)
    stream = CommonTokenStream(lexer)
    parser = MyParser(stream)
    print('Parsing', file=sys.stderr)
    tree = parser.top()
    lispTree = TreeUtils.toLispStringTree(tree, recog=parser)
    with open('out.lisp', 'w') as fout:
        print(lispTree, file=fout)
    print('Walking tree', file=sys.stderr)
    printer = KeyPrinterVisitor()
    print('grammar Sv;\n')
    printer.visit(tree)
    printer.setPass(2)
    printer.visit(tree)
    printer.check()

if __name__ == '__main__':
    parseAndVisit(sys.argv)

