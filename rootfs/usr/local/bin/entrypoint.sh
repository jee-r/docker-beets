#!/bin/bash

if [ ! -d "/config/.config/beets" ]; then
    mkdir -p "/config/.config/beets"
fi

if [ -w /config/ ] && [ ! -f /config/.config/beets/config.yaml ]; then

    cp /etc/default/beets_config.yaml /config/.config/beets/config.yaml
fi

BEETSDIR=/config/.config/beets
export BEETSDIR
FPCALC=/usr/bin/fpcalc
export FPCALC

beets_dir="/config/.config/beets"
beets_config="/config/.config/beets/config.yaml"

if [ "$MODE" == betanin ]; then
    betanin
elif [ "$MODE" == 'inotifywait' ]; then
    inotifywait -m -e create,moved_to --format '%w%f' "$WATCH_DIR" | while IFS= read -r dir_path; do
        /usr/local/bin/beet -c "$beets_config" import -q -i --flat "$dir_path"
    done
elif [ "$MODE" == 'standalone' ]; then
    /usr/local/bin/beet -c "$beets_config"
    exit 0
fi

exit 1
