#!/bin/bash
DEFAULT_MIRROR_URL="rsync://repos.fyralabs.com/repo/"
# This script is for mirroring repos.fyralabs.com to a local directory.

# Default mirror directory: directory of script / repo

: ${MIRROR_DIR:=$(dirname $0)/repo}
: ${MIRROR_URL:=$DEFAULT_MIRROR_URL}

echo "Mirroring $MIRROR_URL to $MIRROR_DIR"

rsync-ssl -avPzr $RSYNC_EXTRA_ARGS --delete $MIRROR_URL $MIRROR_DIR
