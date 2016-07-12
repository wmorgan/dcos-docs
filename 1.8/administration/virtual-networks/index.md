---
layout: page
post_title: Virtual Networks
menu_order: 11.5 
---

DC/OS allows you to create, manage, and use virtual networks, supporting IP-per-container with isolation guarantees amongst subnets. Virtual networks allow both Mesos and Docker containers to communicate from within a single node and between nodes on a cluster, and for services to be created such that their traffic is isolated from other traffic coming from any other virtual networks or hosts in the cluster.

Additionally, virtual networks enable you to provide each container in the system with a unique IP address (“IP-per-container”). This removes the need to worry about potentially overlapping ports in applications, or the need to use nonstandard ports for services to avoid overlapping. IP-per-container functionality also allows you to generate any number of instances of a class of tasks and have them all listen on the same port so that clients don’t have to do port discovery.

A virtual network enables you to run applications that require intra-cluster connectivity, like Cassandra, HDFS, and Riak. Your application can treat the various containers on your network like an end host, making it easier to enforce network isolation. This way, you can run multiple instances of DC/OS services without needing to manage ports. You can also create multiple virtual networks to isolate different portions of your organization, for instance, development, marketing, and production.

**Note:** Isolation guarantees among subnets depend on your CNI implementation and/or your firewall policies.

[Learn how to use virtual networks in your applications](/docs/1.8/usage/virtual-networks/).

# Overview

The overall approach to virtual networks in DC/OS looks as follows:

![Overview of the DC/OS Virtual Networks architecture](/1.8/administration/virtual-networks/img/virtual-networks.png) 

DC/OS virtual networks do not require an external IP address management (IPAM) solution (and indeed at the current point in time do not support external IPAMs), since the global state (IP allocation) is handled via the Mesos Master replicated log. The interaction between the components looks like this:

- Both the Mesos master and the Mesos agents run DC/OS overlay modules that communicate directly.

- For the Mesos containerizer, the CNI isolator is used, whereas for the Docker containerizer [DNI](https://docs.docker.com/engine/userguide/networking/dockernetworks/) is leveraged, shelling out to the Docker daemon.

- For intra-node IP discovery we use an overlay orchestrator called navstar. This operator-facing system component is responsible for programming the overlay backend using a library called lashup that implements a gossip protocol to disseminate and coordinate overlay routing information amongst all Mesos agents in the DC/OS cluster.

**Note:** To use virtual networks in DC/OS you must use a recent Linux kernel (3.9 or above) as well as Docker in version 1.11 on the agent nodes.
Also note that we use the terms “virtual network” and “overlay network” in the context of DC/OS somewhat interchangeably.
