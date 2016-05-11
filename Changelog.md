# Changelog

**latest**
- Upgrade toran proxy to version 1.3.2

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
