This folder is here for historical reasons. The code used
here was used to develop the Sv.g4 grammar from an extract
of the original spec.

This folder contains a grammar to transform an EBNF grammar 
written in the notation of the original System Verilog 
appendix A document to the type of EBNF required by ANTLR.

  SvSpec.g4: The aforementioned grammar 

  java: this folder contains a Makefile and few targets
        that allow sanity checking the grammar above using standard
        tools from the ANTLR standard java distribution

  python: the code here performs the EBNF conversion using a
          visitor pattern


Performing 'make all' on this directory will generate python
collaterals and generate ../Sv.g4 from ../Sv.in

