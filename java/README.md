This directory shows some examples of use of the SV grammar (../Sv.g4)
to process few input sv files

    $ make        -> will generate parsing files for Java

    $ make test1  -> will parse a SV file and dump tokens associated to it
    $ make test1g -> will parse a SV file, dump tokens associated to it
                     and show the syntax tree graphically

    $ make CORPUS/ram_mux.json -> will generate a JSON dump of ram_mux.sv syntax tree
    $ make CORPUS/ram_mux.lisp -> will generate a LISP style dump of ram_mux.sv syntax tree

The 2 dump formats above can be easilly imported into any other language tool
The Makefile includes ways to process *.v files (more examples provided in this
directory)

    TestJson.java -> Used to generate a JSON style dump of the syntax tree
    TestLisp.java -> Used to generate a LISP style dump of the syntax tree

see ../python for example utilites on how to process these formats from
python
