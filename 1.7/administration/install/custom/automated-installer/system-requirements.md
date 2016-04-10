---
UID: 5703eac5ec464
post_title: System Requirements
post_excerpt: ""
layout: page
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
# Hardware Prerequisites

You must have a single bootstrap node, Mesos master nodes, and Mesos agent nodes.

## Bootstrap node

1 node with 2 Cores, 16 GB RAM, 60 GB HDD. This is the node where DCOS installation is run. This bootstrap node must also have:

*   Python, pip, and virtualenv must be installed for the DCOS [CLI][1]. pip must be configured to pull packages from PyPI or your private PyPI, if applicable.
*   A High-availability (HA) load balancer, such as HAProxy to balance the following TCP ports to all master nodes: 80, 443, 8080, 8181, 2181, 5050. 
*  An unencrypted SSH key that can be used to authenticate with the cluster nodes over SSH. Encrypted SSH keys are not supported.
    
## Cluster nodes

The cluster nodes are designated Mesos masters and agents during installation.

### Master nodes

Here are the master node hardware requirements.

<table class="table">
  <tr>
    <th>
      Minimum
    </th>
    
    <th>
      Recommended
    </th>
  </tr>
  
  <tr>
    <td>
      Nodes: 1<br />OS: Enterprise Linux 7 kernel 3.10.0-327 or CoreOS Stable<br />Processor: 4 cores<br />Memory: 32 GB RAM<br />Hard disk space: 120 GB
    </td>
    
    <td>
      Nodes: 3<br />OS: Enterprise Linux 7 kernel 3.10.0-327 or CoreOS Stable<br />Processor: 4 cores<br />Memory: 32 GB RAM<br />Hard disk space: 120 GB
    </td>
  </tr>
</table>

### Agent nodes

Here are the agent node hardware requirements.

<table class="table">
  <tr>
    <th class="tg-e3zv">
      Minimum
    </th>
    
    <th class="tg-e3zv">
      Recommended
    </th>
  </tr>
  
  <tr>
    <td class="tg-031e">
      Nodes: 1<br />OS: Enterprise Linux 7 kernel 3.10.0-327 or CoreOS Stable<br />Processor: 2 cores<br />Memory: 16 GB RAM<br />Hard disk space: 60 GB
    </td>
    
    <td class="tg-031e">
      Nodes: 6<br />OS: Enterprise Linux 7 kernel 3.10.0-327 or CoreOS Stable<br />Processor: 2 cores<br />Memory: 16 GB RAM<br />Hard disk space: 60 GB
    </td>
  </tr>
  
  <tr>
    <td colspan="2">
      The agent nodes must also have: * A <code>/var</code> directory with 10 GB or more of free space. This directory is used by the sandbox for both Docker and Mesos Containerizer.* Network Access to a public Docker repository or to an internal Docker registry.</ul>
    </td>
  </tr>
</table>

</ul>

*   Your Linux distribution must be running the latest version. You can update CentOS with this command:
<pre>$ sudo yum upgrade -y</pre>

*   On RHEL 7 and CentOS 7, firewalld must be stopped and disabled. It is a known <a href="https://github.com/docker/docker/issues/16137" target="_blank">Docker issue</a> that firewalld interacts poorly with Docker. For more information, see the <a href="https://docs.docker.com/v1.6/installation/centos/#firewalld" target="_blank">Docker CentOS firewalld</a> documentation.
<pre>$ sudo systemctl stop firewalld && sudo systemctl disable firewalld</pre>

</ul>

### Port Configuration

