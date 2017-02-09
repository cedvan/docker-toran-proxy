#!/bin/bash

# If any user provided scripts are found source them
LOCALD="$DATA_DIRECTORY/scripts"
FILES="$( [ -e $LOCALD ] && find $LOCALD -type f ! -name '\.*' -a -name '*.sh')"
if [ -n "$FILES" ]; then
  echo "Running local customization scripts..."
  for file in $FILES; do
    echo "-> $file"
    source $file
  done
fi
