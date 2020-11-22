

# ANTLR v4 installation

The file bin/antlr-4.8-complete.jar is provided with this distribution as a convenience to simplify installation. ANTLRv4 is distributed under its own license. See https://www.antlr.org for details.

Note that if using python target additional steps will be
required (also pointed out in the same page above) to include
run-time python support

# The SV parser included here doesn't include a preprocessor

The testing Makefiles assume 'vppreproc' is installed with either 
of the following methods:

a) Using apt facility:

    $ sudo apt install libverilog-perl

b) Or https://metacpan.org/pod/Verilog::Preproc

    $ perl -MCPAN -e install Verilog::Netlist::File
    $ perl -MCPAN -e install Verilog::Preproc
    $ perl -MCPAN -e install vppreproc

Examples of invocation:

    $ vppreproc x.vp
    $ vppreproc x.vp --simple

if not found but Icarus-Verilog (iverilog) is found in the path, then
Icarus Verilog (http://iverilog.icarus.com/) will be used as pre-processor.


# Java binding

A version of the JDK needs to be installed in your system to run
the Java binding. The code has been tested with the following:

    openjdk version "1.8.0_181"
    OpenJDK Runtime Environment (build 1.8.0_181-8u181-b13-0ubuntu0.18.04.1-b13)
    OpenJDK 64-Bit Server VM (build 25.181-b13, mixed mode)


# Python binding

To install the python binding dependencies do the following:


    $ sudo python3 -mpip install -r requirements.txt
    
 or
 
    $ python3 -mpip install -r requirements.txt --user
 
if root permissions are not available.

This will install antlr4 python3 runtime and other misc packages
used to process JSON and XML files on the generated syntax trees

Python binding is very slow at the moment (debug WIP) only suitable for
small files.

It is recommended to use a faster binding, dump the contents of the 
syntax tree out and perform the work in python if desired.

Installation of pypy3 is recommended to accelerate parsing if using python biding

To install pypy3, follow instructions here: http://pypy.org/download.html

NOTE: I had to perform the following on my system (may or may not be required in yours)

    $ cd ~/.local/lib && ln -s python3.6 python3.5
    
and make sure it is available under your $path (in this case I'm creating as soft link under ~/bin which is in my $path)

    $ cd ~/bin && ln -s /home/$USERID/pypy3-v6.0.0-linux64/bin/pypy3 pypy3

