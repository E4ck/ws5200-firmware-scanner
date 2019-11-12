#!/bin/bash

echo -e "\n#### 可以公开的情报(本地固件版本) #####"
localVer=`ls -l $(pwd)/xml/* |awk '{print $9}'| tr -d -c '0-9 \n'`
echo $localVer
workpath=$(pwd)
latestVer=`echo $localVer | rev | cut -d ' ' -f 1 |rev`
# add=9999
# lastVer=`expr $latestVer + $add`
echo -e "\n[+]是否去云端获取最新情报(y/n)"
read g

if [ $g == "y" ];then
    echo "[-]请输入开始查询的版本号（推荐从 $latestVer 开始）："
    read v
    echo "[-]请输入结束查询的版本号:"
    read e
    for ((var=$v;var<$e;var++))
    do
        clear
        echo  [*]正在查询版本 $var，若想终止直接关闭窗口
        curl http://update.hicloud.com/TDS/data/files/p14/s145/G4084/g1810/v$var/f1/changelog.xml > $(pwd)/xml/$var.xml
        filesize=`ls -l $(pwd)/xml/$var.xml | awk '{ print $5 }'`
        if [[ $filesize == '162'  || $filesize == '0' ]]
        then
            echo "This is Not to Download File, Will be Deleted!"
            rm $(pwd)/xml/$var.xml
        fi
    done
    echo -e "\n####更新之后的本地固件版本####"
    localVer=`ls -l $(pwd)/xml/* |awk '{print $9}'| tr -d -c '0-9 \n'`
fi


while true
do
    echo -e "\n####可以公开的情报(本地固件版本)####\n"
    echo $localVer
    echo -e "\n[+]请输入要下载的固件版本\n"
    read version
    echo "--------固件v$version相关信息如下-------"
    cat $(pwd)/xml/$version.xml
    verID=`cat $(pwd)/xml/$version.xml|awk '{print $2 $3}'|cut -d '=' -f 4|tr -d -c '0-9 .'`
    download_url="http://update.hicloud.com/TDS/data/files/p14/s145/G4084/g1810"
    filename1="WS5200_"$verID"_main.bin"
    filename2="Hi5651h-1151-ToC_"$verID"_main.bin"
    mainbin="$download_url/v$version/f1/$filename1"
    tocbin="$download_url/v$version/f1/$filename2"
    echo "[-]下载地址"
    echo $mainbin
    echo $tocbin
    echo -e "\n[*]开始下载固件....."
    wget $mainbin -P "${workpath}/bin/"
    wget $tocbin -P "${workpath}/bin/"
    echo "[^_^]下载完成！"
done