# Docker Toran Proxy

## Quick start

```bash
docker run --name toran-proxy -d \
    -p 8080:80 \
    -e "TORAN_PROXY_HOST=localhost" \
    cedvan/toran-proxy:latest
```
**TORAN_PROXY_HOST** is **required**

Go in your browser to **localhost:8080**

## Save data

```bash
docker run --name toran-proxy -d \
    -v /opt/toran-proxy:/var/www \
    cedvan/toran-proxy:latest
```

## Enabled HTTPS

```bash
docker run --name toran-proxy -d \
    -p 8443:443
    -e "TORAN_PROXY_HTTPS=true" \
    -v /opt/toran-proxy/certs:/var/www/certs \
    cedvan/toran-proxy:latest
```
Add **toran-proxy.key** and **toran-proxy.crt** in folder **certs**
