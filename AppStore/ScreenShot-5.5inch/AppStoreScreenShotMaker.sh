#!/bin/sh

# cf. http://blog.haranicle.net/itunes-connect-screenshot/
 
# settings ==========
 
# src file name
#fileNamePrefix="ScreenShotFileNameFor5.5inch"
fileNamePrefix="ss"
 
# dest directory name
destDir="./dest/"
destDir4_7="./dest/4.7inch/"
destDir4="./dest/4inch/"
 
# ====================
 
# create dest directory
mkdir $destDir
mkdir $destDir4_7
mkdir $destDir4
 
# loop for 4.7inch
echo "4.7inch"
for i in 1 2 3 4 5
do
  destFilePath=$destDir4_7$fileNamePrefix$i".png"
  echo $destFilePath
  convert -resize x1334 $fileNamePrefix$i".png" $destFilePath
done
 
# loop for 4inch
echo "4inch"
for i in 1 2 3 4 5
do
  destFilePath=$destDir4$fileNamePrefix$i".png"
  echo $destFilePath
  convert -resize 640x $fileNamePrefix$i".png" $destFilePath
  convert -crop 640x1136+0+0 $destFilePath $destFilePath
done
