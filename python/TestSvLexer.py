#!/usr/bin/env python3
import sys
from antlr4 import *
from antlr4.InputStream import InputStream
from SvLexer import SvLexer as MyLexer


if __name__ == '__main__':
    if len(sys.argv) > 1:
        inputStream = FileStream(sys.argv[1], encoding='utf-8')
    else:
        inputStream = InputStream(sys.stdin.read())

    lexer = MyLexer(inputStream)

    tok = lexer.nextToken()
    while tok.type != Token.EOF:
        txt = tok.text
        if txt is not None:
            txt = txt.replace("\n", "\\n")
            txt = txt.replace("\r", "\\r")
            txt = txt.replace("\t", "\\t")
        else:
            txt = "<no text>"
        print(
            f'ch#{tok.channel} line {tok.line}:{tok.column}\t({tok.start}, '
            f'{tok.stop}) \t<{tok.type}>\t"{txt}"'
        )
        t = lexer.nextToken()
