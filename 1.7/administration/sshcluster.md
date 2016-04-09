---
UID: 56f98449546cf
post_title: SSHing into Nodes
post_excerpt: ""
layout: page
published: true
menu_order: 15
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
These instructions explain how to set up an SSH connection to your DCOS cluster from an outside network. If you are on the same network as your cluster or connected by using VPN, you can instead use the `dcos node ssh` command. For more information, see the [dcos node section][1] of the CLI reference.

*   [SSH to your DCOS cluster on Unix/Linux (OS X, Ubuntu, etc)][2]
*   [SSH to your DCOS cluster on Windows][3]

**Requirements:**

*   During [AWS DCOS cluster creation][4], a `.pem` file is created. You will need this `.pem` file to SSH to your cluster.

### <a name="unix"></a>SSH to your DCOS cluster on Unix/Linux (OS X, Ubuntu, etc)

1.  Change the permissions on the `.pem` file to owner read/write by using the `chmod` command.
    
    **Important:** Your `.pem` file must be located in the `~/.ssh` directory.
    
        chmod 600 <private-key>.pem
        

2.  SSH into the cluster.
    
    1.  From your terminal, add your new configuration to the `.pem` file, where `<private-key>` is your `.pem` file.
        
            $ ssh-add ~/.ssh/<private-key>.pem
            
            Identity added: /Users/<yourdir>/.ssh/<private-key>.pem (/Users/<yourdir>/.ssh/<private-key>.pem)
            
    
    *   **To SSH to a master node:**
        
        1.  From the DCOS CLI, enter the following command:
            
                $ dcos node ssh --master-proxy --leader
                
            **Tip:** The default user is `core`. If you are using CentOS, enter:
            
                $ dcos node ssh --master-proxy --leader --user=centos
                
    
    *   **To SSH to an agent node:**
        
        1.  From the Mesos web interface, copy the agent node ID. You can find the IDs on the **Frameworks** (`<master-node-IPaddress>/mesos/#/frameworks`) or **Slaves** page (`<master-node-IPaddress>/mesos/#/slaves`).
            
            <a href="/wp-content/uploads/2015/12/mesos-sandbox-slave-copy.png" rel="attachment wp-att-1560"><img src="/wp-content/uploads/2015/12/mesos-sandbox-slave-copy-600x119.png" alt="mesos-sandbox-slave-copy" width="500" height="260" class="alignnone size-medium wp-image-1560" /></a>
        
        2.  From the DCOS CLI, enter the following command, where `<slave-id>` is your agent ID:
            
                $ dcos node ssh --master-proxy --slave=<slave-id>
                

### <a name="windows"></a>SSH to your DCOS cluster on Windows

**Requirements:**

*   PuTTY SSH client or equivalent (These instructions assume you are using PuTTY, but almost any SSH client will work.)
*   PuTTYgen RSA and DSA key generation utility
*   Pageant SSH authentication agent 

To install these programs, download the Windows installer <a href="http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html" target="_blank">from the official PuTTY download page.</a>

1.  Convert the `.pem` file type to `.ppk` by using PuTTYgen:
    
    1.  Open PuTTYgen, select **File > Load Private Key**, and choose your `.pem` file.
    
    2.  Select **SSH-2 RSA** as the key type, click **Save private key**, then choose the name and location to save your new .ppk key.
        
        <a href="/wp-content/uploads/2015/12/windowsputtykey.png" rel="attachment wp-att-1611"><img src="/wp-content/uploads/2015/12/windowsputtykey-600x596.png" alt="windowsputtykey" width="500" height="498" class="alignnone size-medium wp-image-1611" /></a>
    
    3.  Close PuTTYgen.

