---
UID: 56f984454f791
post_title: Configuration Reference
post_excerpt: ""
layout: page
published: true
menu_order: 130
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
Services on DCOS are configured via a JSON file that is passed to the DCOS CLI when installing a package. To configure Velocity, create a new JSON options file in your working directory. This file will contain options specific to your environment, such as the name of the framework (e.g. `velocity-team1`, `velocity-team2`, and so on), and the path to the NFS share where you want to save the Jenkins configuration and build data.

# General options

<table class="table">
  <tr>
    <th class="tg-e3zv">
      Configuration Parameter
    </th>
    
    <th class="tg-e3zv">
      Description
    </th>
    
    <th class="tg-e3zv">
      Default Value
    </th>
  </tr>
  
  <tr>
    <td class="tg-yw4l">
      <code>framework-name</code>
    </td>
    
    <td class="tg-yw4l">
      The framework name to register with Mesos.
    </td>
    
    <td class="tg-yw4l">
      <code>velocity</code>
    </td>
  </tr>
  
  <tr>
    <td class="tg-yw4l">
      <code>host-volume</code>
    </td>
    
    <td class="tg-yw4l">
      The location of a volume on the host for persistent Velocity configuration and build data. The final location will be derived from this value plus the name set in `framework-name` (e.g. `/mnt/host_volume/velocity`). This path must be the same on all DCOS agents.
    </td>
    
    <td class="tg-yw4l">
      <code>/tmp</code>
    </td>
  </tr>
  
  <tr>
    <td class="tg-yw4l">
      <code>pinned-hostname</code>
    </td>
    
    <td class="tg-yw4l">
      An optional DCOS agent hostname to run this instance on (e.g. `10.0.0.1`).
    </td>
    
    <td class="tg-yw4l">
      None
    </td>
  </tr>
  
  <tr>
    <td class="tg-yw4l">
      <code>docker-image</code>
    </td>
    
    <td class="tg-yw4l">
      The Docker image to use for the Velocity service. By default, this package will use the Velocity image in the Mesosphere organization on Docker Hub. Otherwise, specify the host, image, and tag for the Velocity image on your private Docker registry.
    </td>
    
    <td class="tg-yw4l">
      None
    </td>
  </tr>
  
  <tr>
    <td class="tg-yw4l">
      <code>known-hosts</code>
    </td>
    
    <td class="tg-yw4l">
      A space-separated list of hosts used to populate the SSH known hosts file on the master.
    </td>
    
    <td class="tg-yw4l">
      <code>github.com</code>
    </td>
  </tr>
  
  <tr>
    <td class="tg-yw4l">
      <code>cpus</code>
    </td>
    
    <td class="tg-yw4l">
      CPU shares to allocate to each master.
    </td>
    
    <td class="tg-yw4l">
      <code>1.0</code>
    </td>
  </tr>
  
  <tr>
    <td class="tg-yw4l">
      <code>mem</code>
    </td>
    
    <td class="tg-yw4l">
      Memory to allocate to each master (in MB).
    </td>
    
    <td class="tg-yw4l">
      <code>2048.0</code>
    </td>
  </tr>
  
  <tr>
    <td class="tg-yw4l">
      <code>jvm-opts</code>
    </td>
    
    <td class="tg-yw4l">
      Optional arguments to pass to the JVM.
    </td>
    
    <td class="tg-yw4l">
      <code>-Xms1024m -Xmx1024m</code>
    </td>
  </tr>
</table>

# Advanced options

<table class="table">
  <tr>
    <th class="tg-e3zv">
      Configuration Parameter
    </th>
    
    <th class="tg-e3zv">
      Description
    </th>
    
    <th class="tg-e3zv">
      Default Value
    </th>
  </tr>
  
  <tr>
    <td class="tg-yw4l">
      <code>host</code>
    </td>
    
    <td class="tg-yw4l">
      The host that build agents will use to connect to the master.
    </td>
    
    <td class="tg-yw4l">
      <code>$HOST</code>
    </td>
  </tr>
  
  <tr>
    <td class="tg-yw4l">
      <code>mesos-master</code>
    </td>
    
    <td class="tg-yw4l">
      URL of the cluster's Mesos master.
    </td>
    
    <td class="tg-yw4l">
      <code>zk://leader.mesos:2181/mesos</code>
    </td>
  </tr>
  
  <tr>
    <td class="tg-yw4l">
      <code>role</code>
    </td>
    
    <td class="tg-yw4l">
      The accepted resource roles (e.g. `slave_public`). By default, this will deploy to any agents with the `*` role.
    </td>
    
    <td class="tg-yw4l">
      <code>*</code>
    </td>
  </tr>
</table>

# Examples

## Create a new instance backed by NFS

The following JSON options file will create a new DCOS service named `velocity-team1` and use the NFS share located at `/mnt/nfs/velocity_data`:

    {
        "velocity": {
            "framework-name": "velocity-team1",
            "host-volume": "/mnt/nfs/velocity_data"
        }
    }
    

**Tip:** The value of `host-volume` is the base path to a share on a NFS server or other distributed filesystem. The actual path on-disk for this particular example will be `/mnt/nfs/velocity_data/velocity-team1`.

## Create a new instance pinned to a single host

You can also specify an optional `pinned-hostname` constraint. This is useful if you don't have NFS available and need to pin Jenkins to a specific node:

    {
        "velocity": {
            "framework-name": "velocity-pinned",
            "host-volume": "/var/velocity_data",
            "pinned-hostname": "10.0.0.100"
        }
    }
    

## Modify known hosts

The `known-hosts` option allows you to specify a space-separated list of hostnames for which you'd like to retrieve the SSH public keys. This list will be populated on the Jenkins master when the bootstrap script runs (at container launch time). You will need to manually ensure that the SSH known hosts list is populated in any Jenkins agent containers; an example is included in the `dind-image` directory located at the root of this repo.

    {
        "jenkins": {
            "framework-name": "jenkins-private-git",
            "host-volume": "/mnt/nfs/jenkins_data",
            "known-hosts": "github.com git.apache.org git.example.com"
        }
    }
    

## Installation

Install Velocity with your site-specific configuration by running the following command. In this example, the JSON configuration file is called `options.json`.

    $ dcos package install velocity --options=options.json
    

Wait a few moments for the instance to become healthy, then access the Velocity service via the DCOS web interface.