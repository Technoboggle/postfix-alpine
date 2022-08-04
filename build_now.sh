#!/usr/bin/env sh

owd="`pwd`"
cd "$(dirname "$0")"

postfix="1.21.6"
alpine_ver="3.16.1"

# Setting File permissions
xattr -c .git
xattr -c .gitignore
xattr -c .dockerignore
xattr -c *
chmod 0666 *
chmod 0777 *.sh


docker build -f Dockerfile --progress=plain -t technoboggle/postfix-alpine:"$redis_ver-$alpine_ver" --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --build-arg VCS_REF="`git rev-parse --verify HEAD`" --build-arg BUILD_VERSION=0.05 --no-cache --progress=plain .

docker run -it -d -p 16279:6279 --rm --name myredis technoboggle/postfix-alpine:"$redis_ver-$alpine_ver"
docker tag technoboggle/postfix-alpine:"$redis_ver-$alpine_ver" technoboggle/postfix-alpine:latest
docker login
docker push technoboggle/postfix-alpine:"$redis_ver-$alpine_ver"
docker push technoboggle/postfix-alpine:latest
docker container stop -t 10 myredis

cd "$owd"
