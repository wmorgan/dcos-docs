---
UID: 56f984485c373
post_title: >
  Autoscaling based on memory and CPU
  metrics
post_excerpt: ""
layout: page
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
A Python application, marathon-autoscale.py, autoscales your Marathon application based on the utilization metrics Mesos reports.

The application runs on any system that has Python 3 installed and has access to the Marathon server via HTTP TCP Port 80 and the Mesos Agent nodes over TCP port 5051. marathon-autoscale.py is intended to demonstrate what is possible when you run your applications on Marathon and Mesos. It periodically monitors the aggregate CPU and memory utilization for all the individual tasks running on the Mesos agents that make up the specified Marathon application. When the threshold you set for these metrics is reached, marathon-autoscale.py adds instances to the application based on the multiplier you specify.

**Prerequisites**

*   A [running DCOS cluster][1].
*   Python 3 installed on the system you will run marathon-autoscale.py. **Note:** This can be one of the Mesos master nodes.
*   An application running on the native Marathon instance that you intend to autoscale.
*   TCP Port 80 open to the Marathon instance and TCP Port 5051 open to the Mesos Agent hosts.

# Install the application

SSH to the system where you will run marathon-autoscale.py and install it:

        $ git clone https://github.com/mesosphere/marathon-autoscale.git 
        $ cd marathon-autoscale
    

# Run the application

When you run the application, you'll be prompted for the following parameters:

*   **marathon_host (string)** - Fully qualified domain name or IP of the Marathon host (without http://).
*   **marathon_app (string)** - The name of the Marathon app to autoscale (without "/").
*   **max_mem_percent (int)** - The percentage of average memory utilization across all tasks for the target Marathon app before scaleout is triggered.
*   **max_cpu_time (int)** - The average CPU time across all tasks for the target Marathon app before scaleout is triggered.
*   **trigger_mode (string)** - 'or' or 'and' determines whether both CPU and memory must be triggered or just one or the other.
*   **autoscale_multiplier (float)** - The number by which current instances will be multiplied to determine how many instances to add during scaleout.
*   **max_instances (int)** - The ceiling for the number of instances to stop scaling out EVEN if thresholds are crossed.

    $ python marathon-autoscale.py
    Enter the DNS hostname or IP of your Marathon Instance : ip-**-*-*-***
    Enter the Marathon Application Name to Configure Autoscale for from the Marathon UI : testing
    Enter the Max percent of Mem Usage averaged across all Application Instances to trigger Autoscale (ie. 80) : 5
    Enter the Max percent of CPU Usage averaged across all Application Instances to trigger Autoscale (ie. 80) : 5
    Enter which metric(s) to trigger Autoscale ('and', 'or') : or
    Enter Autoscale multiplier for triggered Autoscale (ie 1.5) : 2
    Enter the Max instances that should ever exist for this application (ie. 20) : 10

 [1]: /administration/installing/awscluster/