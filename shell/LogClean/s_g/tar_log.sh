#!/bin/bash

dates=`date +"%Y-%m-%d" -d "-2day"`
dates91=`date +"%Y-%m-%d" -d "-91day"`
error_log=/home/svcaccttomcat/Clean_log_script/clean_log.log

##压缩并清理mobileCK日志
dir=/u1/mobileCK/log

ls -l -d ${dir}/all.log.${dates} &>/dev/null

if [ $? == 0 ]
then
        cd ${dir}
        ##echo "压缩中all.log."${dates}"  ing... ..."
        tar czf  all.log.${dates}.tar.gz  ./all.log.${dates}  &>/dev/null
        sleep 1
        ls -l -d ${dir}/all.log.${dates}.tar.gz &>/dev/null
        if [ $? == 0 ]
        then
                rm -fr ${dir}/all.log.${dates}
                sleep 1
                rm -fr ${dir}/all.log.${dates91}.tar.gz  ${dir}/error.log.${dates91}
                ##echo "Complete."
        else
                echo "压缩失败:all.log."${dates}  >> ${error_log}
        fi
else
        echo "压缩文件未找到:all.log."${dates} >> ${error_log}
fi

sleep 5

##压缩并清理Tomcat日志
tomcat_log=/usr/local/tomcat/logs
access_log=localhost_access_log

ls -d ${tomcat_log}/${access_log}.${dates}.txt &>/dev/null

if [ $? == 0 ]
then
        cd $tomcat_log
        #echo "压缩中:"${tomcat_log}"/"${access_log}"."${dates}".txt   ing... ..."
        tar czf ${access_log}.${dates}.tar.gz ./${access_log}.${dates}.txt &>/dev/null
        sleep 1
        ls -d ${tomcat_log}/${access_log}.${dates}.tar.gz &>/dev/null
        if [ $? == 0 ]
        then
                rm -fr ${tomcat_log}/${access_log}.${dates}.txt
                sleep 1
                rm -fr ${tomcat_log}/${access_log}.${dates91}.tar.gz
                sleep 1
                cat /dev/null > ${tomcat_log}/catalina.out
                sleep 1
                #echo "Complete."
        else
                echo "压缩失败:"${tomcat_log}"/"${access_log}"."${dates}".txt"  >> ${error_log}
        fi
else
        echo "压缩文件未找到:"${tomcat_log}"/"${access_log}"."${dates}".txt"  >> ${error_log}
fi


sleep 5

##压缩并清理e-voucher日志
e_voucher=/u1/e-voucher/logs

ls -d ${e_voucher}/all.log.${dates} &>/dev/null
if [ $? == 0 ]
then
        cd ${e_voucher}
        ##echo "压缩中all.log."${dates}"  ... ..."
        tar czf  all.log.${dates}.tar.gz  ./all.log.${dates}  &>/dev/null
        sleep 1
        ls -d ${e_voucher}/all.log.${dates}.tar.gz &>/dev/null
        if [ $? == 0 ]
        then
                rm -fr ${e_voucher}/all.log.${dates}
                sleep 1
                rm -fr ${e_voucher}/all.log.${dates91}.tar.gz  ${dir}/error.log.${dates91}
                ##echo "Complete."
        else
                echo "压缩失败:all.log."${dates}  >> ${error_log}
        fi
else
        echo "压缩文件未找到:all.log."${dates} >> ${error_log}
fi

sleep 5

##清理Logstash采集日志历史记录
ls -d /u1/logstash/log/logstash-stdout.log &>/dev/null
if [ $? == 0 ]
then
	ls -d /u1/logstash/log/logstash-plain-${dates}.log |xargs rm -fr
	cat /dev/null > /u1/logstash/log/logstash-stdout.log
fi

exit 0

## END ## --Kevin Liu

