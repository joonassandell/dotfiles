#!/bin/bash

DIR=$(dirname "$0")
cd "$DIR"

. scripts/functions.sh

# Sync installed packages, extensions etc. back to the dotfiles
find . -mindepth 2 -name "update.sh" | sort | while read update; do
  ./$update
done

success_final "Finished updating dotfiles!"
