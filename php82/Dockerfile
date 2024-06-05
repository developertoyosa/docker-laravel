#imagen base
FROM php:8.2.18-bookworm

#carpeta predeterminada
WORKDIR /project

RUN useradd -d /project userapp -s /bin/bash

#Desactivar modo interactivo
#ARG DEBIAN_FRONTEND=noninteractive

#Actualizar repositorio, instalar apt-utils, zip, git
 RUN apt-get update \
     && apt-get install -y \
     zip \
     nano \
     locate \
     gnupg 
#     zlib1g-dev \
#     libzip-dev \
#     libxml++2.6-dev \
#     git \
#     net-tools \
#     libfreetype6-dev \
#     libjpeg62-turbo-dev \
#     libmcrypt-dev

#https://learn.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver16

#Debian 12
# instala llave para repositorio microsoft requisito(gnupg)
RUN curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft-prod.gpg
RUN curl https://packages.microsoft.com/config/debian/12/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql18
RUN apt-get install -y unixodbc-dev
RUN pecl install sqlsrv-5.12.0 pdo_sqlsrv-5.12.0

#Configura zip
#RUN docker-php-ext-configure zip --with-zlib-dir

# #Instala y Configura GD
# RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install pdo pdo_mysql && docker-php-ext-enable sqlsrv pdo_sqlsrv

#Instalar composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

#Aumenta memoria PHP
RUN echo 'memory_limit = 2G' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;

#XDebug para debuggear
#xdebug-3.3.2 : version soportada para php 8.2.x
RUN pecl install -f xdebug-3.3.2 \
 && docker-php-ext-enable xdebug \
 && echo "#zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so) \nxdebug.mode=debug \nxdebug.start_with_request=yes \nxdebug.discover_client_host=1 \nxdebug.client_port=9003 \nxdebug.log='/tmp/xdebug.log' \nxdebug.client_host=host.docker.internal" > /usr/local/etc/php/conf.d/xdebug.ini;

#Install nodejs 20.x
RUN curl -sL https://deb.nodesource.com/setup_20.x -o nodesource_setup.sh && bash nodesource_setup.sh && apt-get -y install nodejs

#Copia archivo de configuración para desarrollo
RUN cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

#Inicia con usuario userapp
USER userapp

#inicio de la shell
CMD ["/bin/bash"]
