# docker-bake.hcl
group "default" {
    targets = ["app"]
}

target "app" {
    context = "."
    dockerfile = "Dockerfile"
    tags = ["technoboggle/postfix-alpine:${POSTFIX_VERSION}-${ALPINE_VERSION}", "technoboggle/postfix-alpine:${POSTFIX_VERSION}", "technoboggle/postfix-alpine:latest"]
    args = {
        ALPINE_VERSION = "${ALPINE_VERSION}"
        POSTFIX_VERSION = "${POSTFIX_VERSION}"
        MAINTAINER = "${MAINTAINER}"
        AUTHORNAME = "${AUTHORNAME}"
        AUTHORS = "${AUTHORS}"
        VERSION = "${VERSION}"
        SCHEMAVERSION = "${SCHEMAVERSION}"
        NAME = "${NAME}"
        DESCRIPTION = "${DESCRIPTION}"
        URL = "${URL}"
        VCS_URL = "${VCS_URL}"
        VENDOR = "${VENDOR}"
        BUILDVERSION = "${BUILD_VERSION}"
        BUILD_DATE="${BUILD_DATE}"
        VCS_REF="${VCS_REF}"
    }
    platforms = ["linux/amd64", "linux/arm64", "linux/arm64/v8", "linux/386", "linux/armhf", "linux/s390x", "linux/arm/v7", "linux/arm/v6", "linux/ppc64le"]
    push = true
    cache = false
    progress = "plain"
}
