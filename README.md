# Tanatloc (SSR) deployment

Pre-installation steps: see the [Wiki](https://github.com/Airthium/tanatloc-deploy/wiki)

## Options

### Set

#### Tanatloc tag

Default: `latest`

```
sh tanatloc.sh set tanatloc_tag latest
```

#### Database password

Default: `password`

```
sh tanatloc.sh set database_password password
```

#### Database port

Default: `5432`

```
sh tanatloc.sh set database_port 5432
```

#### Domain

Default: Empty

```
sh tanatloc.sh set domain https://domain.com
```

If the domain name starts with `https`, an SSL certificate will be build using `certbot`.

If you want to renew the certificate, use `sh tanatloc.sh renew certificate`.

#### HTTP port

Default: `80`

```
sh tanatloc.sh set http_port 80
```

#### HTTPS port

Default: `443`

```
sh tanatloc.sh set https_port 443
```

#### Storage folder

```
sh tanatloc.sh set storage /absolute/path
```

You must specify an absolute path

### Database

#### Backup

```
sh tanatloc.sh database backup
```

#### Run

```
sh tanatloc.sh database run
```

### Data

#### Backup

For docker volume only

```
sh tanatloc.sh data backup
```

#### Run

```
sh tanatloc.sh data run
```

### Start

```
sh tanatloc.sh start
```

### Stop

```
sh tanatloc.sh stop
```

### Update

```
sh tanatloc.sh update
```

### Log

```
sh tanatloc.sh log
```

### Clean

```
sh tanatloc.sh clean
```

Clean old docker images

### Renew

#### Certificate

```
sh tanatloc.sh renew certificate
```

Renew the SSL certificate
