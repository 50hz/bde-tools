#!/bin/bash

# This bash script allows Cygwin users run the Windows version of waf to build
# a project using Visual Studio.  The Waf Based Build System in bde-tools does
# not support the Cygwin platform, but it does support the Windows command line
# prompt and Visual Studio.  However, a lot of users prefer to use the Cygwin
# environment on Windows.
#
# The script works by invoking the Windows version of Python passing in the
# Windows path to waf followed by all of the command line arguments.
#
# To use, export the WIN_PYTHON environment variable to point to the *Cygwin*
# path of the *Windows* version of Python.
#
# For example, if the Windows version of CPython is installed to
# C:\Python27\python, then you can use the following command to set up the
# required WIN_PYTHON environment variable:
#
#   $ export WIN_PYTHON=/cygdrive/c/Python27/python
#   $ cygwaf.sh <waf command>  # start using cygwaf.sh as you would waf

case "$(uname)" in
    CYGWIN*) cygwin=1 ;;
    *) cygwin=0 ;;
esac

if [[ $cygwin == 0 ]]; then
    echo "This script is designed to work in only Cygwin." 1>&2
    exit 1
fi

if [[ -z $WIN_PYTHON ]]; then
    echo "Set the WIN_PYTHON environment variable to the Cygwin path of  " 1>&2
    echo "the *Windows* Python executable (not the python "
    echo "version that comes with Cygwin)." 1>&2
    echo "Ex: export WIN_PYTHON=/cygdrive/c/Python27/python" 1>&2
    exit 1
fi

# Get the base directory in which this script reside.
# This solution was taken from
# http://stackoverflow.com/questions/59895/
# can-a-bash-script-tell-what-directory-its-stored-in

source="${BASH_SOURCE[0]}"
while [ -h "$source" ]; do
  dir="$(cd -P "$(dirname "$source")" && pwd)"
  source="$(readlink "$source")"
  [[ $source != /* ]] && source="$dir/$source"
done
base_dir="$(cd -P "$(dirname "$source")" && pwd)"

$WIN_PYTHON  "$(cygpath -m "$base_dir/waf")" "$@"
