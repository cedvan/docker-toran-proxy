FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
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
        ssh
        git \
        apt-transport-https \
        daemontools \
        php7.2-fpm \
        php7.2-json \
        php7.2-cli \
        php7.2-intl \
        php7.2-curl \
        php7.2-xml \
        nginx \
        apache2-utils \
        && apt-get -y --purge autoremove \
        && apt-get clean \
        && rm -rf /var/lib/apt/lists/*

# Configure PHP and Nginx
RUN mkdir /run/php \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

# Version Toran Proxy
ENV TORAN_PROXY_VERSION 1.5.4

# Download Toran Proxy
RUN mkdir /scratch/
RUN curl -sL https://toranproxy.com/releases/toran-proxy-v${TORAN_PROXY_VERSION}.tgz | tar xzC /scratch \
    && mv /scratch/toran/* /var/www

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
