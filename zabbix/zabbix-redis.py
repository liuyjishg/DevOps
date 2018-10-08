#!/usr/bin/env  python
#coding:utf-8
#Author Fleece_Lin    Mail: linuxlzy@163.com      QQ: 594621466
import  redis
import  sys
keyindex = ['used_memory', 'used_memory_rss', 'mem_fragmentation_ratio', 'blocked_clients', 'connected_clients',
            'connected_slaves',
            'instantaneous_ops_per_sec', 'keyspace_hits', 'keyspace_misses', 'keypace_query_total_count',
            'keyspace_hits_rate', 'status']
returnval = None
def zabbix_faild():
    print "ZBX_NOTSUPPORTED"
    sys.exit(2)
if len(sys.argv) != 2 :
    zabbix_faild()
try:
    conn=redis.Redis(host='10.10.3.',port='6379',password='LSy9OetOxT7GiItO')
except Exception, e:
    zabbix_faild()
if  sys.argv[1] in  keyindex:
    if sys.argv[1] == 'status':
        try:
            conn.ping()
            returnval = 1
        except Exception,e:
            returnval = 0
    elif sys.argv[1] == 'keyspace_hits_rate':
        merit = conn.info()
        keyspace_hits_count =  float(merit['keyspace_hits'])
        keyspace_misses_count = float(merit['keyspace_misses'])
        keyspace_hits_rate =  keyspace_hits_count / (keyspace_hits_count + keyspace_misses_count) * 100
        returnval = keyspace_hits_rate
    elif sys.argv[1] == 'keypace_query_total_count':
        merit = conn.info()
        keyspace_hits_count = merit['keyspace_hits']
        keyspace_misses_count = merit['keyspace_misses']
        keypace_query_total_count = keyspace_hits_count + keyspace_misses_count
        returnval = keypace_query_total_count
    else:
        merit = conn.info()
        try:
            returnval = merit[unicode(sys.argv[1])]
        except Exception,e:
            pass
if returnval == None:
    zabbix_faild()
else:
    print returnval

