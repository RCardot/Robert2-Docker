FROM debian:stable-20201012

WORKDIR /var/www/

EXPOSE 80 

RUN set -eux

# Install needed packages
RUN apt update \
&& apt install -y php-dom \
&& apt install -y php7.3 \
&& apt install -y php-intl \
&& apt install -y php-mysql \
&& apt install -y composer \
&& apt install -y apache2 \
&& apt install -y nano


# Deploy Robert2
RUN git clone https://github.com/Robert-2/Robert2.git
RUN cd Robert2/server \
&& composer install --no-dev 

COPY apache2.conf /etc/apache2/apache2.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite
RUN chmod -R 777 /var/www/Robert2
RUN service apache2 restart

CMD apachectl -D FOREGROUND

# Mount a shared volume
VOLUME robert-share /usr/shr