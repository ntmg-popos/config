#!/bin/bash

# Get list of profiles
PROFILES=($(powerprofilesctl list | grep -E "^(\* |  )[a-z-]" | cut -d: -f1 | sed 's/^\* //;s/^  //'))
CURRENT=$(powerprofilesctl get)
LEN=${#PROFILES[@]}

# Find index of current profile
for i in "${!PROFILES[@]}"; do
   if [[ "${PROFILES[$i]}" == "$CURRENT" ]]; then
       INDEX=$i
       break
   fi
done

if [[ "$1" == "up" ]]; then
    NEXT=$(( (INDEX + 1) % LEN ))
else
    NEXT=$(( (INDEX - 1 + LEN) % LEN ))
fi

powerprofilesctl set "${PROFILES[$NEXT]}"
