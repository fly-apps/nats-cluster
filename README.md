# Global NATS Cluster

[NATS](https://docs.nats.io/) is an open source messaging backend suited to many use cases and deployment scenarios. We use it for internal communications at Fly. This repo shows how to use it for your application.

This example creates a federated mesh of NATS servers that communicate over the private, encrypted IpV6 network available to all Fly organizations.
## Setup

1. `fly launch --no-deploy`

    > You'll be prompted for an app name. Hit return to let Fly generate an app name for you. Pick your target organization and a starting region.

2. `flyctl deploy`

    > This will start NATS with a single node in your selected region.

3. Add more regions with `flyctl regions add <region>` or

    > For this demo, we set `ord`, `syd`, `cdg` regions.

```cmd
fly regions set ord syd cdg
```

4. Scale the application so it can place nodes in the regions.

```cmd
fly scale count 3
```

Then run `flyctl logs` and you'll see the virtual machines discover each other.

```
2020-11-17T17:31:07.664Z d1152f01 ord [info] [493] 2020/11/17 17:31:07.646272 [INF] [fdaa:0:1:a7b:abc:21de:af5f:2]:4248 - rid:1 - Route connection created
2020-11-17T17:31:07.713Z 21deaf5f cdg [info] [553] 2020/11/17 17:31:07.704807 [INF] [fdaa:0:1:a7b:81:d115:2f01:2]:34902 - rid:19 - Route connection created
2020-11-17T17:31:08.123Z 82fabc30 syd [info] [553] 2020/11/17 17:31:08.114852 [INF] [fdaa:0:1:a7b:81:d115:2f01:2]:4248 - rid:7 - Route connection created
2020-11-17T17:31:08.259Z d1152f01 ord [info] [493] 2020/11/17 17:31:08.241644 [INF] [fdaa:0:1:a7b:b92:82fa:bc30:2]:45684 - rid:2 - Route connection created
```

## Testing the cluster

While the cluster is only accessible from inside the Fly network, you can use Fly's [Wireguard support](/docs/reference/privatenetwork/) to create a VPN into your Fly organisation and private network.

Then you can use tools such as [natscli](https://github.com/nats-io/natscli) to subscribe to topics, publish messages to topics and perform various tests on your NATS cluster. Install the tool first.

Once installed, create a context that points at your NATS cluster:

```cmd
nats context add fly.demo --server appname.internal:4222 --description "My Cluster" --select
```

You can subscribe to a topic with `nats sub topicname`:

```cmd
nats sub fly.demo
```

And then, in another terminal sessions, we can use `nats pub topicname` to send either simple messages to that topic:

```cmd
nats pub fly.demo "Hello World"
```

Or send multiple messages:

```cmd
nats pub fly.demo "fly.demo says {{.Cnt}} @ {{.TimeStamp}}" --count=10
```

You're ready to start integrating NATS messaging into your other Fly applications.

## What to try next

1. [NATS streaming](https://docs.nats.io/nats-streaming-concepts/intro) offers persistence features, you can create a NATS streaming app by modifying this demo and adding volumes: `flyctl volume create`

2. Create a [NATS super cluster](https://docs.nats.io/nats-server/configuration/gateways) which lets you join multiple NATS clusters with gateways. If you want to run regional clusters, you can query the Fly DNS service at `<region>.<app-name>.internal` to find servers in specific regions.


## Discuss

You can discuss this example (and the paired 6pn-demo-chat example) on the [dedicated Fly Community topic](https://community.fly.io/t/new-examples-nats-cluster-and-6pn-demo-chat/562).
