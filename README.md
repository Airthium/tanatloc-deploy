# Tanatloc (SSR) deployment

Pre-installation steps: see the [Wiki](https://github.com/Airthium/tanatloc-ssr-deploy/wiki)

## Before start

### Set domain

```
sh tanatloc.sh set domain https://domain.com
```

If the domain name starts with `https`, an SSL certificate is build using `certbot`.

If you want to renew the certificate, use `sh tanatloc.sh renew certificate`.

### Set storage folder

```
sh tanatloc.sh set storage /absolute/path
```

## Start

```
sh tanatloc.sh start
```

## Stop

```
sh tanatloc.sh stop
```

## Update

```
sh tanatloc.sh update
```

## Database tools

Access database:

```
sh tanatloc.sh db run
```

Backup:

```
sh tanatloc.sh db backup
```

## Data tools

Access data (if stored in a docker volume):

```
sh tanatloc.sh data run
```

Backup (if stored in a docker volume):

```
sh tanatloc.sh data backup
```
