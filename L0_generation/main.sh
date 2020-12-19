#!/bin/bash
Vaa3dPath=$1
TeraFlyBrains=$2
annotationpath=$3
outputpath=$4
threadNum=$5
logFile=${outputpath}/logFile.txt
function outFoldercheck() {
    for swcpath in $(ls ${annotationpath}/*swc);
    do
        read -u6
        {
        swcname=${swcpath##*/}
        outputDataPath="${outputpath}/${swcname:0:11}"
        #check morphologyData
        if [[ ! -f ${outputDataPath}/morphologyData/${swcname} || ! -f ${outputDataPath}/morphologyData/${swcname:0:11}.ano ]]
        then
            #swc file
            echo "error: ${swcname:0:11} has no morphology file. please check" >>${logFile}
            #ano file
        fi
        #check ResampleData
        fileo=${outputDataPath}/ResampleData/resample_${swcname}
        if [ ! -f ${fileo} ]
        then
	        echo "error: ${swcname:0:11} has no ResampleData. please check" >>${logFile}
		    rm -r ${outputDataPath}
            continue
        fi
        #check L0Data
        if [[ ! -d ${outputDataPath}/L0Data || "`ls -A ${outputDataPath}/L0Data/`" = "" ]]
        then
            echo "error: ${swcname:0:11} has no L0Data. please check" >>${logFile}
            continue
        fi
        } &
    done
}
function compressOutfolder(){
    #backup the images and neuron data
    for swcpath in $(ls ${annotationpath}/*swc);
    do
        read -u6
        {
        swcname=${swcpath##*/}
        outputDataPath="${outputpath}/${swcname:0:11}"
        Imagesfoldername="${outputDataPath}/${swcname:0:11}_L0.tar.gz"
        Neuronsfoldername="${outputDataPath}/${swcname:0:11}_L2.tar.gz" 
        #check morphologyData
        if [[ ! -f ${outputDataPath}/morphologyData/${swcname} || ! -f ${outputDataPath}/morphologyData/${swcname:0:11}.ano ]]
        then
            echo "error: ${swcname:0:11} has no L0Data. please check" >>${logFile}
            continue
        fi
        #check L0Data
        if [[ ! -d ${outputDataPath}/L0Data || "`ls -A ${outputDataPath}/L0Data/`" = "" ]]
        then
            echo "error: ${swcname:0:11} has no L0Data. please check" >>${logFile}
            continue
        fi
        #compress
        if [ ! -f ${Imagesfoldername} ]
        then
            tar -zcvf ${Imagesfoldername} ${outputDataPath}/L0Data    
        fi
        if [ ! -f ${Neuronsfoldername} ]
        then
            tar -zcvf ${Neuronsfoldername} ${outputDataPath}/morphologyData    
        fi
        #check the results of the compress
        if [[ ! -f ${Imagesfoldername} || ! -f ${Neuronsfoldername} ]]
        then
            echo "Compress error: ${swcname:0:11}. please check" >>${logFile}
        fi
        } &
    done
}
function MainMethod(){
    #1.resample data
    #2.get one of resolution path of the brain data
    #3.get level zero data
    for swcpath in $(ls ${annotationpath}/*swc);
    do
    read -u6
    {
        swcname=${swcpath##*/}
        BrainPath=${TeraFlyBrains}/${swcname:0:11}_TeraFly
        outputDataPath="${outputpath}/${swcname:0:11}"
        if [ ! -d ${outputDataPath} ];
        then
            mkdir ${outputDataPath}
	        mkdir ${outputDataPath}/L0Data
            mkdir ${outputDataPath}/ResampleData
	        mkdir ${outputDataPath}/morphologyData
        fi
        #copy to morphologyData
        if [ ! -f ${outputDataPath}/morphologyData/${swcname} ]
        then
            #swc file
            cp ${swcpath} ${outputDataPath}/morphologyData/${swcname}
            #ano file
            if [ ! -f ${outputDataPath}/morphologyData/${swcname:0:11}.ano ]
            then
                echo "SWCFILE=${swcname}">>${outputDataPath}/morphologyData/${swcname:0:11}.ano
            fi
        fi
        #resample swc file
	    if [ -d ${outputDataPath}/ResampleData ];
	    then
	        fileo=${outputDataPath}/ResampleData/resample_${swcname}
            if [ ! -f ${fileo} ]
            then
	            ${Vaa3dPath} -x resample_swc -f resample_swc -i ${swcpath} -o ${fileo} -p 20
            fi
	    fi
        #get one level of the resolution data.
        #get how many levels of this brain. six or seven
        #use brain id to get all the level name in brain data.
        linecount="0"
        for level in $(ls -Sd ${BrainPath}/RES*)
        do
            #echo ${levelname}        
            levelname[$((linecount))]=${level##*/}
            xdim[$((linecount))]=`echo ${level##*/}|awk -F 'x' '{print $2}'`
            let "linecount+=1"
        done
        let "linecount-=1"
        #sort every level
        for levelindex in `seq 0 $((linecount))`
        do
            tempxdim=${xdim[$levelindex]}
            if [ $levelindex = "0" ];
            then
                maxxdim=${tempxdim}
            elif [[ "${maxxdim}" -lt "$tempxdim" ]];
            then
                maxxdim=${tempxdim}
            fi
        done
        for levelindex in `seq 0 $((linecount))`
        do
            tempxdim=${xdim[$levelindex]}
            let "xdimrate=maxxdim/tempxdim"
            case $xdimrate in
            1)
            #sortresults[$levelindex]=0
            sortlevelname[0]=${levelname[$((levelindex))]}
            ;;
            2)
            #sortresults[$levelindex]=1
            sortlevelname[1]=${levelname[$((levelindex))]}
            ;;
            4)
            #sortresults[$levelindex]=2
            sortlevelname[2]=${levelname[$((levelindex))]}
            ;;
            8)
            #sortresults[$levelindex]=3
            sortlevelname[3]=${levelname[$((levelindex))]}
            ;;
            16)
            #sortresults[$levelindex]=4
            sortlevelname[4]=${levelname[$((levelindex))]}
            ;;
            32)
            #sortresults[$levelindex]=5
            sortlevelname[5]=${levelname[$((levelindex))]}
            ;;
            64)
            #sortresults[$levelindex]=6
            sortlevelname[6]=${levelname[$((levelindex))]}
            ;;
            esac
        done
        ##generate level 0 data
        let "maxlevel=linecount+1"
        #if not, generate this neuron's level zero data
        if [ -d ${outputDataPath}/L0Data ]
	    then
            swc=${fileo}
            #copy level seven or six
            let "endindex=linecount-1"                
            if [ ! -d ${outputDataPath}/L0Data/${sortlevelname[$((linecount))]} ]
            then
                    mkdir ${outputDataPath}/L0Data/${sortlevelname[$((linecount))]}
                    if [ "`ls -A ${outputDataPath}/L0Data/${sortlevelname[$((linecount))]}`" = "" ]
                    then
                        cp -R -n "${BrainPath}/${sortlevelname[$((linecount))]}" ${outputDataPath}/L0Data/
                    fi
            fi
            for levelindex in `seq 0 ${endindex}`
            do
                if [ ! -d ${outputDataPath}/L0Data/${sortlevelname[$((levelindex))]} ]
                then
                    mkdir ${outputDataPath}/L0Data/${sortlevelname[$((levelindex))]}
                    if [ "`ls -A ${outputDataPath}/L0Data/${sortlevelname[$((levelindex))]}`" = "" ]
                    then
                        ${Vaa3dPath} -x getlevel0data -f getlevel0data -i "${BrainPath}/${sortlevelname[$((levelindex))]}" ${swc} -o ${outputDataPath}/L0Data/${sortlevelname[$((levelindex))]} -p $levelindex
                    fi
                fi
            done
        fi
        echo "${swcname} finished." >>${logFile}
    } &
    done
}
function Main(){

    if [ ! -f ${logFile} ]
    then
        touch ${logFile}
        chmod +x ${logFile}   
    else
        rm ${logFile}
        touch ${logFile}
        chmod +x ${logFile}
    fi
    tempfifo="getlevel0data_temp_fifo"
    mkfifo ${tempfifo}
    exec 6<>${tempfifo}
    rm -f ${tempfifo}
    for ((i=1;i<${threadNum};i++))
    do
    {
       echo ;
    }
    done >&6  
    #get l0
    MainMethod
    echo "================================Get l0 data finished================================"
    wait
    #error check
    outFoldercheck
    echo "================================check finished================================"
    wait
    #compress the output
    compressOutfolder
    echo "================================Compress finished================================"
    wait
    exec 6>&-
    exit 1
}
Main
