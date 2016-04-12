---
UID: 5703eac639700
post_title: Configure and install DCOS
post_excerpt: ""
layout: docs.jade
published: true
menu_order: 3
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
The DCOS installation creates these folders:

*   `/opt/mesosphere`
    :   Contains all the DCOS binaries, libraries, cluster configuration. Do not modify.

*   `/etc/systemd/system/dcos.target.wants`
    :   Contains the systemd services which start the things that make up systemd. They must live outside of `/opt/mesosphere` because of systemd constraints.

*   Various units prefixed with `dcos` in `/etc/systemd/system`
    :   Copies of the units in `/etc/systemd/system/dcos.target.wants`. They must be at the top folder as well as inside `dcos.target.wants`.

# <a name="config-json"></a>Configure your cluster

In this step you create a YAML configuration file that is customized for your environment. DCOS uses this configuration file during installation to generate your cluster installation files. In these instructions we assume that you are using ZooKeeper for shared storage.

1.  From the bootstrap node, run this command to create a hashed password for superuser authentication, where `<superuser_password>` is the superuser password. Use the hashed password key for the `superuser_password_hash` parameter in your `config.yaml` file.
    
        $ sudo bash dcos_generate_config.ee.sh --hash-password <superuser_password>
        
    
    Here is an example of a hashed password output.
    
        Extracting image from this script and loading into docker daemon, this step can take a few minutes
        dcos-genconf.9eda4ae45de5488c0c-c40556fa73a00235f1.tar
        Running mesosphere/dcos-genconf docker with BUILD_DIR set to /home/centos/genconf
        00:42:10 dcos_installer.action_lib.prettyprint:: ====> HASHING PASSWORD TO SHA512
        00:42:11 root:: Hashed password for 'password' key:
        $6$rounds=656000$v55tdnlMGNoSEgYH$1JAznj58MR.Bft2wd05KviSUUfZe45nsYsjlEl84w34pp48A9U2GoKzlycm3g6MBmg4cQW9k7iY4tpZdkWy9t1
        

2.  Create a configuration file and save as `genconf/config.yaml`. 
    
    You can use this template to get started. This template specifies 3 Mesos masters, 3 ZooKeeper instances for Exhibitor storage, static master discovery list, and Google DNS resolvers. If your servers are installed with a domain name in your `/etc/resolv.conf`, you should add `dns_search` to your `config.yaml` file. For parameters descriptions and configuration examples, see the [documentation][1].
    
        bootstrap_url: http://<bootstrap_public_ip>:<your_port>       
        cluster_name: '<cluster-name>'
        exhibitor_storage_backend: zookeeper
        exhibitor_zk_hosts: <host1>:2181,<host2>:2181,<host3>:2181
        exhibitor_zk_path: /dcos
        master_discovery: static 
        master_list:
        - <master-private-ip-1>
        - <master-private-ip-2>
        - <master-private-ip-3>
        resolvers:
        - 8.8.4.4
        - 8.8.8.8
        superuser_password_hash: <hashed-password>
        superuser_username: <username>
        

# <a name="install-bash"></a>Install DCOS

In this step you create a custom DCOS build file on your bootstrap node and then install DCOS onto your cluster. With this method you package the DCOS distribution yourself and connect to every server manually and run the commands.

**Tip:** If something goes wrong and you want to rerun your setup, use these cluster [cleanup instructions][2].

**Prerequisites**

*   A `genconf/config.yaml` file that is optimized for manual distribution of DCOS across your nodes.
*   A `genconf/ip-detect` script.

<!-- Early access URL: https://downloads.mesosphere.com/dcos/EarlyAccess/dcos_generate_config.sh -->

<!-- Stable URL: https://downloads.mesosphere.com/dcos/stable/dcos_generate_config.sh --> To install DCOS:

1.  From the bootstrap node, run the DCOS installer shell script to generate a customized DCOS build file. The setup script extracts a Docker container that uses the generic DCOS install files to create customized DCOS build files for your cluster. The build files are output to `./genconf/serve/`.
    
    At this point your directory structure should resemble:
    
        ├── dcos-genconf.c9722490f11019b692-cb6b6ea66f696912b0.tar
        ├── dcos_generate_config.ee.sh
        ├── genconf
        │   ├── config.yaml
        │   ├── ip-detect
        

2.  Run this command to generate your customized DCOS build file:
    
        $ sudo bash dcos_generate_config.ee.sh
        
    
    **Tip:** For the install script to work, you must have created `genconf/config.yaml` and `genconf/ip-detect`.

3.  From your home directory, run this command to host the DCOS install package through an nginx Docker container. For `<your-port>`, specify the port value that is used in the `bootstrap_url`.
    
        $ sudo docker run -d -p <your-port>:80 -v $PWD/genconf/serve:/usr/share/nginx/html:ro nginx
        

4.  Run these commands on each of your master nodes in succession to install DCOS using your custom build file.
    
    **Tip:** Although there is no actual harm to your cluster, DCOS may issue error messages until all of your master nodes are configured.
    
    1.  SSH to your master nodes:
        
            $ ssh <master-ip>
            
    
    2.  Make a new directory and navigate to it:
        
            $ mkdir /tmp/dcos && cd /tmp/dcos
            
    
    3.  Download the DCOS installer from the nginx Docker container, where `<bootstrap-ip>` and `<your_port>` are specified in `bootstrap_url`:
        
            $ curl -O http://<bootstrap-ip>:<your_port>/dcos_install.sh
            
    
    4.  Run this command to install DCOS on your master nodes:
        
            $ sudo bash dcos_install.sh master
            

5.  Run these commands on each of your agent nodes to install DCOS using your custom build file.
    
    1.  SSH to your agent nodes:
        
            $ ssh <agent-ip>
            
    
    2.  Make a new directory and navigate to it:
        
            $ mkdir /tmp/dcos && cd /tmp/dcos
            
    
    3.  Download the DCOS installer from the nginx Docker container, where `<bootstrap-ip>` and `<your_port>` are specified in `bootstrap_url`:
        
            $ curl -O http://<bootstrap-ip>:<your_port>/dcos_install.sh
            
    
    4.  Run this command to install DCOS on your agent nodes:
        
            $ sudo bash dcos_install.sh slave
            

6.  Monitor Exhibitor and wait for it to converge at `http://<master-ip>:8181/exhibitor/v1/ui/index.html`.
    
    **Tip:** This process can take about 10 minutes. During this time you will see the Master nodes become visible on the Exhibitor consoles and come online, eventually showing a green light.
    
    ![alt text](/img/chef-zk-status.png)
    
    When the status icons are green, you can access the DCOS web interface.

7.  Launch the DCOS web interface at: `http://<master-node-public-ip>/`.

9.  Enter your administrator username and password.
    
    ![alt text](/img/ui-installer-auth2.png)
    
    You are done!
    
    ![alt text](/img/ui-dashboard-ee.png)
    
### Next Steps

Now you can [assign user roles][4].

 [1]: /installing-enterprise-edition-1-7/configuration-parameters/
 [2]: /administration/installing/installing-enterprise-edition/dcos-cleanup-script/
 [3]: /usage/cli/
 [4]: /administration/security-and-authentication/