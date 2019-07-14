#!/bin/sh
dir=`dirname $0`
jar=$(ls $dir/bin/antlr*.jar)
export CLASSPATH=".:$jar:$CLASSPATH"
java org.antlr.v4.gui.TestRig $*
