# antlr_system_verilog_grammar
ANTLR grammar for System Verilog 2017 HDL


# INTRODUCTION

This package main contents is the file **Sv.g4** containing a 
System Verilog 2017 grammar for ANTLR v4.

The grammar has been generated using a semi-automated flow, out of the
EBNF description included in SystemVerilog_IEEE_1800-2017.pdf (included
in the ```doc``` folder for reference). Manual intervention was required on the following:

   1. Lexer rules (~the last 60 lines of the file)
   2. Some rules had to be broken to avoid recursivity errors
   3. Some rules had to be expanded inline

Occurences 2, 3 are flagged with TODO markers.

The flow has been semi-automated with the intent to cover the full
spec (nothing has been intentionally left behind out of the grammar).

Aside for the grammar few utilities are included to facilitate processing of the generated syntax tree.

# BINDINGS

Examples on **Java** and **Python** bindings are provided. As of today Python
binding generates very slow executables over such a large grammar (
Performance debugging is in progress). A recommeded flow is to use
the java binding and provided tools to dump the syntax tree on easy 
to import formats (JSON, XML and lisp styles are currently supported). Python 
utilities to import those are provided as examples of use. Using native anltr4 in java is of
course another option. Only java and python bindings have been tested by the author, but the 
grammar definition should be equally usable on other bindings.

    $ make                         -> process grammar though antlr4 to generate python/java artifacts
    $ cd java                      
    $ make test1
    $ make TESTS/rstgen.json       -> parse TESTS/rstgen.sv and generate syntax tree 
                                      dumped onto TESTS/core_region.json
    $ make TESTS/rstgen.lisp       -> parse TESTS/rstgen.sv and generate syntax tree 
                                      dumped onto TESTS/core_region.lisp

# HOWTO

To process a System Verilog file and generate a syntax tree the wrapper script ```sv_parse.sh``` is provided:

    $ make                          -> do once
    $ ./sv_parshe.sh
    
    Usage: ./sv_parse.sh [-python|-java] [-lisp|-json|-xml] filename ...

    Code binding to use is defined by the following:
      -python : to use python binding
      -java   : to use java binding - default

    Output format is defined by the following
      -lisp   : to geerate lisp style output
      -json   : to geerate JSON output
      -xml    : to geerate XML output - default


The recommended flow is to use the java binding (fastest) and XML output format, for simpler post-processing. For example:

    $ ./sv_parse.sh -xml TESTS/rstgen.sv 
    
 The result would be 'rstgen.sv.xml' (it would append .json/.lisp if those output formats are requested)
   
# COMMON ISSUES

1. if you get this error:

```
errors preprocessing Verilog program.
#Error pre-processing TESTS/core_region.sv, skipping it
```

The reason is that the parser requires an external system-verilog preprocessor (I.e. it parses verilog without pre-processing directives, or assumes they are  already expanded). The script looks for two open source tools in the path, ***vppreproc*** and ***iverilog*** (Icarus verilog used as pre-processor only). At least one of them needs to be installed and available in the path.

2. If you see this:

```
Error: Could not find or load main class Testjson
```

or

    Error: Could not find or load main class Testlisp

remember you need to do ```make``` at least once


# TESTS

A number of System Verilog files are included as test corpus under the ```TESTS``` directory. They are currently
taken from the RISC-V Pulpino project but more will be added over time. They are covered
under their own license, and are included here only as a convenience. To run them do:


    $ make                          -> do once
    $ ./sv_parse.sh TESTS/*.sv

# BUGS

This code is in Beta testing. Please report any bugs along with input file and command line used to allow its reproduction to: miguel.a.guerrero at gmail.com

Suggestions for improvement and contributions are most welcomed

# DEPENDENCIES

- The SV parser included here doesn't include a preprocessor
The testing assumes 'vppreproc' is installed. However this can
be replaced in the Makefiles with any other preprocessor tool

- JDK if using java binding (recommended for speed), otherwise 
just the JRE

- Either ***vppreproc*** and ***iverilog***  to be installed in the path to be
used as verilog pre-processors

- ANTLR distribution. A copy of the version used for testing is under the 
bin directory for simplicity of installation. It is expected to be 
copied under /usr/local/lib however it is simple to change the expected
path in the scripts if required.

- Python 3 if using python binding (with pypy3 recommended). Testing has
been performed with Python 3.6.5 and mostly pypy3 for speed.

Python 3.6.5 has been used for testing but is expected that lower
python 3 distributions may be compatible. 

- The following python3 packages:

  dict2xml : pip3 install dict2xml

See INSTALL.md for details

# LICENSE

See LICENSE and NOTICE files for licensing details

