This folder contains a link to a grammar 
to transform an EBNF grammar written in the notation of
the original System Verilog appendix A document to the
type of EBNF required by ANTLR.

The point of this folder is to allow performing basic
sanity checks on the grammar through a small sample test
file using standard code from the ANLTR standard distribution
(I.e. this folder contains no custom code)

Makefile:

    all :  <default> Perform this first!

        processes SvSpec.g4 (the grammar that
        handles the EBNF conversion) and generates
        and compiles ANTLR files in java for it. 

    test1l: 
    
        processes a small sample of grammar written
        in SV spec style EBNF. The output is a lexer
        token dump onto stdout

    test1: 
    
        parses a small sample of grammar written
        in SV spec style EBNF. The output is a lexer
        token dump onto stdout and a graphics view
        of the parse tree

    clean:
        clears all generated files

