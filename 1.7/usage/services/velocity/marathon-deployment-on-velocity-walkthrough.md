---
UID: 56f98445400f1
post_title: >
  Marathon Deployment on Velocity
  Walkthrough
post_excerpt: ""
layout: page
published: true
menu_order: 110
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
This is a guide to deploying applications on [Marathon][1] using [Velocity][2]. This guide will walk you through creating a new Jenkins job, publishing a docker container on source code changes, and deploying those changes to Marathon based on the [Application Definition][3] contained in the project’s `marathon.json` file.

The rest of this document assumes the read has [a working Velocity installation][2] and permission to launch applications on Marathon.

# The Example Project

The project used in this tutorial is taken from the [cd-demo][4] repository and runs a Jekyll website inside a Docker container.

The files needed for this tutorial are `Dockerfile`, `marathon.json`, and the `site` directory. Copy those items to a new project and push to a new git repository on the host of your choice.

# Accessing Velocity

If you have not already installed Velocity as described on the [Overview and Installation][2] page, do so before proceeding.

Velocity can be accessed through the Dashboard or Services navigation menu’s within the DCOS UI. Click on the “velocity” service and click the "Open Service"" to access the Jenkins UI.

<a href="/wp-content/uploads/2016/03/dcos-velocity-healthy.png" rel="attachment wp-att-4059"><img src="/wp-content/uploads/2016/03/dcos-velocity-healthy-800x351.png" alt="dcos-velocity-healthy" width="800" height="351" class="aligncenter size-large wp-image-4059" /></a>

<a href="/wp-content/uploads/2016/03/dcos-velocity-jenkins-ui.png" rel="attachment wp-att-4060"><img src="/wp-content/uploads/2016/03/dcos-velocity-jenkins-ui-800x516.png" alt="dcos-velocity-jenkins-ui" width="800" height="516" class="aligncenter size-large wp-image-4060" /></a>

# The Job

We’ll create a new Jenkins job that will perform several operations with Docker Hub and then either update or create a Marathon application.

Create a new "Freestyle" job with a name including only lowercase letters and hyphens. This name will be used later in the docker image name and possibly as the Marathon application ID.

<a href="/wp-content/uploads/2016/03/dcos-jenkins-new-freestyle.png" rel="attachment wp-att-4061"><img src="/wp-content/uploads/2016/03/dcos-jenkins-new-freestyle-800x175.png" alt="dcos-jenkins-new-freestyle" width="800" height="175" class="aligncenter size-large wp-image-4061" /></a>

# SCM / Git

From the "Example Project" section above, fill in the Git repository URL with the newly created Git repository. This must be accessible to Jenkins and may require adding credentials to the Jenkins instance.

<a href="/wp-content/uploads/2016/03/dcos-jenkins-repourl.png" rel="attachment wp-att-4062"><img src="/wp-content/uploads/2016/03/dcos-jenkins-repourl-800x185.png" alt="dcos-jenkins-repourl" width="800" height="185" class="aligncenter size-large wp-image-4062" /></a>

# Build Triggers

Select the "Poll SCM" build trigger with a schedule of: `*/5 * * * *`. This will check the git repository every five minutes for changes.

# Build Environment

A username and password are required to log in to Docker Hub. To log in securely, the "Build Environment" section of the Job configuration has a “Use secret text(s) or file(s)” option. Select this option and fill in the credentials appropriately. Use `DOCKER_HUB_USERNAME` for "Username Variable" and `DOCKER_HUB_PASSWORD` for "Password Variable".

<a href="/wp-content/uploads/2016/03/dcos-jenkins-bindings.png" rel="attachment wp-att-4063"><img src="/wp-content/uploads/2016/03/dcos-jenkins-bindings-800x356.png" alt="dcos-jenkins-bindings" width="800" height="356" class="aligncenter size-large wp-image-4063" /></a>

# Build Steps

The Jenkins job performs the following actions:

1.  Log in to Docker Hub.
2.  Build a new Docker image.
3.  Push the new image to Docker Hub.

These actions can either be contained within a single build step or split across many. You can decide which implementation you prefer. The example below contains everything in one step.

In order to login to Docker Hub, the job needs to know the username, password, and email address of the target Docker Hub account. The username and password are provided by the `Credentials` plugin, so that leaves the email address. This can either be hard-coded in the shell script or added as a build parameter and referenced in the script. For this job, the email will be hard coded.

A published Docker image also requires a namespace. On Docker Hub, this may be the user’s username or an organization the user is a member. For this job, the username will be reused as the target namespace.

From the “Add build step” drop-down list, select "Execute Shell" option and populate with the script below. *Note:* Change <ACCOUNT EMAIL>.

## Script:

    #!/bin/bash
    docker login -u ${DOCKER_HUB_USERNAME} -p ${DOCKER_HUB_PASSWORD} -e <ACCOUNT EMAIL>
    
    IMAGE_NAME="${DOCKER_HUB_USERNAME}/${JOB_NAME}:${GIT_COMMIT}"
    docker build -t $IMAGE_NAME .
    docker push $IMAGE_NAME
    

