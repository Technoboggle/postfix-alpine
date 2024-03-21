#!/usr/bin/env sh

owd="$(pwd)"
cd "$(dirname "$0")" || exit

if [ -f .env ]; then
    export $(cat .env | xargs)
fi

if [ -f .perms ]; then
    export $(cat .perms | xargs)
fi

postfix_ver="3.7.3-r1"
alpine_ver="3.17.1"

# Setting File permissions
xattr -c .git
xattr -c .gitignore
xattr -c .dockerignore
xattr -c ./*
chmod 0666 ./*
find "$(pwd)" -type d -exec chmod ugo+x {} \;
find "$(pwd)" -type f -exec chmod ugo=wr {} \;
find "$(pwd)" -type f \( -iname \*.sh -o -iname \*.py \) -exec chmod ugo+x {} \;
chmod 0666 .gitignore
chmod 0666 .dockerignore

current_builder=$(docker buildx ls | grep -i '\*' | head -n1 | awk '{print $1;}')

docker buildx create --name tb_builder --use --bootstrap

docker login -u="${DOCKER_USER}" -p="${DOCKER_PAT}"

docker buildx build -f Dockerfile \
    --platform linux/arm64,linux/amd64,linux/amd64/v2,linux/386,linux/armhf,linux/s390x,linux/ppc64le \
    -t technoboggle/postfix-alpine:"${POSTFIX_VERSION}-${ALPINE_VERSION}" \
    --build-arg BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')" \
    --build-arg VCS_REF="$(git rev-parse --verify HEAD)" \
    --build-arg ALPINE_VERSION="${ALPINE_VERSION}" \
    --build-arg BUILD_VERSION=0.05 \
    --force-rm \
    --no-cache \
    --push .
#--progress=plain

docker run -it -d --rm -p 25:25 -p 465:465 -p 583:583 -p 110:110 --name mypostfix technoboggle/postfix-alpine:"$postfix_ver-$alpine_ver"
docker container stop -t 10 mypostfix

docker buildx use "${current_builder}"
docker buildx rm tb_builder

cd "$owd" || exit
