# Tanatloc (SSR) deployment

## Requirements

- [Docker](https://docs.docker.com/get-docker/)
- [Docker compose](https://docs.docker.com/compose/install/)
- [certbot](https://eff-certbot.readthedocs.io/en/stable/install.html)

## Quick start

Without any customization, you can just run:

```bash
bash tanatloc.sh start
```

The server will start with a default user:

- email: `admin`
- password: `password`

## Options

### Start

```
bash tanatloc.sh start
```

Start Tanatloc

### Stop

```
bash tanatloc.sh stop
```

Stop Tanatloc

### Update self

```
bash tanatloc.sh update-self
```

Update Tanatloc deployment script

### Update

```
bash tanatloc.sh update
```

Update Tanatloc with the latest docker

### Clean

```
bash tanatloc.sh clean
```

Clean old docker images (tanatloc, postgres, nginx)

### Renew

#### Certificate

```
bash tanatloc.sh renew certificate
```

Renew the SSL certificate

### Log

```
bash tanatloc.sh log
```

Print Tanatloc log

### Set

#### Tanatloc tag

Default: `latest`

```
bash tanatloc.sh set tanatloc_tag latest
```

Set the Tanatloc docker tag to use

#### Database password

Default: `password`

```
bash tanatloc.sh set database_password password
```

Set the database password

#### Database backup

Default: `/media/tanatloc-backup/database`

```
bash tanatloc.sh set database_backup /media/tanatloc-backup/database
```

Set the database backup path. You must specify an absolute path

<span style="color: orange;">
:warning Warning: that does not activate the automatic backup system
</span>

#### Domain

Default: Empty

```
bash tanatloc.sh set domain https://domain.com
```

Set the server domain

If the domain name starts with `https`, an SSL certificate will be build using `certbot`

If you want to renew the certificate, use `bash tanatloc.sh renew certificate`

#### HTTP port

Default: `80`

```
bash tanatloc.sh set http_port 80
```

Set the HTTP port

#### HTTPS port

Default: `443`

```
bash tanatloc.sh set https_port 443
```

Set the HTTPS port

#### HTTP proxy

Default: Empty

```
bash tanatloc.sh set http_proxy htpps://my.proxy
```

Set the HTTP proxy

#### HTTPS proxy

Default: Empty

```
bash tanatloc.sh set https_proxy htpps://my.proxy
```

Set the HTTPS proxy

#### Storage

Default: Docker volume

```
bash tanatloc.sh set storage /absolute/path
```

Set the storage path. You must specify an absolute path

#### Storage backup

Default: `/media/tanatloc-backup/storage`

```
bash tanatloc.sh set storage_backup /media/tanatloc-backup/storage
```

Set the storage backup path. You must specify an absolute path

<span style="color: orange;">
:warning Warning: that does not activate the automatic backup system
</span>

#### Additional path

Default: Empty

```
bash tanatloc.sh set additional_path /usr/local/bin
```

Add paths to $PATH environement variable

#### SHARETASK_JVM

Default: Empty

```
bash tanatloc.sh set sharetask_jvm /usr/local/bin/java
```

Set the SHARETASK_JVM environment variable

### Add

#### Volume

Default: None

```
bash tanatloc.sh add volume bind /source/path /target/path
```

Add volume to Tanatloc service

<span style="color: orange;">
:warning Warning: you can only add volumes, to remove or edit it you must edit the <a href="./docker-compose.volumes.yml">docker-compose.volumes.yml file</a>
</span>

### Database

#### Backup

```
bash tanatloc.sh database backup
```

Make a database backup

#### Run

```
bash tanatloc.sh database run
```

Run the database docker

### Data

#### Backup

For docker volume only

```
bash tanatloc.sh data backup
```

Make a storage backup

#### Run

```
bash tanatloc.sh data run
```

Run the storage volume

<span style="color: orange;">
:warning Warning: that only works if you keep the storage in a docker volume
</span>

## Cron

`cron` scripts are available in `scripts/cron_*.sh` for:

- start Tanatloc at system startup
- automatically backup database and storage
- automatically renew the SSL certificate

Have a look on [example cron script](scripts/example.cron)

## Sharetask usage

### Share executables

Add additional path value:

```bash
bash tanatloc.sh set additional_path /usr/local/sharetask/bin
```

Set SHARETASK_JVM:

```bash
bash tanatloc.sh set sharetask_jvm /usr/local/jre/bin/java
```

Add volume bind:

```bash
bash tanatloc.sh add volume bind /path/to/sharetask/bin /usr/local/sharetask/bin
bash tanatloc.sh add volume bind /path/to/java/bin /usr/local/jre/bin
```
