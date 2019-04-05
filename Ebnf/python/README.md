
The main file in this directory is TestSvSpecVisitor.py
(the other TestSvSpec*.py are for testing)

It uses ANTLR visitor pattern to transform a grammar written
in System Verilog spec Appendix A EBNF to EBNF in ANLTR format

There are some externsions to the input grammar to allow for
frequent transformations required

LHS = (a|b|c|...);   Performs inline substitution of the RHS wherever LHS appears
                     providing a named token LHS=(a|b|c|...)

LHS =* RHS;          Performs inline substitution of the RHS wherever LHS appears
                     Substitution is verbatim and unamed.

//@<line>            This type of comment outputs <line> verbatim to the output file
                     This is used to copy out verbatim lexer rules on the input file
                     without further processing, which allows making the input file
                     a single point of definition of the output grammar.

NOTE: Current limitation, subtitution rules are not yet recursive, I.e. a replaced 
      rule cannot invoke rules that are replaced as well.

To perform the conversion do:

    $ make

to generate coverstion tool files, and

    $ make sv 

to generate ../../Sv.g4  (main output) from ../../Sv.in  (main input)


test1/test2 are smaller test cases that have other related targets
in the Makefile to test the conversion utilities

