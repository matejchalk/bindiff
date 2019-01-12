#!/bin/bash

script=$0
bunchsize=
hexasciisep=
awkfile="bindiff.awk"

function usage {
    echo "usage: ${script} [ -b BUNCHSIZE ] [ -s HEXASCIISEP ] OLD NEW"
}

function dump {
    echo "od -An -tx1c -w1 -v $1 | paste -d '' - -";
}

while getopts "hb:s:" opt; do
    case $opt in
        h)
            usage
            exit 0
            ;;
        b)
            bunchsize=${OPTARG}
            ;;
        s)
            hexasciisep=${OPTARG}
            ;;
        *)
            usage
            exit 1
            ;;
    esac
done

shift $((OPTIND-1))

if [ "$#" -ne 2 ]; then
    usage
    exit 1
fi

if ! [ -f "$1" ]; then
    echo "no file \"$1\""
    exit 1
fi

if ! [ -f "$2" ]; then
    echo "no file \"$2\""
    exit 1
fi

if ! [ -f "$awkfile" ]; then
    echo "missing GNU Awk file \"$awkfile\""
    exit 1
fi

diff -y <(eval `dump $1`) <(eval `dump $2`) | \
gawk -f bindiff.awk -v bunchsize=$bunchsize -v hexasciisep=$hexasciisep
