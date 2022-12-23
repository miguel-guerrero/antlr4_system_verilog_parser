#!/bin/bash

if [ "$1" == "" ] || [ "$2" == "" ]; then
    echo "Preprocess a SystemVerilog file"
    echo "Usage: $0 src dst"
    exit 1
fi
src=$1
dst=$2

ivl=$(which iverilog 2> /dev/null)

if [ -f "$src" ]; then
    if [ -x "$ivl" ]; then
        $ivl -I. -I$(dirname $src) -E -o $dst $src
    else
        echo "ERROR: No preprocessor found in path (checked for iverilog)"
        echo "please install iverilog or modify $0 to point to yours"
        exit 1
    fi
    if [ $? != 0 ]; then
        echo "# Error pre-processing $src, skipping it"
        exit 1
    fi
else
    echo "# Warning: skipping $src, not found"
    exit 1
fi
