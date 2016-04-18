---
post_title: Deploying Public Services
nav_title: Public Services
---

DC/OS agent nodes can be designated as [public](/overview/concepts/#public) or [private](/overview/concepts/#private) during [advanced](/administration/installing/custom/) or [cloud](/administration/installing/cloud/) installations. Public agent nodes provide public access to your DC/OS applications. By default apps are launched on private agent nodes. To launch an app on a public node, you must create a Marathon app definition with the `"acceptedResourceRoles":["slave_public"]` parameter specified.


1.  Install DC/OS and DC/OS CLI by using the [advanced installation](/administration/installing/custom/) or [cloud installation](/administration/installing/cloud/) instructions. You must declare at least one agent node as public. 

    For example, with advanced installation you can designate an agent node with this command:

        $ sudo bash dcos_install.sh slave_public
        
    For example, with the AWS cloud installation, you can specify a public agent node with the `PublicSlaveInstanceCount` box:
   
    ![alt text](/img/dcos-aws-step2c.png)
        
1.  Create a Marathon app definition with the `"acceptedResourceRoles":["slave_public"]` parameter specified. For example:
    
        {
            "id": "/product/service/myApp",
            "container": {
            "type": "DOCKER",
            "docker": {
                  "image": "group/image",
                  "network": "BRIDGE",
                  "portMappings": [
                    { "hostPort": 80, "containerPort": 80, "protocol": "tcp"}
                  ]
                }
            },
            "acceptedResourceRoles": ["slave_public"],
            "instances": 1,
            "cpus": 0.1,
            "mem": 64
        }

    For more information about the `acceptedResourceRoles` parameter, see the Marathon REST API [documentation](https://mesosphere.github.io/marathon/docs/rest-api.html). 
    
1.  Add the your app to Marathon by using this command:
        
        $ dcos marathon app add myApp.json
        
    If this is added successfully, there is no output.
        
1.  Verify that the app is added:
    
        $ dcos marathon app list
        ID      MEM  CPUS  TASKS  HEALTH  DEPLOYMENT  CONTAINER  CMD                        
        /nginx   64  0.1    0/1    ---      scale       DOCKER   None

 [1]: /tutorials/containerized-app/
 [3]: /administration/installing/
 [4]: /usage/cli/install/
```
