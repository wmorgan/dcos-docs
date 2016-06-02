---
post_title: Installing Services
nav_title: Installing
---
<!-- This source repo for this topic is https://github.com/dcos/dcos-docs -->

You can install services directly from the DC/OS package [repository][1] by using the web UI and the CLI.

**Prerequisite:**

*   [DC/OS][2] installed
*   [DC/OS CLI][3] installed

## Install a service 

### CLI

1.  Choose your package in the DC/OS CLI:

    ```bash
    $ dcos package search [--json <query>]
    ```
    
    For example, to search for scheduler packages:
    
    ```bash
    $ dcos package search "scheduler"
    NAME     VERSION  SELECTED  FRAMEWORK  DESCRIPTION                                                                       
    chronos  2.4.0    True      True       A fault tolerant job scheduler for Mesos which handles dependencies and ISO86...  
    ```

1.  Install the datacenter service with this command:

    ```bash
    $ dcos package install <servicename>
    ```
    
    For example, to install Chronos:
    
    ```bash
    $ dcos package install chronos
    ```
    
### Web UI

1.  Navigate to the [**Universe**](/docs/1.7/usage/webinterface/#universe) page in the DC/OS UI.

2.  Choose your package and click **Install package**. 

3.  Confirm your installation or choose **Advanced Installation**. You can include a custom configuration with the advanced installation.


## Verify your installation

### CLI

```bash
$ dcos package list
```

### Web UI

Go to the **Services** tab and confirm that the service is running. For more information, see the UI [documentation](/docs/1.7/usage/webinterface/#services).

**Tip:** Some services from the "Community Packages" section of the Universe will not show up in the DC/OS service listing. For these, inspect the service's Marathon app in the Marathon UI to verify that the service is running and healthy.

 [1]: /docs/1.7/usage/services/repo/
 [2]: /docs/1.7/administration/installing/
 [3]: /docs/1.7/usage/cli/install/
