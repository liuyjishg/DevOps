#!/bin/bash

tomcat=/usr/local/tomcat/logs
tlog=localhost_access_log

for (( i=91; i>1; i-- ))
do
        dates=`date +"%Y-%m-%d" -d "-${i}day"`
        ls -d ${tomcat}/${tlog}.${dates}.tar.gz &>/dev/null
        if [ $? == 0 ]
        then
                echo "Tomcat tar file已经存在，不处理。"
        else
                ls -d ${mobileck}/${log}.${dates} &>/dev/null
                if [ $? == 0 ]
                then
                        cd ${mobileck}
                        tar czf ${log}.${dates}.tar.gz  ./${log}.${dates} &>/dev/null
                        rm -fr ${mobileck}/${log}.${dates}
                        echo ${dates}": Mobileck 完成"
                else
                        echo ${mobileck}/${log}.${dates}"文件不存在，tar命令不执行"
                fi
        fi

done


sleep 2
ls ${tomcat}/${tlog}.2017-* |xargs rm -fr
ls ${tomcat}/${tlog}.2018-01-*.txt |xargs rm -fr
ls ${tomcat}/${tlog}.2018-02-*.txt |xargs rm -fr
ls ${tomcat}/${tlog}.2018-03-*.txt |xargs rm -fr
ls ${tomcat}/${tlog}.2018-04-*.txt |xargs rm -fr
ls ${tomcat}/${tlog}.2018-05-*.txt |xargs rm -fr
ls ${tomcat}/${tlog}.2018-06-*.txt |xargs rm -fr

ls ${tomcat}/catalina.2017*.log |xargs rm -fr
ls ${tomcat}/catalina.2018-01-*.log |xargs rm -fr
ls ${tomcat}/catalina.2018-02-*.log |xargs rm -fr
ls ${tomcat}/catalina.2018-03-*.log |xargs rm -fr
ls ${tomcat}/catalina.2018-04-*.log |xargs rm -fr
ls ${tomcat}/catalina.2018-05-*.log |xargs rm -fr
ls ${tomcat}/catalina.2018-06-*.log |xargs rm -fr

## end ## --Kevin
