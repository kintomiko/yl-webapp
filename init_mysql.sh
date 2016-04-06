#!/bin/bash

if [ -z "${MYSQL_ROOT_PASSWORD}" ]; then
	MYSQL_ROOT_PASSWORD=123123
fi

DATADIR="$(mysqld --verbose --help --log-bin-index=`mktemp -u` 2>/dev/null | awk '$1 == "datadir" { print $2; exit }')"
mkdir -p "$DATADIR"
chown -R mysql:mysql "$DATADIR"

echo 'Initializing database'
mysql_install_db --user=mysql --datadir="$DATADIR" --rpm --basedir=/usr/local/mysql
echo 'Database initialized'

chown -R mysql:mysql "$DATADIR"

mysqld &

echo "wating mysql to start"
sleep 10


echo "setting mysql password as"
echo ${MYSQL_ROOT_PASSWORD}
mysql -uroot -e "use mysql;update user set password=password(${MYSQL_ROOT_PASSWORD}) where user='root';flush privileges;"
echo "finish setting password"
