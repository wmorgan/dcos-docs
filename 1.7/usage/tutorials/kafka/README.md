---
post_title: How to use Apache Kafka on DC/OS
post_excerpt: ""
layout: docs.jade
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---

[Apache Kafka](https://kafka.apache.org/) is a distributed high-throughput publish-subscribe messaging system with strong ordering guarantees. Kafka clusters are highly available, fault tolerant, and very durable. DC/OS Kafka gives you direct access to the Kafka API so that existing producers and consumers can interoperate. You can configure and install DC/OS Kafka in moments. Multiple Kafka clusters can be installed on DC/OS and managed independently, so you can offer Kafka as a managed service to your organization.
[Apache Zookeeper](https://zookeeper.apache.org/) is used by Kafka for coordination.
The purpose of Kafka is to serve real-time data ingestion systems with high-throughput and low-latency. Kafka is written is Scala.


**Time Estimate**:

This tutorial will take aproximatively 20 minutes to complete, given a DC/OS cluster with sufficient resources is available.

**Target Audience**:

- Automated Administration

**Terminology**:

- pub/sub ... Publish/Subscribe messaging pattern
- Broker ... A Kafka message broker that routes messages to one or more topics
- Topic ... A Kafka topic: message filtering mechanism in the pub/sub systems. Subscribers register to receive/consume messages from topics
- Publisher ... An application that publishes messages on Kafka
- Consumer ... An application that consumes messages from Kafka
- Universe ... The default DC/OS repository
- Multiverse ... The extended DC/OS repository


**Scope**:

This tutorial will cover the installation of Kafka framework on DC/OS and dcos enhanced cli operations for Kafka.
You will learn how to install Kafka framework, how to validate the Kafka framework is up and running and how to use the enhanced cli Kafka operations.
You will learn about how to use Kafka on DC/OS, launching brokers and publishing/consuming messages.

# Table of Contents

# Prerequisites

- [Install](../install/README.md)
- Cluster Size - [Check Cluster Size](../getting-started/cluster-size)

# Installing

## Typical installation
Assuming you have a DC/OS cluster up and running, the first step is to install Kafka. As the minimum cluster size for this tutorial I recommend at least three nodes with 2 CPUs and 2 GB of RAM available, each:

```
dcos package install kafka
This will install Apache Kafka DCOS Service.
Continue installing? [yes/no] yes
Installing Marathon app for package [kafka] version [0.9.4.0]
Installing CLI subcommand for package [kafka] version [0.9.4.0]
New command available: dcos kafka
The Apache Kafka DCOS Service is installed:
  docs   - https://github.com/mesos/kafka
  issues - https://github.com/mesos/kafka/issues
```

While the DC/OS command line interface (CLI) is immediately available it takes a few minutes until Kafka is actually running in the cluster.

## Custom manual installation procedure

Verify existing dcos repositories

`dcos package repo list
Universe: https://universe.mesosphere.com/repo
`

In case you want to install a version of the Kafka framework available on the Multiverse repository, [install](https://github.com/mesosphere/multiverse#installation) the Multiverse repository first
`dcos package repo add Multiverse: https://github.com/mesosphere/multiverse/archive/version-2.x.zip`
`dcos package repo list
Universe: https://universe.mesosphere.com/repo
Multiverse: https://github.com/mesosphere/multiverse/archive/version-2.x.zip
`

Identify available versions for the Kafka framework

- List
`dcos package list kafka`

- Search
`dcos package search kafka`

Install the Kafka framework

- Install/upgrade to a specific version of the kafka package
`dcos package install --yes --force --package-version=<package_version> kafka`

Validate that installation added enhanced cli Kafka support
`dcos package list kafka; dcos kafka help`

Validate that Kafka service is healthy
![DCOS dashboard services status](img/dcos-dashboard-kafka-service-status.png)
![DCOS services status](img/dcos-services-kafka-service-status.png)

## UI manual installation procedure

On DC/OS you can also install the Kafka service from [DC/OS Univers dashboard](http://<dcos-master-dns>/#/universe/packages/)


# DC/OS Kafka operations

- Add Brokers
`dcos kafka broker add 0..2`

- Start Brokers
`dcos kafka broker start 0..2`

- Remove Brokers. Brokers have to be stopped first in order to qualify for removal.
`dcos kafka broker stop 1..2`
`dcos kafka broker remove 1..2`

Expected outcome:
`brokers 1,2 removed`

- List Kafka Brokers
`dcos kafka broker list`

- Update Broker. A Broker needs to be stopped first in order to qualify for update.
```
dcos kafka broker stop 0 &&\
dcos kafka broker update 0 --mem 128 --heap 64 &&\
dcos kafka broker start 0
```

Expected outcome:
```
broker started:
  id: 0
  active: true
  state: running
  resources: cpus:1.00, mem:128, heap:64, port:auto
  failover: delay:1m, max-delay:10m
  stickiness: period:10m, hostname:192.168.65.121
  task:
    id: broker-0-52ca36ad-d34b-48fc-8692-ac438e76c130
    state: running
    endpoint: 192.168.65.121:1025
```
![Kafka service single broker status](img/dcos-kafka-single-broker-status.png)

- Add Broker with options provided
`dcos kafka broker add 1 --mem 128 --heap 64 && dcos kafka broker start 1`

Expected outcome:
```
broker started:
  id: 1
  active: true
  state: running
  resources: cpus:1.00, mem:128, heap:64, port:auto
  failover: delay:1m, max-delay:10m
  stickiness: period:10m, hostname:192.168.65.121
  task:
    id: broker-1-40276308-8122-4e9c-b645-b6b98b46b5f1
    state: running
    endpoint: 192.168.65.121:1026
```

![Kafka service multi brokers status](img/dcos-kafka-multi-brokers-status.png)

- Add Topic
`dcos kafka topic add t0 --broker 0`

- Publishing and consuming messages

```
dcos kafka topic create topic1 --partitions 3 --replication 3
dcos kafka connection
dcos node ssh --master-proxy --master
docker run -it mesosphere/kafka-client
./kafka-console-producer.sh --broker-list ip-10-0-3-230.us-west-2.compute.internal:9092 --topic test
This is a message
This is another message
./kafka-console-consumer.sh --zookeeper master.mesos:2181/kafka --topic test --from-beginning
This is a message
This is another message
```

# Cleanup

Uninstall
`dcos package uninstall kafka`

Purge/cleanup persisted state
[Kafka uninstall](http://docs.mesosphere.com/services/kafka/#uninstall)


# Appendix: Next Steps

- [API Documentation](https://kafka.apache.org/documentation.html)
