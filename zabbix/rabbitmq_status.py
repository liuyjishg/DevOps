#!/usr/bin/env /usr/bin/python
#coding:utf-8
#Author Fleece_Lin    Mail: linuxlzy@163.com      QQ: 594621466
'''Python module to query the RabbitMQ Management Plugin REST API and get
results that can then be used by Zabbix.
'''
'''
    This script is tested on RabbitMQ 3.5.3
'''
import json
import optparse
import socket
import urllib2
import subprocess
import tempfile
import os
import logging
import fcntl
import struct
  
 
logging.basicConfig(filename='/var/log/zabbix/rabbitmq_zabbix.log', level=logging.WARNING, format='%(asctime)s %(levelname)s: %(message)s')
 
class RabbitMQAPI(object):
    '''Class for RabbitMQ Management API'''
    def __init__(self, user_name='rmqmonitoring@fm', password='rmqmonitoring@fm', host_name=('10.105.229.138'),
                 protocol='http', port=15672, conf='/etc/zabbix/zabbix_agentd.conf', senderhostname=None):
        self.user_name = user_name
        self.password = password
        self.host_name = host_name or socket.gethostname()
        self.protocol = protocol
        self.port = port
        self.conf = conf or '/etc/zabbix/zabbix_agentd.conf'
        self.senderhostname = senderhostname if senderhostname else host_name
 
    def call_api(self, path):
        '''
           All URIs will server only resource of type application/json,and will require HTTP basic authentication. The default username and password is guest/guest.  /%sf is encoded for the default virtual host '/' 
        '''
        url = '{0}://{1}:{2}/api/{3}'.format(self.protocol, self.host_name, self.port, path)
        password_mgr = urllib2.HTTPPasswordMgrWithDefaultRealm()
        password_mgr.add_password(None, url, self.user_name, self.password)
        handler = urllib2.HTTPBasicAuthHandler(password_mgr)
        logging.debug('Issue a rabbit API call to get data on ' + path)
