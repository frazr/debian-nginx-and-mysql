#!/bin/bash
set -eo pipefail
shopt -s nullglob

if [ ! -d "$MYSQL_DATA_DIR" ]; then
	if [ -z "$MYSQL_ROOT_PASSWORD" ]; then
		echo >&2 '  No MYSQL_ROOT_PASSWORD specified, generating a random password.'
		echo >&2 '  Generating a random password. '
		MYSQL_ROOT_PASSWORD=$(pwgen -cnysB 50 1)
		SECRET_FILE=/data/secrets/mysql
		echo >&2 '  Storing random password in '$SECRET_FILE
		mkdir -p /data/secrets
		echo "$MYSQL_ROOT_PASSWORD" > $SECRET_FILE
		chmod 400 $SECRET_FILE
	fi

	mysql_install_db \
		--user=mysql \
		--datadir=/data/mysql/data 

	mkdir -p "$MYSQL_DATA_DIR"

 	# start mysql server
    echo "Starting MySQL server..."
    /usr/bin/mysqld_safe >/dev/null 2>&1 &

    # wait for mysql server to start (max 30 seconds)
    timeout=30
    echo -n "Waiting for database server to accept connections"
    while ! /usr/bin/mysqladmin -u root status >/dev/null 2>&1
    do
      timeout=$(($timeout - 1))
      if [ $timeout -eq 0 ]; then
        echo -e "\nCould not connect to database server. Aborting..."
        exit 1
      fi
      echo -n "."
      sleep 1
    done
    echo

	/usr/bin/mysqladmin -u root password "$MYSQL_ROOT_PASSWORD"
	killall mysqld
	sleep 10s

	echo
	echo 'MySQL init process done. Ready for start up.'
	echo
fi