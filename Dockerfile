#imagen base
FROM php:7.3-stretch

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
    gnupg \
    gnupg1 \
    gnupg2 \
    zlib1g-dev \
    libzip-dev \
    libxml++2.6-dev \
    git \
    apt-transport-https \
    net-tools \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev

#instala llave para repositorio microsoft requisito(gnupg, gnupg1, gnupg2)
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/9/prod.list > /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update
RUN ACCEPT_EULA=Y apt-get install -y msodbcsql17 mssql-tools
RUN apt-get install unixodbc-dev -y
RUN pecl install sqlsrv pdo_sqlsrv

#Configura zip
#RUN docker-php-ext-configure zip --with-zlib-dir

#Instala y Configura GD
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

#Instala extensión zip, mbstring, pdo, pdo_mysql y luego activa las extensiones
RUN docker-php-ext-install zip mbstring pdo pdo_mysql bcmath soap gd && docker-php-ext-enable sqlsrv pdo_sqlsrv

#Instalar composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

#Aumenta memoria PHP
RUN echo 'memory_limit = 2G' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;

#XDebug para debuggear
#xdebug-3.1.6 : ultima version que soportada php 7.3, 7.4
RUN pecl install -f xdebug-3.1.6 \
&& docker-php-ext-enable xdebug \
&& echo "#zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so) \nxdebug.mode=debug \nxdebug.start_with_request=yes \nxdebug.discover_client_host=1 \nxdebug.client_port=9003 \nxdebug.log='/tmp/xdebug.log' \nxdebug.client_host=host.docker.internal" > /usr/local/etc/php/conf.d/xdebug.ini;

#Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_14.x -o nodesource_setup.sh && bash nodesource_setup.sh && apt-get -y install nodejs

#Copia archivo de configuración para desarrollo
RUN cp "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

#Inicia con usuario userapp
USER userapp

#inicio de la shell
CMD ["/bin/bash"]
