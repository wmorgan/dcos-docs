---
UID: 56f9844854644
post_title: Running multiple Cassandra instances
post_excerpt: ""
layout: page
published: true
menu_order: 105
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
In this tutorial, an additional instance of the DCOS Cassandra service is installed.

For each new instance, you must provide a unique Cassandra instance name in an `options.json` file and specify this file during Cassandra installation.

By default, the DCOS Cassandra service creates an instance named `cassandra`. Additional instance names are created as `cassandra.<new-user>`.

**Prerequisites:**

*   [DCOS is installed][1]
*   Sufficient resources to add more Cassandra hosts

1.  Create an `options.json` file and specify the new Cassandra instance as `user3`. This new Cassandra instance is named: `cassandra.user3`.
    
        {
          "cassandra": {
            "cluster-name": "user3"
          }
        }
        

2.  From the DCOS CLI, run this command to install Cassandra with the options file specified:
    
        dcos package install cassandra --options=options.json
        

3.  [verify-service-install]

4.  To run advanced Cassandra jobs, you must [SSH into your cluster][2].
    
    For example, to view several system tables in the Cassandra servers, from any node in your cluster, run the following command. Because this example downloads a Docker file, it may take a while.
    
        $ docker run -i -t --net=host --entrypoint=/usr/bin/cqlsh spotify/cassandra -e " SELECT * FROM system.schema_keyspaces ; SELECT * FROM system.schema_columns ; SELECT * FROM system.schema_columnfamilies ;" cassandra-dcos-node.cassandra.dcos.mesos 9160
        

5.  Access the Cassandra cluster by using the DNS name created by Mesos-DNS: `cassandra-user3-node.cassandra.user3.mesos`.
    
    For more information on Mesos-DNS naming, see [Service Naming][3].

 [1]: /administration/installing/
 [2]: /administration/sshcluster/
 [3]: /administration/service-discovery/service-naming/