#!/bin/bash
sleep 5
DIR="$(dirname "$0")"
cd "$DIR"
conky -d -b -c "./conky.conf" &