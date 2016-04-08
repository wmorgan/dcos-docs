---
post_title: Running ArangoDB on DC/OS
post_excerpt: ""
layout: page
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---

ArangoDB is a distributed, multi-model database featuring JSON
documents, graphs and key/value pairs. It has a unified query language (AQL)
that allows to mix all three data models and supports joins and
transactions.

**Time Estimate**:

~5 minutes

**Target Audience**:

Anyone that wants to deploy a distributed multi model database on DC/OS. Beginner level.

**Scope**:

This tutorial covers the basics to get you started with ArangoDB on DC/OS.

# Table of Contents

## Prerequisites

This tutorial assumes that you have a DC/OS cluster up and running and that you have installed the `dcos` command on your computer.

## Installation of ArangoDB on DC/OS

The dcos command line utility provides a very convenient way to deploy applications on your DC/OS cluster.

Using the dcos command line utility deploying ArangoDB is as easy as:

    dcos package install arangodb

This will install the dcos subcommand and start an instance of the ArangoDB framework/service with its default configuration under its standard name "arangodb" via Marathon.

When you open the DC/OS UI in the browser you can now watch your ArangoDB cluster starting up on your Open DC/OS cluster when you access the “Services” tab:

![Services](img/services.png)

Clicking on the ArangoDB task will reveal the involved subtask that the framework has started:

![Tasks](img/tasks.png)

Clicking on “Open Service” will open the ArangoDB Cluster Dashboard:

![Dashboard](img/dashboard.png)

By default ArangoDB will not expose itself to the outside. The IPs listed here are the internal IPs in the cluster. To access the nodes from the outside we recommend to use sshuttle (https://github.com/sshuttle/sshuttle).

The exact way to dig a tunnel using sshuttle varies from infrastructure to infrastructure. The following is an example for an AWS cluster:

    sshuttle --python /opt/mesosphere/bin/python3.4 -r core@54.171.143.132 10.0.0.0/8

The IP may be extracted from the top left corner in the DC/OS UI:

![Dashboard](img/ip.png)

Note: Some sshuttle versions had problems during our tests. Version 0.77.3 worked properly for us.

Afterwards you should be able to access the internal IPs and clicking on the coordinator link in the ArangoDB cluster UI should open the ArangoDB coordinator:

![Dashboard](img/arangodb.png)

Congratulations. You now have ArangoDB running on DC/OS.


## Further reading

### Service discovery

ArangoDB integrates with DC/OS service discovery (https://docs.mesosphere.com/administration/service-discovery/mesos-dns/service-naming/). From within the cluster you should use this to talk to the coordinator. To find out the IP of the coordinator do a standard DNS lookup for arangodb-coordinator1.arangodb.mesos.

Then issue a SRV DNS request to arangodb-coordinator1.arangodb.mesos to find out the port.

### Deinstallation/Shutdown

To shutdown and delete your ArangoDB framework/service and to remove the
command line tool, do the following two commands:

    dcos arangodb uninstall ; dcos package uninstall arangodb

The first one uses the "arangodb" subcommand to gracefully shut down and
delete all instances of your ArangoDB service. The framework scheduler
itself will run in a silent mode for another 120 seconds. This enables
the second command to remove the "arangodb" subcommand and the entry in
Marathon that would otherwise restart the framework scheduler
automatically.

### Configuration options

There are a number of options, which can be specified in the following
way:

    dcos package install --config=<JSON_FILE> arangodb

where `JSON_FILE` is the path to a JSON file. For a list of possible
attribute values and their documentation see

    dcos package describe --config arangodb

### Further Infos

For further infos please visit

    https://github.com/arangoDB/arangodb-mesos-framework

It is distributed in binary form as a Docker image

    arangodb/arangodb-mesos-framework
    
See the [README.md](https://github.com/ArangoDB/arangodb-mesos-framework)
in the framework repository for details on how the framework scheduler is
configured.


### Support and bug reports

The ArangoDB Mesos framework as well as the DCOS subcommand are
supported by ArangoDB GmbH, the company behind ArangoDB. If you get
stuck, need help or have questions, just ask via one of the following
channels:

  - [Slack](http://slack.arangodb.com)
  - [Google Group](https://groups.google.com/forum/#!forum/arangodb)
  - `hackers@arangodb.com`: developer mailing list of ArangoDB
  - `max@arangodb.com`: direct email to Max Neunhöffer
  - `frank@arangodb.com`: direct email to Frank Celler
  - `mop@arangodb.com`: direct email to Andreas Streichardt

Additionally, we track issues, bug reports and questions via the github
issue trackers at

  - [arangodb-dcos](https://github.com/ArangoDB/arangodb-dcos/issues):
    the DCOS subcommand
  - [arangodb-mesos](https://github.com/arangodb/arangodb-mesos/issues):
    the ArangoDB framework/service