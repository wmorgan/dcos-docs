---
post_title: Frequently Asked Questions for Administrators
nav_title: Admin FAQ
menu_order: 10
---

###### Q. Can I install DC/OS on an already running Mesos cluster?
- **A.** We recommend starting with a fresh cluster to ensure all defaults are set to expected values. This prevents unexpected conditions related to mismatched versions and configurations.

###### Q. What are the OS requirements of DC/OS?
- **A.** Please review our list of [system requirements, located here.](../installing/custom/system-requirements/)

###### Q. Does DC/OS install Zookeeper, or can I use my own Zookeeper quorum?
- **A.** DC/OS runs its own ZooKeeper supervised by Exhibitor and systemd, but users are able to create their own ZooKeeper quorums as well. The ZooKeeper quorum installed by default will be available at `master.mesos:[2181|2888|3888]`.

###### Q. Is it necessary to maintain a bootstrap node after the cluster is created?
- **A.** If you specify an `external_storage_backend` other than `static` in your cluster's configuration, you should maintain the external storage for the full lifetime of the cluster to facilitate leader elections. If your cluster is mission critical, it is wise to harden your external storage by using S3 or running the bootstrap ZooKeeper as a quorum. Interruptions of service from the external storage can be tolerated, but permanent loss of state can lead to unexpected conditions.

###### Q. How do I gracefully shut down an agent?
- **A.** To gracefully kill an agent node's Mesos process and allow systemd to restart it, use the following command. _Note: If Auto Scaling Groups are in use, the node will be replaced automatically_:

    ```bash
    $ sudo systemctl kill -s SIGUSR1 dcos-mesos-slave
    ```

- _For a public agent:_

    ```bash
    $ sudo systemctl kill -s SIGUSR1 dcos-mesos-slave-public
    ```

- To gracefully kill the process and prevent systemd from restarting it, add a `stop` command:

    ```bash
    $ sudo systemctl kill -s SIGUSR1 dcos-mesos-slave && sudo systemctl stop dcos-mesos-slave
    ```

- _For a public agent:_

    ```bash
    $ sudo systemctl kill -s SIGUSR1 dcos-mesos-slave-public && sudo systemctl stop dcos-mesos-slave-public
    ```
