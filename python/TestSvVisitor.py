#!/usr/bin/env python3
from antlr4 import *
from SvLexer import SvLexer
from SvParser import SvParser
from SvVisitor import *
import TreeUtils

# from antlr4.InputStream import InputStream
import sys


class KeyPrinterVisitor(SvVisitor):
    pass


def parseAndVisit(argv):
    inputStream = FileStream(argv[1], encoding='utf-8')

    outputFileName = None
    if len(argv) >= 3:
        outputFileName = argv[2]

    lexer = SvLexer(inputStream)
    stream = CommonTokenStream(lexer)
    parser = SvParser(stream)
    tree = parser.source_text()
    # dump = tree.toStringTree(recog=parser)

    if outputFileName:
        if outputFileName[-5:] == ".lisp":
            dump = TreeUtils.toLispStringTree(tree, recog=parser)
        else:  # json style is default
            dump = TreeUtils.toJsonStringTree(tree, recog=parser)
        with open(outputFileName, 'wt') as fout:
            print(dump, file=fout)

    printer = KeyPrinterVisitor()
    printer.visit(tree)


if __name__ == '__main__':
    parseAndVisit(sys.argv)
