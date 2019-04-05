

# ANTLR v4 installation

The file antlr-4.7.1-complete.jar

is expected to be present under /usr/local/lib

Please download it from: https://www.antlr.org/download.html

Note that if using python target additional steps will be
required (also pointed out in the same page above) to include
run-time python support

# The SV parser included here doesn't include a preprocessor

The testing assumes 'vppreproc' is installed with either 
of the following methods:

a) $ sudo apt install libverilog-perl

b) See: https://metacpan.org/pod/Verilog::Preproc

        $ perl -MCPAN -e install Verilog::Netlist::File
        $ perl -MCPAN -e install Verilog::Preproc
        $ perl -MCPAN -e install vppreproc

Examples of invocation:

        $ vppreproc x.vp
        $ vppreproc x.vp --simple


# Java binding

A version of the JDK needs to be installed in your system to run
the Java binding. The code has been tested with the following:

    openjdk version "1.8.0_181"
    OpenJDK Runtime Environment (build 1.8.0_181-8u181-b13-0ubuntu0.18.04.1-b13)
    OpenJDK 64-Bit Server VM (build 25.181-b13, mixed mode)


# Python binding

Python binding is very slow at the moment (debug WIP) only suitable for
small files.

It is recommended to use a faster binding, dump the contents of the 
syntax tree out and perform the work in python if desired


Installation of pypy3 is recommended to accelerate parsing if using python biding

To install pypy3:

    Follow instructions here: http://pypy.org/download.html

I performed the following on my system (but may not be required in yours)

    $ cd ~/.local/lib && ln -s python3.6 python3.5
    $ cd ~/bin && ln -s /home/$USERID/pypy3-v6.0.0-linux64/bin/pypy3 pypy3
