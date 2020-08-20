# Changelog

**latest**
- Enable HTTP/2 in Nginx.

**1.5.4-2**
- Upgrade Ubuntu 18.04 to 20.04
- Upgrade PHP 7.2 to 7.4

**1.5.4-1**
- Derive `TORAN_SCHEME` from `TORAN_HTTPS` resp. `TORAN_HTTP` which allows toran to spit out HTTPS links despite being addressed via HTTP (reverse proxy scenario)
- Upgrade PHP 7.1 to PHP 7.2
- Remove unnecessary PPA
- Upgrade Ubuntu 14.04 to 18.04
- Optimize layers by doing all apt and purge as a single run. (Down from 499MB to 355MB)
- Fix the tarball extract and copy

**1.5.4**
- Add custom scripts directory `/data/toran-proxy/scripts` for user customizations to be executed on startup
- Update FROM to `ubuntu:14.04`
- Upgrade to PHP 7.1
- Upgrade toran proxy to 1.5.4

**1.5.3-1**
- Enabling HTTP Basic Authentication configuration with `TORAN_AUTH_ENABLE`, `TORAN_AUTH_USER`, and `TORAN_AUTH_PASSWORD` env vars.
- Fix load toran logs
- Fix permissions on packagist directory

**1.5.3**
- Upgrade toran proxy to version 1.5.3
- Fixing wrong declaration of cron "hour" value.

**1.5.2**
- Upgrade toran proxy to version 1.5.2
- Redirection `http` to `https` auto with use https vhost type
- Generate self-signed certificates automatically
- Clean create and permissions on logs directory
- Add option `TORAN_HTTP_PORT` to allow arbitrary http port for nginx / toran proxy
- Add option `TORAN_HTTPS_PORT` to allow arbitrary https port for nginx / toran proxy
- Optimize check environment configuration

**1.5.1**
- Upgrade toran proxy to version 1.5.1
- Fix update github token

**1.5.0**
- Upgrade toran proxy to version 1.5.0
- Add `monorepo` to `config.yml` of toran proxy
- Add option `TORAN_TRACK_DOWNLOADS` to track private package installs with logs
- Add option `TORAN_MONO_REPO` to track private package installs with logs

**1.4.4**
- Upgrade toran proxy to version 1.4.4

**1.4.3**
- Upgrade toran proxy to version 1.4.3

**1.4.2**
- Upgrade toran proxy to version 1.4.2

**1.4.1**
- Upgrade toran proxy to version 1.4.1

**1.4.0**
- Upgrade toran proxy to version 1.4.0
- Add toran proxy logs to data volume saved
- Add `track_downloads` to `config.yml` of toran proxy
- Add a contributing file

**1.3.2**
- Upgrade toran proxy to version 1.3.2
- Fix create packages directory
- Fix bad restart synchronisation
- Add microbadger to report docker image size
- Add option `TORAN_REVERSE` to running toran proxy behind a reverse proxy for i.e. SSL termination.

**1.2.0**
- Optimize README.md
- Upgrade toran proxy to version 1.2.0
- Global clean
- Add support `ssh/config` for private repository
- Rename environment variable `TORAN_PHP_TIMEZONE` to `PHP_TIMEZONE`
- Change user nginx and php-fpm from `root` to `www-data`
- Add `ssh` package
- Upgrade image base to `cedvan/ubuntu:14.04.20160326`

**1.1.7-2**
- Add supervisor
- Redirect logs to stdout
- Start first sync on startup
- Change `TORAN_CRON_TIMER` to `fifteen` by default
- Add PHP logs

**1.1.7-1**
- Fix sed in toran.sh
- Add Cron timer configuration
- Optimize logs directories
- Remove launch cron on start to speed up launch
- Optimize loading permissions
- Fix bug with token github empty

**1.1.7**
- Update Toran Proxy to version 1.1.7

**1.1.6-3**
- Update image FROM to cedvan/ubuntu:14.04.20150414
- Add ssh config for root user
- Fix License
- Fix config github token for composer

**1.1.6-2**
- Add **cron** every minute for download packages in background
- Fix toran config `git_path`
- Optimize logs directories

**1.1.6-1**
- Download Toran Proxy in Dockerfile
- Move save data in `/data/toran-proxy`
- Add default config for *git* and save mirrors in /data
- Rename `settings.yml` to `config.yml`
- Remove useless `parameters.yml`
- Move `assets/config` to `/assets/config` in container
- Remove useless `init.sh`
- Remove useless configuration *TORAN_PACKAGIST*, may change with toran interface
- Remove useless configuration *TORAN_SYNC*, may change with toran interface

**1.1.6**
- First version
