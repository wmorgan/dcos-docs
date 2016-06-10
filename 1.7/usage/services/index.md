---
post_title: Services
nav_title: Services
menu_order: 4
---

# About DC/OS services

DC/OS services are Marathon applications available as packages within public DC/OS package repositories. Available DC/OS services include Mesos frameworks and other applications. A Mesos framework is the combination of a Mesos scheduler and an optional custom executor.

# Managing DC/OS repos, packages, and services

DC/OS provides a number of services within its default package repository. You can use either the web interface or the CLI to:

* [Manage repositories](#managing-repos)
* [Find packages](#find-packages)
* [Customize service installation parameters](#customizing-install)
* [Install services](#installing)
* [Monitor installed services](#monitoring)
* [Add and remove packages from a repository](#add-rm-pks)
* [Uninstall services](#uninstall)

**Tip:** Before you can use the CLI, you need to [install it](/docs/1.7/usage/cli/install/).

# <a name="managing-repos"></a>Managing repositories

## Listing repositories

By default, the DC/OS CLI is configured to use the Universe, but other package repositories may also be configured.

See which package repositories are currently configured from the DC/OS CLI as follows:

```bash
$ dcos package repo list
Universe: https://universe.mesosphere.com/repo
```

## Adding a repository

The syntax to add a repo using the CLI follows.

```bash
$ dcos package repo add <repo-name> <repo-URI>
```

The following command adds a repo named `your-repo` located at `https://yourdomain.com/archive/stuff.zip`.

```bash
$ dcos package repo add your-repo https://yourdomain.com/archive/stuff.zip
```

## Removing a repository

The syntax to add a repo using the CLI follows:

```bash
$ dcos package repo remove <repo-name>
```

The following command removes a repo named `your-repo`.

```bash
$ dcos package repo remove your-repo
```

# <a name="finding-packages"></a>Finding packages

The syntax for searching for packages follows.

```bash
$ dcos package search [--json <query>]
```

The following command will locate big data packages.

```bash
$ dcos package search "big data"
NAME VERSION FRAMEWORK SOURCE DESCRIPTION
spark 1.4.0-SNAPSHOT True https://github.com/mesosphere/universe/archive/version-1.x.zip Spark is a fast and general cluster computing system for Big Data
```

# <a name="customizing-install"></a>Customizing service installation parameters

Each service installs with a set of default parameters. You can discover the default parameters and change them as desired.

1. View the available configuration options for the service with the `dcos package describe --config <package-name>` command.

    ```bash
    $ dcos package describe --config marathon
    {
     "properties": {
        "application": {
          "cpus": {
            "default": 2.0,
            "description": "CPU shares to allocate to each Marathon instance.",
            "minimum": 0.0,
            "type": "number"
         },
        ...
        "mem": {
          "default": 1024.0,
          "description": "Memory (MB) to allocate to each Marathon task.",
          "minimum": 512.0,
          "type": "number"
         },
         ...
    }
    ```

2.  Create a JSON configuration file. You can choose an arbitrary name, but you might want to choose a pattern like `<package-name>-config.json`. For example, `marathon-config.json`.

    ```bash
    $ nano marathon-config.json
    ```

3.  Use the `properties` objects (see [Discovering the default parameters](#discover-defaults)) to build your JSON options file. For example, to change the number of Marathon CPU shares to 3 and memory allocation to 2048:

    ```json
    {
      "application": {
        "cpus": 3.0, "mem": 2048.0
       }
    }
    ```

4.  From the DC/OS CLI, install the DC/OS service with the custom options file specified:

    ```bash
    $ dcos package install --options=marathon-config.json marathon
    ```

For more information, see the [dcos package](/docs/1.7/usage/cli/command-reference/#cli-dcos-package) documentation.

 
# <a name="installing"></a>Installing a service
 
## Installing a service using the CLI

The general syntax for installing a service with the CLI follows. 

```bash
$ dcos package install [--options=<config-file-name>.json] <servicename>
```

Use the optional `--options` flag to specify the name of the customized JSON file you created in [Customizing service installation parameters](#customizing-install).

For example, you would use the following command to install Chronos with the default parameters.
    
```bash
$ dcos package install chronos
```
    
## Installing a service using the web interface

1.  Navigate to the [**Universe**](/docs/1.7/usage/webinterface/#universe) page in the DC/OS UI.

2.  Choose your package and click **Install package**. 

3.  Confirm your installation or choose **Advanced Installation** to include a custom configuration, as discussed in [Customizing service installation parameters](#customizing-install).

## Verifying your installation

### CLI

```bash
$ dcos package list
```

### Web UI

Go to the **Services** tab and confirm that the service is running. For more information, see the UI [documentation](/docs/1.7/usage/webinterface/#services).

**Tip:** Some services from the "Community Packages" section of the Universe will not show up in the DC/OS service listing. For these, inspect the service's Marathon app in the Marathon UI to verify that the service is running and healthy.

# <a name="monitoring"></a>Monitoring installed services

## Monitoring services using the DC/OS CLI

From the DC/OS CLI, enter the `dcos service` command. In this example you can see the native Marathon instance and the installed DC/OS services Chronos, HDFS, and Kafka.

```bash
$ dcos service
NAME      HOST             ACTIVE  TASKS CPU   MEM     DISK   ID
chronos   <privatenode1>   True     0    0.0    0.0     0.0   <service-id1>
hdfs      <privatenode2>   True     1    0.35  1036.8   0.0   <service-id2>
kafka     <privatenode3>   True     0    0.0    0.0     0.0   <service-id3>
marathon  <privatenode3>   True     3    2.0   1843.0  100.0  <service-id4>
```

## Monitoring services using the DC/OS web interface

From the DC/OS web interface, click the **Services** [**Services**](/docs/1.7/usage/webinterface/#services) tab. 

*   **NAME** Displays the DC/OS service name.
*   **HOST** Displays the private agent node where the service running.
*   **ACTIVE** Indicates whether the service is connected to a scheduler.
*   **TASK** Displays the number of running tasks.
*   **CPU** Displays the percentage of CPU in use.
*   **MEM** Displays the amount of memory used.
*   **DISK** Displays the amount of disk space used.
*   **ID** Displays the DC/OS service framework ID. This value is automatically generated and is unique across the cluster.

The [Web Interfaces](/docs/1.7/usage/webinterface/#services) page contains more details about the **Services** tab. 

# <a name="add-rm-pkgs"></a>Adding and removing packages from a repository

## Adding a Repository

Add a repo with the name `your-repo` and the repo archive URL `https://yourcompany/archive/stuff.zip`:

```bash
$ dcos package repo add your-repo https://yourcompany/archive/stuff.zip
```

## Removing a Repository

Remove the repo with the name `your-repo`:

```bash
$ dcos package repo remove your-repo
```

# <a name="uninstall"></a>Uninstalling services

## About uninstalling services

Services can be uninstalled from either the web interface or the CLI. If the service has any reserved resources, you also need to run the framework cleaner script. The framework cleaner script removes the service instance from ZooKeeper, along with any data associated with it.  

## Uninstalling a service

### Uninstalling a service using the CLI

1.  Uninstall a datacenter service with this command:

    ```bash
    $ dcos package uninstall <servicename>
    ```

    For example, to uninstall Chronos:

    ```bash
    $ dcos package uninstall chronos
    ```

### Uninstalling a service using the web UI

1.  Navigate to the Universe page in the DC/OS UI:

    ![Universe](/docs/latest/usage/services/img/webui-universe-install.png)

2.  Click on the Installed tab:

    ![Universe](/docs/latest/usage/services/img/webui-universe-installed-packages.png)

3.  Hover your cursor over the name of the package you wish to uninstall and you will see a red "Uninstall" link to the right. Click this link to uninstall the package.

## <a name="framework-cleaner"></a>Cleaning up ZooKeeper

### About cleaning up ZooKeeper

If your service has reserved resources, you can use the framework cleaner docker image, `mesosphere/janitor`, to simplify the process of removing your service instance from ZooKeeper and destroying all the data associated with it.

There are two ways to run the framework cleaner script. The preferred method is via the DC/OS CLI. If the CLI is unavailable, you can also run the image as a self-deleting Marathon task.

### Configuring the cleanup

The script takes the following flags:

* `-r`: The role of the resources to be deleted
* `-p`: The principal of the resources to be deleted
* `-z`: The configuration zookeeper node to be deleted

These are some examples of default configurations (these will vary depending on selected task name, etc):

* Cassandra:
    * Default: `-r cassandra-role -p cassandra-principal -z cassandra`
    * Custom name: `-r <name>-role -p <name>-principal -z <name>`
* Kafka:
    * Default: `-r kafka-role -p kafka-principal -z kafka`
    * Custom name: `-r <name>-role -p <name>-principal -z <name>`

### Running from the DC/OS CLI

Connect to the leader and start the script:

1. Open an SSH session to the cluster leader.

        your-machine$ dcos node ssh --master-proxy --leader

1. Run the `mesosphere/janitor` image with the role, principal, and zookeeper nodes that were configured for your service:

        leader$ docker run mesosphere/janitor /janitor.py -r sample-role -p sample-principal -z sample-zk

### Running from Marathon

From the Marathon web interface, use the JSON editor to add the following as a Marathon task. Replace the values passed to `-r`/`-p`/`-z` according to what needs to be cleaned up.

    {
      "id": "janitor",
      "cmd": "/janitor.py -r sample-role -p sample-principal -z sample",
      "cpus": 1,
      "mem": 128,
      "disk": 1,
      "instances": 1,
      "container": {
        "docker": {
          "image": "mesosphere/janitor:latest",
          "network": "HOST"
        },
        "type": "DOCKER"
      }
    }
    
When the framework cleaner has completed its work, it will automatically remove itself from Marathon to ensure that it's only run once. This removal will often result in a `TASK_KILLED` or even a `TASK_FAILED` outcome for the janitor task, even if it finished successfully. The janitor task will also quickly disappear from both the Marathon web interface and the Dashboard.

### Verifying the outcome

To view the script's outcome, go to Mesos (http://your-cluster.com/mesos) and look at the task's `stdout` content. If `stdout` lacks content, run the following command manually:

    # Determine id of agent which ran the Docker task. This is an example:
    
    your-machine$ dcos node ssh --master-proxy --mesos-id=c62affd0-ce56-413b-85e7-32e510a7e131-S3
    
    agent-node$ docker ps -a
    CONTAINER ID        IMAGE                       COMMAND             ...
    828ee17b5fd3        mesosphere/janitor:latest   /bin/sh -c /janito  ...
    
    agent-node$ docker logs 828ee17b5fd3
    
### Sample result

Here's an example of the output for a successful run for a Cassandra installation:

    your-machine$ dcos node ssh --master-proxy --leader

    leader-node$ docker run mesosphere/janitor /janitor.py -r cassandra_role -p cassandra_principal -z cassandra
    [... docker download ...]
    Master: http://leader.mesos:5050/master/ Exhibitor: http://leader.mesos:8181/ Role: cassandra_role Principal: cassandra_principal ZK Path: cassandra
    
    Destroying volumes...
    Mesos version: 0.28.1 => 28
    Found 1 volume(s) for role 'cassandra_role' on slave 3ce447e3-2894-4c61-bd0f-be97e4d99ee9-S5, deleting...
    200 
    Found 1 volume(s) for role 'cassandra_role' on slave 3ce447e3-2894-4c61-bd0f-be97e4d99ee9-S4, deleting...
    200 
    No reserved resources for any role on slave 3ce447e3-2894-4c61-bd0f-be97e4d99ee9-S3
    No reserved resources for any role on slave 3ce447e3-2894-4c61-bd0f-be97e4d99ee9-S2
    Found 1 volume(s) for role 'cassandra_role' on slave 3ce447e3-2894-4c61-bd0f-be97e4d99ee9-S1, deleting...
    200 
    No reserved resources for role 'cassandra_role' on slave 3ce447e3-2894-4c61-bd0f-be97e4d99ee9-S0. Known roles are: [slave_public]
    
    Unreserving resources...
    Found 4 resource(s) for role 'cassandra_role' on slave 3ce447e3-2894-4c61-bd0f-be97e4d99ee9-S5, deleting...
    200 
    Found 4 resource(s) for role 'cassandra_role' on slave 3ce447e3-2894-4c61-bd0f-be97e4d99ee9-S4, deleting...
    200 
    No reserved resources for any role on slave 3ce447e3-2894-4c61-bd0f-be97e4d99ee9-S3
    No reserved resources for any role on slave 3ce447e3-2894-4c61-bd0f-be97e4d99ee9-S2
    Found 4 resource(s) for role 'cassandra_role' on slave 3ce447e3-2894-4c61-bd0f-be97e4d99ee9-S1, deleting...
    200 
    No reserved resources for role 'cassandra_role' on slave 3ce447e3-2894-4c61-bd0f-be97e4d99ee9-S0. Known roles are: [slave_public]
    
    Deleting zk node...
    Successfully deleted znode 'cassandra' (code=200), if znode existed.
    Cleanup completed successfully.

If you run the script via Marathon, you will also see the following output:

    Deleting self from Marathon to avoid run loop: /janitor
    Successfully deleted self from marathon (code=200): /janitor
