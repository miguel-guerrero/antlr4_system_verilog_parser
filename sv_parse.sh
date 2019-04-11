#!/bin/bash

if [ "$1" == "" ]; then
    echo "Usage: $0 filename ..."
    exit 1
fi

dir=`dirname $0`
export CLASSPATH="${dir}/java:/usr/local/lib/antlr-4.7.1-complete.jar:${CLASSPATH}" 

while [ "$1" != "" ]; do
    if [ -f "$1" ]; then
        inpBase=`basename $1`

        vppreproc $1 --simple > $inpBase.post
        if [ $? == 0 ]; then
            echo "=== generating $inpBase.json" 
            java TestJson $inpBase.post > $inpBase.json 
        else
            echo "# Error pre-processing $1, skipping it"
        fi
    else
        echo "# Warning: skipping $1, not found"
    fi

    shift
done
