FROM ubuntu:trusty
MAINTAINER Boris Gorbylev <ekho@ekho.name>

# Version Toran Proxy
ENV TORAN_PROXY_VERSION 1.4.2

# Install software
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    daemontools \
    git \
    net-tools \
    nginx \
    php5-cli \
    php5-curl \
    php5-fpm \
    php5-intl \
    php5-json \
    ssh \
    supervisor \
    unzip \
    wget \
  && apt-get autoremove -y \
  && apt-get autoclean all \
  && rm -rf /var/lib/apt/lists/*

COPY scripts /scripts/toran-proxy/
COPY assets/supervisor/conf.d /etc/supervisor/conf.d
COPY assets/supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY assets/vhosts /etc/nginx/sites-available
COPY assets/config /assets/config

RUN echo "daemon off;" >> /etc/nginx/nginx.conf \
 && curl -sL https://toranproxy.com/releases/toran-proxy-v${TORAN_PROXY_VERSION}.tgz | tar xzC /tmp \
 && mv /tmp/toran /var/www \
 && chmod -R u+x /scripts/toran-proxy

ENV PATH $PATH:/scripts/toran-proxy

VOLUME /data/toran-proxy

EXPOSE 80 443

CMD /scripts/toran-proxy/launch.sh
