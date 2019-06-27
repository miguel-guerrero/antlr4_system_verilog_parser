#!/bin/bash

if [ "$1" == "" ]; then
    echo "Usage: $0 [-python|-java] [-lisp|-json|-xml] filename ..."
    echo " "
    echo "Code binding to use is defined by the following:"
    echo "  -python : to use python binding"
    echo "  -java   : to use java binding - default"
    echo "Output format is defined by the following"
    echo "  -lisp   : to geerate lisp style output"
    echo "  -json   : to geerate JSON output"
    echo "  -xml    : to geerate XML output - default"
    exit 1
fi

dir=`dirname $0`
export CLASSPATH="${dir}/java:${dir}/bin/antlr-4.7.1-complete.jar:${CLASSPATH}" 

pyth_binding=0
ext=json
xml=1
while [ "$1" != "" ]; do
    if [ "$1" == "-python" ]; then
        pyth_binding=1
    elif [ "$1" == "-json" ]; then
        ext=json
        xml=0
    elif [ "$1" == "-xml" ]; then
        ext=json
        xml=1
    elif [ "$1" == "-lisp" ]; then
        ext=lisp
    elif [ -f "$1" ]; then
        inpBase=`basename $1`
        $dir/sv_preproc.sh $1 post.$1
        if [ $? == 0 ]; then
            if [ $pyth_binding == 0 ]; then
                echo "=== generating $inpBase.$ext with java binding ===" 
                java Test$ext post.$1 > $inpBase.$ext 
            else
                echo "=== generating $inpBase.$ext with python binding ===" 
                ${dir}/python/TestSvVisitor.py post.$1 $inpBase.$ext
            fi
            if [ $ext == 'json' ] && [ $xml == 1 ]; then
                cat $inpBase.$ext | $dir/bin/j2x_filter.py > $inpBase.xml
            fi
        else
            exit 1
        fi
    else
        echo "# Warning: skipping $1, not found"
    fi

    shift
done
