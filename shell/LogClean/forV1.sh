#!/bin/bash
mpns=/u1/mpush/logs
cache=cache-mpush.log
conn_mpush=conn-mpush.log
debug=debug-mpush.log
heart=heartbeat-mpush.log
info_mpush=info-mpush.log
monitor=monitor-mpush.log
mpush=mpush.log
push_mpush=push-mpush.log


for (( i=31; i>1; i-- ))
do
        dates=`date +"%Y-%m-%d" -d "-${i}day"`
        cd ${mpns}
        ls -d ${cache}.${dates} && tar czf ${cache}.${dates}.tar.gz ./${cache}.${dates} || echo "文件不存在"
        ls -d ${conn_mpush}.${dates} && tar czf ${conn_mpush}.${dates}.tar.gz ./${conn_mpush}.${dates} || echo "文件不存在"
        ls -d ${debug}.${dates} && tar czf ${debug}.${dates}.tar.gz ./${debug}.${dates} || echo "文件不存在"
        ls -d ${heart}.${dates} && tar czf ${heart}.${dates}.tar.gz ./${heart}.${dates} || echo "文件不存在"
        ls -d ${info_mpush}.${dates} && tar czf ${info_mpush}.${dates}.tar.gz ./${info_mpush}.${dates} || echo "文件不存在"
        ls -d ${monitor}.${dates} && tar czf ${monitor}.${dates}.tar.gz ./${monitor}.${dates} || echo "文件不存在"
        ls -d ${mpush}.${dates} && tar czf ${mpush}.${dates}.tar.gz  ./${mpush}.${dates} || echo "文件不存在"
        ls -d ${push_mpush}.${dates} && tar czf ${push_mpush}.${dates}.tar.gz  ./${push_mpush}.${dates} || echo "文件不存在"
        sleep 1
        ls -d ${cache}.${dates}.tar.gz && rm -fr ${cache}.${dates} || echo "没有tar.gz"
        ls -d ${conn_mpush}.${dates}.tar.gz && rm -fr ${conn_mpush}.${dates} || echo "没有tar.gz"
        ls -d ${debug}.${dates}.tar.gz && rm -fr ${debug}.${dates} || echo "没有tar.gz"
        ls -d ${heart}.${dates}.tar.gz && rm -fr ${heart}.${dates} || echo "没有tar.gz"
        ls -d ${info_mpush}.${dates}.tar.gz && rm -fr ${info_mpush}.${dates} || echo "没有tar.gz"
        ls -d ${monitor}.${dates}.tar.gz && rm -fr ${monitor}.${dates} || echo "没有tar.gz"
        ls -d ${mpush}.${dates}.tar.gz && rm -fr ${mpush}.${dates} || echo "没有tar.gz"
        ls -d ${push_mpush}.${dates}.tar.gz && rm -fr ${push_mpush}.${dates} || echo "没有tar.gz"
done

sleep 1
ls /u1/logstash/log/logstash-plain-201*.log |xargs rm -fr
cat /dev/null > /u1/logstash/log/logstash-stdout.log

## end ## --Kevin Liu
