#!/bin/bash

# FOLOSIRE
# ocrfile.sh input_file.pdf nume_fisier_txt [mod_incercare]
#
# nume_fisier_txt se va scrie fara extensia .txt .
# mod_incercare va fi determinat din numele fisierului pdf care 
# contine expresia _TRY2, _TRY3 etc.
# Daca nu contine expresia si nu se precizeaza un mod_incercare valid
# in linia de comanda, se aplica modul default nr. 1.
# Moduri de incercare:
# 1 - rezolutie:200, curatare:threshold(mai rapid), ocr:tessfast(mai rapid)
# 2 - rezolutie:200, curatare:threshold(mai rapid), ocr:tessbest(mai lent)
# 3 - rezolutie:200, curatare:cleantext(mai lent), ocr:tessbest
# 4 - rezolutie:300, curatare:threshold, ocr:tessbest
# 5 - rezolutie:300, curatare:cleantext, ocr:tessbest

IFS='
'
filename="$1"
filename=${filename##*/}
filename=${filename%.*}
if [[ $filename =~ ._TRY[1-5]$ ]]
  then
    try=${filename: -1}
  else
    try="1"
  fi
if [[ $3 =~ ^[1-5]$ ]]
  then
    try=$3
  fi
if [ $try = "1" ] || [ $try = "2" ] || [ $try = "3" ]
  then
    rezolutie=200
  else
    rezolutie=300
  fi
if [ $try = "1" ] || [ $try = "2" ] || [ $try = "4" ]
  then
    cleanmode="threshold"
  else
    cleanmode="cleantext"
  fi
if [ $try = "1" ]
  then
    tessmode="/home/localadmin/ocr/tessfast"
  else
    tessmode="/home/localadmin/ocr/tessdata"
  fi

if [ -f "$filename".sv ]
  then
    rm -f "$filename".sv
  fi

echo "Try=$try Rezolutie=$rezolutie Curatare=$cleanmode Tesseract mode=$tessmode"
convert -density $rezolutie "$1" -depth 8 -strip -background white -alpha off "$filename"%d.tif
for i in "$filename"*.tif
  do
    python /home/localadmin/ocr/rotate.py "$i" "out_$i" $cleanmode
    rm -f $i
    echo "out_$i" >> "$filename".sv
  done
if [ -f "$2".txt ]
  then
    rm -f "$2".txt
  fi
tesseract "$filename".sv "$2" -l ron --oem 1 --psm 1 --dpi $rezolutie --tessdata-dir "$tessmode"
rm -f out_"$filename"*.tif
rm -f "$filename".sv

# Script-ul extrage in variabila $filename din cale (path) numele de fisier fara extensie. Apoi, aplicatia
# convert extrage fiecare pagina din fisierul pdf si o transforma in tiff grayscale 8-bit, dandu-i o numerotare cu
# respectarea ordinii initiale a paginilor. Tiff este formatul intern al Tesseract si de aceea l-am preferat si noi.
# Variabila $rezolutie este folosita de aplicatia convert si este util - desi nu necesar - sa se potriveasca cu rezolutia in
# dpi la care a fost scanat fisierul pdf (200 dpi). Daca apar erori la urcarea in Ecris, script-ul este pus sa mai
# incerce inclusiv la rezolutia 300 dpi.
# Pentru fiecare fisier tif, se ruleaza script-ul rotate.py, care curata si indreapta imaginea, salvand rezultatul sub forma
# out_"$filename"x.tif. Script-ul rotate.py nu face diferenta intre orientarea 0 grade si 180 grade, insa Tesseract poate in
# aproape toate cazurile. Apoi, script-ul creeaza un fisier text cu extensia .sv, in care salveaza numele fiecarui fisier
# out_"$filename"x.tif. Fisierul .sv este folosit de aplicatia OCR tesseract, care extrage din el lista cu fisierele imagine
# pe care le are de prelucrat intr-un singur lot. Tesseract produce un fisier text final cu numele $filename.txt, in care
# este adunat rezultatul tuturor imaginilor din fisierul .sv . La sfarsit, sunt sterse fisierele intermediare .tif si .sv .
# Script-ul foloseste Shell script, care este optimizat pentru operatiuni cu fisierele si lansarea de aplicatii, precum si
# Python, care este potrivit pentru prelucrari matematice de imagine.
