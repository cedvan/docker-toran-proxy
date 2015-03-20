FROM cedvan/ubuntu:14.04.20150311
MAINTAINER dev@cedvan.com

# Install PHP and Nginx
RUN apt-get update -qq \
    && apt-get install -qqy \
        git \
        apt-transport-https \
        daemontools \
        php5-fpm \
        php5-json \
        php5-cli \
        php5-intl \
        php5-curl \
        nginx

# Configure PHP and Nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf \
    && sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini \
    && sed -i "s/;date.timezone.*/date.timezone = Europe\/Paris/" /etc/php5/fpm/php.ini \
    && sed -i "s/;date.timezone.*/date.timezone = Europe\/Paris/" /etc/php5/cli/php.ini \
    && sed -i "s/;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 0.0.0.0/" /etc/php5/fpm/pool.d/www.conf \
    && sed -i "s/^user\s*=.*/user = root/" /etc/php5/fpm/pool.d/www.conf \
    && sed -i "s/^group\s*=.*/group = root/" /etc/php5/fpm/pool.d/www.conf

# Download Toran Proxy
RUN curl -sL https://toranproxy.com/releases/toran-proxy-v1.1.6.tgz | tar xzC /tmp \
    && mv /tmp/toran /var/www

# Load Scripts bash for installing Toran Proxy
COPY bin /bin/toran-proxy/
RUN chmod u+x /bin/toran-proxy/*

# Load assets
COPY assets/vhosts /etc/nginx/sites-available
COPY assets/config /assets/config

VOLUME /data

EXPOSE 80
EXPOSE 443

CMD /bin/toran-proxy/launch.sh
