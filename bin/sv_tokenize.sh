#!/bin/bash
bin_dir=$(dirname $0)
abs_file_path=$(readlink -f $1)

pushd $bin_dir/../java
#this must be run from the directory where all Sv generated files are
../grun.sh Sv source_text -tokens $abs_file_path
popd

