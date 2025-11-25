#!/bin/bash
sleep 5
DIR="$(dirname "$0")"
cd "$DIR"

cava -p ./cava_config &
conky -d -b -c "./conky.conf" &
conky -d -b -c "./player.conf" &