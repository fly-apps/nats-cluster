FROM nats:2.1.9-scratch
ADD nats.conf /etc/nats.conf


CMD ["-c", "/etc/nats.conf"]