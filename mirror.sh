#!/bin/bash
DEFAULT_MIRROR_URL="rsync://repos.fyralabs.com/repo/"
# This script is for mirroring repos.fyralabs.com to a local directory.

# Default mirror directory: directory of script / repo
: ${MIRROR_DIR:=$(dirname $0)/repo}
: ${MIRROR_URL:=$DEFAULT_MIRROR_URL}

# rsync binary to use
: ${RSYNC:=rsync-ssl}

# use parallel rsync?
: ${PARALLEL:=0}

MAX_THREADS=$(nproc)

list_all_files() {
    # echo "Fetching file list"
    # clean up all the folders too, I guess
    $RSYNC -rt $MIRROR_URL | awk '{print $5}' | grep -v '/$' | sort | uniq
}

# now, parallelize the rsync using GNU parallel

parallel_rsync() {
    echo "Starting parallel rsync with $MAX_THREADS threads"
    
    list_all_files | parallel --no-notice -j $MAX_THREADS \
        $RSYNC \
        -avPzdR --mkpath \
        $RSYNC_EXTRA_ARGS \
        --delete \
        $MIRROR_URL{} \
        $MIRROR_DIR/{}

}

echo "Mirroring $MIRROR_URL to $MIRROR_DIR"

# rsync-ssl -avPzr $RSYNC_EXTRA_ARGS --delete $MIRROR_URL $MIRROR_DIR

if [ $PARALLEL -eq 1 ]; then
    parallel_rsync
else
    $RSYNC -avPzr $RSYNC_EXTRA_ARGS --delete $MIRROR_URL $MIRROR_DIR
fi
