#!/bin/bash
#set -o xtrace

help() {
    echo " "
    echo "Usage: $0 [-python|-java] [-lisp|-json|-xml] [-d outdir] filename ..."
    echo " "
    echo "Code binding to use is defined by the following:"
    echo "  -python  : to use python binding"
    echo "  -java    : to use java binding (default)"
    echo " "
    echo "Output format is defined by the following:"
    echo "  -lisp    : to generate lisp style output"
    echo "  -json    : to generate JSON output"
    echo "  -xml     : to generate XML output (default)"
    echo " "
    echo " -d outdir : specify output directory"
    echo " -h        : provide this help"
    echo " "
    exit 1
}

if [ "$1" == "" ]; then
    help
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


# set option defaults
pyth_binding=0
ext=xml
outDir="./"
inpFiles=()
while [ "$1" != "" ]; do
    if [ "$1" == "-h" ]; then
        help
    elif [ "$1" == "-python" ]; then
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
        inpFiles+=("$1")
    else
        echo "# Warning: skipping $1, not found/not an option"
    fi
    shift
done

if [ $pyth_binding == 0 ]; then
    # setup paths for java binding
    JAR=$(ls $top_bin/antlr*.jar)
    export CLASSPATH="${top}/java:$JAR:$CLASSPATH"
    echo "CLASSPATH=$CLASSPATH"
else
    # choose pypy3 if available
    pyth=$(which pypy3 2> /dev/null)
    if [ ! -x $pyth ]; then
        pyth=python3
    fi
    echo "python=$pyth"
fi

# process all files
for inpFile in "${inpFiles[@]}"; do
    inpBase=`basename $inpFile`
    postProc="$outDir/post.$inpBase"
    $top_bin/sv_preproc.sh $inpFile $postProc
    if [ $? != 0 ]; then
        echo "Some error occurred preprocessing $inpFile"
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
        $pyth ${top}/python/TestSvVisitor.py $postProc $fileOut
    fi
    if [ $? != 0 ]; then
        echo "Some error occurred during parsing $inpFile"
        exit 1
    fi
    rm -f $postProc
done
