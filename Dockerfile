FROM alpine:3.16.1

# Technoboggle Build time arguments.
ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

ENV ALPINE_VERSION 3.16.1
ENV POSTFIX_VERSION 7.0.4

# Labels.
LABEL maintainer="edward.finlayson@btinternet.com"
LABEL net.technoboggle.authorname="Edward Finlayson" \
      net.technoboggle.authors="edward.finlayson@btinternet.com" \
      net.technoboggle.version="0.1" \
      net.technoboggle.description="This image builds a PHP-FPM server on Alpine" \
      net.technoboggle.buildDate="${BUILD_DATE}"

LABEL org.label-schema.schema-version="1.0"
LABEL org.label-schema.build-date="${BUILD_DATE}"
LABEL org.label-schema.name="Technoboggle/php-fpm-alpine"
LABEL org.label-schema.description="Technoboggle lightweight php-fpm node"
LABEL org.label-schema.url="http://technoboggle.com/"
LABEL org.label-schema.vcs-url="https://github.com/Technoboggle/php-fpm"
LABEL org.label-schema.vcs-ref="$VCS_REF"
LABEL org.label-schema.vendor="WSO2"
LABEL org.label-schema.version="$BUILD_VERSION"
LABEL org.label-schema.docker.cmd="docker run -it -d -p 16379:6379 --rm --name mypostfix technoboggle/postfix-alpine:${POSTFIX_VERSION}-${ALPINE_VERSION}"


RUN apk --no-cache add postfix ca-certificates cyrus-sasl-login cyrus-sasl libsasl

COPY main.cf /etc/postfix/main.cf
COPY entrypoint.sh /entrypont.sh

ENTRYPOINT ["sh", "/entrypont.sh"]