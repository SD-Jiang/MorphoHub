#!/bin/bash

outswcfolder=$1
markerfile=$2
brainpath=$3
Vaa3dPath=$4

if [ $# -ge 6 ];then
    threadNum=$6
elif [ $# -lt 6 ];then
    echo "Input error: not enough parameters"
    exit 0
else
    threadNum=30
fi
#multi-thread
tempfifo="dendrite_Complete_fulltrace_fifo"
mkfifo ${tempfifo}
exec 6<>${tempfifo}
rm -f ${tempfifo}
for ((i=1;i<${threadNum};i++))
do
{
    echo ;
}
done >&6

threlist=(10 15 20 25 30 35)
threlistlen=${#threlist[@]}

for brain in $(ls ${brainpath})
do
    echo "Now moving to ${brain}"
    for imgfile in $(ls ${brainpath}/${brain}/*v3draw)
    do
    read -u6
    {
        imgfilename=${imgfile##*/}        
        # 1. img file constrain
        # 2. somata number constrain
            if [ ! -d "${outswcfolder}/${brain}" ]
            then
                mkdir -p "${outswcfolder}/${brain}"
            fi
                # 3. ini swc file constrain
            if [ -f "${outswcfolder}/${brain}/${imgfilename}_ini.swc" ]
            then
                echo "remove old ini swc file:${brain}/${imgfilename}_ini.swc"
                rm "${outswcfolder}/${brain}/${imgfilename}_ini.swc"
            fi
            #enter thre loop
            for((i=0; i<$threlistlen;i++))
            do
                bkg_thre=${threlist[i]}
                echo "Now threshold is ${bkg_thre}"

                out_swc_name="${imgfilename}_thre${bkg_thre}.swc"
                out_swc_path="${outswcfolder}/${brain}/${out_swc_name}"
                
                if [ ! -f "${outswcfolder}/${brain}/${imgfilename}_thre${bkg_thre}_ini.swc" ]
                then
                    timeout 30s ${Vaa3dPath} -x vn2 -f app2 -i ${imgfile} -o ${out_swc_path} -p ${markerfile} 0 ${bkg_thre}
                fi
                # wait
                #clear old ini swc file
                if [ -f "${outswcfolder}/${brain}/${imgfilename}_thre${bkg_thre}_ini.swc" ]
                then
                    echo "remove old ini swc file: ${brain}/${imgfilename}_thre${bkg_thre}_ini.swc"
                    rm "${outswcfolder}/${brain}/${imgfilename}_thre${bkg_thre}_ini.swc"
                fi
                #if traced result is not existed or the size is very small
                if [ ! -f ${out_swc_path} ]
                then
                    echo "Threshold ${bkg_thre} is too big Or time is not enough"
                    continue
                fi
            done            
        echo >&6
    } & 
    done
    wait
    
    echo "${brain} Tracing Finished"
    sleep 2 
done
wait
sleep 2
echo "All Tracing Finished"
exec 6>&-

