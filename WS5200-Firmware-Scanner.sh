#!/bin/bash

echo -e "\n#### Information that can be exposed (local firmware version) #####"
localVer=`ls -l $(pwd)/xml/* |awk '{print $9}'| tr -d -c '0-9 \n'`
echo $localVer
workpath=$(pwd)
latestVer=`echo $localVer | rev | cut -d ' ' -f 1 |rev`
# add=9999
# lastVer=`expr $latestVer + $add`
echo -e "\n[+]Whether to go to the cloud to get the latest intelligence(y/n)"
read g

if [ $g == "y" ];then
    echo "[-]Please enter the version number to start the query（Recommended from $latestVer）："
    read v
    echo "[-]Please enter the version number of the end of the query:"
    read e
    for ((var=$v;var<$e;var++))
    do
        clear
        echo  "[*]Querying the version $var，Close the window directly if you want to terminate"
        curl http://update.hicloud.com/TDS/data/files/p14/s145/G4084/g1810/v$var/f1/changelog.xml > $(pwd)/xml/$var.xml
        filesize=`ls -l $(pwd)/xml/$var.xml | awk '{ print $5 }'`
        if [[ $filesize == '162'  || $filesize == '0' ]]
        then
            echo "This is Not to Download File, Will be Deleted!"
            rm $(pwd)/xml/$var.xml
        fi
    done
    echo -e "\n####Updated local firmware version####"
    localVer=`ls -l $(pwd)/xml/* |awk '{print $9}'| tr -d -c '0-9 \n'`
fi


while true
do
    echo -e "\n####Information that can be exposed (local firmware version)####\n"
    echo $localVer
    echo -e "\n[+]Please enter the firmware version you want to download\n"
    read version
    echo "--------Devicev$version related information-------"
    cat $(pwd)/xml/$version.xml
    verID=`cat $(pwd)/xml/$version.xml|awk '{print $2 $3}'|cut -d '=' -f 4|tr -d -c '0-9 .'`
    download_url="http://update.hicloud.com/TDS/data/files/p14/s145/G4084/g1810"
    filename1="WS5200_"$verID"_main.bin"
    filename2="Hi5651h-1151-ToC_"$verID"_main.bin"
    mainbin="$download_url/v$version/f1/$filename1"
    tocbin="$download_url/v$version/f1/$filename2"
    echo "[-]Download address"
    echo $mainbin
    echo $tocbin
    echo -e "\n[*]Start Download....."
    wget $mainbin -P "${workpath}/bin/"
    wget $tocbin -P "${workpath}/bin/"
    echo "[^_^]Download completed！"
done