<a href="/wp-content/uploads/2016/03/dcos-jenkins-exec-shell.png" rel="attachment wp-att-4064"><img src="/wp-content/uploads/2016/03/dcos-jenkins-exec-shell-800x202.png" alt="dcos-jenkins-exec-shell" width="800" height="202" class="aligncenter size-large wp-image-4064" /></a>

The script above performs steps one to three: log in, build, and push. The fourth and final step is handled by the Marathon Deployment post-build action below.

# Marathon Deployment

Add a Marathon Deployment post-build action.

<a href="/wp-content/uploads/2016/03/dcos-jenkins-plugin-popup.png" rel="attachment wp-att-4065"><img src="/wp-content/uploads/2016/03/dcos-jenkins-plugin-popup.png" alt="dcos-jenkins-plugin-popup" width="637" height="701" class="aligncenter size-full wp-image-4065" /></a>

The Marathon instance within DCOS can be accessed using the URL `http://leader.mesos/service/marathon`. Fill in the fields appropriately, using Jenkins variables if desired. The Docker Image should be the same as the build step above (`${DOCKER_HUB_USERNAME}/${JOB_NAME}:${GIT_COMMIT}`) to ensure the correct image is used.

<a href="/wp-content/uploads/2016/03/dcos-velocity-marathon-config.png" rel="attachment wp-att-4066"><img src="/wp-content/uploads/2016/03/dcos-velocity-marathon-config-800x300.png" alt="dcos-velocity-marathon-config" width="800" height="300" class="aligncenter size-large wp-image-4066" /></a>

## How It Works

The Marathon Deployment post-build action reads the application definition file, by default `marathon.json`, contained within the project’s git repository. This is a JSON file and must contain a valid \[Marathon application definition\]\[3\].

The configurable fields in the post-build action will overwrite the content of matching fields from the file. For example, setting the "Application Id" will replace the `id` field in the file. In the configuration above, "Docker Image" is configured and will overwrite the `image` field contained within the [docker field][5].

The final JSON payload is sent to the configured Marathon instance and the application is updated or created.

# Save

Save the job configuration.

# Build It

Click "Build Now" and let the job build.

<a href="/wp-content/uploads/2016/03/dcos-jenkins-build-now.png" rel="attachment wp-att-4067"><img src="/wp-content/uploads/2016/03/dcos-jenkins-build-now-800x224.png" alt="dcos-jenkins-build-now" width="800" height="224" class="aligncenter size-large wp-image-4067" /></a>

# Deployment

Upon a successful run in Jenkins, the application will begin deployment on Marathon. Visit the Marathon web interface to monitor progress.

<a href="/wp-content/uploads/2016/03/dcos-marathon-demo-deploying.png" rel="attachment wp-att-4068"><img src="/wp-content/uploads/2016/03/dcos-marathon-demo-deploying-800x172.png" alt="dcos-marathon-demo-deploying" width="800" height="172" class="aligncenter size-large wp-image-4068" /></a>

When the Status has changed to Running, the deployment is complete and you can visit the website.

<a href="/wp-content/uploads/2016/03/dcos-marathon-demo-running.png" rel="attachment wp-att-4069"><img src="/wp-content/uploads/2016/03/dcos-marathon-demo-running-800x216.png" alt="dcos-marathon-demo-running" width="800" height="216" class="aligncenter size-large wp-image-4069" /></a>

## Visit Your Site

Visit port `80` on the public DCOS agent to display a jekyll website.

<a href="/wp-content/uploads/2016/03/dcos-jekyll-site1.png" rel="attachment wp-att-4070"><img src="/wp-content/uploads/2016/03/dcos-jekyll-site1-800x313.png" alt="dcos-jekyll-site1" width="800" height="313" class="aligncenter size-large wp-image-4070" /></a>

# Adding a New Post

The content in the `_posts` directory generates a jekyll website. For this example project, that directory is `site/_posts`. Copy an existing post and create a new one with a more recent date in the filename. I added a post entitled "An Update".

Commit the new post to git. Shortly after the new commit lands on the master branch, Jenkins will see the change and redeploy to Marathon.

<a href="/wp-content/uploads/2016/03/dcos-jekyll-updated.png" rel="attachment wp-att-4071"><img src="/wp-content/uploads/2016/03/dcos-jekyll-updated-800x389.png" alt="dcos-jekyll-updated" width="800" height="389" class="aligncenter size-large wp-image-4071" /></a>

 [1]: https://mesosphere.github.io/marathon/
 [2]: /usage/services/velocity/
 [3]: https://mesosphere.github.io/marathon/docs/application-basics.html
 [4]: https://github.com/mesosphere/cd-demo
 [5]: https://mesosphere.github.io/marathon/docs/native-docker.html