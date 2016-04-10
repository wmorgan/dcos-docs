---
UID: 56f9844873f57
post_title: Running a Spark Job
post_excerpt: ""
layout: page
published: true
menu_order: 105
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
In this tutorial a Spark job is run by using DCOS.

**Prerequisites:**

*   [Running DCOS cluster][1] with at least 3 private agent nodes.
*   [Configured DCOS CLI][2].
*   Upload your Spark application .jar to an external file server that is reachable by the DCOS cluster. For example: `http://external.website/mysparkapp.jar`.

1.  From the DCOS CLI, enter this command to install the Spark DCOS service and CLI:
    
        $ dcos package install spark
        
    
    **Tip:** It can take up to 15 minutes to download and complete deployment, depending on your internet connection.

2.  Verify that Spark is running:
    
    *   From the DCOS web interface, go to the Services tab and confirm that Spark is running. Click the **spark** row item to view the Spark web interface. <a href="/wp-content/uploads/2015/12/sparktask.png" rel="attachment wp-att-1236"><img src="/wp-content/uploads/2015/12/sparktask.png" alt="sparktask" width="717" height="41" class="alignnone size-full wp-image-1236" /></a>
    *   From the DCOS CLI: `dcos package list`
    *   From the Mesos web interface at `http://<hostname>/mesos`, verify that the Spark framework has registered and is starting tasks. There should be several journalnodes, namenodes, and datanodes running as tasks. Wait for all of these to show the RUNNING state.

3.  To run a job with the main method in a class called `MySampleClass` and arguments 10:
    
        $ dcos spark run --submit-args='--class MySampleClass http://external.website/mysparkapp.jar 10'
        

4.  View the Spark scheduler progress by navigating to the Spark web interface as shown with this command:
    
        $ dcos spark webui
        

5.  Set the `--supervise` flag when running the job to allow the scheduler to restart the job anytime the job finishes.
    
        $ dcos spark run --submit-args='--supervise --class MySampleClass http://external.website/mysparkapp.jar 10'
        

6.  You can set the amount of cores and memory that the driver will require to be scheduled by passing in `--driver-cores` and `--driver-memory` flags. Any options that the usual spark-submit script accepts are also accepted by DCOS Spark CLI.

7.  To set any Spark properties (e.g. coarse grain mode or fine grain mode), you can also provide a custom `spark.properties` file and set the environment variable `SPARK_CONF_DIR` to that directory.

 [1]: /administration/installing/
 [2]: /usage/cli/install/