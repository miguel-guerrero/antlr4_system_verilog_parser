#!/bin/bash
#set -o xtrace

if [ "$1" == "" ]; then
    echo "Usage: $0 [-python|-java] [-lisp|-json|-xml] [-d outdir] filename ..."
    echo " "
    echo " -d outdir : specify output directory"
    echo " "
    echo "Code binding to use is defined by the following:"
    echo "  -python  : to use python binding"
    echo "  -java    : to use java binding - default"
    echo " "
    echo "Output format is defined by the following"
    echo "  -lisp    : to geerate lisp style output"
    echo "  -json    : to geerate JSON output"
    echo "  -xml     : to geerate XML output - default"
    echo " "
    exit 1
fi


# find absolute path to script following symlinks if needed
src="${BASH_SOURCE[0]}"
src_abs="$(cd "$(dirname "$src")" && pwd)/$(basename "$src")"
if [ -s "$src_abs" ]; then  # follow symbolic link
    src_abs=$(dirname $src_abs)/$(readlink $src_abs)
fi
src_path="$(dirname $src_abs)" 

# define vars for top directory
top_bin=$src_path
top="$top_bin/.."
JAR=$(ls $top_bin/antlr*.jar)
export CLASSPATH="${top}/java:$JAR:$CLASSPATH"
echo "CLASSPATH=$CLASSPATH"

# choose pypy3 if available
pyth=$(which pypy3 2> /dev/null)
if [ ! -x $pyth ]; then
    pyth=python3
fi

pyth_binding=0
ext=xml
outDir="./"
while [ "$1" != "" ]; do
    if [ "$1" == "-python" ]; then
        pyth_binding=1
    elif [ "$1" == "-java" ]; then
        pyth_binding=0
    elif [ "$1" == "-lisp" ]; then
        ext=lisp
    elif [ "$1" == "-json" ]; then
        ext=json
    elif [ "$1" == "-xml" ]; then
        ext=xml
    elif [ "$1" == "-d" ]; then
        shift
        outDir="$1"
        if [ ! -d "$outDir" ]; then
            mkdir $outDir
        fi
    elif [ -f "$1" ]; then
        inpBase=`basename $1`
        postProc="$outDir/post.$inpBase"
        $top_bin/sv_preproc.sh $1 $postProc
        if [ $? != 0 ]; then
            echo "Some error occurred preprocessing $1"
            exit 1
        fi
        fileOut="$outDir/$inpBase.$ext"
        if [ $pyth_binding == 0 ]; then
            echo "=== generating $inpBase.$ext (using java binding) ===" 
            if [ "$ext" == "xml" ]; then
                # xml is generated doing first JSON and then converting to XML
                java Testjson $postProc | $top_bin/json2xml_filter.py > $fileOut
            else
                java Test$ext $postProc > $fileOut
            fi
        else
            echo "=== generating $inpBase.$ext (using python binding) ===" 
            if [ "$ext" == "xml" ]; then
                # xml is generated doing first JSON and then converting to XML
                ${top}/python/TestSvVisitor.py $postProc /dev/stdout | $top_bin/json2xml_filter.py > $fileOut
            else
                $pyth ${top}/python/TestSvVisitor.py $postProc $fileOut
            fi
        fi
        if [ $? != 0 ]; then
            echo "Some error occurred during parsing $1"
            exit 1
        fi
        rm -f $postProc
    else
        echo "# Warning: skipping $1, not found/not an option"
    fi
    shift
done
