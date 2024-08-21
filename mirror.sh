#!/bin/bash
DEFAULT_MIRROR_URL="rsync://repos.fyralabs.com/repo/"
DEFAULT_HTTP_MIRROR="https://repos.fyralabs.com"
: ${USE_RCLONE=0}

# This script is for mirroring repos.fyralabs.com to a local directory.

# Default mirror directory: directory of script / repo
: ${MIRROR_DIR:=$(dirname $0)/repo}
if [ "$USE_RCLONE" -eq 1 ]; then
    : ${MIRROR_URL=$DEFAULT_HTTP_MIRROR}
else
    : ${MIRROR_URL:=$DEFAULT_MIRROR_URL}
fi

# rsync binary to use
: ${RSYNC:=rsync-ssl}

# use parallel rsync?
: ${PARALLEL:=0}

: ${MAX_THREADS:=$(nproc)}

: ${SYNC_SOURCES:=1}
if [ "$SYNC_SOURCES" -eq 0 ]; then
    RSYNC_OPTS+=("--exclude=*-source/")
    RCLONE_OPTS+=("--exclude=*-source/")
fi

list_all_files() {
    # echo "Fetching file list"
    # clean up all the folders too, I guess; ^d excludes directories
    $RSYNC "${RSYNC_OPTS[@]}" -rt $MIRROR_URL | grep -v '^d' | awk '{print $5}' | grep -v '/$' | sort | uniq
}

# now, parallelize the rsync using GNU parallel

parallel_rsync() {
    echo "Starting parallel rsync with $MAX_THREADS threads"

    list_all_files | xargs -P $MAX_THREADS -I '{}' \
        $RSYNC \
        -avPz --mkpath \
        "${RSYNC_OPTS[@]}" \
        --delete \
        $MIRROR_URL{} \
        $MIRROR_DIR/{}

    # We run rsync again just to get rid of any files that are deleted
    $RSYNC -avPzr "${RSYNC_OPTS[@]}" --delete $MIRROR_URL $MIRROR_DIR
}

echo "Mirroring $MIRROR_URL to $MIRROR_DIR"

# rsync-ssl -avPzr $RSYNC_EXTRA_ARGS --delete $MIRROR_URL $MIRROR_DIR

if [ "$USE_RCLONE" -eq 0 ]; then
    echo "Using rsync"
    if [ $PARALLEL -eq 1 ]; then
        parallel_rsync
    else
        $RSYNC -avPzr "${RSYNC_OPTS[@]}" --delete $MIRROR_URL $MIRROR_DIR
    fi

else
    echo "Using Rclone"

    rclone sync \
        --delete-after \
        --track-renames \
        --delete-excluded \
        --fast-list \
        --transfers $MAX_THREADS \
        --stats 5s \
        --stats-one-line \
        -v "${RCLONE_OPTS[@]}" \
        --http-url $DEFAULT_HTTP_MIRROR \
        :http:/ $MIRROR_DIR
fi
