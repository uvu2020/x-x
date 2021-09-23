FROM alpine:latest

ADD less.sh /opt/less.sh

RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && chmod +x /opt/less.sh

ENTRYPOINT ["sh", "-c", "/opt/less.sh"]
