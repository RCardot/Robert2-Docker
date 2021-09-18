FROM php:7.4-apache

MAINTAINER Mor1 <mor1@zelig.ch>

SHELL [ "/bin/sh", "-xe", "-c" ]

ENV DEBIAN_FRONTEND=noninteractive
ENV ROBERT_VERSION '0.15.0'
ARG ROBERT_HOSTNAME
ENV ROBERT_HOSTNAME ${ROBERT_HOSTNAME}

RUN set -xe \
    && apt-get update -q \
    && apt-get install -qy --no-install-recommends \
		unzip \
#		php-mysql \
#		php7.4-xml \
#		php7.4-mbstring \
#		php7.4-json \
#		php7.4-intl \
		nodejs \
		npm

# ADD ./ForBuild/install_php_composer.sh /tmp/install_php_composer.sh
# RUN /bin/sh /tmp/install_php_composer.sh
# RUN rm /tmp/install_php_composer.sh

WORKDIR /tmp
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir=/usr/bin --filename=composer
RUN php -r "unlink('composer-setup.php');"


# Install other PHP extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions intl pdo_mysql

# Get Robert2
# ADD https://github.com/Robert-2/Robert2/releases/download/${ROBERT_VERSION}/Robert2-${ROBERT_VERSION}.zip  /tmp/robert.zip
ADD https://github.com/Robert-2/Robert2/releases/download/0.15.0/Robert2-0.15.0.zip  /tmp/robert.zip
RUN unzip /tmp/robert.zip -d /tmp \
     && cd  /var/www/ \
     && cp -rvp /tmp/Robert2-${ROBERT_VERSION}/. /var/www/robert

# ADD ./ForBuild/apache2.conf /etc/apache2/apache2.conf

ADD apache2.conf /etc/apache2/apache2.conf
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

RUN rm /etc/apache2/sites-enabled/000-default.conf \
	&& ln -s /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-enabled/000-default.conf

WORKDIR /var/www/robert
RUN composer install --no-dev

RUN chmod -R 755 /var/www/robert \
	&& chown -R www-data:www-data /var/www \
	&& chown -R www-data:www-data /var/www/robert/src

RUN a2enmod rewrite 

EXPOSE 80
#VOLUME /var/www/documents

CMD ["apache2-foreground"]	