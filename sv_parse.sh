#!/bin/bash

if [ "$1" == "" ]; then
    echo "Usage: $0 [-python] [-lisp] filename ..."
    exit 1
fi

dir=`dirname $0`
export CLASSPATH="${dir}/java:${dir}/bin/antlr-4.7.1-complete.jar:${CLASSPATH}" 

pyth=0
ext=json
while [ "$1" != "" ]; do
    if [ "$1" == "-python" ]; then
        pyth=1
    elif [ "$1" == "-lisp" ]; then
        ext=lisp
    elif [ -f "$1" ]; then
        inpBase=`basename $1`

        echo "=== preprocessing $1 into $inpBase.post" 
        vppreproc $1 --simple > $inpBase.post
        #iverilog -E $1 -o $inpBase.post
        if [ $? == 0 ]; then
            if [ $pyth == 0 ]; then
                echo "=== generating $inpBase.$ext with java" 
                java Test$ext $inpBase.post > $inpBase.$ext 
            else
                echo "=== generating $inpBase.$ext with python" 
                ${dir}/python/TestSvVisitor.py $inpBase.post $inpBase.$ext
            fi
        else
            echo "# Error pre-processing $1, skipping it"
        fi
    else
        echo "# Warning: skipping $1, not found"
    fi

    shift
done
