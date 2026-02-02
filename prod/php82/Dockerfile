#imagen base
FROM php:8.2-trixie

#carpeta predeterminada
WORKDIR /app

#RUN useradd -d /app userapp -s /bin/bash

#Desactivar modo interactivo
#ARG DEBIAN_FRONTEND=noninteractive

#Actualizar repositorio, instalar apt-utils, zip
RUN apt-get update && apt-get install -y --no-install-recommends \
    zip \
    unzip \ 
    vim \
    locate \
    gnupg \
    zlib1g-dev \
    libzip-dev\
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \ 
    git \
    rsync \
    && rm -rf /var/lib/apt/lists/*

#Configura extensiones zip y GD
RUN docker-php-ext-configure zip && \
    docker-php-ext-configure gd --with-freetype --with-jpeg

RUN docker-php-ext-install pdo gd zip pdo_mysql

#Instalar composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv composer.phar /usr/local/bin/composer

#Aumenta memoria PHP
RUN echo 'memory_limit = 2G' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini;

#Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_24.x -o nodesource_setup.sh && bash nodesource_setup.sh && apt-get -y install nodejs

#Inicia con usuario userapp
#USER userapp

#inicio de la shell
CMD ["/bin/bash"]

