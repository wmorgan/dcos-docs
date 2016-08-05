---
post_title: Updating the CLI
nav_title: Updating
menu_order: 3
---

You can update the DC/OS CLI to the latest version or downgrade to an older version.

# <a name="upgrade"></a>Upgrade the CLI

**Important:** If you downloaded the CLI from PYPI or from the DC/OS UI version 1.7 or earlier, you must completely [uninstall](/docs/1.8/usage/cli/uninstall/) the CLI. You cannot upgrade. 

You can upgrade an existing DC/OS CLI installation to the latest build.

1.  Remove the current CLI binary:

    ```bash
    $ rm path/to/binary/dcos
    ```

1.  From the directory you want to install the new DC/OS CLI binary, enter this command to update the DC/OS CLI with the upgrade version (`<version>`) specified:
    
    ```bash
    $ curl https://downloads.dcos.io/binaries/cli/darwin/x86-64/<version>/dcos
    ```

# <a name="downgrade"></a>Downgrade the CLI

You can downgrade an existing DC/OS CLI installation to an older version.

1.  Remove the current CLI binary:

    ```bash
    $ rm path/to/binary/dcos
    ```

1.  From the directory you want to install the new DC/OS CLI binary, enter this command to update the DC/OS CLI with the downgrade version (`<version>`) specified:
    
    ```bash
    $ curl https://downloads.dcos.io/binaries/cli/darwin/x86-64/<version>/dcos
    ```