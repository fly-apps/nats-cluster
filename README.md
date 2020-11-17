# Global NATS Cluster

NATS is an open source messaging backend you can use for everything from chat applications to infrastructure events. 

This is an example application that runs multiple NATS servers on Fly.io. It creates a mesh ofNATS servers that communicate over a private, encrypted IPv6 network.

When you point clients at this app, Fly routes them to the closest available server. A client in Chicago will connect to a Chicago basedNATS server, a client in Australia will connect to a server running in Sydney. Messages are accepted "at the edge", traverse the Fly private network, and are delivered :from the edge".

## Setup

1. `flyctl apps create <app-name>`

    > we're using `nats-cluster-example` for this demo, you'll need to pick something else.
2. Update `nats.conf`, change the `routes` setting to `nats-route://global.<app-name>.internal:4248`.

    > This tells NATS to query `global.<app-name>.internal` to find other servers. The Fly private DNS resolver returns all available servers when you query the `global.` subdomain.
3. `flyctl deploy`
4. Add more regions with `flyctl regions add <region>`

    > For this demo, we set `ord`, `syd`, `cdg` regions.

Then run `flyctl logs` and you'll see the virtual machines discover each other.

```
2020-11-17T17:31:07.664Z d1152f01 ord [info] [493] 2020/11/17 17:31:07.646272 [INF] [fdaa:0:1:a7b:abc:21de:af5f:2]:4248 - rid:1 - Route connection created
2020-11-17T17:31:07.713Z 21deaf5f cdg [info] [553] 2020/11/17 17:31:07.704807 [INF] [fdaa:0:1:a7b:81:d115:2f01:2]:34902 - rid:19 - Route connection created
2020-11-17T17:31:08.123Z 82fabc30 syd [info] [553] 2020/11/17 17:31:08.114852 [INF] [fdaa:0:1:a7b:81:d115:2f01:2]:4248 - rid:7 - Route connection created
2020-11-17T17:31:08.259Z d1152f01 ord [info] [493] 2020/11/17 17:31:08.241644 [INF] [fdaa:0:1:a7b:b92:82fa:bc30:2]:45684 - rid:2 - Route connection created
```

Once deployed, you can connect NATS clients to `<app-name>.fly.dev:10000`, or if they support TLS, `<app-name>.fly.dev:10001`.

## What to try next

1. [NATS streaming](https://docs.nats.io/nats-streaming-concepts/intro) offers persistence features, you can create a NATS streaming app by modifying this demo and adding volumes: `flyctl volume create`
2. Create a [NATS super cluster](https://docs.nats.io/nats-server/configuration/gateways) let you join multiple NATS clusters with gateways. If you want to run regional clusters, you can query the Fly DNS service to with `<region>.<app-name>.internal` to find server in specific regions.