FROM alpine:3.15

LABEL AUTHOR="Steven Coburn"

RUN \
  apk update && \
  apk --no-cache add coreutils curl openssl s-nail

COPY build/ssl-cert-check /ssl-cert-check
COPY build/run.sh /run.sh
COPY build/mailrc.template /tmp/

RUN chmod +x /ssl-cert-check
RUN chmod +x /run.sh

CMD /run.sh