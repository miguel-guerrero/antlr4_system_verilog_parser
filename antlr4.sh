#!/bin/sh
DIR=`dirname $0`
JAR=$(ls $DIR/bin/antlr*.jar)
export CLASSPATH=".:$JAR:$CLASSPATH"
java -jar $JAR $*
