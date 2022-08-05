
[![Known Vulnerabilities](https://snyk.io/test/github/Technoboggle/postfix-alpine/badge.svg)](https://snyk.io/test/github/Technoboggle/postfix-alpine)



![Trueosiris Rules](https://img.shields.io/badge/trueosiris-rules-f08060)

[![Docker Pulls](https://badgen.net/docker/pulls/trueosiris/godaddypy?icon=docker&label=pulls)](https://hub.docker.com/r/trueosiris/godaddypy/)
[![Docker Stars](https://badgen.net/docker/stars/trueosiris/godaddypy?icon=docker&label=stars)](https://hub.docker.com/r/trueosiris/godaddypy/)
[![Docker Image Size](https://badgen.net/docker/size/trueosiris/godaddypy?icon=docker&label=image%20size)](https://hub.docker.com/r/trueosiris/godaddypy/)
![Github stars](https://badgen.net/github/stars/trueosiris/docker-godaddypy?icon=github&label=stars)
![Github forks](https://badgen.net/github/forks/trueosiris/docker-godaddypy?icon=github&label=forks)
![Github issues](https://img.shields.io/github/issues/TrueOsiris/docker-godaddypy)
![Github last-commit](https://img.shields.io/github/last-commit/TrueOsiris/docker-godaddypy)







# The following commands to build image and upload to dockerhub
```

# Setting File permissions
xattr -c .git
xattr -c .gitignore
xattr -c .dockerignore
xattr -c *
chmod 0666 *
chmod 0777 *.sh


docker build -f Dockerfile --progress=plain -t technoboggle/postfix-alpine:3.7.2-3.16.1 --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --build-arg VCS_REF="`git rev-parse --verify HEAD`" --build-arg BUILD_VERSION=0.05 --no-cache --progress=plain .

in the above pay special attenttion to the values to be updated which are:
  1.21.6-3.16.1                    = Postfix version - alpine version
  "`git rev-parse --verify HEAD`"  = git commit SHA key
  0.05                             = current version of this image

docker run -it -d --rm --name mypostfix technoboggle/postfix-alpine:3.7.2-3.16.1
docker tag technoboggle/postfix-alpine:3.7.2-3.16.1 technoboggle/postfix-alpine:latest
docker login
docker push technoboggle/postfix-alpine:3.7.2-3.16.1
docker push technoboggle/postfix-alpine:latest
docker container stop -t 10 mypostfix


deprecated the use of the :latest tag as it seeds confusion
