#!/bin/bash

if [ "$1" == "" ]; then
    echo "Usage: $0 [-python|-java] [-lisp|-json|-xml] filename ..."
    echo " "
    echo "Code binding to use is defined by the following:"
    echo "  -python : to use python binding"
    echo "  -java   : to use java binding - default"
    echo " "
    echo "Output format is defined by the following"
    echo "  -lisp   : to geerate lisp style output"
    echo "  -json   : to geerate JSON output"
    echo "  -xml    : to geerate XML output - default"
    exit 1
fi

dir=`dirname $0`
export CLASSPATH="${dir}/java:${dir}/bin/antlr-4.7.1-complete.jar:${CLASSPATH}" 

pyth_binding=0
ext=xml
while [ "$1" != "" ]; do
    if [ "$1" == "-python" ]; then
        pyth_binding=1
    elif [ "$1" == "-json" ]; then
        ext=json
    elif [ "$1" == "-xml" ]; then
        ext=xml
    elif [ "$1" == "-lisp" ]; then
        ext=lisp
    elif [ -f "$1" ]; then
        inpBase=`basename $1`
        $dir/sv_preproc.sh $1 post.$1
        if [ $? == 0 ]; then
            if [ $pyth_binding == 0 ]; then
                echo "=== generating $inpBase.$ext with java binding ===" 
                if [ $ext == xml ]; then
                    java Testjson post.$1 | $dir/bin/j2x_filter.py > $inpBase.$ext 
                else
                    java Test$ext post.$1 > $inpBase.$ext 
                fi
            else
                echo "=== generating $inpBase.$ext with python binding ===" 
                if [ $ext == xml ]; then
                    ${dir}/python/TestSvVisitor.py post.$1 /dev/stdout | \
                        ${dir}/bin/j2x_filter.py > $inpBase.xml
                else
                    ${dir}/python/TestSvVisitor.py post.$1 $inpBase.$ext
                fi
            fi
        else
            exit 1
        fi
    else
        echo "# Warning: skipping $1, not found"
    fi

    shift
done
