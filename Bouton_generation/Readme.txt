MorphoHub: Petabyte-Scale Multi-Morphometry of Single Neurons for Whole Brains
Designed by Shengdian Jiang, 2020-02-12
Email: allencenter@seu.edu.cn

#This script will generate Level-3 bouton data from a list of swc files
#Design by shengdian,2020-08-20
#get latest bouton detection plugin code at https://github.com/Vaa3D/vaa3d_tools/tree/master/hackathon/shengdian/BoutonDetection
#Workflow:
    #1. complie Vaa3d BoutonDetection plugin Vaa3d plugin. (code in <Bouton_generation/src>)
    #2: use v3d BoutonDetection plugin (BoutonDection_terafly), get intensity of all the nodes
        #PS:
        #1.At this step, if out path is not specified, generated results will be saved at the same folder
        #2.The intensity of the nodes is a local maximum intensity in a small box, and the box size can be set. (in this script, the box size is 2 pixels)
    #3: use v3d BoutonDetection plugin (BoutonDection_filter), get all the bouton points
        #the bouton will be stored at Apo file.

#The following input parameters are needed:
	#Vaa3dPath: the path of the Vaa3d software
    #TeraFlyBrains: the path of storing all the TeraFly datasets
	#inputfolder: the path of input swc files
	#outputpath: the path for storing all the generated Level-0 data
    #threadNum: the number of threads (cpu)


