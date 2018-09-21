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
dates=`date +"%Y-%m-%d" -d "-2day"`
dates31=`date +"%Y-%m-%d" -d "-31day"`
error_log=/home/svcaccttomcat/Clean_log_script/clean_log.log

for log in ${cache} ${conn_mpush} ${debug} ${heart} ${info_mpush} ${monitor} ${mpush} ${push_mpush}
do
        cd ${mpns}
        ls -d ${log}.${dates} && tar czf ${log}.${dates}.tar.gz ./${log}.${dates} || echo ${log}.${dates}" file is not find" &>>${error_log}
        sleep 1
        ls -d ${log}.${dates}.tar.gz && rm -fr ${log}.${dates} || echo "no tar.gz file"
        sleep 1
        ls -d ${log}.${datesi31}.tar.gz && rm -fr ${log}.${dates31}.tar.gz || echo "no 31 tar.gz"
done

## end ## --Kevin Liu
