#!/usr/bin/env python3
from antlr4 import *
from SvLexer import SvLexer
from SvParser import SvParser
from SvVisitor import *
import TreeUtils

# from antlr4.InputStream import InputStream
import sys


# convert s json structure into xml
def json2xml(dump: str) -> str:
    import json
    import dict2xml
    d = json.loads(dump)
    outp = ""
    outp += '<?xml version="1.0"?>\n'
    outp += "<top>\n"
    outp += dict2xml.dict2xml(d) + "\n"
    outp += "</top>\n"
    return outp


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
        ext = outputFileName[outputFileName.rindex(".") + 1:]
        if ext in ("lisp", "json", "xml"):
            if ext == "lisp":
                dump = TreeUtils.toLispStringTree(tree, recog=parser)
            elif ext == "json":
                dump = TreeUtils.toJsonStringTree(tree, recog=parser)
            elif ext == "xml":
                dump = TreeUtils.toJsonStringTree(tree, recog=parser)
                dump = json2xml(dump)

            with open(outputFileName, 'wt') as fout:
                print(dump, file=fout)
        else:
            # using JSON as default
            dump = TreeUtils.toJsonStringTree(tree, recog=parser)
            print(dump)

    printer = KeyPrinterVisitor()
    printer.visit(tree)


if __name__ == '__main__':
    parseAndVisit(sys.argv)
