---
UID: 56f98447d3573
post_title: >
  Adding a Containerized Docker App to
  Marathon
post_excerpt: ""
layout: page
published: true
menu_order: 105
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
In this tutorial, a custom Docker app is created and added to Marathon.

### Prerequisites

*   [Docker][1] installed on your workstation
*   [Docker Hub][2] account
*   [DCOS][3] installed
*   [DCOS CLI][4] installed

# Create a custom Docker container

1.  In the `dcos` directory created by the DCOS CLI installation script, create a new directory named `simple-docker-tutorial` and navigate to it:
    
        $ mkdir simple-docker-tutorial
        $ cd simple-docker-tutorial
        

2.  Create a file named `index.html` by using nano, or another text editor of your choice:
    
        $ nano index.html
        

3.  Paste the following markup into `index.html` and save:
    
        <html>
            <body>
            <h1> Hello brave new world! </h1>
            </body>
        </html>
        

4.  Create and edit a Dockerfile by using nano, or another text editor of your choice:
    
        $ nano Dockerfile
        

5.  Paste the following commands into it and save:
    
        FROM nginx:1.9
        COPY index.html /usr/share/nginx/html/index.html
        

6.  Build the container, where `<username>` is your Docker Hub username:
    
        $ docker build -t <username>/simple-docker .
        

7.  Log in to Docker Hub:
    
        $ docker login
        

8.  Push your container to Docker Hub, where `<username>` is your Docker Hub username:
    
        $ docker push <username>/simple-docker
        

# Add your Docker app to Marathon

1.  Create a file named `nginx.json` by using nano, or another text editor of your choice:
    
        $ nano nginx.json
        

2.  Paste the following into the `nginx.json` file. If you’ve created your own Docker container, replace the image name mesosphere with your Docker Hub username:
    
        {
            "id": "nginx",
            "container": {
            "type": "DOCKER",
            "docker": {
                  "image": "mesosphere/simple-docker",
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
        
    
    This file specifies a simple Marathon application called “nginx” that runs one instance of itself on a public node.

3.  Add the nginx Docker container to Marathon by using the DCOS command:
    
        $ dcos marathon app add nginx.json
        
    
    If this is added successfully, there is no output.

4.  Verify that the app is added:
    
        $ dcos marathon app list
        ID      MEM  CPUS  TASKS  HEALTH  DEPLOYMENT  CONTAINER  CMD                        
        /nginx   64  0.1    0/1    ---      scale       DOCKER   None

 [1]: https://www.docker.com
 [2]: https://hub.docker.com
 [3]: /administration/installing/
 [4]: /usage/cli/install/