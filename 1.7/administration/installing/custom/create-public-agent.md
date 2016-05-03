---
post_title: Creating a Public Agent
nav_title: Public Agent
menu_order: 8
---

In DC/OS, agent nodes that are publicly accessible are designated as public and those that are not are designated as private. By default, agent nodes are designated as private during [GUI][1] or [CLI][2] installation.

You can determine how many public agent nodes are in your cluster by running the following command. A result of 0 means that you do not have a public agent:

    $ curl -skSL -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/mesos/master/slaves | jq '.slaves[] | .reserved_resources' | grep slave_public | wc -l
           0
    

### Prerequisites:

*   DC/OS is installed and you have deployed at least one private agent node.
*   These steps must be performed on a machine that is configured as a DC/OS node. 
*   Any tasks that are running on the node will be terminated during this conversion process.

### Uninstall the DC/OS private agent software

1.  Uninstall the current DC/OS software on the agent node.
    
        $ sudo -i /opt/mesosphere/bin/pkgpanda uninstall
        $ sudo systemctl stop dcos-mesos-slave
        $ sudo systemctl disable dcos-mesos-slave
        

2.  Remove the old directory structures on the agent node.
    
        $ sudo rm -rf /opt/mesosphere /var/lib/mesos
        

3.  Restart the machine.
    
        $sudo reboot
        

### Install DC/OS and convert to a public agent node

1.  Copy the `dcos-install.tar` file to the node that that is being converted to a public agent. This `.tar` file is created during the GUI or CLI installation method.
    
        $ ssh $USER@$AGENT "sudo mkdir -p /opt/dcos_install_tmp"
        $ scp ~/dcos-install.tar $ROOT_USER@$AGENT:~/dcos-install.tar
        

2.  SSH to the machine:
    
        $ ssh $USER@$AGENT
        

3.  Install DC/OS as a public agent:
    
        $ sudo mv ~/dcos-install.tar /opt/dcos_install_tmp
        $ sudo bash /opt/dcos_install_tmp/dcos_install.sh slave_public
        

4.  Verify that your new agent node is public by running this command from DC/OS CLI.
    
        $ curl -skSL -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/mesos/master/slaves | jq '.slaves[] | .reserved_resources' | grep slave_public | wc -l
        
    
    You should see an output greater than zero to indicate at least one public agent.

 [1]: /docs/1.7/administration/installing/custom/gui/
 [2]: /docs/1.7/administration/installing/custom/cli/