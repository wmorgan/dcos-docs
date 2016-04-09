---
UID: 56f9844a100f4
post_title: Log Management with Splunk
post_excerpt: ""
layout: page
published: true
menu_order: 5
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
You can pipe system and application logs from a Mesosphere DCOS cluster to your existing Splunk server.

These instructions are based on Mesosphere [DCOS 1.3][1] on CoreOS 766.4.0 and might differ substantially from other Linux distributions. This document does not explain how to setup and configure a Splunk server.

**Prerequisites**

*   An existing Splunk installation that can ingest data for indexing.
*   All DCOS nodes must be able to connect to your Splunk indexer via HTTP or HTTPS. (See Splunk's documentation for instructions on enabling HTTPS.) 
*   The `ulimit` of open files must be set to `unlimited` for your user with root access.

# Step 1: All Nodes

For all nodes in your DCOS cluster:

1.  Install Splunk's [universal forwarder][2]. Splunk provides packages and installation instructions for most platforms.
2.  Make sure the forwarder has the credentials it needs to send data to the indexer. See Splunk's documentation for details.
3.  Start the forwarder.

# Step 2: Master Nodes

For each Master node in your DCOS cluster:

1.  Create a script `$SPLUNK_HOME/bin/scripts/journald-master.sh` that will obtain the Mesos master logs from `journald`:
    
        #!/bin/sh
        
        exec journalctl --since=now -f \
            -u dcos-exhibitor.service \
            -u dcos-marathon.service \
            -u dcos-mesos-dns.service \
            -u dcos-mesos-master.service \
            -u dcos-nginx.service
        

2.  Make the script executable:
    
        chmod +x "$SPLUNK_HOME/bin/scripts/journald-master.sh"
        

3.  Add the script as an input to the forwarder:
    
        "$SPLUNK_HOME/bin/splunk" add exec \
            -source "$SPLUNK_HOME/bin/scripts/journald-master.sh" \
            -interval 0
        

# Step 3: Agent Nodes

For each agent node in your DCOS cluster:

1.  Create a script `$SPLUNK_HOME/bin/scripts/journald-agent.sh` that will obtain the Mesos agent logs from `journald`:
    
        #!/bin/sh
        
        exec journalctl --since=now -f \
            -u dcos-mesos-slave.service \
            -u dcos-mesos-slave-public.service
        

2.  Make the script executable:
    
        chmod +x "$SPLUNK_HOME/bin/scripts/journald-agent.sh"
        

3.  Add the script as an input to the forwarder:
    
        "$SPLUNK_HOME/bin/splunk" add exec \
            -source "$SPLUNK_HOME/bin/scripts/journald-agent.sh" \
            -interval 0
        

4.  Add the task logs as inputs to the forwarder:
    
        "$SPLUNK_HOME/bin/splunk" add monitor '/var/lib/mesos/slave' \
            -whitelist '/stdout$|/stderr$'
        

# Known Issue

*   The agent node Splunk forwarder configuration expects tasks to write logs to `stdout` and `stderr`. Some DCOS services, including Cassandra and Kafka, do not write logs to `stdout` and `stderr`. If you want to log these services, you must customize your agent node Splunk forwarder configuration.

# What's Next

For details on how to filter your logs with Splunk, see [Filtering DCOS logs with Splunk][3].

 [1]: /administration/release-notes/community-edition/1-3/
 [2]: http://www.splunk.com/en_us/download/universal-forwarder.html
 [3]: /administration/logging/filter-splunk/