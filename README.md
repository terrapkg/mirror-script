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
