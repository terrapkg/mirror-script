# Terra Mirror Scripts

This repository contains scripts to mirror Terra RPM repositories to a local directory.

## Requirements

- rsync
- A good internet connection
- Some disk space (100GB or more)
- Some time
- (Optional) A cron job to run this script regularly (preferrably hourly)

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
- `PARALLEL`: Toggle parallel downloads. Default: `0` (off) due to the incomplete multi-threaded rsync script.
- `MAX_THREADS`: The maximum number of threads to use. Default: output of `nproc` (`$(nproc)`).
- `USE_RSYNC`: Use rsync instead of Rclone. Default: `0` (off). The script mirrors from the HTTP server directly using Rclone by default.
