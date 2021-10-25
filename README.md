# Tanatloc (SSR) deployment

## Set domain

```
sh tanatloc.sh set domain https://domain.com
```

If the domain name starts with `https`, an SSL certificate is build using `certbot`.

If you want to renew the certificate, use `sh tanatloc.sh renew certificate`.

## Set storage folder

```
sh tanatloc.sh set storage /absolute/path
```
