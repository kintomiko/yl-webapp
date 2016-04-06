#!/bin/bash

sh /init_mysql.sh

# initial db
cd /database/scripts
bash ./refresh-db.sh

# start tomcat
/usr/local/tomcat/bin/catalina.sh run
