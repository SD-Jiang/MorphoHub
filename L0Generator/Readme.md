L0Generator
===
This script (L0Generator/main.sh) will will generate Level-0 data from a list of swc files
---
>*MorphoHub: Petabyte-Scale Multi-Morphometry of Single Neurons for Whole Brains  
Designed by Shengdian Jiang, 2019-06-02  
Email: allencenter@seu.edu.cn*
***

## Workflow:
1. compile the Vaa3d plugin (getlevel0data.pro) in <L0Generator/src>
2. put all the swc files in one folder
3. resample swc to speed up the generation
4. generate Level-0 data
5. check the processing state
6. compress the data for a better sharing performance

### The following input parameters are needed:
+ Vaa3dPath: the path of the Vaa3d software
+ TeraFlyBrains: the path of storing all the TeraFly datasets
+ annotationpath: the path of input swc files
+ outputpath: the path for storing all the generated Level-0 data
+ threadNum: the number of threads (cpu)

###PS
+ annotationpath format: All the swc file should store at this folder and the format of the swc should be like this: `BrainID_NeuronID_--.swc`
+ The organization of the output folder will be like this: 
    * BrainID_NeuronID
        * L0Data
        * morphologyData
            * Annotation: morphologyData.swc
            * ResampleData: resampleSwc.file
+ the processing state can be checked at logFile

