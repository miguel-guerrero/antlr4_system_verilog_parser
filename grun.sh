#!/bin/sh
dir=`dirname $0`
export CLASSPATH=".:$dir/bin/antlr-4.7.1-complete.jar:$CLASSPATH"
java org.antlr.v4.gui.TestRig $*
