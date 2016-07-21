---
post_title: Overlay Networks
menu_order: 8.5
---

DC/OS enables virtual networking through the use of overlay networks. DC/OS overlay networks enable you to provide each container in the system with a unique IP address (“IP-per-container”) with isolation guarantees amongst subnets. DC/OS overlay networks offer the following advantages:

* Both Mesos and Docker containers can communicate from within a single node and between nodes on a cluster.

* Services can be created such that their traffic is isolated from other traffic coming from any other overlay network or host in the cluster.

* They remove the need to worry about potentially overlapping ports in applications, or the need to use nonstandard ports for services to avoid overlapping.

* You can generate any number of instances of a class of tasks and have them all listen on the same port so that clients don’t have to do port discovery.

* You can run applications that require intra-cluster connectivity, like Cassandra, HDFS, and Riak.

* You can create multiple overlay networks to isolate different portions of your organization, for instance, development, marketing, and production.

**Note:** Isolation guarantees among subnets depend on your CNI implementation and/or your firewall policies.

# Using Overlay Networks

First, you or the data center operator needs to [configure the overlay networks](/docs/1.8/administration/overlay-networks/).

Overlay networks are configured at install time. You or the data center operator will specify a canonical name for each network in the `config.yaml`. When your service needs to launch a container, refer to it by that canonical name.

# Example

The following Marathon application definition specifies a virtual network named `dcos-1`, which refers to the target DC/OS overlay network of the same name.

```json
{
   "id":"my-networking",
   "cmd":"env; ip -o addr; sleep 30",
   "cpus":0.10,
   "mem":64,
   "instances":1,
   "backoffFactor":1.14472988585,
   "backoffSeconds":5,
   "ipAddress":{
      "networkName":"dcos-1"
   },
   "container":{
      "type":"DOCKER",
      "docker":{
         "network":"USER",
         "image":"busybox",
         "portMappings":[
            {
               "containerPort":123,
               "servicePort":80,
               "name":"foo"
            }
         ]
      }
   }
}
```
