#!/bin/bash

beets_dir="/config/beets"
beets_config="/config/config.yaml"
#watch_dir="/torrents/seed/Music"

BEETSDIR=/config
export BEETSDIR
FPCALC=/usr/bin/fpcalc
export FPCALC

inotifywait -m -e create,moved_to --format '%w%f' "$WATCH_DIR" | while IFS= read -r dir_path; do
    /usr/local/bin/beet -c "$beets_config" import -q -i --flat "$dir_path"
done
