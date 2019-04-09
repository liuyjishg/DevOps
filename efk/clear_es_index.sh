#!/bin/bash
#clean es index 10day
#Kevin Liu

date=`date +%Y.%m.%d -d -11day`

index=`curl -s 'localhost:9200/_cat/indices?v' |grep ${date} |awk '{print $3}'`

for i in ${index[@]}
do
        echo ${i}
        curl -XDELETE localhost:9200/${i}?pretty

done
