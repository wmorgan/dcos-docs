---
UID: 56f984497821a
post_title: Kubernetes
post_excerpt: ""
layout: page
published: true
menu_order: 16
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
**Disclaimer:** Kubernetes is available at the alpha level and is not recommended for Mesosphere DCOS production systems.

Kubernetes is an open-source container orchestration project introduced by Google. With the Mesosphere DCOS, you can deploy Kubernetes in your own datacenter or in the cloud. The Kubernetes service on DCOS [adds several benefits to standalone Kubernetes][1], including high availability, easy installation, and easy maintenance. Kubernetes on DCOS runs reliably alongside other popular next-generation services on the same cluster without competing for resources.

The current Kubernetes alpha <a href="https://github.com/mesosphere/kubernetes/releases/tag/v0.7.2-v1.1.5" target="_blank">DCOS package v0.7.2-v1.1.5</a> is based on <a href="https://github.com/GoogleCloudPlatform/kubernetes/releases/tag/v1.1.5" target="_blank">Kubernetes v1.1.5</a>. For more information see the <a href="https://github.com/mesosphere/kubernetes-mesos" target="_blank">Kubernetes-Mesos project on GitHub</a>. There are behavioral differences between the Kubernetes DCOS service and standalone Kubernetes, notably the [behavior of the scheduler][2].

# <a name="install"></a>Installing Kubernetes on DCOS

**Prerequisite**

*   The DCOS CLI must be [installed][3].

1.  Install the [etcd-mesos][4] service, which provides failover for etcd. By default, the Kubernetes DCOS service installs a single-node etcd cluster.
    
        $ dcos package install etcd
        

3.  Verify that etcd-mesos service is installed and healthy before going on to the next step. The etcd-mesos service takes a few minutes to deploy.
    
        $ dcos package list
        NAME  VERSION  APP    COMMAND  DESCRIPTION
        etcd  0.0.1    /etcd  ---      A distributed consistent key-value store for shared configuration and service discovery.
        

4.  Create a Kubernetes JSON configuration file that specifies the etcd-mesos services and save as `options.json`. This file is specified during DCOS Kubernetes installation.
    
        {
          "kubernetes": {
            "etcd-mesos-framework-name": "etcd"
          }
        }
        

5.  From the DCOS CLI, install Kubernetes with the `options.json` file specified:
    
        $ dcos package install --options=options.json kubernetes
        

6.  Verify that Kubernetes is installed and healthy. The Kubernetes cluster takes a few minutes to deploy.
    
    *   From the DCOS CLI, enter this command to show the installed packages:
        
                $ dcos package list
                NAME VERSION APP COMMAND DESCRIPTION
                kubernetes v0.7.2-v1.1.5-alpha /kubernetes kubernetes Kubernetes is an open source system for managing containerized applications across multiple hosts, providing basic mechanisms for deployment, maintenance, and scaling of applications.
            
    
    *   From the DCOS web interface, go to the Services tab and confirm that Kubernetes is running at <hostname>/#/services/.
        
        <a href="/wp-content/uploads/2015/12/kubernetestask.png" rel="attachment wp-att-1401"><img src="/wp-content/uploads/2015/12/kubernetestask.png" alt="kubernetestask" width="721" height="48" class="alignnone size-full wp-image-1401" /></a>
    
    *   Open a browser and navigate to the Kubernetes web interface at `<hostname>/service/kubernetes/`.
        
        <a href="/wp-content/uploads/2015/12/kubernetes-interface.png" rel="attachment wp-att-1404"><img src="/wp-content/uploads/2015/12/kubernetes-interface.png" alt="kubernetes-interface" width="674" height="614" class="alignnone size-full wp-image-1404" /></a>
    
    *   Open a browser and navigate to the Mesos web interface at `<hostname>/mesos`. Verify that the Kubernetes framework has registered and is starting tasks.

7.  Install the kubectl DCOS subcommand:
    
        $ dcos kubectl
        

8.  Verify that Kube-DNS & Kube-UI are deployed, running, and ready. The kube-ui service is automatically deployed on the cluster.
    
        $ dcos kubectl get pods --namespace=kube-system
        NAME                READY     STATUS    RESTARTS   AGE
        kube-dns-v8-tjxk9   4/4       Running   0          1m
        kube-ui-v2-tjq7b    1/1       Running   0          1m
        
    
    **Tip:** Names and versions may vary.

Now that Kubernetes is installed on DCOS, you can explore the [Kubernetes Samples][5] or the [Kubernetes User Guide][6].

# <a name="uninstall"></a>Uninstalling Kubernetes

1.  Stop and delete all replication controllers and pods in each namespace:
    
    Before uninstalling Kubernetes, destroy all the pods and replication controllers. The uninstall process will try to do this itself, but by default it times out quickly and may leave your cluster in a dirty state:
    
        $ dcos kubectl delete rc,pods --all --namespace=default
        $ dcos kubectl delete rc,pods --all --namespace=kube-system
        

2.  Validate that all pods have been deleted
    
        $ dcos kubectl get pods --all-namespaces
        

3.  Uninstall Kubernetes
    
        $ dcos package uninstall kubernetes
        

### <a name="more-info"></a>For more information

*   **Kubernetes** 
    *   [User Guide][6]
    *   [Samples][5]
    *   [Source][7]
*   **Kubernetes-Mesos** 
    *   [Getting Started Guide][8]
    *   [Release Notes][9]
    *   [Documentation][10]
    *   [Architecture][11]
    *   [Known Issues][12]
    *   [DCOS Package Source][13]

 [1]: https://github.com/kubernetes/kubernetes/blob/release-1.1/contrib/mesos/README.md
 [2]: https://github.com/kubernetes/kubernetes/blob/master/contrib/mesos/docs/scheduler.md
 [3]: /usage/cli/install/
 [4]: https://github.com/mesosphere/etcd-mesos
 [5]: http://kubernetes.io/docs/samples
 [6]: http://kubernetes.io/docs/user-guide/
 [7]: https://github.com/kubernetes/kubernetes
 [8]: http://kubernetes.io/docs/getting-started-guides/mesos/
 [9]: https://github.com/mesosphere/kubernetes/releases
 [10]: https://github.com/mesosphere/kubernetes/blob/v0.7.2-v1.1.5/contrib/mesos/README.md
 [11]: https://github.com/mesosphere/kubernetes/blob/v0.7.2-v1.1.5/contrib/mesos/docs/architecture.md
 [12]: https://github.com/mesosphere/kubernetes/blob/v0.7.2-v1.1.5/contrib/mesos/docs/issues.md
 [13]: https://github.com/mesosphere/kubernetes-mesos