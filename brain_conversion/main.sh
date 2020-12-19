#!/bin/bash

input_imageDataset=$1
server_path=$2
teraApp=$3
output_path=$4
imageName=$5

BrainRaw="${server_path}/${imageName}_Raw"
BrainTeraFly="${server_path}/${imageName}_TeraFly"
ServerBraindir="${output_path}/TeraFlyImageDatasets"

if [ ! -d ${BrainRaw} ];then
	mkdir -p ${BrainRaw}
fi
if [ -d ${BrainRaw} ];then
	echo "copy ${input_imageDataset} to ${BrainRaw}"
	cp -R ${input_imageDataset}/* ${BrainRaw}
else
	echo "Error: can't make new dir for ${BrainRaw}"
	exit 0
fi

if [ ! -d ${BrainTeraFly} ];then
	mkdir -p ${BrainTeraFly}
fi
if [ ! -d ${BrainTeraFly} ];then
	echo "Error: can't make new dir for ${BrainTeraFly}"
	exit 0
fi

echo "Start the converting process" 
${teraApp} -s="${BrainRaw}" -d="${BrainTeraFly}" --resolutions=012345 --width=256 --height=256 --depth=256 --sfmt="TIFF (series, 2D)" --dfmt="TIFF (tiled, 3D)" --libtiff_rowsperstrip=-1 --halve=max


if [ ! -d "${ServerBraindir}/${imageName}_TeraFly" ];then
	echo "copy converted dataset to server"
	cp -R "${BrainTeraFly}" ${ServerBraindir}/
fi
if [ ! -d "${ServerBraindir}/${imageName}_TeraFly" ];then
	echo "Error: copy failed"
	exit 0
fi
#change permission
if [ -d "${ServerBraindir}/${imageName}_TeraFly" ];then
	echo "change permission of this converted brain"
	chmod -R 755 "${ServerBraindir}/${imageName}_TeraFly"
	chmod 777 "${ServerBraindir}/${imageName}_TeraFly"
else
	echo "Error: cannot find converted dataset"
	exit 0
fi

#compress
compressdir="${output_path}/BackupCenter_ImageDatasets"
if [ ! -f "${compressdir}/${imageName}_TeraFly_seu_allen.tar.gz" ];then
	tar -czvp -f "${compressdir}/${imageName}_TeraFly_seu_allen.tar.gz" "${ServerBraindir}${imageName}_TeraFly"
fi
if [ ! -f "${compressdir}/${imageName}_TeraFly_seu_allen.tar.gz" ];then
	echo "Error: backup failed."
	exit 0
fi