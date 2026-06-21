FROM php:8.2-cli
RUN apt-get update && apt-get install -y git curl zip unzip libpng-dev libxml2-dev libzip-dev nodejs npm && docker-php-ext-install pdo pdo_mysql mbstring xml zip gd
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /app
COPY . .
RUN composer install --no-dev --optimize-autoloader
RUN npm install && npm run build
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache
EXPOSE 8000
CMD php artisan migrate --force && php artisan serve --host=0.0.0.0 --port=$PORT
