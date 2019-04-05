This directory shows some examples of use of the SV grammar (../Sv.g4)
to process few input sv files using the Python binding

    $ make        -> will generate parsing files for Python

    $ make test1  -> will parse a SV file and dump tokens associated to it
    $ make test1g -> will parse a SV file, dump tokens associated to it
                     and show the syntax tree graphically

    $ make arbiter.json -> will generate a JSON dump of arbiter.v syntax tree
    $ make arbiter.lisp -> will generate a LISP style dump of arbiter.v syntax tree

The 2 dump formats above can be easilly imported into any other language tool
The Makefile includes ways to process *.v files (more examples provided in the
TESTS directory)

TestJson.py <filename.json>

   Reads filename.json and dumps it as a dictionary
   just to show an example

TestJsonSyntaxTree.py <filename.json>    

   Reads filename.json and dumps 
      - all non-terminals as comments
      - all terminals verbatim
   The output is verbose but should be equivalent
   to the original input file (token and syntax wise)

   It is a necessary condition that the parsing of this
   file generates identical output if taken though the flow
   again which can be used to sanity check some of the tools
   in the chain.

   This is just another exaple of how to process the 
   syntax tree once imported from a json file
