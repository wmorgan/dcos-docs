---
post_title: Installing Services
---
You can install services directly from the DC/OS package [repository][1].

**Prerequisite:**

*   [DC/OS][2] installed
*   [DC/OS CLI][3] installed

To install a DC/OS service:

1.  Install the datacenter service with this command:

         dcos package install <servicename>

    For example, to install Chronos:

         dcos package install chronos

2.  Verify that the service is successfully installed:

    *   From the DC/OS CLI: `dcos package list`
    *   From the Mesosphere DC/OS web interface: Go to the Services tab and confirm that the datacenter services are running.
    ![services]()

    <a href="/wp-content/uploads/2015/12/services.png" rel="attachment wp-att-1126"><img src="/wp-content/uploads/2015/12/services-800x486.png" alt="Services page" width="800" height="486" class="alignnone size-large wp-image-1126" /></a>

 [1]: /docs/1.7/usage/package-repo/
 [2]: /docs/1.7/administration/installing/
 [3]: /docs/1.7/usage/cli/install/
