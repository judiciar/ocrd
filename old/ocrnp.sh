#!/bin/bash

listafoldereocr=("/mnt/cagl/OCR/" "/mnt/trgl/OCR/" "/mnt/jdgl/OCR/" "/mnt/jdtecuci/OCR/" "/mnt/jdtgb/OCR/" "/mnt/jdliesti/OCR/" "/mnt/br/TrBraila/OCR/" "/mnt/br/JdBraila/OCR/" "/mnt/jdfaurei/OCR/" "/mnt/trvn/OCR/" "/mnt/jdfocsani/OCR/" "/mnt/jdadjud/OCR/" "/mnt/jdpanciu/OCR/")
listafolderepdf=("/mnt/cagl/Splitate/" "/mnt/trgl/Splitate/" "/mnt/jdgl/Splitate/" "/mnt/jdtecuci/Splitate/" "/mnt/jdtgb/Splitate/" "/mnt/jdliesti/Splitate/" "/mnt/br/TrBraila/Splitate/" "/mnt/br/JdBraila/Splitate/" "/mnt/jdfaurei/Splitate/" "/mnt/trvn/Splitate/" "/mnt/jdfocsani/Splitate/" "/mnt/jdadjud/Splitate/" "/mnt/jdpanciu/Splitate/")
listafolderetxt=("/mnt/cagl/TXT/" "/mnt/trgl/TXT/" "/mnt/jdgl/TXT/" "/mnt/jdtecuci/TXT/" "/mnt/jdtgb/TXT/" "/mnt/jdliesti/TXT" "/mnt/br/TrBraila/TXT/" "/mnt/br/JdBraila/TXT/" "/mnt/jdfaurei/TXT/" "/mnt/trvn/TXT/" "/mnt/jdfocsani/TXT/" "/mnt/jdadjud/TXT/" "/mnt/jdpanciu/TXT/")

cd /home/localadmin/ocr/temp/
IFS=$'
'

for ((i=0;i<${#listafoldereocr[@]};i++))
 do
  for file in $(find ${listafoldereocr[$i]} -type f -name "*_TRYNEXT.pdf")
    do
    ocrbest.sh $file ${file%pdf}
    mv -f -v $file ${listafolderepdf[$i]}
    mv -f ${file%pdf}txt ${listafolderetxt[$i]}
    done
  for file in $(find ${listafoldereocr[$i]} -type f -name "*.pdf" -not -name "*_TRYNEXT.pdf")
    do
    ocrfast.sh $file ${file%pdf}
    mv -f -v $file ${listafolderepdf[$i]}
    mv -f ${file%pdf}txt ${listafolderetxt[$i]}
    done
 done
