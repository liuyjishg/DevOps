#!/bin/bash

dates=`date +"%Y-%m-%d" -d "-2day"`
dates10=`date +"%Y-%m-%d" -d "-10day"`
dates30=`date +"%Y-%m-%d" -d "-30day"`
error_log=/home/svcaccttomcat/Clean_log_script/clean_log.log

##压缩并清理Tomcat日志
tomcat_log=/usr/local/tomcat/logs
access_log=localhost_access_log

ls -d ${tomcat_log}/${access_log}.${dates}.txt &>/dev/null
if [ $? == 0 ]
then
        cd $tomcat_log
        ##echo "压缩中:"${tomcat_log}"/"${access_log}"."${dates}".txt   ing... ..."
        tar czf ${access_log}.${dates}.tar.gz ./${access_log}.${dates}.txt &>/dev/null
        sleep 1
        ls -d ${tomcat_log}/${access_log}.${dates}.tar.gz &>/dev/null
        if [ $? == 0 ]
        then
                rm -fr ${tomcat_log}/${access_log}.${dates}.txt
                sleep 1
                rm -fr ${tomcat_log}/${access_log}.${dates91}.tar.gz
                ##sleep 1
                ##cat /dev/null > ${tomcat_log}/catalina.out
                ##sleep 1
                ##echo "Complete."
        else
                echo "缩失败:"${tomcat_log}"/"${access_log}"."${dates}".txt"  >> ${error_log}
        fi
else
        echo "压缩文件未找到:"${tomcat_log}"/"${access_log}"."${dates}".txt"  >> ${error_log}
fi


mpns=/u1/mpns/logs
conn_mpush=conn-mpush.log

ls -d ${mpns}/${conn_mpush}.${dates} &>/dev/null
if [ $? == 0 ]
then
        cd $mpns
        ##echo "压缩中:"${mpns}"/"${conn_mpush}"."${dates}"   ing... ..."
        tar czf ${conn_mpush}.${dates}.tar.gz ./${conn_mpush}.${dates} &>/dev/null

        sleep 1

        ls -d ${mpns}/${conn_mpush}.${dates}.tar.gz &>/dev/null
        if [ $? == 0 ]
        then
                rm -fr ${mpns}/${conn_mpush}.${dates}

                sleep 1

                rm -fr ${mpns}/${conn_mpush}.${dates30}.tar.gz
        else
                echo "压缩失败:"${mpns}"/"${conn_mpush}"."${dates}""  >> ${error_log}
        fi
else
        echo "压缩文件未找到:"${mpns}"/"${conn_mpush}"."${dates}""  >> ${error_log}
fi

sleep 1

info_mpush=info-mpush.log
ls -d ${mpns}/${info_mpush}.${dates} &>/dev/null
if [ $? == 0 ]
then
        cd $mpns
        tar czf ${info_mpush}.${dates}.tar.gz ./${info_mpush}.${dates} &>/dev/null

        sleep 1

        ls -d ${mpns}/${info_mpush}.${dates}.tar.gz &>/dev/null
        if [ $? == 0 ]
        then
                rm -fr ${mpns}/${info_mpush}.${dates}
                sleep 1
                rm -fr ${mpns}/${info_mpush}.${dates10}.tar.gz
        else
                echo "压缩失败:"${mpns}"/"${info_mpush}"."${dates}""  >> ${error_log}
        fi
else
        echo "压缩文件未找到:"${mpns}"/"${info_mpush}"."${dates}""  >> ${error_log}
fi

sleep 1

mpush=mpush.log
ls -d ${mpns}/${mpush}.${dates} &>/dev/null
if [ $? == 0 ]
then
        cd $mpns
        tar czf ${mpush}.${dates}.tar.gz ./${mpush}.${dates} &>/dev/null
        sleep 1
        ls -d ${mpns}/${mpush}.${dates}.tar.gz &>/dev/null
        if [ $? == 0 ]
        then
                rm -fr ${mpns}/${mpush}.${dates}
                sleep 1
                rm -fr ${mpns}/${mpush}.${dates10}.tar.gz
        else
                echo "压缩失败:"${mpns}"/"${mpush}"."${dates}""  >> ${error_log}
        fi
else
        echo "压缩文件未找到:"${mpns}"/"${mpush}"."${dates}""  >> ${error_log}
fi

sleep 1

push_mpush=push-mpush.log
ls -d ${mpns}/${push_mpush}.${dates} &>/dev/null
if [ $? == 0 ]
then
        cd $mpns
        tar czf ${push_mpush}.${dates}.tar.gz ./${push_mpush}.${dates} &>/dev/null

        sleep 1

        ls -d ${mpns}/${push_mpush}.${dates}.tar.gz &>/dev/null
        if [ $? == 0 ]
        then
                rm -fr ${mpns}/${push_mpush}.${dates}
                sleep 1
                rm -fr ${mpns}/${push_mpush}.${dates30}.tar.gz
        else
                echo "压缩失败:"${mpns}"/"${push_mpush}"."${dates}""  >> ${error_log}
        fi
else
        echo "压缩文件未找到:"${mpns}"/"${push_mpush}"."${dates}""  >> ${error_log}
fi

##清理Logstash采集日志史记录
ls -d /u1/logstash/log/logstash-stdout.log &>/dev/null
if [ $? == 0 ]
then
        ls -d /u1/logstash/log/logstash-plain-*.log |xargs rm -fr
        cat /dev/null > /u1/logstash/log/logstash-stdout.log
fi



exit 0

## END ## --Kevin Liu
