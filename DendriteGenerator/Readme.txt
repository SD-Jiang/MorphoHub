MorphoHub: Petabyte-Scale Multi-Morphometry of Single Neurons for Whole Brains
Designed by Shengdian Jiang, 2020-02-12
Email: allencenter@seu.edu.cn

#This script (main.sh) will generate dendrite data from a list of image blocks
#Workflow:
    #1. compile the App2 (https://github.com/Vaa3D/vaa3d_tools/tree/master/released_plugins/v3d_plugins/neurontracing_vn2) at Vaa3D software
    #2. set the background threshold list
    #3. set the running time threshold (30s in this script)
#The following input parameters are needed:
	#outswcfolder: traced result folder
	#markerfile: this is a parameter for app2, you can find this file in <DendriteGenerator/App2_marker_file>
	#brainpath: the path of image blocks from different brain datasets
    #Vaa3dPath: the path of the Vaa3d software
    #threadNum: the number of threads (cpu)


