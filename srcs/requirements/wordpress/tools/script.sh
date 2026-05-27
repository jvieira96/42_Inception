#!/bin/bash

while ! mysqladmin ping -h $WORDPRESS_DB_HOST --silent; do
    sleep 1
done

if [ ! -f /var/www/html/wordpress/wp-config.php ]; then
    wp core download --path=/var/www/html/wordpress --allow-root

    wp config create --path=/var/www/html/wordpress \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=$WORDPRESS_DB_HOST \
        --allow-root

    wp core install --path=/var/www/html/wordpress \
        --url=$WORDPRESS_URL \
        --title=$WORDPRESS_TITLE \
        --admin_user=$WORDPRESS_ADMIN_USER \
        --admin_password=$WORDPRESS_ADMIN_PASSWORD \
        --admin_email=$WORDPRESS_ADMIN_EMAIL \
        --allow-root
    
    wp user create $WORDPRESS_USER $WORDPRESS_USER_EMAIL \ 
        --user_pass=$WORDPRESS_USER_PASSWORD \
        --role=author \
        --path=/var/www/html/wordpress \
        --allow-root
fi

exec php-fpm7.4 -F
