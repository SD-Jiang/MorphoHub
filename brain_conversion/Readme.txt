MorphoHub: Petabyte-Scale Multi-Morphometry of Single Neurons for Whole Brains
Designed by Shengdian Jiang, 2020-02-12
Email: allencenter@seu.edu.cn

#This script is used to convert 2D image datasets into TeraFly format.
#Workflow: 
	#1. for the purpose of speeding up the whole processing and the safe of the image datasets, 2D image datasets will firstly copy to a SSD server.
	#2. make a new path for saving the converted datasets at SSD server.
	#3. get TeraConverter from https://github.com/Vaa3D/Vaa3D_Wiki/wiki/TeraConverter
	#4. copy the converted dataset into petabyte data server
	#5. change the dataset permission
	#6. backup to petabyte data server
#The following input parameters are needed:
	#input_imageDataset: the path of the input image dataset
	#server_path: the path of the SSD server
	#teraApp: the path of the TeraConverter app
	#output_path: the path for storing all the converted datasets
	#imageName: the name of the converted image

