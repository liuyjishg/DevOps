FROM centos 
MAINTAINER  Kevin "409216159@qq.com"  

ADD epel.repo /etc/yum.repos.d
RUN yum install -y mariadb-server mariadb 
RUN mysql_install_db --user=mysql
ADD my.cnf /etc/my.cnf
#ADD full.sql /opt
ADD startup.sh /root

#RUN /usr/bin/mysqld_safe --datadir=/var/lib/mysql &
#RUN ls -l /var/lib/mysql
#RUN mysql  < /opt/full.sql &&  mysql -e "show databases;"


RUN yum clean all
RUN chmod +x /opt/startup.sh
#RUN ps -ef |grep mysql|grep -v grep |awk '{print $2}' |xargs kill -9
EXPOSE 3306  

CMD ["sh /root/startup.sh"]  
