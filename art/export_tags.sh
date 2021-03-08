#!/bin/bash
aseprite="D:/Program Files/Aseprite/Aseprite.exe"
fileName=""
excludeFiles=()
for file in ./ase/*.aseprite ; do
  fileName="${file##*/}"
  fileName="${fileName%.*}"
  if [[ ! "${excludeFiles[@]}" =~ "${fileName}" ]]; then
  "$aseprite" -b $file --save-as ./export_tiles/${fileName}{tag}0.png
  fi
done
