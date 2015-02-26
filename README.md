# Docker Toran Proxy

Toran acts as a proxy for Packagist and GitHub. It is meant to be set up on your own server or even inside your office. This offers a few benefits:

- **Redundant infrastructure to ensure your deployments never fail and your developers can work at any time.** Packages will be installed from your proxy with a fallback to GitHub, ensuring a maximum availability.
- **Higher bandwidth for faster installations.** You can set up Toran in your local network or on a server near you.

## Quick start

```bash
docker run --name toran-proxy -d \
    -p 8080:80 \
    cedvan/toran-proxy:1.1.6
```
Go with your browser to **localhost:8080**

## Save data

Files are saved to `/var/www` in container. Just mount this volume for save your configurations and repositories

```bash
docker run --name toran-proxy -d \
    -v /opt/toran-proxy:/var/www \
    cedvan/toran-proxy:1.1.6
```

## Enabled HTTPS

```bash
docker run --name toran-proxy -d \
    -p 8443:443
    -e "TORAN_HTTPS=true" \
    -v /opt/toran-proxy/certs:/var/www/certs \
    cedvan/toran-proxy:1.1.6
```
Add **toran-proxy.key** and **toran-proxy.crt** in folder **certs**

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

- Install **nginx** (cf http://wiki.nginx.org/Install)
- Create **/etc/nginx/conf.d/proxy.conf**
```
proxy_redirect              off;
proxy_set_header            Host            $host;
proxy_set_header            X-Real-IP       $remote_addr;
proxy_set_header            X-Forwarded-For $proxy_add_x_forwarded_for;
client_max_body_size        10m;
client_body_buffer_size     128k;
client_header_buffer_size   64k;
proxy_connect_timeout       90;
proxy_send_timeout          90;
proxy_read_timeout          90;
proxy_buffer_size           16k;
proxy_buffers               32 16k;
proxy_busy_buffers_size     64k;
```
- Create **/etc/nginx/sites-available/toran-proxy.conf**
    - For HTTP
    ```
    server {
            listen 80;
            server_name toran-proxy.domain.tld;

            location / {
                    proxy_pass https://localhost:8080/;
            }
    }
    ```
    - For HTTPS
    ```
    server {
            listen 80;
            server_name toran-proxy.domain.tld;
            rewrite ^/(.*) https://toran-proxy.domain.tld/$1 permanent;
    }

    server {
            listen 443;
            server_name toran-proxy.domain.tld;

            ssl on;
            ssl_certificate /opt/toran-proxy/certs/toran-proxy.crt;
            ssl_certificate_key /opt/toran-proxy/certs/toran-proxy.key;

            location / {
                proxy_pass https://localhost:8443/;
            }
    }
    ```
- Create **symbolic link** for enabled reverse proxy `ln -s /etc/nginx/sites-available/toran-proxy.conf /etc/nginx/sites-enabled/toran-proxy.conf`
- Restart **nginx** `sudo service nginx restart`


## Add HTTP Authentification to improve safety

- Add **auth_basic** and **auth_basic_user_file** to your reverse proxy
- Add **.htpasswd**

```
    location / {
        auth_basic "Toran proxy protected";
        auth_basic_user_file  /opt/toran-proxy/.htpasswd;
        proxy_pass http://localhost:8080/;
    }
```


## Toran Proxy Options

*Please refer the docker run command options for the `--env-file` flag where you can specify all required environment variables in a single file. This will save you from writing a potentially long docker run command. Alternately you can use fig.*

Below is the complete list of available options that can be used to customize your toran proxy installation.

- **TORAN_HOST**: The hostname of the toran proxy server. Defaults to `localhost`
- **TORAN_HTTPS**: Set to `true` to enable https support, Defaults to `false`. **Do not forget to add the certificates files**
- **TORAN_PACKAGIST**: Enabled packagist proxy repository. Possible configuration options are `proxy` and `false`. Defaults to `proxy`
- **TORAN_SYNC**: Snchronization mode. Possible configuration options are `lazy`, `all` and `new`. Defaults to `lazy`
    - `lazy` : Every archive is built on demand when you first install a given package's version
    - `new` : Tags newer than the oldest version you have used will be pre-cached as soon as they are available
    - `all` : All releases will be pre-cached as they become available
- **TORAN_TOKEN_GITHUB**: Add your Github token for ensure download repositories since Github. Default null.

## Toran Proxy License

By default, Toran proxy license is for personal use.
You can add a license from the Toran proxy interface

## References

Toran is built by Jordi Boggiano, lead developer of Composer. As such he can make sure they work well together. No surprises.

- https://toranproxy.com/
- https://twitter.com/toranproxy
- https://getcomposer.org/doc/articles/handling-private-packages-with-satis.md
