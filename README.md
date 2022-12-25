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

# QUICK START

    $ ./install.sh
    $ ./regress.sh

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

Run some tests with java bindings:

    $ cd java                      
    $ make test1
    $ make CORPUS/rstgen.json      -> parse CORPUS/rstgen.sv and generate syntax tree 
                                      dumped onto CORPUS/core_region.json
    $ make CORPUS/rstgen.lisp      -> parse CORPUS/rstgen.sv and generate syntax tree 
                                      dumped onto CORPUS/core_region.lisp

# HOWTO

To process a System Verilog file and generate a syntax tree the wrapper script ```sv_parse.sh``` is provided:

    $ make                          -> do once
    $ ./sv_parshe.sh
    
    Usage: ./sv_parse.sh [-python|-java] [-lisp|-json|-xml] [-d outdir] filename ...

    Code binding to use is defined by the following:
      -python : to use python binding
      -java   : to use java binding - default

    Output format is defined by the following
      -lisp   : to geerate lisp style output
      -json   : to geerate JSON output
      -xml    : to geerate XML output - default


The recommended flow is to use the java binding (fastest) and XML output format, for simpler post-processing. For example:

    $ ./sv_parse.sh -xml CORPUS/rstgen.sv 
    
 The result would be 'rstgen.sv.xml' (it would append .json/.lisp if those output formats are requested)
   
# DATA EXTRACTION

One example of data extraction from a generated XML file is included under ```extract``` directory. It extracts few items from interfaces defined in that file. For example:

    $ ./sv_parse.sh -xml CORPUS/apb_bus.sv
    $ extract/dump_xml_iface.py apb_bus.sv.xml

Generates:

```
interface name: APB_BUS
paramId: APB_ADDR_WIDTH
paramId: APB_DATA_WIDTH
variable_identifier: paddr
variable_identifier: pwdata
variable_identifier: pwrite
variable_identifier: psel
variable_identifier: penable
variable_identifier: prdata
variable_identifier: pready
variable_identifier: pslverr
```
   
# COMMON ISSUES

1. if you get this error:

```
errors preprocessing Verilog program.
#Error pre-processing CORPUS/core_region.sv, skipping it
```

The reason is that the parser requires an external system-verilog preprocessor (I.e. it parses verilog without pre-processing directives, or assumes they are  already expanded). The script looks for ***iverilog*** (Icarus verilog used as pre-processor only) in the path. 

2. If you see this:

```
Error: Could not find or load main class Testjson
```

or

    Error: Could not find or load main class Testlisp

remember you need to do ```make``` at least once on the root directory


# TESTS

A number of System Verilog files are included as test corpus under the ```CORPUS``` directory. They are currently
taken from the RISC-V Pulpino project but more will be added over time. They are covered
under their own license, and are included here only as a convenience. To run them do:


    $ make                          -> do once
    $ ./sv_parse.sh CORPUS/*.sv
    
You can also run all of them (this will run with both java and python bindings)

    $ ./regress.sh

# BUGS

This code is in Beta testing. Please report any bugs along with input file and command line used to allow its reproduction to: miguel.a.guerrero at gmail.com

Suggestions for improvement and contributions are most welcomed

# DEPENDENCIES

See INSTALL.md for details (running ./install.sh should cover requiremetns).

- The SV parser included here doesn't include a verilog preprocessor
The testing assumes  **iverilog** is installed and in the path to be 
used as pre-processors. However this can be replaced in the scripts 
with any other preprocessor tool

- JDK if using java binding (recommended for speed), otherwise 
just the JRE

- ANTLR distribution. A copy of the version used for testing is under the 
bin directory for simplicity of installation. It is not required to 
be installed globally. All code here refers to the local copy

- Python 3 if using python binding Testing has been performed with 
Python 3.6.5 and 3.10.8 but other pytho3 versions are expected to be
ok.

- if pypy3 is detected it will be used by sv_parse.sh parser script as it
gets a significant speed up over python3. But this is not required.

- Some python packages

# LICENSE

See LICENSE and NOTICE files for licensing details

