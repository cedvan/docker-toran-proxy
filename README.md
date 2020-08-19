# Docker Toran Proxy

[![Version](https://images.microbadger.com/badges/version/cedvan/toran-proxy:1.5.4-2.svg)](https://microbadger.com/images/cedvan/toran-proxy:1.5.4-2 "Get your own version badge on microbadger.com")
[![Docker Pulls](https://img.shields.io/docker/pulls/cedvan/toran-proxy.svg?style=flat-square)](https://hub.docker.com/r/cedvan/toran-proxy/)
[![Docker Stars](https://img.shields.io/docker/stars/cedvan/toran-proxy.svg?style=flat-square)](https://hub.docker.com/r/cedvan/toran-proxy/)
[![Docker image](https://images.microbadger.com/badges/image/cedvan/toran-proxy.svg?style=flat-square)](https://microbadger.com/#/images/cedvan/toran-proxy "Size docker image on Docker Hub")
[![Build Status](https://img.shields.io/travis/cedvan/docker-toran-proxy/master.svg?style=flat-square)](https://travis-ci.org/cedvan/docker-toran-proxy)
[![Join the chat at https://gitter.im/cedvan/docker-toran-proxy](https://badges.gitter.im/cedvan/docker-toran-proxy.svg)](https://gitter.im/cedvan/docker-toran-proxy?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![GitHub license](https://img.shields.io/:license-mit-blue.svg?style=flat-square)]()

![toran-proxy](https://raw.githubusercontent.com/cedvan/docker-toran-proxy/master/img/toran-proxy.png "Toran-Proxy")

---

:warning: | **Toran proxy stating no longer supported and that people should use Private Packagist at https://packagist.com instead**
------------ | -------------

---

Toran acts as a proxy for Packagist and GitHub. It is meant to be set up on your own server or even inside your office. This offers a few benefits:

- **Redundant infrastructure to ensure your deployments never fail and your developers can work at any time.** Packages will be installed from your proxy with a fallback to GitHub, ensuring a maximum availability.
- **Higher bandwidth for faster installations.** You can set up Toran in your local network or on a server near you.

## Quick start

```bash
docker run --name toran-proxy -d \
    -p 80:80 \
    cedvan/toran-proxy:1.5.4-2
```
Go with your browser to **localhost**

## Save data

Files are saved to `/data/toran-proxy` in container. Just mount this volume for save your configurations and repositories

```bash
docker run --name toran-proxy -d \
    -v /opt/toran-proxy:/data/toran-proxy \
    cedvan/toran-proxy:1.5.4-2
```

## Add ssh config for private repository

```bash
docker run --name toran-proxy -d \
    -p 443:443 \
    -v /opt/toran-proxy/ssh:/data/toran-proxy/ssh \
    cedvan/toran-proxy:1.5.4-2
```
*Files supported : `id_rsa`, `id_rsa.pub`, `config` and `known_hosts`*

## Configure Cron timer

```bash
docker run --name toran-proxy -d \
    -p 443:443 \
    -e "TORAN_CRON_TIMER=half" \
    cedvan/toran-proxy:1.5.4-2
```

## Enabled HTTPS

```bash
docker run --name toran-proxy -d \
    -p 443:443 \
    -e "TORAN_HTTPS=true" \
    -v /opt/toran-proxy/certs:/data/toran-proxy/certs \
    cedvan/toran-proxy:1.5.4-2
```
Add your **toran-proxy.key** and **toran-proxy.crt** in folder **certs**. If `toran-proxy.key` and `toran-proxy.crt` do not exist, the container will create self-signed certificates

## HTTP Authentification

Use file **htpasswd** to add authentification ?

Add `auth.json` to composer configuration home folder

```
{
    "http-basic": {
        "toran-proxy.domain.tld": {
            "username": "myUsername",
            "password": "myPassword"
        },
    }
}
```

## Toran Proxy Options

*Please refer the docker run command options for the `--env-file` flag where you can specify all required environment variables in a single file. This will save you from writing a potentially long docker run command. Alternately you can use fig.*

Below is the complete list of available options that can be used to customize your toran proxy installation.

- **TORAN_HOST**: The hostname of the toran proxy server. Defaults to `localhost`
- **TORAN_HTTP_PORT**: The port of the toran http server. Defaults to `80`
- **TORAN_HTTPS**: Set to `true` to enable https support, Defaults to `false`. **If you do not use a reverse proxy, do not forget to add the certificates files**
- **TORAN_HTTPS_PORT**: The port of the toran https server. Defaults to `443`
- **TORAN_REVERSE**: Set to `true` if you use docker behind a reverse proxy for i.e. ssl termination. This will make Toran use the HTTPS scheme without the need to add certificates. If you do so, make sure to set your reverse proxy to target port 443. Defaults to `false`
- **TORAN_CRON_TIMER**: Setup cron job timer. Defaults to `fifteen`
    - `minutes`: All minutes
    - `five`: All five minutes
    - `fifteen`: All fifteen minutes
    - `half`: All thirty minutes
    - `hour`: All hours
    - `daily`: All days at 04:00 (Use *TORAN_CRON_TIMER_DAILY_TIME* for customize time)
- **TORAN_CRON_TIMER_DAILY_TIME**: Set a time for cron job daily timer in `HH:MM` format. Defaults to `04:00`
- **TORAN_TOKEN_GITHUB**: Add your Github token for ensure download repositories since Github. Default `null`.
- **TORAN_TRACK_DOWNLOADS**: Track private package installs, set to `true` to get an install log in `/data/toran-proxy/logs/downloads.private.log`. Defaults to `false`
- **TORAN_MONO_REPO**: Set to `true` for switch to a monorepo instead of dual repo model. Defaults to `false`
- **PHP_TIMEZONE**: Configure timezone PHP. Default `Europe/Paris`.
- **TORAN_AUTH_ENABLE**: Set to `true` to enable HTTP Basic Authentication. When enabled, `TORAN_AUTH_USER` and `TORAN_AUTH_PASSWORD` are required. Defaults to `false`.
- **TORAN_AUTH_USER**: Configure the HTTP Basic Authentication Username. Defaults to `toran`.
- **TORAN_AUTH_PASSWORD**: Configure the HTTP Basic Authentication Password. Defaults to `toran`.

## Add customization scripts

For scenarios where the degree of configurability his image offers via the
above listed options is not sufficient, you are able to add container local
customization scripts which will get executed during container runtime. Here
you can add for example sed calls which further tweak the nginx configuration.

The container `launch.sh` script expects custom scripts to be found under
`/data/toran-proxy/scripts/*.sh`. These scripts just get sourced in order.

```bash
export custdir=/tmp/toran-customs
mkdir -p $custdir
echo "echo 'hello world'" > $custdir/hello.sh
docker run --name toran-proxy -d \
    -p 443:443 \
    -v $custdir:/data/toran-proxy/scripts
    cedvan/toran-proxy:1.5.4-2
```

## Toran Proxy License

By default, Toran proxy license is for personal use.
You can add a license from the Toran proxy interface

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md) file.

## References

Toran is built by Jordi Boggiano, lead developer of Composer. As such he can make sure they work well together. No surprises.

- https://toranproxy.com/
- https://twitter.com/toranproxy
- https://getcomposer.org/doc/articles/handling-private-packages-with-satis.md
- https://github.com/jwilder/nginx-proxy
