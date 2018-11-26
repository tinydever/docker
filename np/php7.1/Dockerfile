#
# alpine-3.7 + openresty-1.13
#
#
FROM tinydever/php-alpine:fpm-7.1

#nginx
ENV NGINX_VERSION nginx-1.13.6
ENV OPENRESTY_VERSION openresty-1.13.6.2

#php-fpm
ENV MAX_CHILDREN 50
ENV START_SERVERS 5
ENV MIN_SPARE_SERVERS 5
ENV MAX_SPARE_SERVERS 35

#not use default nginx form php-fpm user www-data
#	addgroup -S nginx && \
#	adduser -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx && \
RUN apk --update add git \
    openssl-dev \
    pcre-dev \
    zlib-dev \
    perl \
    curl \
    sed \
    supervisor \
    build-base && \
    mkdir -p /tmp/src && \
    mkdir -p /var/log/supervisor && \
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
        --user=www-data \
	--group=www-data \
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
    apk del build-base git curl sed && \
    rm -rf /tmp/src && \
    rm -rf /var/cache/apk/* && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log
    
    
ADD nginx.conf /etc/openresty/nginx/conf/nginx.conf
ADD nginx.vh.default.conf /etc/openresty/nginx/conf/default.conf
ADD supervisord.conf /etc/supervisord.conf
ADD start.sh /start.sh

#VOLUME ["/var/log/nginx"]
#VOLUME ["/var/www/html"]

RUN chmod +x /start.sh

EXPOSE 443 80

WORKDIR "/var/www/html"
CMD ["/start.sh"]
