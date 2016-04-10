---
UID: 56f984484cb28
post_title: Creating a Chronos job
post_excerpt: ""
layout: page
published: true
menu_order: 105
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
In this example, a Chronos job that sleeps for 10 seconds is created.

**Prerequisite:**

*   The DCOS Chronos service is [installed][1]

1.  From the DCOS Services page, click on the **chronos** link to go to the Chronos web interface.

2.  From the Chronos web interface, click **New Job**.

3.  Add the NAME “Test Chronos Sleep”, COMMAND `sleep 10`, your email for OWNER(S), and click **Create**.
    
    <a href="http://live-mesosphere-documentation.pantheon.io/wp-content/uploads/2015/12/chronosnewjob.png" rel="attachment wp-att-1308"><img src="http://live-mesosphere-documentation.pantheon.io/wp-content/uploads/2015/12/chronosnewjob.png" alt="chronosnewjob" width="424" height="432" class="alignnone size-full wp-image-1308" /></a>

4.  After the job is created, you can click on **Force Run** (the ‘play’ button) to run it. You should see it as a running task on your Mesos master and the Sandbox. Once it’s finished running, you should see status “SUCCESS.”
    
    <a href="http://live-mesosphere-documentation.pantheon.io/wp-content/uploads/2015/12/chronosforcerun.png" rel="attachment wp-att-1310"><img src="http://live-mesosphere-documentation.pantheon.io/wp-content/uploads/2015/12/chronosforcerun.png" alt="chronosforcerun" width="315" height="99" class="alignnone size-full wp-image-1310" /></a>

 [1]: /usage/services/chronos/#chronosinstall