######## json.loads()  transfer json data to python data
######## json.dump()   transfer python data to json data
        return json.loads(urllib2.build_opener(handler).open(url).read())
 
    def list_queues(self):
        ''' curl -i -u guest:guest http://localhost:15672/api/queues  
        return a list 
        '''
        queues = []
        for queue in self.call_api('queues'):
            logging.debug("Discovered queue " + queue['name'])
            element = {'{#VHOSTNAME}': queue['vhost'],
                       '{#QUEUENAME}': queue['name']
                      }
            queues.append(element)
            logging.debug('Discovered queue '+queue['vhost']+'/'+queue['name'])
        return queues
 
    def list_nodes(self):
        '''Lists all rabbitMQ nodes in the cluster'''
        nodes = []
        for node in self.call_api('nodes'):
            # We need to return the node name, because Zabbix
            # does not support @ as an item parameter
            name = node['name'].split('@')[1]
            element = {'{#NODENAME}': name,
                       '{#NODETYPE}': node['type']}
            nodes.append(element)
            logging.debug('Discovered nodes '+name+'/'+node['type'])
        return nodes
 
    def check_queue(self):
        '''Return the value for a specific item in a queue's details.'''
        return_code = 0
        #### use tempfile module to create a file on memory, will not be deleted when it is closed , because 'delete' argument is set to False
        rdatafile = tempfile.NamedTemporaryFile(delete=False)
        for queue in self.call_api('queues'):
            self._get_queue_data(queue, rdatafile)
        rdatafile.close()
        return_code = self._send_queue_data(rdatafile)
        #### os.unlink is used to remove a file
        os.unlink(rdatafile.name)
        return return_code
 
    def _get_queue_data(self, queue, tmpfile):
        '''Prepare the queue data for sending'''
        '''
          ### one single  queue's information like this #####
          ### curl -i -u guest:guest http://localhost:15672/api/queues   dumps a list   ###
{"memory":32064,"message_stats":{"ack":3870,"ack_details":{"rate":0.0},"deliver":3871,"deliver_details":{"rate":0.0},"deliver_get":3871,"deliver_get_details":{"rate":0.0},"disk_writes":3870,"disk_writes_details":{"rate":0.0},"publish":3870,"publish_details":{"rate":0.0},"redeliver":1,"redeliver_details":{"rate":0.0}},"messages":0,"messages_details":{"rate":0.0},"messages_ready":0,"messages_ready_details":{"rate":0.0},"messages_unacknowledged":0,"messages_unacknowledged_details":{"rate":0.0},"idle_since":"2016-03-01 22:04:22","consumer_utilisation":"","policy":"","exclusive_consumer_tag":"","consumers":4,"recoverable_slaves":"","state":"running","messages_ram":0,"messages_ready_ram":0,"messages_unacknowledged_ram":0,"messages_persistent":0,"message_bytes":0,"message_bytes_ready":0,"message_bytes_unacknowledged":0,"message_bytes_ram":0,"message_bytes_persistent":0,"disk_reads":0,"disk_writes":3870,"backing_queue_status":{"q1":0,"q2":0,"delta":["delta",0,0,0],"q3":0,"q4":0,"len":0,"target_ram_count":"infinity","next_seq_id":3870,"avg_ingress_rate":0.060962064328682466,"avg_egress_rate":0.060962064328682466,"avg_ack_ingress_rate":0.060962064328682466,"avg_ack_egress_rate":0.060962064328682466},"name":"app000","vhost":"/","durable":true,"auto_delete":false,"arguments":{},"node":"rabbit@test2"}
        '''
        for item in [ 'memory','messages','messages_ready','messages_unacknowledged','consumers' ]:
            #key = rabbitmq.queues[/,queue_memory,queue.helloWorld]
            key = '"rabbitmq.queues[{0},queue_{1},{2}]"'.format(queue['vhost'], item, queue['name'])
            ### if item is in queue,value=queue[item],else value=0
            value = queue.get(item, 0)
            logging.debug("SENDER_DATA: - %s %s" % (key,value))
            tmpfile.write("- %s %s\n" % (key, value))
        ##  This is a non standard bit of information added after the standard items
        for item in ['deliver_get', 'publish']:
            key = '"rabbitmq.queues[{0},queue_message_stats_{1},{2}]"'.format(queue['vhost'], item, queue['name'])
            value = queue.get('message_stats', {}).get(item, 0)
            logging.debug("SENDER_DATA: - %s %s" % (key,value))
            tmpfile.write("- %s %s\n" % (key, value))
 
    def _send_queue_data(self, tmpfile):
        '''Send the queue data to Zabbix.'''
        '''Get key value from temp file. '''
        args = '/usr/bin/zabbix_sender -c {0} -i {1}'
        if self.senderhostname:
            args = args + " -s " + self.senderhostname
        return_code = 0
        process = subprocess.Popen(args.format(self.conf, tmpfile.name),
                                           shell=True, stdout=subprocess.PIPE,
                                           stderr=subprocess.PIPE)
        out, err = process.communicate()
        logging.debug("Finished sending data")
        return_code = process.wait()
        logging.info("Found return code of " + str(return_code))
        if return_code != 0:
            logging.warning(out)
            logging.warning(err)
        else:
            logging.debug(err)
            logging.debug(out)
        return return_code
 
    def check_aliveness(self):
        '''Check the aliveness status of a given vhost. '''
        '''virtual host '/' should be encoded as '/%2f' ''' 
        return self.call_api('aliveness-test/%2f')['status']
 
    def check_overview(self, item):
        '''First, check the overview specific items'''
        ''' curl -i -u guest:guest http://localhost:15672/api/overview   '''
        ## rabbitmq[overview,connections]
        if   item in [ 'channels','connections','consumers','exchanges','queues' ]: 
          return self.call_api('overview').get('object_totals').get(item,0)
        ## rabbitmq[overview,messages]
        elif item in [ 'messages','messages_ready','messages_unacknowledged' ]:
          return self.call_api('overview').get('queue_totals').get(item,0)
        elif item == 'message_stats_deliver_get':
          return self.call_api('overview').get('message_stats', {}).get('deliver_get',0)
        elif item == 'message_stats_publish':
          return self.call_api('overview').get('message_stats', {}).get('publish',0)
        elif item == 'message_stats_ack':
          return self.call_api('overview').get('message_stats', {}).get('ack',0)
        elif item == 'message_stats_redeliver':
          return self.call_api('overview').get('message_stats', {}).get('redeliver',0)
        elif item == 'rabbitmq_version':
          return self.call_api('overview').get('rabbitmq_version', 'None')
 
    def check_server(self,item,node_name):
        '''Return the value for a specific item in a node's details. '''
        '''curl -i -u guest:guest http://localhost:15672/api/nodes'''
        '''return a list'''
        # hostname     hk-prod-mq1.example.com
        # self.call_api('nodes')[0]['name']   rabbit@hk-prod-mq1
        node_name = node_name.split('.')[0]
        for nodeData in self.call_api('nodes'):
            if node_name in nodeData['name']:
                return nodeData.get(item,0)
        return 'Not Found'
 
 
