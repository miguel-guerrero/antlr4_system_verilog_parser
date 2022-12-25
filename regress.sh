#!/bin/bash

echo "Running regression with java binding"
rm -rf  out_java 2> /dev/null
time ./sv_parse.sh -d out_java -java -lisp ./CORPUS/*.sv 

echo "Running regression with python binding"
rm -rf  out_python 2> /dev/null
time ./sv_parse.sh -d out_python -python -lisp ./CORPUS/*.sv 

diff -r out_java out_python
