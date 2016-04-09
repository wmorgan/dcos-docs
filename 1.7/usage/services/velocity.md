---
UID: 56f98445756de
post_title: Velocity
post_excerpt: ""
layout: page
published: true
menu_order: 19
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
# Overview

[Mesosphere Velocity][1] helps organizations accelerate application delivery by lowering the barriers to continuous integration and continuous delivery (CI/CD) for modern and traditional applications. Building upon capabilities in Mesosphere DCOS, and with Jenkins at its core, Velocity provides scalable and reliable infrastructure for application lifecycle management. Velocity’s tight integration with Marathon provides an end-to-end solution that automates the full application lifecycle, including building, testing and deploying applications in production.

Velocity allows you to scale your CI/CD infrastructure by dynamically creating and destroying build agents as demand increases or decreases and enables you to avoid the statically partitioned infrastructure typical of other standalone Jenkins clusters. You may also run multiple instances of Velocity on a single DCOS cluster, allowing multiple teams to use a single pool of resources, improving the efficiency of your CI/CD infrastructure.

To deploy Velocity, you must provide a mount point to a shared file system on each of your DCOS agents or "pin" the instance to a single DCOS agent in the cluster. There are a number of existing shared file system solutions, including NFS, HDFS (plus its NFS gateway), Ceph, and more. The following installation instructions use NFS as the example.

# Installation

Velocity is distributed as a Docker image. In order to download and install Velocity, you will first need to contact [Mesosphere Sales][2]. The Sales or Support team will give you a link to the Docker image and a link to the Velocity package repository for DCOS. There are two supported methods for running Velocity on your DCOS cluster:

*   *With a private Docker registry.* If you wish to use a private Docker registry, we will give you a URL to the Velocity Docker image, which you can load into your registry. More information about loading Docker images into a registry is available at [docs.docker.com][3].
*   *Using the public Docker Hub.* You can also pull the image from the Mesosphere organization hosted on [hub.docker.com][4]. You must provide Mesosphere Support with the Docker account that you wish to use to authenticate with Docker Hub (via `docker login`). More information is available at [docs.docker.com][5].

## Prerequisites

*   The [DCOS CLI][6] must be installed.
*   A mount point to a shared file system at the same path on each of your DCOS agents. NFS guides are available for [Red Hat Enterprise Linux][7], [Ubuntu][8], and [CoreOS][9].
*   The Velocity Docker image is available on your private registry or each of the DCOS agents in the cluster have been configured to access the private image on Docker Hub.

## Installing Velocity

[caption id="attachment_3997" align="aligncenter" width="800"]<a href="/wp-content/uploads/2016/03/01-turnkey-velocity.gif" rel="attachment wp-att-3997"><img src="/wp-content/uploads/2016/03/01-turnkey-velocity-800x450.gif" alt="Velocity installation process." width="800" height="450" class="size-large wp-image-3997" /></a> Velocity installation process.[/caption]

1.  First, add the private Velocity package repository to your DCOS cluster:
    
        $ dcos package repo add universe-private <https://path/to/universe-private.zip>
        

2.  Create a Velocity JSON configuration file that specifies any instance-specific or site-specific configuration values, such as the framework name, the base path to the NFS share on the DCOS agent, the name of the Docker image, or the number of CPUs and memory to allocate to the Jenkins master. For a complete list of configuration options, see the [Configuration Reference][10] page.
    
    In this example, we call the file `options.json`. This file will be used during the Velocity installation.
    
        {
            "velocity": {
                "framework-name": "velocity-team1",
                "host-volume": "/mnt/nfs/velocity_data"
            }
        }
        

You can run multiple Velocity installations on the same cluster by choosing a unique framework name, allowing you to share the cluster's resources among multiple teams or installations. Each Velocity installation creates a subdirectory inside the directory that you specified for the host volume. In this example, the data is stored on the NFS server at `/mnt/nfs/velocity_data/velocity-team1`.

1.  From the DCOS CLI, install Velocity with the JSON options file specified:
    
        $ dcos package install velocity --options=options.json
        

## Running Velocity

The first time Velocity runs, it populates the directory on your NFS share with a basic Jenkins configuration and a pre-selected set of plugins. If Marathon needs to restart the task on a different host, the container automatically mounts your existing data directory, including job configurations, build history, and installed plugins. For future versions of DCOS, we are planning to add support for other distributed file systems and leverage the external persistent volume support coming soon to DCOS.

1.  Verify that Velocity is installed and healthy.
    
    *   From the DCOS CLI, run the following command to list the installed packages: `$ dcos package list`.
    *   From the DCOS web interface, go to the Services tab and confirm that Velocity is running at `/#/services/`.

2.  Open your web browser and navigate to the Velocity web interface at `http://<hostname>/service/velocity`.

## Uninstalling Velocity

From the DCOS CLI, uninstall Velocity by running the following command:

    $ dcos package uninstall velocity
    

**Note:** You must manually clean up any job configurations and/or build data that was stored on your NFS share.

 [1]: https://mesosphere.com/velocity
 [2]: https://mesosphere.com/contact/
 [3]: https://docs.docker.com/engine/reference/commandline/load/
 [4]: https://hub.docker.com
 [5]: https://docs.docker.com/engine/reference/commandline/login/
 [6]: /usage/cli/install/
 [7]: https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Storage_Administration_Guide/ch-nfs.html
 [8]: https://help.ubuntu.com/14.04/serverguide/network-file-system.html
 [9]: https://coreos.com/os/docs/latest/mounting-storage.html#mounting-nfs-exports
 [10]: /usage/services/velocity/configuration-reference