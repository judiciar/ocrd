#!/bin/bash

listafoldereocr=("/mnt/cagl/OCR/") # "/mnt/trgl/OCR/" "/mnt/jdgl/OCR/" "/mnt/jdtecuci/OCR/" "/mnt/jdtgb/OCR/" "/mnt/jdliesti/OCR/" "/mnt/trvn/OCR/" "/mnt/jdfocsani/OCR/" "/mnt/jdpanciu/OCR/" "/mnt/jdadjud/OCR/" "/mnt/br/TrBraila/OCR/" "/mnt/br/JdBraila/OCR/" "/mnt/jdfaurei/OCR/")
listafolderepdf=("/mnt/cagl/Splitate/" "/mnt/trgl/Splitate/" "/mnt/jdgl/Splitate/" "/mnt/jdtecuci/Splitate/" "/mnt/jdtgb/Splitate/" "/mnt/jdliesti/Splitate/" "/mnt/trvn/Splitate/" "/mnt/jdfocsani/Splitate/" "/mnt/jdpanciu/Splitate/" "/mnt/jdadjud/Splitate/" "/mnt/br/TrBraila/Splitate/" "/mnt/br/JdBraila/Splitate/" "/mnt/jdfaurei/Splitate/")
listafolderetxt=("/mnt/cagl/TXT/" "/mnt/trgl/TXT/" "/mnt/jdgl/TXT/" "/mnt/jdtecuci/TXT/" "/mnt/jdtgb/TXT/" "/mnt/jdliesti/TXT/" "/mnt/trvn/TXT/" "/mnt/jdfocsani/TXT/" "/mnt/jdpanciu/TXT/" "/mnt/jdadjud/TXT/" "/mnt/br/TrBraila/TXT/" "/mnt/br/JdBraila/TXT/" "/mnt/jdfaurei/TXT/")

cd /home/localadmin/ocr/temp/
export OMP_THREAD_LIMIT=1
IFS=$'
'

for ((i=0;i<${#listafoldereocr[@]};i++))
  do
    find ${listafoldereocr[$i]} -type f -name "*.pdf" | parallel --progress "/home/localadmin/ocr/ocrfile.sh {1} {1/.}; mv -f -v {1} ${listafolderepdf[$i]}; mv -f {1/.}.txt ${listafolderetxt[$i]}" :::: -
  done

# Script-ul OCR citatii proceseaza fiecare folder din vectorul (array) listafoldereocr, cautand fisiere cu extensia .pdf.
# Cautarea este case-insensitive (accepta si extensii .PDF, .Pdf etc.). 
# Script-ul preda apoi fisierele aplicatiei GNU parallel. GNU parallel prelucreaza cate un fisier pdf pe fiecare core al
# procesorului in paralel, obtinand astfel viteze foarte mari. Aplicatia lasa cateva core-uri libere pentru alte programe
# (-j-x). Pentru fiecare fisier, GNU parallel ruleaza script-ul ocrfile.sh, care curata si indreapta imaginea si apoi
# livreaza rezultatul aplicatiei OCR tesseract. La sfarsit, este returnat un fisier text cu rezultatul OCR.
# Script-ul muta fisierul text in folder-ul corespunzator (cu acelasi indice) din vectorul (array) listafolderetxt, iar 
# fisierul pdf este mutat in folder-ul corespunzator din vectorul listafolderepdf. 
# Script-ul si ocrfile.sh folosesc Shell script, care este optimizat pentru operatiuni cu fisierele si lansarea de
# aplicatii, precum si Python, care este potrivit pentru prelucrari matematice de imagine.
