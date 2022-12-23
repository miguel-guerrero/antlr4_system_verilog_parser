#!/bin/bash

# --user is optional, remove it if you want to install for all users
INSOPT="--user"

echo "--- Installing libraries for python3"
python3 -mpip install -r requirements.txt $INSOPT

pypy3=$(which pypy3 2> /dev/null)
if [ -x "$pypy3" ]; then
    echo "--- Installing libraries for pypy3"
    $pypy3 -mpip install -r requirements.txt $INSOPT
fi

# build parser collaterals
echo "--- building parser collaterals"
make all

# check if iverilog is present in the system
echo "--- checking for iverilog (used as preprocessor)"
ivl=$(which iverilog 2> /dev/null)
if [ ! -x "$ivl" ]; then
    echo "This package assumes Icarus Verilog (iverilog) is in your path"
    echo "to be used as a pre-processor"
    echo "Follow instructions in:"
    echo "https://iverilog.fandom.com/wiki/Installation_Guide "
    echo "for iverilog installation"
    exit 1
else
    echo "iverilog found in the path!"
fi
