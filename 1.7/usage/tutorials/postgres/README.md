---
post_title: Running PostgreSQL on DC/OS
post_excerpt: ""
layout: page
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---

[PostgreSQL](http://www.postgresql.org/) is an object-relational database management system with an emphasis on extensibility and standards-compliance.

**Time Estimate**:

It will take around 10 minutes to complete this tutorial.

**Target Audience**:

This tutorial is for developers who want to test their software and use Postgres in DC/OS environment. This is a basic installation of PostgreSQL server and it does not include data backup and is not highly available. This is not meant for use in a production environment.

# Prerequisites
*   [DC/OS](/administration/installing/) installed
*   [DC/OS CLI](/usage/cli/install/) installed
*	[Cluster Size](../getting-started/cluster-size): at least one agent node with 1 CPU, 1 GB of RAM and 1000 MB of disk space available.

# Install Postgres from official Docker image

Create a Marathon app definition file named [postgres.marathon.json](postgres.marathon.json) with the following Marathon application descriptor. A Marathon app definition file specifies the required parameters for launching an app with Marathon. Specified in this app definition is the PostgreSQL Docker container, the PostgreSQL password, the resources required, Marathon health checks, and Marathon [upgrade strategy](https://mesosphere.github.io/marathon/docs/rest-api.html). 

<pre>
{
  "id": "/postgres",
  "cpus": 1,
  "mem": 1024,
  "instances": 1,
  "container": {
    "type": "DOCKER",
    "volumes": [
      {
        "containerPath": "pgdata",
        "mode": "RW",
        "persistent": {
          "size": 10000
        }
      }
    ],
    "docker": {
      "image": "postgres:9.5",
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 5432,
          "hostPort": 0,
          "protocol": "tcp",
          "labels": {
            "VIP_0": "5.4.3.2:5432"
          }
        }
      ],
    }
  },
  "env": {
    "POSTGRES_PASSWORD": "DC/OS_ROCKS",
    "PGDATA": "/mnt/mesos/sandbox/pgdata"
  },
  "healthChecks": [
    {
      "protocol": "TCP",
      "portIndex": 0,
      "gracePeriodSeconds": 300,
      "intervalSeconds": 60,
      "timeoutSeconds": 20,
      "maxConsecutiveFailures": 3,
      "ignoreHttp1xx": false
    }
  ],
  "upgradeStrategy": {
    "maximumOverCapacity": 0,
    "minimumHealthCapacity": 0
  }
}
</pre>

Add the Marathon app definition to DC/OS with this CLI command:
<pre>
dcos marathon app add postgres.marathon.json 
</pre>

This command installs the PostgreSQL server on your DC/OS cluster and makes it available on VIP `5.4.3.2` and standard Postgres port `5432`. 

# Test installation

TODO: Describe how to test the installation.

# Cleanup

You can remove Postgres with this DC/OS CLI command:
<pre>
dcos marathon app remove postgres
</pre>