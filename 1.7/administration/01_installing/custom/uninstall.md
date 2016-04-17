---
post_title: Uninstall DC/OS
nav_title: Uninstall
layout: docs.jade
---

1.  From the bootstrap node, enter this command:

        $ sudo bash dcos_generate_config.sh --uninstall
        Running mesosphere/dcos-genconf docker with BUILD_DIR set to /home/centos/genconf
        ====> EXECUTING UNINSTALL
        This will uninstall DC/OS on your cluster. You may need to manually remove /var/lib/zookeeper in some cases after this completes, please see our documentation for details. Are you ABSOLUTELY sure you want to proceed? [ (y)es/(n)o ]: yes
        ====> START uninstall_dcos
        ====> STAGE uninstall
        ====> STAGE uninstall
        ====> OUTPUT FOR uninstall_dcos
        ====> END uninstall_dcos with returncode: 0
        ====> SUMMARY FOR uninstall_dcos
        2 out of 2 hosts successfully completed uninstall_dcos stage.
        ====> END OF SUMMARY FOR uninstall_dcos
