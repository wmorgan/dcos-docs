---
UID: 56f9844a0781b
post_title: System Logging
post_excerpt: ""
layout: page
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
To access the DCOS core component logs, you must have SSH access to your DCOS cluster. The DCOS core components use the host’s systemd journal for logging; they do not use the standard Mesos sandbox logs.

1.  [SSH into your master node][1].

2.  Enter the command for the component whose logs you wish to view:
    
    **Admin Router**
    
           journalctl -u dcos-nginx -b
        
    
    **DCOS Marathon**
    
           journalctl -u dcos-marathon -b
        
    
    **gen-resolvconf**
    
           journalctl -u dcos-gen-resolvconf -b
        
    
    **Mesos master node**
    
           journalctl -u dcos-mesos-master -b
        
    
    **Mesos agent node**
    
           journalctl -u dcos-mesos-slave -b
        
    
    **Mesos DNS**
    
           journalctl -u dcos-mesos-dns -b
        
    
    **ZooKeeper**
    
           journalctl -u dcos-exhibitor -b

 [1]: /administration/installing/sshcluster/