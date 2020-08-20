FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
MAINTAINER dev@cedvan.com
# Install requirements
RUN apt-get update -y \
    && apt-get install -y \
        curl \
        wget \
        ca-certificates \
        cron\
        sudo\
        git \
        unzip \
        supervisor \
        ssh \
        git \
        apt-transport-https \
        daemontools \
        php7.4-fpm \
        php7.4-json \
        php7.4-cli \
        php7.4-intl \
        php7.4-curl \
        php7.4-xml \
        nginx \
        apache2-utils \
        && apt-get -y --purge autoremove \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Configure PHP and Nginx
RUN mkdir /run/php \
    && echo "daemon off;" >> /etc/nginx/nginx.conf \
    && echo "ssl_session_cache shared:SSL:5m; ssl_session_timeout 1h;" >> /etc/nginx/conf.d/ssl_session.conf

# Version Toran Proxy
ENV TORAN_PROXY_VERSION 1.5.4

# Download Toran Proxy
RUN mkdir -p /var/www
RUN curl -sL https://toranproxy.com/releases/toran-proxy-v${TORAN_PROXY_VERSION}.tgz | tar xzC /tmp \
    && mv /tmp/toran/* /var/www

# Load Scripts bash for installing Toran Proxy
COPY scripts /scripts/toran-proxy/
RUN chmod -R u+x /scripts/toran-proxy

# Load binaries
COPY bin /bin/toran-proxy/
RUN chmod -R u+x /bin/toran-proxy
ENV PATH $PATH:/bin/toran-proxy

# Load assets
COPY assets/supervisor/conf.d /etc/supervisor/conf.d
COPY assets/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY assets/vhosts /etc/nginx/sites-available
COPY assets/config /assets/config

VOLUME /data/toran-proxy

EXPOSE 80
EXPOSE 443

CMD /scripts/toran-proxy/launch.sh