def main():
    '''Command-line parameters and decoding for Zabbix use/consumption.'''
    choices = ['list_queues', 'list_nodes', 'queues', 'check_aliveness',
               'overview','server']
    parser = optparse.OptionParser()
    parser.add_option('--username', help='RabbitMQ API username',
                      default='rmqmonitoring@fm')
    parser.add_option('--password', help='RabbitMQ API password',
                      default='rmqmonitoring@fm')
    parser.add_option('--hostname', help='RabbitMQ API host',
                      default=socket.gethostname())
    parser.add_option('--protocol', help='RabbitMQ API protocol (http or https)',
                      default='http')
    parser.add_option('--port', help='RabbitMQ API port', type='int',
                      default=15672)
    parser.add_option('--check', type='choice', choices=choices,
                      help='Type of check')
    parser.add_option('--metric', help='Which metric to evaluate', default='')
    parser.add_option('--node', help='Which node to check (valid for --check=server)')
    parser.add_option('--conf', default='/etc/zabbix/zabbix_agentd.conf')
    parser.add_option('--senderhostname', default='', help='Allows including a sender parameter on calls to zabbix_sender')
    (options, args) = parser.parse_args()
    if not options.check:
        parser.error('At least one check should be specified')
    logging.debug("Started trying to process data")
    api = RabbitMQAPI(user_name=options.username, password=options.password,
                      host_name=options.hostname, protocol=options.protocol, port=options.port,
                      conf=options.conf, senderhostname=options.senderhostname)
 
    if options.check == 'list_queues':
        print json.dumps({'data': api.list_queues()},indent=4,separators=(',',':'))
    elif options.check == 'list_nodes':
        print json.dumps({'data': api.list_nodes()},indent=4,separators=(',',':'))
    elif options.check == 'queues':
        print api.check_queue()
    elif options.check == 'check_aliveness':
        print api.check_aliveness()
    elif options.check == 'overview':
    #rabbitmq[overview,connections]
    #--check=overview   --metric=connections
        if not options.metric:
            parser.error('Missing required parameter: "metric"')       
        else:
            if options.node:
                print api.check_overview(options.metric)
            else:
                print api.check_overview(options.metric)
    elif options.check == 'server':
    #rabbitmq[server,sockets_used]
    #--check=server   --metric=sockets_used
         if not options.metric:
            parser.error('Missing required parameter: "metric"')
         else:
            if options.node:
                print api.check_server(options.metric,options.node)
            else:
                print api.check_server(options.metric,api.host_name)
  
 
if __name__ == '__main__':
    main()

