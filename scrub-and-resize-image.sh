#!/bin/bash
set -euo pipefail

maxLongSide=${MAX_LONG:-800}

image=${1:?first param must be path to image}
outFile=$(mktemp)

echo "Resizing to $maxLongSide max on the long side"
convert $image -resize "${maxLongSide}>" $outFile

echo "Scrubbing GPS metadata"
# thanks https://askubuntu.com/a/237892/234373
exiftool -gps:all= -xmp:geotag= $outFile

mv $outFile $image
