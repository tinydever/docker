# PHP + nginx
#
# VERSION 7.2+

FROM php:7.2-fpm

ENV MAX_CHILDREN 50
ENV START_SERVERS 5
ENV MIN_SPARE_SERVERS 5
ENV MAX_SPARE_SERVERS 35
ENV NGINX_VERSION nginx-1.13.6
ENV OPENRESTY_VERSION openresty-1.13.6.2

RUN apt-get update && apt-get install -y \
        libpng-dev \
        pkg-config \
        libssl-dev \
        libsasl2-dev \
        libxml2-dev \
        gettext \
        libmcrypt-dev \
        libxslt-dev \
        libmemcached-dev \
  && docker-php-ext-install gd pdo pdo_mysql mysqli shmop sockets sysvsem xsl iconv zip  bcmath xmlrpc soap intl gettext pcntl \
  && docker-php-ext-install opcache


RUN pecl install redis \
  && pecl install mongodb \
  && pecl install memcached \
  && pecl install swoole \
  && docker-php-ext-enable redis mongodb  memcached swoole



RUN sed -i 's/pm.max_children = 5/pm.max_children = ${MAX_CHILDREN}/g' /usr/local/etc/php-fpm.d/www.conf  \
  && sed -i 's/pm.start_servers = 2/pm.start_servers = ${START_SERVERS}/g' /usr/local/etc/php-fpm.d/www.conf \
  && sed -i 's/pm.min_spare_servers = 1/pm.min_spare_servers = ${MIN_SPARE_SERVERS}/g' /usr/local/etc/php-fpm.d/www.conf \
  && sed -i 's/pm.max_spare_servers = 3/pm.max_spare_servers = ${MAX_SPARE_SERVERS}/g' /usr/local/etc/php-fpm.d/www.conf


RUN apt-get install -y git openssl-dev pcre-dev zlib-dev perl curl sed build-base && \
	addgroup -S nginx && \
	adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx && \
    mkdir -p /tmp/src && \
    cd /tmp/src && \
    curl -fSL https://openresty.org/download/${OPENRESTY_VERSION}.tar.gz -o nginx.tar.gz && \
    tar -zxvf nginx.tar.gz && \
    rm -rf nginx.tar.gz && \
    git clone git://github.com/alibaba/nginx-http-concat.git /tmp/src/nginx-http-concat && \
    sed -i '/ngx_string("application\/x-javascript"),/a\    ngx_string("application\/javascript"),'  /tmp/src/nginx-http-concat/ngx_http_concat_module.c && \
    cd /tmp/src/${OPENRESTY_VERSION} && \
    sed -i 's/1.13.6/x/g' bundle/${NGINX_VERSION}/src/core/nginx.h && \
    sed -i 's/\"openresty\/\" NGINX_VERSION \".2\"/\"web\/\" NGINX_VERSION/g' bundle/${NGINX_VERSION}/src/core/nginx.h && \
    ./configure \
        --user=nginx \
		--group=nginx \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
        --with-stream_ssl_module \
        --prefix=/etc/openresty \
        --http-log-path=/var/log/nginx/access.log \
        --error-log-path=/var/log/nginx/error.log \
        --sbin-path=/usr/local/sbin/nginx  \
        --add-module=/tmp/src/nginx-http-concat && \
    make && \
    make install && \
    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/*

RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/openresty/nginx/conf/nginx.conf
COPY nginx.vh.default.conf /etc/openresty/nginx/conf/default.conf

VOLUME ["/var/log/nginx"]

WORKDIR /etc/openresty

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
