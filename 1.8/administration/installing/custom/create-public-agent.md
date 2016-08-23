---
post_title: Converting Agent Node Types
nav_title: Convert Agent Type
menu_order: 8
---

You can convert agent nodes to public or private for an existing DC/OS cluster. 

In DC/OS, agent nodes are designated as [public](/docs/1.8/overview/concepts/#public) or [private](/docs/1.8/overview/concepts/#private) during installation. By default, agent nodes are designated as private during [GUI][1] or [CLI][2] installation.

You can determine the node type by running a command from the DC/OS CLI. 

**Public node query**

A result of `0` indicates that you do not have a public agent. A result of `1` means that you have one or more public agents. In this example, there are no public agents.

```bash
$ curl -skSL -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/mesos/master/slaves | grep slave_public | wc -l
           0
```

**Private node query**

A result of `0` indicates that you do not have a private agent. A result of `1` means that you have one or more private agents. In this example, there are no private agents.

```bash
$ curl -skSL -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/mesos/master/slaves | grep slave_private | wc -l
           0
```


### Prerequisites:
These steps must be performed on a machine that is configured as a DC/OS node. Any tasks that are running on the node will be terminated during this conversion process.

*   DC/OS is installed using the [custom](/docs/1.8/administration/installing/custom/) installation method and you have deployed at least one [master](/docs/1.8/overview/concepts/#master) and one [private](/docs/1.8/overview/concepts/#private) agent node.
*   The archived DC/OS installer file (`dcos-install.tar`) from your [installation](/docs/1.8/administration/installing/custom/gui/#backup).     

### Uninstall the DC/OS private agent software

1.  Uninstall the current DC/OS software on the agent node.

    ```bash
    $ sudo -i /opt/mesosphere/bin/pkgpanda uninstall
    $ sudo systemctl stop dcos-mesos-slave
    $ sudo systemctl disable dcos-mesos-slave
    ```

2.  Remove the old directory structures on the agent node.

    ```bash
    $ sudo rm -rf /etc/mesosphere /opt/mesosphere /var/lib/mesos /var/lib/dcos
    ```

3.  Restart the machine.

    ```bash
    $ sudo reboot
    ```        

### Install DC/OS and convert to a public agent node
Copy the archived DC/OS installer file (`dcos-install.tar`) to the node that that is being converted to a public agent. This archive is created during the GUI or CLI [installation](/docs/1.8/administration/installing/custom/gui/#backup) method.

1.  Copy the files to your agent node. For example, you can use Secure Copy (scp) to copy `dcos-install.tar` to your home directory:

    ```bash
    $ scp ~/dcos-install.tar $username@$node-ip:~/dcos-install.tar
    ```

2.  SSH to the machine:

    ```bash
    $ ssh $USER@$AGENT
    ```

1.  Create a directory for the installer files:

     ```bash
     $ sudo mkdir -p /opt/dcos_install_tmp
     ```

1.  Unpackage the `dcos-install.tar` file:

    ```bash
    $ sudo tar xf dcos-install.tar -C /opt/dcos_install_tmp
    ```

3.  Install DC/OS as a public agent:

    ```bash
    $ sudo bash /opt/dcos_install_tmp/dcos_install.sh slave_public
    ```

4.  Verify that your new agent node is public by running this command from a workstation with the DC/OS CLI. You should see a result of `1`, which indicates that you have at least one public node.

    ```bash
    $ curl -skSL -H "Authorization: token=$(dcos config show core.dcos_acs_token)" $(dcos config show core.dcos_url)/mesos/master/slaves | grep slave_public | wc -l
               1
    ```

 [1]: /docs/1.8/administration/installing/custom/gui/
 [2]: /docs/1.8/administration/installing/custom/cli/
