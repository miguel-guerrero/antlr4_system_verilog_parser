# antlr_system_verilog_grammar
ANTLR grammar for System Verilog 2017 HDL


# INTRODUCTION

This package main contents is the file Sv.g4 containing a 
System Verilog 2017 grammar for ANTLR v4.

The grammar has been generated using a semi-automated flow out of the
EBNF description included in SystemVerilog_IEEE_1800-2017.pdf included
for reference. Manual intervention was required on the following:

   1. Lexer rules (~the last 60 lines of the file)
   2. Some rules had to be broken to avoid recursivity errors
   3. Some rules had to be expanded inline

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
    $ make test1
    $ make test2
    $ make TESTS/core_region.json  -> parse TESTS/core_region.sv and generate syntax tree 
                                      on TESTS/core_region.json
    $ make TESTS/core_region.lisp  -> parse TESTS/core_region.sv and generate syntax tree 
                                      on TESTS/core_region.lisp

# TESTS

A number of System Verilog files are included as test corpus. They are currently
taken from the RISC-V Pulpino project but more will be added over time. They are covered
under their own license and are included here only for convenience.

# BUGS

This code is in Beta testing. Please report any bugs along with input file and command line used to allow its reproduction to: miguel.a.guerrero at gmail.com

Suggestions for improvement are most welcomed

# DEPENDENCIES

- The SV parser included here doesn't include a preprocessor
The testing assumes 'vppreproc' is installed. However this can
be replaced in the Makefiles with any other preprocessor tool

- JDK if using java binding (recommended for speed), otherwise 
just the JRE

- ANTLR distribution. A copy of the version used for testing is under the 
bin directory for simplicity of installation. It is expected to be 
copied under /usr/local/lib however it is simple to change the expected
path in the scripts if required.

- Python 3 if using python binding (with pypy3 recommended). Testing has
been performed with Python 3.6.5 and mostly pypy3 for speed.

Python 3.6.5 has been used for testing but is expected that lower
python 3 distributions may be compatible. 

See INSTALL.md for details

# LICENSE

See LICENSE and NOTICE files for licensing details

