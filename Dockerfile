FROM debian:stable-20201012

WORKDIR /var/www/

EXPOSE 80 

RUN set -eux

# Install needed packages
RUN apt-get update && apt-get install -y php-dom \
     php-dom \
     php7.3 \
     php-intl \
     php-mysql \
     composer \
     apache2 \
     nano \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*


# Deploy Robert2

RUN git clone https://github.com/Robert-2/Robert2.git

WORKDIR /Robert2/server

RUN composer install --no-dev 

COPY apache2.conf /etc/apache2/apache2.conf

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite

RUN chmod -R 777 /var/www/Robert2

CMD ["/usr/sbin/apache2", "-D",  "FOREGROUND"]

# Mount a shared volume
VOLUME robert-share /usr/shr