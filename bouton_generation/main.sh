#!/bin/bash
inputfolder=$1
outputpath=$2
boxSize=$3
TeraFlyBrains=$4
Vaa3dPath=$5

#multi-thread
threadNum=46
tempfifo="bouton_intensity_temp_fifo"
mkfifo ${tempfifo}
exec 6<>${tempfifo}
rm -f ${tempfifo}
for ((i=1;i<${threadNum};i++))
do
{
    echo ;
}
done >&6  

    for neuron in $(ls $inputfolder/*swc)
    do
    read -u6
    {
        filename=${neuron##*/}
        brain=${filename:0:11}
        prepath="$TeraFlyBrains/${brain}_TeraFly"
        
        linecount="0"
        for level in $(ls -Sd ${prepath}/RES*)
        do
                #echo ${levelname}        
                levelname[$((linecount))]=${level##*/}
                # echo ${level##*/}
                xdim[$((linecount))]=`echo ${level##*/}|awk -F 'x' '{print $2}'`
                let "linecount+=1"
        done
        let "linecount-=1"
            #sort every level
            maxindex=0
        for levelindex in `seq 0 $((linecount))`
        do
                tempxdim=${xdim[$levelindex]}
                if [ $levelindex = "0" ];
                then
                    maxxdim=${tempxdim}
                    maxindex=0
                elif [[ "${maxxdim}" -lt "$tempxdim" ]];
                then
                    maxxdim=${tempxdim}
                    maxindex=$levelindex
                fi
        done
        input_img_path="${prepath}/${levelname[maxindex]}"
        outname_density="${outputpath}/${neuron##*/}_IntensityResult.eswc"
        #echo ${outname_density}
        if [ ! -f $outname_density ]
        then
            ${Vaa3dPath} -x BoutonDectection -f BoutonDection_terafly -i ${input_img_path} ${neuron} -o ${outputpath} -p ${boxSize}
        fi
        echo >&6
    } &   
    done
    wait
    for neuron in $(ls $outputpath/*_IntensityResult.eswc)
    do
    read -u6
    {
        outname_bouton_apo="${neuron}_bouton.apo"
        if [ ! -f $outname_bouton_apo ]
        then
            ${Vaa3dPath} -x BoutonDectection -f BoutonDection_filter -i ${neuron}
        fi   
        echo >&6
    } &  
    done
    wait  
    echo "all finished"
sleep 2
exec 6>&-