---
post_title: Running Stateful Services on DC/OS via Marathon
post_excerpt: ""
layout: page
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---

A stateful service acts on persistent data. Simple, stateless services in Marathon run in an empty sandbox each time they are launched. In contrast, stateful services on Marathon make use of persistent volumes that reside on agents in a cluster until explicitly destroyed.

These persistent volumes are mounted into a task's Mesos sandbox and are therefore continuously accessible to a service. Marathon creates persistent volumes for each task and all resources required to run the task are dynamically reserved. That way, Marathon ensures that a service can be relaunched and can reuse its data when needed. This is useful for databases, caches, and other data-aware services.

If the service you intend to run does not replicate data on its own, you need to take care of backups or have a suitable replication strategy.

Stateful services leverage 2 underlying Mesos features:

- [Dynamic reservations](http://mesos.apache.org/documentation/latest/reservation/) with reservation labels
- [Persistent volumes](http://mesos.apache.org/documentation/latest/persistent-volume/)

**Time Estimate**:

Approximately 20 minutes.

**Target Audience**:

This tutorial is for developers who want to run stateful services on DC/OS. This tutorial does not cover data replication and persistent volume functionality is not considered highly available or ready for production.

**Terminology**:

- **Dynamic reservation:** For stateful services, Marathon uses dynamic reservations that are created for a role at runtime if needed.
- **Persistent volume:** Persistent volumes are created by Mesos and reside on an agent until explicitly destroyed.

**Scope**:

This will teach you how to set up and manage a stateful service on DC/OS.

# Prerequisites
* [DC/OS](/administration/installing/) installed
* [DC/OS CLI](/usage/cli/install/) installed
* [Cluster Size](../getting-started/cluster-size): at least one agent node with 1 CPU, 1 GB of RAM and 1000 MB of disk space available.

# Install a stateful service

1. Install the official PostgresSQL Docker image using the provided [JSON configuration](postgres.marathon.json):

```shell
$ dcos marathon app add postgres.marathon.json
```
The task will eventually become healthy and ready to use.

1. List all tasks:

```shell
$ dcos marathon task list
APP        HEALTHY          STARTED              HOST     ID                                             
/postgres    True   2016-04-13T17:25:08.301Z  10.0.1.223  postgres.f2419e31-018a-11e6-b721-0261677b407a  
```

1. Inspect the details of the stateful service you created:

```
$ dcos marathon task show postgres.f2419e31-018a-11e6-b721-0261677b407a
{
  "appId": "/postgres",
  "host": "10.0.1.223",
  "id": "postgres.f2419e31-018a-11e6-b721-0261677b407a",
  "ipAddresses": [
    {
      "ipAddress": "172.17.0.3",
      "protocol": "IPv4"
    }
  ],
  "localVolumes": [
    {
      "containerPath": "pgdata",
      "persistenceId": "postgres#pgdata#f2415010-018a-11e6-b721-0261677b407a"
    }
  ],
  "ports": [
    2073
  ],
  "servicePorts": [
    10000
  ],
  "slaveId": "01447637-182a-48b0-b040-d6a7832f05b2-S0",
  "stagedAt": "2016-04-13T17:25:07.466Z",
  "startedAt": "2016-04-13T17:25:08.301Z",
  "version": "2016-04-13T17:25:07.443Z"
}
```

This command displays all information about the task along with the created volume.

# Stop the service

Now, stop the service:
```shell
$ dcos marathon app stop postgres
```

This command scales the `instances` count down to 0 and kills all runing tasks. If you inspect the tasks list again, you will notice that the task is still there, however, containing the information about which agent it was placed on and which persistent volume it had attached, but without a `startedAt` value:

```shell
$ dcos marathon task list
APP        HEALTHY  STARTED     HOST     ID                                             
/postgres    True     N/A    10.0.1.223  postgres.f2419e31-018a-11e6-b721-0261677b407a

$ dcos marathon task show postgres.f2419e31-018a-11e6-b721-0261677b407a
{
  "appId": "/postgres",
  "host": "10.0.1.223",
  "id": "postgres.f2419e31-018a-11e6-b721-0261677b407a",
  "localVolumes": [
    {
      "containerPath": "pgdata",
      "persistenceId": "postgres#pgdata#f2415010-018a-11e6-b721-0261677b407a"
    }
  ],
  "servicePorts": [
    10000
  ],
  "slaveId": "01447637-182a-48b0-b040-d6a7832f05b2-S0"
}
```

# Restart

Start the stateful service again:

```shell
$ dcos marathon app start postgres
```

The metadata of the previous `postgres` task is used to launch a new task that takes over the reservations and volumes of the previously stopped service. Inspect the running task again by repeating the command from the previous step. You will see that the same `persistenceId` is used and the running service task is using the same data as the previous one.

# Scale up

Scale the service to 2 instances:

```shell
$ dcos marathon app update postgres instances=2
```

# Scale down

Suppose you now want to scale down again and will no longer need the data for the second task. Follow two steps to scale down your app and clear the repository:

1. scale down to 1 task:

```shell
$ dcos marathon app update postgres instances=1
```
You will still see the second task, as you did before when scaling to 0.

1. In order to get rid of the task and its persistent data, you need to now explicitly `wipe` the state off the internal repository:

```
$ dcos marathon task stop postgres.53ab8733-fd96-11e5-8e70-76a1c19f8c3d --wipe
```

The task will be wiped from the Marathon state, its reserved resources will be unreserved and the persistent volumes it used will be destroyed. The Mesos garbage collection process will eventually remove destroyed persistent volumes from disk.

# Cleanup

In order to restore the state of your cluster as it was before installing the stateful service, you delete the service:

```shell
$ dcos marathon app remove postgres
```

# Appendix

For further information on stateful services in DC/OS on Marathon, see:

- [Marathon API Documentation](https://mesosphere.github.io/marathon/docs/persistent-volumes.html)
