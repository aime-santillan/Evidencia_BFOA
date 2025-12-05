
# Usa una imagen base oficial de PHP (ajusta la versión y el servidor web según necesites)
FROM php:8.2-fpm
# Antes de PHP-FPM
RUN usermod -u 1000 www-data
# Instala dependencias necesarias
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*
RUN git config --global --add safe.directory /var/www/html

# Instala Composer globalmente
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Instala Node.js y npm
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /var/www/html

# Instala extensiones de PHP, incluyendo ZIP y GD
# libzip-dev: Necesario para la extensión 'zip' (resuelve openspout/phpspreadsheet)
# libpng-dev: Necesario para la extensión 'gd'
# libfreetype-dev: Útil para GD (manejo de fuentes)
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libicu-dev \
    libpng-dev \
    libfreetype-dev \
    libjpeg-dev \
    && rm -rf /var/lib/apt/lists/*

# Configura e instala las extensiones de PHP
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo pdo_mysql mysqli zip gd\

#archivos de configuracion
COPY docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini
COPY docker/php-fpm/www.conf /usr/local/etc/php-fpm.d/zzz-custom.conf

# Copia el código de tu aplicación al directorio de trabajo del contenedor
# Nota: La vinculación (mount) en Compose hará que esto sea menos crítico, pero es una buena práctica.
COPY . /var/www/html/


# Por defecto, la imagen php:apache ya configura el puerto 80.
EXPOSE 80
