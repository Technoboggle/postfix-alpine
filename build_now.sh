#!/usr/bin/env sh

owd="$(pwd)"
cd "$(dirname "$0")" || exit

BUILD_DATE="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"
VCS_REF="$(git rev-parse --verify HEAD)"

export BUILD_DATE
export VCS_REF

sed -i.bu -E 's/BUILD_DATE=".*"/BUILD_DATE="'"${BUILD_DATE}"'"/g' env.hcl
sed -i.bu -E 's/VCS_REF=".*"/VCS_REF="'"${VCS_REF}"'"/g' env.hcl

if [ -f env.hcl ]; then
    export $(cat env.hcl | xargs)
fi

if [ -f .perms ]; then
    export $(cat .perms | xargs)
fi

sed -i.bu -E 's/BUILD_DATE=".*"/BUILD_DATE=""/g' env.hcl
sed -i.bu -E 's/VCS_REF=".*"/VCS_REF=""/g' env.hcl

rm -f env.hcl.bu

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

#current_builder=$(docker buildx ls | grep -i 'docker\-container' | head -n1 | awk '{print $1;}')
current_builder=$(docker buildx ls | grep -i '\s\*' | head -n1 | awk '{print $1;}')

docker buildx create --name technoboggle_builder --use --bootstrap --platform=linux/arm/v7,linux/arm64,linux/amd64,linux/arm64/v8,linux/386,linux/armhf,linux/s390x,linux/arm/v7,linux/arm/v6,linux/ppc64le

docker login -u="${DOCKER_USER}" -p="${DOCKER_PAT}"

docker buildx bake -f docker-bake.hcl -f env.hcl --no-cache --push

docker run -it -d --rm -p 25:25 -p 465:465 -p 583:583 -p 110:110 --name mypostfix technoboggle/postfix-alpine:"${POSTFIX_VERSION}-${ALPINE_VERSION}"

docker container stop -t 10 mypostfix

docker buildx use "${current_builder}"
docker buildx rm technoboggle_builder

cd "$owd" || exit
