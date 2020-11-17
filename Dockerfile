FROM nats:2.1.9-alpine
RUN apk add bind-tools
ADD nats.conf /etc/nats.conf
ADD start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh
ENTRYPOINT "/usr/local/bin/start.sh"