---
layout: page
post_title: Virtual Networks
menu_order: 8.5 
---

DC/OS allows you to use virtual networks to allow both Mesos and Docker containers to communicate from within a single node and between nodes on a cluster, and for services to be created such that their traffic is isolated from other traffic coming from any other virtual networks or hosts in the cluster.

Additionally, virtual networks enable you to provide each container in the system with a unique IP address (“IP-per-container”). This removes the need to worry about potentially overlapping ports in applications, or the need to use nonstandard ports for services  to avoid overlapping. IP-per-container functionality also allows you to generate any number of instances of a class of tasks and have them all listen on the same port so that clients don’t have to do port discovery.

The virtual network enables you to run applications that require intra-cluster connectivity, like Cassandra, HDFS, and Riak. Your application can treat the various containers on your network like an end host, making it easier to enforce network isolation. This way you can run multiple instances of DC/OS services without needing to manage ports. You can also create multiple virtual networks to isolate different portions of your organization, for instance, development, marketing, and production.

# Using Virtual Networks

First, you or the data center operator needs to [configure the virtual networks](/docs/1.8/administration/virtual-networks/).

Virtual networks are configured at install time. You or the data center operator will specify a canonical name for each network in the `config.yaml`. When your service needs to launch a container, refer to it by that canonical name.

# Example

The following Marathon application definition specifies a virtual network named `dcos-1`.

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
