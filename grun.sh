#!/bin/sh
export CLASSPATH=".:/usr/local/lib/antlr-4.7.1-complete.jar:$CLASSPATH"
java org.antlr.v4.gui.TestRig $*
