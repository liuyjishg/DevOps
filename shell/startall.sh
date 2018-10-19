#!/bin/bash

kibana_fun() {
	kibana_values=$1
	kibana_home=/usr/local/kibana
	kibana_start() {
		lsof -i:5601 >/dev/null
		if [ $? == 0 ]
		then
			kibana_pid=`lsof -i:5601|grep "LISTEN"|awk '{print $2}'`
			ps -A -opid,stime,etime|grep ${kibana_pid}|awk '{print "\nKibana is running \nPrecessPid : "$1"\nStartTime : "$2"\nRunningTime : "$3"\n"}'
		else
			cd ${kibana_home}
			./bin/kibana >/dev/null 2>&1 &
			echo "Kibana service start ing...."
			sleep 90
			kibana_pid=`lsof -i:5601|grep "LISTEN"|awk '{print $2}'`
			echo $? >/dev/null && ps -A -opid,stime,etime|grep ${kibana_pid}|awk '{print "\nKibana is running \nPrecessPid : "$1"\nStartTime : "$2"\nRunningTime : "$3"\n"}' || echo -e "\nKibana start fail\n"
			
		fi
	}

	kibana_stop() {
		lsof -i:5601 >/dev/null
		if [ $? -eq 0 ]
		then
			kill `lsof -i:5601|grep "LISTEN"|awk '{print $2}'`
			sleep 30
			lsof -i:5601 >/dev/null && echo -e "\nKibana stop fail.!!!\n" || echo -e "\nKibana stop Success\n"
		else
			echo -e "\nkibana NO Start.!!!\n"
		fi
	}

	case ${kibana_values} in
		start|status)
			kibana_start;
			;; 
		stop)
			kibana_stop;
			;;
		*)
			echo "Please enter:"$0 "{kibana \"start|status|stop\"}";
			;;
	esac
}


search_fun() {
	search_values=$1
	search_home=/usr/local/elasticsearch
	search_start() {
		lsof -i:9200 >/dev/null
		if [ $? == 0 ]
		then
			search_pid=`lsof -i:9200|grep "LISTEN"|awk '{print $2}'`
			ps -A -opid,stime,etime|grep ${search_pid}|awk '{print "\nElasticsearch is running \nPrecessPid : "$1"\nStartTime : "$2"\nRunningTime : "$3"\n"}'
		else
			cd ${search_home}
			./bin/search >/dev/null 2>&1 &
			echo "elasticsearch service start ing...."
			sleep 90
			search_pid=`lsof -i:9200|grep "LISTEN"|awk '{print $2}'`
			echo $? >/dev/null && ps -A -opid,stime,etime|grep ${search_pid}|awk '{print "\nsearch is running \nPrecessPid : "$1"\nStartTime : "$2"\nRunningTime : "$3"\n"}' || echo -e "\nelasticsearch start fail\n"
			
		fi
	}

	search_stop() {
		lsof -i:9200 >/dev/null
		if [ $? -eq 0 ]
		then
			kill `lsof -i:9200|grep "LISTEN"|awk '{print $2}'`
			sleep 30
			lsof -i:9200 >/dev/null && echo -e "\nelasticsearch stop fail.!!!\n" || echo -e "\nelasticsearch stop Success\n"
		else
			echo -e "\nelasticsearch NO Start.!!!\n"
		fi
	}

	case ${search_values} in
		start|status)
			search_start;
			;; 
		stop)
			search_stop;
			;;
		*)
			echo "Please enter:"$0 "{search \"start|status|stop\" }";
			;;
	esac
}


case $1 in
kibana)
	kibana_fun $2;
	;;

search|elasticsearch)
	search_fun $2;
	;;

*)
	echo -e "Please enter:"$0 "{kibana values | search values}";
	;;
esac


