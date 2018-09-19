#!/bin/bash

e_voucher=/u1/e-voucher/logs
mobileck=/u1/mobileCK/log
tomcat=/usr/local/tomcat/logs
log=all.log
tlog=localhost_access_log

for (( i=91; i>1; i-- ))
do
        dates=`date +"%Y-%m-%d" -d "-${i}day"`
        ls -d ${tomcat}/${tlog}.${dates}.tar.gz &>/dev/null
        if [ $? == 0 ]
        then
                echo "Tomcat tar file已经存在，不处理。"
        else
                ls -d ${tomcat}/${tlog}.${dates}.txt &>/dev/null
                if [ $? == 0 ]
                then
                        cd ${tomcat}
                        tar czf ${tlog}.${dates}.tar.gz ./${tlog}.${dates}.txt  &>/dev/null
                        rm -fr ${tomcat}/${tlog}.${dates}.txt
                        echo ${dates}": Tomcat 完成"
                else
                        echo ${tomcat}/${tlog}.${dates}"文件不存在，tar命令不执行"
                fi
        fi


        sleep 1

        ls -d ${e_voucher}/${log}.${dates}.tar.gz &>/dev/null
        if [ $? == 0 ]
        then
                echo "E_voucher tar file已经存在，不处理。"
        else
                ls -d ${e_voucher}/${log}.${dates} &>/dev/null
                if [ $? == 0 ]
                then
                        cd ${e_voucher}
                        tar czf ${log}.${dates}.tar.gz  ./${log}.${dates} &>/dev/null
                        rm -fr ${e_voucher}/${log}.${dates}
                        echo ${dates}": E_voucher 完成"
                else
                        echo ${e_voucher}/${log}.${dates}"文件不存在，tar命令不执行"
                fi

        fi


        sleep 1

        ls -d ${mobileck}/${log}.${dates}.tar.gz  &>/dev/null
        if [ $? == 0 ]
        then
                echo "MobileCK tar file已经存在，不处理。"
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

