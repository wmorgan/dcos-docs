---
post_title: Running Kafka on DC/OS
post_excerpt: ""
layout: page
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---

[Apache Kafka](https://kafka.apache.org/) is a distributed, fast, highly scalable and durable publish-subscribe messaging system.
In a nutshell, Kafka is a messaging system implemented as a distributed commit log.
[Apache Zookeeper](https://zookeeper.apache.org/) is used for coordination.
The purpose of Kafka is to serve real-time data ingestion systems with high-throughput and low-latency.
Kafka is written is Scala.


**Time Estimate**:

This tutorial will take aproximatively 20 minutes to complete, given a DC/OS cluster with sufficient resources is available.

**Target Audience**:

- Automated Administration

**Terminology**:

- pub/sub ... Publish/Subscribe messaging pattern
- Broker ... A Kafka message broker that routes messages to one or more topics
- Topic ... A Kafka topic: message filtering mechanism in the pub/sub systems. Subscribers register to receive/consume messages from topics
- Universe ... The default DC/OS repository
- Multiverse ... The extended DC/OS repository


**Scope**:

This tutorial will cover the installation of Kafka framework on DC/OS and dcos enhanced cli operations for Kafka.
You will learn how to install Kafka framework, how to validate the Kafka framework is up and running and how to use the enhanced cli Kafka operations.

# Table of Contents

# Prerequisites

- [Install](../install/README.md)
- Cluster Size - [Check Cluster Size](../getting-started/cluster-size)

# Installing

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

- Install the latest available kafka version
`dcos package install --yes kafka`

- Install/upgrade to a specific version of the kafka package
`dcos package install --yes --force --package-version=<package_version> kafka`

Validate that installation added enhanced cli Kafka support
`dcos package list kafka; dcos kafka help`

Validate that Kafka service is healthy
![DCOS dashboard services status](img/dcos-dashboard-kafka-service-status.png)
![DCOS services status](img/dcos-services-kafka-service-status.png)

# dcos Kafka operations

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


# Cleanup

Uninstall
`dcos package uninstall kafka`

Purge/cleanup persisted state
[Kafka uninstall](http://docs.mesosphere.com/services/kafka/#uninstall)


# Appendix: Next Steps

- [API Documentation](https://kafka.apache.org/documentation.html)
