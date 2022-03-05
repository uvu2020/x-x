FROM alpine:latest

ADD mess.sh /opt/mess.sh

RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && chmod +x /opt/mess.sh

ENTRYPOINT ["sh", "-c", "/opt/mess.sh"]
