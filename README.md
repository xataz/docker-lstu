![](https://framagit.org/luc/lstu/raw/master/themes/default/public/img/lstu128.png)

[![Build Status](https://drone.xataz.net/api/badges/xataz/docker-lstu/status.svg)](https://drone.xataz.net/xataz/docker-lstu)
[![](https://images.microbadger.com/badges/image/xataz/lstu.svg)](https://microbadger.com/images/xataz/lstu "Get your own image badge on microbadger.com")
[![](https://images.microbadger.com/badges/version/xataz/lstu.svg)](https://microbadger.com/images/xataz/lstu "Get your own version badge on microbadger.com")

> This image is build and push with [drone.io](https://github.com/drone/drone), a circle-ci like self-hosted.
> If you don't trust, you can build yourself.

## Tag available
* latest [(lstu/Dockerfile)](https://github.com/xataz/docker-lstu/blob/master/Dockerfile)

## Description
What is [lstu](https://framagit.org/luc/lstu) ?

It means Let's Shorten That Url.

**This image does not contain root processes**

## BUILD IMAGE

```shell
docker build -t xataz/lstu github.com/xataz/docker-lstu.git#master
```

## Configuration
### Environments
* UID : choose uid for launching lstu (default : 991)
* GID : choose gid for launching lstu (default : 991)
* WEBROOT : webroot of lstu (default : /)
* SECRET : random string used to encrypt cookies (default : f6056062888a9a6aff1cc89dd3397853)
* ADMINPWD : password to access the statistics page. (default : s3cr3T)
* CONTACT : lstu contact (default : contact@domain.tld)

Tip : you can use the following command to generate SECRET. `date +%s | md5sum | head -c 32`

### Volumes
* /usr/lstu/data/ : lstu's database is here

### Ports
* 8282

## Usage
### Simple launch
```shell
docker run -d -p 8282:8282 xataz/lstu
```
URI access : http://XX.XX.XX.XX:8282

### Advanced launch
```shell
docker run -d -p 8181:8282 \
    -v /docker/config/lstu:/usr/lstu/data \
    -e UID=1001 \
    -e GID=1001 \
    -e WEBROOT=/lstu \
    -e SECRET=$(date +%s | md5sum | head -c 32) \
    -e CONTACT=contact@mydomain.com \
    -e ADMINPWD="mypassword" \
    xataz/lstu
```
URI access : http://XX.XX.XX.XX:8181/lstu

## Contributing
Any contributions are very welcome !
