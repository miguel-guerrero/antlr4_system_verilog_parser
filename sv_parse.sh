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
	$dir/sv_preproc.sh $1 post.$1
        if [ $? == 0 ]; then
            if [ $pyth == 0 ]; then
                echo "=== generating $inpBase.$ext with java" 
                java Test$ext post.$1 > $inpBase.$ext 
            else
                echo "=== generating $inpBase.$ext with python" 
                ${dir}/python/TestSvVisitor.py post.$1 $inpBase.$ext
            fi
        else
            exit 1
        fi
    else
        echo "# Warning: skipping $1, not found"
    fi

    shift
done