2.  SSH into the cluster.
    
    *   **To SSH to a master node:**
        
        1.  From the DCOS web interface, copy the IP address of the master node. The IP address is displayed beneath your cluster name.
            
            <a href="/wp-content/uploads/2015/12/nodehostname.png" rel="attachment wp-att-1567"><img src="/wp-content/uploads/2015/12/nodehostname-600x231.png" alt="nodehostname" width="300" height="116" class="alignnone size-medium wp-image-1567" /></a>
        
        2.  Open PuTTY and enter the master node IP address in the **Host Name (or IP address)** field.
            
            <a href="/wp-content/uploads/2015/12/windowsputtybasic.png" rel="attachment wp-att-1610"><img src="/wp-content/uploads/2015/12/windowsputtybasic-600x592.png" alt="windowsputtybasic" width="500" height="496" class="alignnone size-medium wp-image-1610" /></a>
        
        3.  In the **Category** pane on the left side of the PuTTY window, choose **Connection > SSH > Auth**, click **Browse**, locate and select your `.ppk` file, then click **Open**.
            
            <a href="/wp-content/uploads/2015/12/windowsputtysshopt.png" rel="attachment wp-att-1612"><img src="/wp-content/uploads/2015/12/windowsputtysshopt-600x592.png" alt="windowsputtysshopt" width="500" height="496" class="alignnone size-medium wp-image-1612" /></a>
        
        4.  Login as user “core”.
            
            <a href="/wp-content/uploads/2015/12/windowscore.png" rel="attachment wp-att-1607"><img src="/wp-content/uploads/2015/12/windowscore-600x349.png" alt="windowscore" width="500" height="375" class="alignnone size-medium wp-image-1607" /></a>
    
    *   **To SSH to an agent node**
        
        **Prerequisite:** You must be logged out of your master node.
        
        1.  Enable agent forwarding in PuTTY.
            
            **Caution:** SSH agent forwarding has security implications. Only add servers that you trust and that you intend to use with agent forwarding. For more information on agent forwarding, see <a href="https://developer.github.com/guides/using-ssh-agent-forwarding/" target="_blank">Using SSH agent forwarding.</a>
            
            1.  Open PuTTY. In the **Category** pane on the left side of the PuTTY window, choose **Connection > SSH > Auth** and check the **Allow agent forwarding** box.
            
            2.  Click the **Browse** button and locate the `.ppk` file that you created previously using PuTTYgen.
                
                <a href="/wp-content/uploads/2015/12/windowsforwarding.png" rel="attachment wp-att-1608"><img src="/wp-content/uploads/2015/12/windowsforwarding-600x592.png" alt="windowsforwarding" width="500" height="496" class="alignnone size-medium wp-image-1608" /></a>
        
        2.  Add the `.ppk` file to Pageant.
            
            1.  Open Pageant. If the Pageant window does not appear, look for the Pageant icon in the notification area in the lower right area of the screen next to the clock and double-click it to open Pageant's main window.
            
            2.  Click the **Add Key** button.
            
            3.  Locate the `.ppk` file that you created using PuTTYgen and click **Open** to add your key to Pageant.
                
                <a href="/wp-content/uploads/2015/12/windowspageant.png" rel="attachment wp-att-1609"><img src="/wp-content/uploads/2015/12/windowspageant-600x433.png" alt="windowspageant" width="500" height="417" class="alignnone size-medium wp-image-1609" /></a>
            
            4.  Click the **Close** button to close the Pageant window.
        
        3.  SSH into the master node.
            
            1.  From the DCOS web interface, copy the IP address of the master node. The IP address is displayed beneath your cluster name.
            
            2.  In the **Category** pane on the left side of the PuTTY window, choose **Session** and enter the master node IP address in the **Host Name (or IP address)** field.
            
            3.  Login as user “core”.
                
                <a href="/wp-content/uploads/2015/12/windowscore.png" rel="attachment wp-att-1607"><img src="/wp-content/uploads/2015/12/windowscore-600x349.png" alt="windowscore" width="500" height="375" class="alignnone size-medium wp-image-1607" /></a>
        
        4.  From the master node, SSH into the agent node.
            
            1.  From the Mesos web interface, copy the agent node hostname. You can find hostnames on the **Frameworks** (`<master-node-IPaddress>/mesos/#/frameworks`) or **Slaves** page (`<master-node-IPaddress>/mesos/#/slaves`).
            
            2.  SSH into the agent node as the user `core` with the agent node hostname specified:
                
                    ssh core@<agent-node-hostname>

 [1]: /usage/cli/command-reference/
 [2]: #unix
 [3]: #windows
 [4]: /administration/installing/awscluster/#create
 

