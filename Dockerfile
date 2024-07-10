# https://github.com/docker-library/php/blob/master/8.2/alpine3.20/fpm/Dockerfile
FROM php:8.2-fpm-alpine

# 使用阿里云镜像
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 安装PHP开发以及运行所需扩展
RUN apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libwebp-dev libjpeg-turbo-dev \
    && apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    && pecl install redis \
    && docker-php-ext-enable redis.so \
    && docker-php-ext-install pdo pdo_mysql mysqli \
    && docker-php-ext-install bcmath \
    && docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype \
    && docker-php-ext-install gd \
    # 安装zip
    && apk add --no-cache libzip-dev \
    && docker-php-ext-install zip \
    # 删除依赖
    && apk del .build-deps

# 默认向外暴露9000端口
EXPOSE 9000

# 工作目录
WORKDIR /data/wwwroot

CMD ["php-fpm"]
