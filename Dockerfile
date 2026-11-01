FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    zip \
    unzip \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY composer.json composer.lock ./

RUN composer install --no-dev --no-scripts --no-interaction

COPY . .

RUN cp .env.example .env \
    && composer dump-autoload --no-dev --optimize --no-scripts \
    && APP_ENV=prod APP_SECRET=build-time-placeholder composer run-script auto-scripts --no-interaction \
    && mkdir -p var/cache var/log \
    && chown -R www-data:www-data var \
    && chmod -R 775 var

EXPOSE 9000

CMD ["php-fpm"]
