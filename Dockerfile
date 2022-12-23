FROM alpine:3.17.0

# Technoboggle Build time arguments.
ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

ENV ALPINE_VERSION 3.17.0
ENV POSTFIX_VERSION 3.7.3-r1

# Labels.
LABEL maintainer="edward.finlayson@btinternet.com"
LABEL net.technoboggle.authorname="Edward Finlayson" \
      net.technoboggle.authors="edward.finlayson@btinternet.com" \
      net.technoboggle.version="0.1" \
      net.technoboggle.description="This image builds a Postfix email server on Alpine" \
      net.technoboggle.buildDate="${BUILD_DATE}"

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date="${BUILD_DATE}"
LABEL org.label-schema.name="Technoboggle/postfix-alpine"
LABEL org.label-schema.description="Technoboggle lightweight postfix node"
LABEL org.label-schema.url="http://technoboggle.com/"
LABEL org.label-schema.vcs-url="https://github.com/Technoboggle/postfix-alpine"
LABEL org.label-schema.vcs-ref="$VCS_REF"
LABEL org.label-schema.vendor="WSO2"
LABEL org.label-schema.version="$BUILD_VERSION"
LABEL org.label-schema.docker.cmd="docker run -it -d -p 16379:6379 --rm --name mypostfix technoboggle/postfix-alpine:${POSTFIX_VERSION}-${ALPINE_VERSION}"


RUN apk add --no-cache bash postfix postfix-pcre ca-certificates cyrus-sasl-login cyrus-sasl libsasl

COPY conf /etc/postfix
COPY entrypoint.sh /entrypont.sh

VOLUME ["/var/spool/postfix"]

ENTRYPOINT ["/etc/postfix/postfix-service.sh"]

EXPOSE 25
