#!/usr/bin/env python3
import sys
from antlr4 import *
from antlr4.InputStream import InputStream
from SvSpecLexer import SvSpecLexer

if __name__ == '__main__':
    if len(sys.argv) > 1:
        inputStream = FileStream(sys.argv[1])
    else:
        inputStream = InputStream(sys.stdin.read())

    lexer = SvSpecLexer(inputStream)

    t = lexer.nextToken()
    while t.type != Token.EOF:
        txt = t.text
        if txt is not None:
            txt = txt.replace("\n","\\n")
            txt = txt.replace("\r","\\r")
            txt = txt.replace("\t","\\t")
        else:
            txt = "<no text>"
        #print(f'{t}')
        print(f'ch#{t.channel} line {t.line}:{t.column}\t({t.start}, {t.stop})  \t<{t.type}>\t"{txt}"')
        t = lexer.nextToken()
