FROM kindai/yl-service

RUN mkdir -p /etc/mysql/conf.d \
	&& { \
		echo '[mysqld]'; \
		echo 'skip-host-cache'; \
		echo 'skip-name-resolve'; \
		echo 'user = mysql'; \
		echo 'datadir = /var/lib/mysql'; \
		echo 'lower_case_table_names = 1'; \
		echo '!includedir /etc/mysql/conf.d/'; \
	} > /etc/mysql/my.cnf

COPY init_mysql.sh /init_mysql.sh
COPY init.sh /init.sh
COPY database /database
COPY jce_policy-8.zip /srv/java/jdk1.8.0_74/jre/lib/security/jce_policy-8.zip

RUN apt-get install -y unzip \
	&& cd /srv/java/jdk1.8.0_74/jre/lib/security \
	&& unzip jce_policy-8.zip \
	&& cp UnlimitedJCEPolicyJDK8/* .

COPY apps.war /usr/local/tomcat/webapps/
RUN chmod +x /init_mysql.sh /init.sh

ENTRYPOINT ["/init.sh"]
EXPOSE 8080
