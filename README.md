![](https://git.framasoft.org/uploads/project/avatar/5/lstu.png)

> This image is build and push with [drone.io](https://github.com/drone/drone), a circle-ci like self-hosted.
> If you don't trust, you can build yourself.

## Tag available
* latest [(lstu/Dockerfile)](https://github.com/xataz/dockerfiles/blob/master/lstu/Dockerfile)

## Description
What is [lstu](https://git.framasoft.org/luc/lstu) ?

It means Let's Shorten That Url.

**This image not contains root process**

## BUILD IMAGE

```shell
docker build -t xataz/lstu github.com/xataz/dockerfiles.git#master:lstu
```

## Configuration
### Environments
* UID : Choose uid for launch lstu (default : 991)
* GID : Choose gid for launch lstu (default : 991)
* WEBROOT : webroot of lstu (default : /)
* SECRET : random string used to encrypt cookies (default : f6056062888a9a6aff1cc89dd3397853)
* ADMINPWD : Password for access to statistique page. (default : s3cr3T)
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
Any contributions, are very welcome !