*   Each node is network accessible from the bootstrap node.
*   Each node has SSH enabled and ports open from the bootstrap node.
*   Each node has IP-to-IP connectivity from itself to all nodes in the DCOS cluster.
*   Each node has Network Time Protocol (NTP) for clock synchronization enabled.
*   Each node has ICMP enabled.
*   Each node has TCP and UDP enabled port 53 for DNS.
*   All hostnames (FQDN and short hostnames) must be resolvable in DNS, both forward and reverse lookups must succeed. </ul> 
    These ports must be open for communication from the master nodes to the agent nodes:</li> </ul>
    
    <table class="table">
      <tr>
        <th class="tg-e3zv">
          TCP Port
        </th>
        
        <th class="tg-e3zv">
          Description
        </th>
      </tr>
      
      <tr>
        <td class="tg-yw4l">
          5051
        </td>
        
        <td class="tg-yw4l">
          Mesos agent nodes
        </td>
      </tr>
    </table>
    
    </ul> These ports must be open for communication from the agent nodes to the master nodes.
    
    <table class="table">
      <tr>
        <th class="tg-e3zv">
          TCP Port
        </th>
        
        <th class="tg-e3zv">
          Description
        </th>
      </tr>
      
      <tr>
        <td class="tg-yw4l">
          2181
        </td>
        
        <td class="tg-yw4l">
          ZooKeeper, see the <a href="http://zookeeper.apache.org/doc/r3.1.2/zookeeperAdmin.html#sc_zkCommands" target="_blank">ZK Admin Guide</a>
        </td>
      </tr>
      
      <tr>
        <td class="tg-yw4l">
          2888
        </td>
        
        <td class="tg-yw4l">
          Exhibitor, see the <a href="https://github.com/Netflix/exhibitor/wiki/REST-Introduction" target="_blank">Exhibitor REST Documentation</a>
        </td>
      </tr>
      
      <tr>
        <td class="tg-yw4l">
          3888
        </td>
        
        <td class="tg-yw4l">
          Exhibitor, see the <a href="https://github.com/Netflix/exhibitor/wiki/REST-Introduction" target="_blank">Exhibitor REST Documentation</a>
        </td>
      </tr>
      
      <tr>
        <td class="tg-031e">
          5050
        </td>
        
        <td class="tg-031e">
          Mesos master nodes
        </td>
      </tr>
      
      <tr>
        <td class="tg-031e">
          5051
        </td>
        
        <td class="tg-031e">
          Mesos agent nodes
        </td>
      </tr>
      
      <tr>
        <td class="tg-031e">
          8080
        </td>
        
        <td class="tg-031e">
          Marathon
        </td>
      </tr>
      
      <tr>
        <td class="tg-031e">
          8123
        </td>
        
        <td class="tg-031e">
          Mesos-DNS API
        </td>
      </tr>
      
      <tr>
        <td class="tg-yw4l">
          8181
        </td>
        
        <td class="tg-yw4l">
          Exhibitor, see the <a href="https://github.com/Netflix/exhibitor/wiki/REST-Introduction" target="_blank">Exhibitor REST Documentation</a>
        </td>
      </tr>
    </table>
        

       
        
# Software Prerequisites

## All Nodes

### Docker

Your bootstrap and cluster nodes must have Docker version 1.9 or greater installed. You must run Docker commands as the root user (`sudo`). For more information, see <a href="http://docs.docker.com/engine/installation/" target="_blank">Docker installation</a>. Install Docker by using these commands for your Linux distribution.

*   **CoreOS** Includes Docker natively.

*   **RHEL** Install Docker by using a subscription channel. For more information, see <a href="https://access.redhat.com/articles/881893" target="_blank">Docker Formatted Container Images on Red Hat Systems</a>. <!-- $ curl -sSL https://get.docker.com | sudo sh -->

*   **CentOS** CentOS Install Docker with OverlayFS.
    
    1.  Add the Docker yum repo to your node:
        
            $ sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
            [dockerrepo]
            name=Docker Repository
            baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
            enabled=1
            gpgcheck=1
            gpgkey=https://yum.dockerproject.org/gpg
            EOF
            
    
    2.  Create Docker systemd drop-in files:
        
            $ sudo mkdir -p /etc/systemd/system/docker.service.d && sudo tee /etc/systemd/system/docker.service.d/override.conf <<- EOF 
            [Service] 
            ExecStart= 
            ExecStart=/usr/bin/docker daemon --storage-driver=overlay -H fd:// 
            EOF
            
    
    3.  Install the Docker engine, daemon, and service:
        
            $ sudo yum install -y docker-engine &&
             sudo systemctl start docker &&
              sudo systemctl enable docker
            
        
        This can take a few minutes. This is what the end of the process should look like: Complete! Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
    
    You can test that your Docker build is properly installed with this command:
    
        $ sudo docker ps
        
    
    Do not use use Docker `devicemapper` storage driver for loopback. For more information, see <a href="https://docs.docker.com/engine/userguide/storagedriver/device-mapper-driver/" target="_blank">Docker and the Device Mapper storage driver</a>.

## Bootstrap node

The bootstrap node is a permanent part of your cluster and is required for DCOS recovery. The leader state and leader election of your Mesos masters is maintained in Exhibitor ZooKeeper. Before installing DCOS, you must ensure that your bootstrap node has the following prerequisites.

### DCOS setup file

Download and save the DCOS setup file to your bootstrap node. This file is used to create your customized DCOS build file. Contact your sales representative or <sales@mesosphere.com> to obtain the DCOS setup file.

</li> </ul></li> </ul>
        
# Next step

Choose [GUI](/gui-install/) or [Command Line](cli-install) installation.

 [1]: /usage/cli/