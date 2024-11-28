#!/bin/sh

# Creazione della directory per mysqld
if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
    chown -R mysql:mysql /run/mysqld
fi

# Inizializzazione del database se non esiste
if [ ! -d "/var/lib/mysql/mysql" ]; then
    chown -R mysql:mysql /var/lib/mysql

    # Inizializza il database
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    # Creazione di un file temporaneo
    tfile=$(mktemp)
    if [ ! -f "$tfile" ]; then
        exit 1
    fi

    # SQL per configurare MariaDB
    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE CHARACTER SET utf8 COLLATE utf8_general_ci;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

    # Esecuzione dello script SQL
    /usr/bin/mysqld --user=mysql --bootstrap < $tfile
    rm -f $tfile
fi

# Abilita connessioni remote
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

# Avvia MariaDB
exec /usr/bin/mysqld --user=mysql --console
