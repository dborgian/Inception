# Use Alpine as the base image
FROM alpine:3.19

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
# Install PHP and php-fpm

RUN 	apk update && apk upgrade && \
		apk add --no-cache \
		wget \
		tar \
		mariadb-client \
		redis \
		php81-cli \
		php81 php81-fpm \
		php81-bcmath \
        php81-curl \
        php81-dom \
        php81-gd \
        php81-mbstring \
        php81-mysqli \
        php81-openssl \
        php81-pdo \
        php81-pdo_mysql \
        php81-zip \
		php81-phar && \
	 # Install WP-CLI
	 wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	 chmod +x wp-cli.phar && \
	 mv wp-cli.phar /usr/local/bin/wp && \
	 which php81 && echo $PATH && php81 -v



RUN		wget https://it.wordpress.org/latest-it_IT.zip
RUN		unzip latest-it_IT.zip
RUN		mkdir -p /var/www/html
RUN		mv wordpress/ /var/www/html/wordpress
#RUN 	[ -d wordpress ] && mv wordpress/* /var/www/html/wordpress || echo "Directory wordpress/ non trovata o vuota"

#used to run as a non-root user.
#this can improve security by limiting the privileges of the web server 
#and reducing the risk of unauthorized access.
RUN		adduser -S nginx && addgroup -S nginx

#coping configuration files
COPY	conf/php-fpm.conf /etc/php81/php-fmp.conf
COPY	conf/www.conf	/etc/php81/php-fpm.d/www.conf
#COPY    conf/index.html /tmp/html/index.html


#downloads wp-cli from github and save it as a .phar file
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN cp wp-cli.phar /usr/bin/wp

#sets the working directory
WORKDIR	/var/www/html/wordpress

#copy the configuration script in tmp folder
COPY    script/configure.sh /tmp/configure.sh

#execute the configuration script just copied
ENTRYPOINT	[ "sh", "/tmp/configure.sh" ]