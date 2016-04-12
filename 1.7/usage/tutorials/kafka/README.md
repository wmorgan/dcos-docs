---
post_title: How to use Apache Kafka
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

**Terminology**:

- Broker ... TBD
- Publisher ... TBD
- Consumer ... TBD

**Scope**:

In the following tutorial you will learn about how to use Kafka on DC/OS, launching brokers and publishing/consuming messages.

# Installing

Assuming you have a DC/OS cluster up and running, the first step is to install Kafka. As the minimum cluster size for this tutorial I recommend at least three nodes with 2 CPUs and 2 GB of RAM available, each:

    $ dcos package install kafka
    This will install Apache Kafka DCOS Service.
    Continue installing? [yes/no] yes
    Installing Marathon app for package [kafka] version [0.9.4.0]
    Installing CLI subcommand for package [kafka] version [0.9.4.0]
    New command available: dcos kafka
    The Apache Kafka DCOS Service is installed:
      docs   - https://github.com/mesos/kafka
      issues - https://github.com/mesos/kafka/issues
      
While the DC/OS command line interface (CLI) is immediately available it takes a few minutes until Kafka is actually running in the cluster. Let's first check the DC/OS CLI and its new subcommand `kafka`:

    $ dcos kafka

## Launching a broker

    $ dcos kafka broker add 0

    $ dcos kafka broker start 0

## Publishing and consuming messages

    $ dcos kafka topic create topic1 --partitions 3 --replication 3

    $ dcos kafka connection
    
    $ dcos node ssh --master-proxy --master
    core@ip-10-0-6-153 ~ $ docker run -it mesosphere/kafka-client
    root@7bc0e88cfa52:/kafka_2.10-0.8.2.2/bin# ./kafka-console-producer.sh --broker-list ip-10-0-3-230.us-west-2.compute.internal:9092 --topic test
    This is a message
    This is another message
    root@7bc0e88cfa52:/kafka_2.10-0.8.2.2/bin# ./kafka-console-consumer.sh --zookeeper master.mesos:2181/kafka --topic test --from-beginning
    This is a message
    This is another message

## Further resources

TBD


