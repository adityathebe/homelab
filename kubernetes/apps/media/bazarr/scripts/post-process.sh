#!/usr/bin/env bash

echo "Cleaning subtitles for $1 ..."
python3 /add-ons/subcleaner/subcleaner.py "$1" -s