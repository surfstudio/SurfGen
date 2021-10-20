#! /bin/bash

pathToDTOFolder=$1
nameOfTheUmbrella=$2

fileNames=()

# remove old umbrella file
# to exclude it from file reading (the simpliest way)

rm -f $nameOfTheUmbrella

# Read all files from directory with DTO models
# and save their names (with extensions) into `fileNames` array

for file in ${pathToDTOFolder}/*
do
    nameAndExt=${file##*/}
    fileNames+=($nameAndExt)
done

# write new umbrella

for value in ${fileNames[@]}
do
    name=${value%.*}
    echo "export '$value';" >> $nameOfTheUmbrella
done

# for value in "${fileNames[@]}"
# do
#      echo $value
# done