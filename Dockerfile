FROM ubuntu:14.04
MAINTAINER dev@cedvan.com

# Install requirements
RUN apt-get update -qq \
    && apt-get install -qqy \
        curl \
        wget \
        ca-certificates \
        unzip

# Install supervisor
RUN apt-get update -qq \
    && apt-get install -qqy supervisor

# Install ssh
RUN apt-get update -qq \
    && apt-get install -qqy ssh

# Install PHP 7 repo
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -qqy software-properties-common \
    && LANG=C.UTF-8 add-apt-repository -y ppa:ondrej/php \
    && apt-get purge -qqy software-properties-common

# Install PHP and Nginx
RUN apt-get update -qq \
    && apt-get install -qqy \
        git \
        apt-transport-https \
        daemontools \
        php7.1-fpm \
        php7.1-json \
        php7.1-cli \
        php7.1-intl \
        php7.1-curl \
        php7.1-xml \
        nginx \
        apache2-utils

# Configure PHP and Nginx
RUN mkdir /run/php \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

# Version Toran Proxy
ENV TORAN_PROXY_VERSION 1.5.4

# Download Toran Proxy
RUN curl -sL https://toranproxy.com/releases/toran-proxy-v${TORAN_PROXY_VERSION}.tgz | tar xzC /tmp \
    && mv /tmp/toran /var/www

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

# Clean
RUN apt-get -qqy --purge autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

VOLUME /data/toran-proxy

EXPOSE 80
EXPOSE 443

CMD /scripts/toran-proxy/launch.sh
