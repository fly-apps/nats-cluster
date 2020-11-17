#! /bin/sh

routes=$(dig aaaa ord.nats-cluster-example.internal @fdaa::3 +short | awk -vORS=, '{ printf "\"nats-route://[%s]:4248\"\n",$1 }' | paste -s -d, -)
sed -i "s|NATS_ROUTES|$routes|" /etc/nats.conf
nats-server -c /etc/nats.conf