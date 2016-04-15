---
post_title: High Availability in DC/OS
post_excerpt: "Describes high availability in DC/OS"
layout: docs.jade
---

This document will discuss some of the high availability features in DC/OS, in
addition to best practices for building highly available applications on DC/OS.

## General concepts of high availability

### Leader/follower architecture

A common pattern in highly available systems is the leader/follower concept.
This is also sometimes referred to as: master/slave, primary/replica, or some
combination thereof. Generally speaking, this architecture is used when you have
one authoritative process, with N standby processes. In some systems, the
standby processes may also be capable of serving requests or performing other
operations. For example, when running a database like MySQL with a master and
replica, the replica is able to serve read-only requests, but it cannot accept
writes (only the master will accept writes).

In DC/OS, a number of components follow the leader/follower pattern. We'll
discuss some of them here and how they work.

#### Mesos

Mesos may be run in high availability mode, which requires running 3 or 5
masters. When run in HA mode, one master will become elected as the leader,
while the other masters will become followers. Each master has a replicated log
which contains some state about the cluster. The leading master is elected by
using ZooKeeper to perform leader election. For more detail on this, see the
[Mesos HA
documentation](https://mesos.apache.org/documentation/latest/high-availability/).

#### Marathon

Marathon may be operated in HA mode, which allows running multiple Marathon
instances (at least 2 for HA), with one elected leader. Marathon will use
ZooKeeper for leader election, and the followers will not accept writes or API
requests, but will proxy all API requests to the leading Marathon instance.

#### ZooKeeper

ZooKeeper is used by numerous services in DC/OS to provide consistency.
ZooKeeper can be used as a distributed locking service, a state store, and a
messaging system. ZooKeeper uses Paxos-like log replication and a
leader/follower architecture to maintain consistency across multiple ZooKeeper
instances. For a more detailed explanation of how ZooKeeper works, check out the
[ZooKeeper internals
document](https://zookeeper.apache.org/doc/r3.4.8/zookeeperInternals.html).

### Fault domain isolation

Fault domain isolation is an important part of building HA systems. In order to
correctly handle failure scenarios, systems must be distributed across fault
domains in order survive outages. There are different types of fault domains, a
few examples of which are:

 * Physical domains: this includes rack, datacenter, region, availability zone,
  and so on.
 * Network domains: machines within the same network may be subject
 to network partitions. For example, a shared network switch may fail or have
 invalid configuration.

With DC/OS, it's recommended that masters be distributed across racks for HA,
but not across DCs or regions. Agents may be distributed across regions/DCs, and
it's recommended that you tag agents with attributes to describe their location.

For applications which require HA, they should also be distributed across fault domains. With Marathon, this can be accomplished by using the [`GROUP_BY` constraint operator](https://mesosphere.github.io/marathon/docs/constraints.html).

### Separation of concerns

Fill me in too please

### Eliminating single points of failure

Me too!

### Fast failure detection

And me, thanks.

### Fast failover

Yep, same.
