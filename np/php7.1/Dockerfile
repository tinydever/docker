#
# alpine-3.7 + openresty-1.13
#
#
FROM tinydever:fpm-7.1

ENV NGINX_VERSION nginx-1.13.6
ENV OPENRESTY_VERSION openresty-1.13.6.2

RUN apk --update add git openssl-dev pcre-dev zlib-dev perl curl sed build-base && \
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
    apk del build-base git curl sed && \
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
