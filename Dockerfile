FROM nats:2.1.9-alpine

ADD entrypoint.sh /fly/
ADD nats.conf /etc/nats.conf

ENTRYPOINT [ "fly/entrypoint.sh"]
CMD ["-c", "/etc/nats.conf"]