#!/bin/sh

# Attendere che il database sia disponibile
while ! mariadb -h$MYSQL_HOSTNAME -u$MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE &>/dev/null; do
    sleep 3
done

# Controllo se WordPress è già installato
if [ ! -f "/var/www/html/wordpress/wp-config.php" ]; then
   
    echo "Configurando il file wp-config.php"
    /usr/bin/php81 /usr/local/bin/wp config create --dbname=$MYSQL_DATABASE --dbuser=$MYSQL_USER --dbpass=$MYSQL_PASSWORD --dbhost=$MYSQL_HOSTNAME --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root

    /usr/bin/php81 /usr/local/bin/wp core install --url=$DOMAIN_NAME --title=dborgian --admin_user=$WP_USER_ADMIN --admin_password=$WP_PWD_ADMIN --admin_email=$WP_EMAIL_ADMIN --skip-email --allow-root

    /usr/bin/php81 /usr/local/bin/wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$PASSWORD_WP --allow-root

    /usr/bin/php81 /usr/local/bin/wp theme install bizboost --activate --allow-root
else
    echo "WordPress è già installato."

fi

if [ ! -f "/usr/sbin/php-fpm8" ]; then
     /usr/sbin/php-fpm81 -F -R
else
    echo "PHP-FPM non trovato, verificare l'installazione."
    exit 1
fi

# Avvia PHP-FPM
/usr/sbin/php-fpm81 -F -R
