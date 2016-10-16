#!/bin/bash

export MYSQL_DATA_DIR="/data/mysql/data"

function create_mysql_data {
    if [[ ! -d $MYSQL_DATA_DIR ]]; then
        echo "=> An empty or uninitialized MySQL volume is detected in $MYSQL_DATA_DIR"
        echo "=> Installing MySQL ..."
        /root/scripts/mysql.sh
        echo "=> Done!"  
    else
        echo "=> Using an existing volume of MySQL"
    fi
}

create_mysql_data
/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
