#!/bin/bash

# Simple wrapper script to mirror multiple subrepos

export RELEASE=41
# export PARALLEL=1

: ${PARALLEL:=0}

mirror() {
    local repo=$1
    export MIRROR_SUBDIR=$repo
    mkdir -p $PWD/repo/$repo
    export MIRROR_DIR=$PWD/repo/$repo

    ./mirror.sh || return 1

}

usage() {
    echo "Usage: $0 <repo> [<repo> ...]"
    echo "Mirror the specified repositories"
    exit 1
}

if [ $# -eq 0 ]; then
    usage
fi

# if --help or -h
for arg in "$@"; do
    if [ "$arg" = "--help" ] || [ "$arg" = "-h" ]; then
        usage
    fi
done

# iterate through all args
for repo in "$@"; do
    mirror "$repo"
done