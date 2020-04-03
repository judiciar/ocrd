#!/bin/bash

IFS='
'
filename="$1"
filename=${filename##*/}
filename=${filename%.*}
if [ -f "$filename".sv ]
  then
  rm -f "$filename".sv
  fi
convert -density 300 "$1" -depth 8 -strip -background white -alpha off "$filename"%d.tif
for i in "$filename"*.tif
  do
  # /mnt/ramdisk/textcleaner.sh -e stretch -f 25 -o 20 -t 50 -s 1 -T -p 20 $i out_$i
  python /mnt/ramdisk/rotate.py "$i" "out_$i"
  rm -f $i
  echo "out_$i" >> "$filename".sv
  done
if [ -f "$2".txt ]
  then
  rm -f "$2".txt
  fi
/mnt/ramdisk/bin/tesseract "$filename".sv "$2" -l ron --oem 1 --psm 1 --tessdata-dir /mnt/ramdisk/tessdata
rm -f out_"$filename"*.tif
rm -f "$filename".sv
