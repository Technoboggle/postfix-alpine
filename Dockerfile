ARG ALPINE_VERSION

FROM alpine:${ALPINE_VERSION} as alpineUpgraded

# Technoboggle Build time arguments.
ARG BUILD_DATE="${BUILD_DATE}"
ARG VCS_REF="${VCS_REF}"
ARG BUILD_VERSION="${BUILD_VERSION}"

ARG POSTFIX_VERSION="${POSTFIX_VERSION}"
ARG MAINTAINER="${MAINTAINER}"
ARG AUTHORNAME="${AUTHORNAME}"
ARG AUTHORS="${AUTHORS}"
ARG VERSION="${VERSION}"

ARG SCHEMAVERSION="${SCHEMAVERSION}"
ARG NAME="${NAME}"
ARG DESCRIPTION="${DESCRIPTION}"
ARG URL="${URL}"
ARG VCS_URL="${VCS_URL}"
ARG VENDOR="${VENDOR}"
ARG BUILDVERSION="${BUILDVERSION}"

# Labels.
LABEL maintainer=${MAINTAINER}
LABEL net.technoboggle.authorname=${AUTHORNAME} \
      net.technoboggle.authors=${AUTHORS} \
      net.technoboggle.version=${VERSION} \
      net.technoboggle.description=${DESCRIPTION} \
      net.technoboggle.buildDate=${BUILD_DATE}
LABEL org.label-schema.schema-version=${SCHEMAVERSION}
LABEL org.label-schema.build-date=${BUILD_DATE}
LABEL org.label-schema.name=${NAME}
LABEL org.label-schema.description=${DESCRIPTION}
LABEL org.label-schema.url=${URL}
LABEL org.label-schema.vcs-url=${VCS_URL}
LABEL org.label-schema.vcs-ref=${VSC_REF}
LABEL org.label-schema.vendor=${VENDOR}
LABEL org.label-schema.version=${BUILDVERSION}
LABEL org.label-schema.docker.cmd=${DOCKERCMD}
LABEL org.label-schema.docker.cmd="docker run -it -d -p 16379:6379 --rm --name mypostfix technoboggle/postfix-alpine:${POSTFIX_VERSION}-${ALPINE_VERSION}"


RUN echo "alpine:${ALPINE_VERSION}\n"; echo "BUILD_DATE:${BUILD_DATE}\n"; \
    apk update --no-cache && \
    apk upgrade --no-cache && \
    apk add --no-cache bash postfix postfix-pcre ca-certificates cyrus-sasl-login cyrus-sasl libsasl

# Main image
FROM scratch

COPY --from=alpineUpgraded / /

CMD ["/bin/sh"]

COPY conf /etc/postfix
COPY entrypoint.sh /entrypont.sh

VOLUME ["/var/spool/postfix"]

ENTRYPOINT ["/etc/postfix/postfix-service.sh"]

EXPOSE 25
