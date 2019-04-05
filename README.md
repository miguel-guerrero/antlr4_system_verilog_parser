# antlr_system_verilog_grammar
ANTLR grammar for System Verilog 2017 HDL


# INTRODUCTION

This package main contents is the file Sv.g4 containing a 
System Verilog 2017 grammar for ANTLR v4.

The grammar has been generated using a semi-automated flow out of the
EBNF description included in SystemVerilog_IEEE_1800-2017.pdf included
for reference. Manual intervention was required on the following:

    1- Lexer rules (~the last 60 lines of the file)
    2- Some rules had to be broken to avoid recursivity errors
    3- Some rules had to be expanded inline

Occurences 2, 3 are flagged with TODO markers.

The flow has been semi-automated with the intent to cover the full
spec (nothing has been intentionally left behind out of the grammar).

# BINDINGS

Examples on Java and Python bindings are provided. As of today Python
binding generates very slow executables over such a large grammar.
Performance debugging is in progress. A recommeded flow is to use
the java binding and provided tools to dump the syntax tree on easy 
to import formats (JSON and lisp style currently supported). Python 
utilities to import those are provided as examples of use.

$ make
$ cd java
$ make arbiter.json   -> parser arbiter.v and generates syntax tree in arbiter.json
$ make arbiter.lisp   -> parser arbiter.v and generates syntax tree in arbiter.lisp
$ cd ../python

# TESTS

Verilog files invoked on Makefile's are currently not part of the distribution
till licensing of that contents is clarified

# DEPENDENCIES

1) The SV parser included here doesn't include a preprocessor
The testing assumes 'vppreproc' is installed. However this can
be replaced in the Makefiles with any other preprocessor tool

2) JDK if using java binding

3) Python 3 if using python binding (with pypy3 recommended)

Python 3.6.5 has been used for testing but is expected that lower
python 3 distributions may be compatible

See INSTALL for details

# LICENSE

See LICENSE and NOTICE File for licensing details

