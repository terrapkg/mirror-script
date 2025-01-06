# Terra Mirror Scripts

This repository contains scripts to mirror Terra RPM repositories to a local directory.

## Requirements

- rsync
- A good internet connection
- Some disk space (100GB or more)
- Some time
- A cron job to run this script regularly (preferrably every 5 minutes)

## Usage

```bash
export MIRROR_DIR=/path/to/mirror # The default mirror directory is $CWD/repo
./mirror.sh
```

### Usage as a container

In case you'd like to run this script inside a container, you can use the image provided at `ghcr.io/terrapkg/mirror-scripts:main`. The image is based on RHEL UBI9 and contains the necessary dependencies to run the script.

You can use either `podman` or `docker` to run the container. The following example uses `podman`:

```bash
podman run --rm -it -v /path/to/mirror:/data ghcr.io/terrapkg/mirror-script:main
```

### Configuration

The script can be configured using environment variables:

- `MIRROR_DIR`: The directory to mirror the repositories to. Default: `$CWD/repo`, or `/data` if running inside a container.
- `RSYNC`: The rsync binary to use. Default: `rsync-ssl`
- `PARALLEL`: Toggle parallel downloads. (Currently only applicable for rsync.) Default: `0` (off) due to the jankiness of this code path. This might be useful to enable for an initial sync, disabling it after. Incremental syncs using this method may be slower than normal. Again, please don't use it outside of initally setting up your mirror.
- `MAX_THREADS`: The maximum number of threads to use. Default: output of `nproc` (`$(nproc)`).
- `USE_RCLONE`: Use Rclone instead of rsync, mirroring from the HTTP server. Default: `0` (off). The script mirrors from the Fyra Labs rsync server by default.
- `SYNC_SOURCES`: Whether to sync source repositories. Default: `1` (on).
- `MIRROR_SUBDIR`: Optionally only mirror a specific subdirectory of the repository. Default: `''` (off).
