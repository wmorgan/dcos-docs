---
UID: 56f9844984a01
post_title: Kafka
post_excerpt: ""
layout: page
published: true
menu_order: 15
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
Kafka is a distributed, partitioned, replicated commit log service. It provides the functionality of a messaging system, but with a unique design. The Kafka DCOS service also has its own CLI as well.

# <a name="kafkainstall"></a>Installing Kafka on DCOS

**Prerequisite**

*   The DCOS CLI must be [installed][1].

1.  From the DCOS CLI, enter this command to install the Kafka DCOS service and CLI:
    
        $ dcos package install kafka
        
    
    **Tip:** It can take a few minutes to download and complete deployment, depending on your internet connection.

2.  [verify-service-install]

# <a name="uninstall"></a>Uninstalling Kafka

1.  From the DCOS CLI, enter this command:
    
        $ dcos package uninstall kafka
        

2.  Open the Zookeeper Exhibitor web interface at `<hostname>/exhibitor`, where `<hostname>` is the [Mesos Master hostname][2].
    
    1.  Click on the **Explorer** tab and navigate to the `kafka-mesos` folder.
        
        <a href="/wp-content/uploads/2015/12/zkkafka.png" rel="attachment wp-att-1395"><img src="/wp-content/uploads/2015/12/zkkafka-600x456.png" alt="zkkafka" width="300" height="228" class="alignnone size-medium wp-image-1395" /></a>
    
    2.  Click the **Modify** button on the lower-left side of browser.
    
    3.  Choose Type **Delete**, enter the required **Username**, **Ticket/Code**, and **Reason** fields, and click **Next**.
        
        <a href="/wp-content/uploads/2015/12/zkkafkadelete.png" rel="attachment wp-att-1393"><img src="/wp-content/uploads/2015/12/zkkafkadelete-600x331.png" alt="zkkafkadelete" width="300" height="166" class="alignnone size-medium wp-image-1393" /></a>
    
    4.  Click **OK** to confirm your deletion.
    
    5.  If a broker is added to Kafka, repeat steps 1-3 for `admin`, `brokers`, `config`, `consumers`, and `controller_epoch` folders. And if it exists, the `controller` znode.
        
        **Optional:** By default the Kafka broker logs are written into their Mesos task sandboxes, which are automatically cleaned up if necessary. If you created your brokers by using `--options log.dirs` to specify an alternative log location, you must clear that data manually to completely uninstall Kafka:
        
        1.  Identify the agent nodes that were running your Kafka brokers using the Mesos UI.
        
        2.  [SSH into each broker agent][3] and delete the data written to the directory you specified with the `--options log.dirs` option.

For more information:

*   <a href="https://github.com/mesosphere/kafka/blob/master/README.md" target="_blank">Kafka Mesos Framework</a>
*   <a href="http://kafka.apache.org/documentation.html" target="_blank">Apache Kafka Documentation</a>

 [1]: /usage/cli/install/
 [2]: /administration/installing/awscluster#launchdcos
 [3]: /sshcluster/