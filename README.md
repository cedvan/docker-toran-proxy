# Docker Toran Proxy

Toran acts as a proxy for Packagist and GitHub. It is meant to be set up on your own server or even inside your office. This offers a few benefits:

- **Redundant infrastructure to ensure your deployments never fail and your developers can work at any time.** Packages will be installed from your proxy with a fallback to GitHub, ensuring a maximum availability.
- **Higher bandwidth for faster installations.** You can set up Toran in your local network or on a server near you.

## Quick start

```bash
docker run --name toran-proxy -d \
    -p 8080:80 \
    cedvan/toran-proxy:1.1.7-1
```
Go with your browser to **localhost:8080**

## Save data

Files are saved to `/data/toran-proxy` in container. Just mount this volume for save your configurations and repositories

```bash
docker run --name toran-proxy -d \
    -v /opt/toran-proxy:/data/toran-proxy \
    cedvan/toran-proxy:1.1.7-1
```

## Add ssh config for private repository

```bash
docker run --name toran-proxy -d \
    -p 8443:443 \
    -v /opt/toran-proxy/ssh:/data/toran-proxy/ssh \
    cedvan/toran-proxy:1.1.7-1
```
*Files supported : `id_rsa`, `id_rsa.pub` and `known_hosts`*

## Enabled HTTPS

```bash
docker run --name toran-proxy -d \
    -p 8443:443 \
    -e "TORAN_HTTPS=true" \
    -v /opt/toran-proxy/certs:/data/toran-proxy/certs \
    cedvan/toran-proxy:1.1.7-1
```
Add **toran-proxy.key** and **toran-proxy.crt** in folder **certs**

## Configure Cron timer

```bash
docker run --name toran-proxy -d \
    -p 8443:443 \
    -e "TORAN_CRON_TIMER=half" \
    cedvan/toran-proxy:1.1.7-1
```

### Generation of Self Signed Certificates

Generation of self-signed SSL certificates involves a simple 3 step procedure.

**STEP 1**: Create the server private key

```bash
openssl genrsa -out toran-proxy.key 2048
```

**STEP 2**: Create the certificate signing request (CSR)

```bash
openssl req -new -key toran-proxy.key -out toran-proxy.csr
```

**STEP 3**: Sign the certificate using the private key and CSR

```bash
openssl x509 -req -days 365 -in toran-proxy.csr -signkey toran-proxy.key -out toran-proxy.crt
```

Congratulations! you have now generated an SSL certificate thats valid for 365 days.

## Add reverse proxy to improve access

Just run docker container `jwilder/nginx-proxy` (cf https://github.com/jwilder/nginx-proxy/blob/master/README.md)

```bash
docker run --name proxy -d \
    -p 80:80 \
    -p 443:443 \
    -v /var/run/docker.sock:/tmp/docker.sock \
    -v /opt/proxy/certs:/etc/nginx/certs \
    jwilder/nginx-proxy
```

Next add environment variables **VIRTUAL_HOST** and **VIRTUAL_PROTO** to container toran-proxy

##### HTTP

```bash
docker run --name toran-proxy -d \
    -e "VIRTUAL_HOST=toran-proxy.domain.tld" \
    -e "VIRTUAL_PROTO=http" \
    cedvan/toran-proxy:1.1.7-1
```
Go with your browser to **http://toran-proxy.domain.tld**


##### HTTPS

```bash
docker run --name toran-proxy -d \
    -e "VIRTUAL_HOST=toran-proxy.domain.tld" \
    -e "VIRTUAL_PROTO=https" \
    -v /opt/toran-proxy/certs:/data/toran-proxy/certs \
    cedvan/toran-proxy:1.1.7-1
```
Go with your browser to **https://toran-proxy.domain.tld**


## Add HTTP Authentification to improve safety

Use file **htpasswd** to add authentification (cf https://github.com/jwilder/nginx-proxy/blob/master/README.md#basic-authentication-support) :

```bash
docker run --name proxy -d \
    -p 80:80 \
    -v /opt/proxy/htpasswd:/etc/nginx/htpasswd \
    jwilder/nginx-proxy
```

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
- **TORAN_HTTPS**: Set to `true` to enable https support, Defaults to `false`. **Do not forget to add the certificates files**
- **TORAN_CRON_TIMER**: Setup cron job timer. Defaults to `minutes`
    - `minutes`: All minutes
    - `five`: All five minutes
    - `fifteen`: All fifteen minutes
    - `half`: All thirty minutes
    - `hour`: All hours
    - `daily`: All days at 04:00 (Use *TORAN_CRON_TIMER_DAILY_TIME* for customize time)
- **TORAN_CRON_TIMER_DAILY_TIME**: Set a time for cron job daily timer in `HH:MM` format. Defaults to `04:00`
- **TORAN_TOKEN_GITHUB**: Add your Github token for ensure download repositories since Github. Default null.
- **TORAN_PHP_TIMEZONE**: Configure timezone PHP. Default `Europe/Paris`.

## Toran Proxy License

By default, Toran proxy license is for personal use.
You can add a license from the Toran proxy interface

## References

Toran is built by Jordi Boggiano, lead developer of Composer. As such he can make sure they work well together. No surprises.

- https://toranproxy.com/
- https://twitter.com/toranproxy
- https://getcomposer.org/doc/articles/handling-private-packages-with-satis.md
- https://github.com/jwilder/nginx-proxy
