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

This document is for developers who would like to test theirs software which requires Postgres in DCOS environment. This is a basic installation of PostgreSQL server which doesn't include data backup and is not highly available, so it's not recommended to use it in production as is.

# Prerequisites
*   [DCOS](/administration/installing/) installed
*   [DCOS CLI](/usage/cli/install/) installed
*	  [Cluster Size](../getting-started/cluster-size): at least one agent node with 1 CPU, 1GB of RAM and 1000MB of disk space available.

# Install Postgres from official Docker image
Create a file named [postgres.marathon.json](postgres.marathon.json) with the following Marathon application descriptor:
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
Run the following dcos command:
<pre>
dcos marathon app add postgres.marathon.json 
</pre>
This command will install PostgreSQL server on your DCOS cluster and make it available on VIP 5.4.3.2 and standard Postgres port 5432. 

# Test installation

TODO: Describe how to test the installation.

# Cleanup

To remove Postgres launch the following command:
<pre>
dcos marathon app remove postgres
</pre>