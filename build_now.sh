#!/usr/bin/env sh

owd="`pwd`"
cd "$(dirname "$0")"

postfix_ver="3.7.2"
alpine_ver="3.16.1"

# Setting File permissions
xattr -c .git
xattr -c .gitignore
xattr -c .dockerignore
xattr -c *
chmod 0666 *
chmod 0777 *.sh
chmod 0777 conf

docker build -f Dockerfile -t technoboggle/postfix-alpine:"$postfix_ver-$alpine_ver" --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') --build-arg VCS_REF="`git rev-parse --verify HEAD`" --build-arg BUILD_VERSION=0.05 --force-rm --no-cache .
#--progress=plain 

docker run -it -d --rm -p 25:25 -p 465:465 -p 583:583 -p 110:110 --name mypostfix technoboggle/postfix-alpine:"$postfix_ver-$alpine_ver"
docker tag technoboggle/postfix-alpine:"$postfix_ver-$alpine_ver" technoboggle/postfix-alpine:latest
docker login
docker push technoboggle/postfix-alpine:"$postfix_ver-$alpine_ver"
docker push technoboggle/postfix-alpine:latest
#docker container stop -t 10 mypostfix

cd "$owd"
