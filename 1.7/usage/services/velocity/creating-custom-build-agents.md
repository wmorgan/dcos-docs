---
UID: 56f9844569787
post_title: Creating Custom Build Agents
post_excerpt: ""
layout: page
published: true
menu_order: 104
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
By default, Mesosphere DCOS runs everything inside Docker containers in order to minimize dependencies on the underlying host operating system and to offer resilience in the event of a machine failure. When using Velocity, the underlying Mesos scheduler in DCOS creates new Jenkins agents that run as Mesos tasks within a Docker container. User-configured builds are then run inside the same container.

Since builds typically have steps that invoke the Docker utility, such as `docker build` or `docker push`, we provide the [mesosphere/jenkins-dind][1] Docker image and configure Velocity to use this by default. The `mesosphere/jenkins-dind` image also includes several other well-known tools. For a complete list, see the [Dockerfile][2].

However, in many cases you will have your own dependencies to specify for your applications and environment. As such, we expect that our customers will create custom Docker images for their Jenkins build agents with their environment-specific packages and configurations. Below, you'll find several common scenarios and a recipe for each. Once your new Docker image is built, you can then push it to Docker Hub or your own private Docker registry. This registry must be accessible by each of the DCOS agents.

At a minimum, a custom agent requires the following packages:

*   *OpenJDK 8.* Required by Jenkins to launch the agent and register with the master.
*   *CA certificates.* Required to verify SSL/TLS certificates.

Additionally, you may also want these commonly-used packages:

*   *Bash.* Required by many Jenkins build scripts.
*   *Git.* Popular version control system.
*   *OpenSSH client.* Required to clone Git repositories via SSH.

# Creating a new image based on mesosphere/jenkins-dind

To provide your own dependencies, we recommend extending the provided `jenkins-dind-agent` image and install the packages you require.

The example below shows how you could create an image which includes `sbt`, a Scala build tool (the following code snippet is based on [docker-sbt][3]):

    FROM mesosphere/jenkins-dind:0.2.2
    
    ENV SBT_VERSION 0.13.8
    ENV SBT_HOME /usr/local/sbt
    ENV PATH ${PATH}:${SBT_HOME}/bin
    
    RUN curl -sL "http://dl.bintray.com/sbt/native-packages/sbt/$SBT_VERSION/sbt-$SBT_VERSION.tgz" \
        | gunzip | tar -x -C /usr/local && echo -ne "- with sbt $SBT_VERSION\n" >> /root/.built
    

# Modifying the SSH host keys

By default, Velocity includes the SSH public keys used by GitHub. If you aren't using GitHub to host your Git repositories and want to use SSH when cloning your Git repositories, you will need to add your Git server's SSH public key(s) to `/etc/ssh/ssh_known_hosts` by appending the following lines to your Dockerfile:

        ENV SSH_KNOWN_HOSTS github.com my.git.server
        RUN ssh-keyscan $SSH_KNOWN_HOSTS | tee /etc/ssh/ssh_known_hosts
    

# Configuring Jenkins

Once the image has been created and is available on Docker Hub or your private Docker registry, you need to configure Jenkins to make this image available in your job configurations. From the Jenkins web interface, navigate to the "Manage Jenkins" page, and then to the "Configure Jenkins" page.

Scroll to the "Cloud" section at the bottom and click "Advanced". You will see a grey button to "Add Slave Info":

<a href="/wp-content/uploads/2016/03/velocity-add-slave-info.png" rel="attachment wp-att-4016"><img src="/wp-content/uploads/2016/03/velocity-add-slave-info.png" alt="velocity-add-slave-info" width="740" height="228" class="aligncenter size-full wp-image-4016" /></a>

On the "Add Slave Info" page, set values based on the needs of your particular job or application. Some options include:

*   *Label string.* Specify a label for the Jenkins agent. This will be referenced in any jobs that make use of this image.
*   *Usage.* Leave this as the default, "Utilize this node as much as possible."
*   *Jenkins slave CPUs.* The CPU shares consumed by a single agent.
*   *Jenkins slave memory in MB.* The memory consumed by a single agent.
*   *Maximum number of executors per slave.* Number of Jenkins executors that will exist within a single container.
*   *Jenkins executor CPUs.* The CPU shares given to each executor within the container (estimated).
*   *Jenkins executor memory.* The memory given to each Jenkins executor within the container (estimated).

**Note:** The actual resources available to the Jenkins agent are calculated using the following formulas. Use these to create your estimates when you configure the agent's CPUs and memory.

    actualCpus = slaveCpus + maxExecutors * executorCpus
    actualMem = slaveMem + maxExecutors * executorMem
    

<a href="/wp-content/uploads/2016/03/velocity-jenkins-slave-info.png" rel="attachment wp-att-4017"><img src="/wp-content/uploads/2016/03/velocity-jenkins-slave-info.png" alt="velocity-jenkins-slave-info" width="691" height="228" class="aligncenter size-full wp-image-4017" /></a>

To configure this Jenkins agent with a custom Docker image that you have created, click "Advanced" again and select the "Use Docker Containerizer" checkbox. Here you can specify the "Docker Image" name.

<a href="/wp-content/uploads/2016/03/velocity-docker-containerizer-settings.png" rel="attachment wp-att-4018"><img src="/wp-content/uploads/2016/03/velocity-docker-containerizer-settings.png" alt="velocity-docker-containerizer-settings" width="676" height="583" class="aligncenter size-full wp-image-4018" /></a>

**Note:** If you're creating a new Docker-in-Docker image, be sure to select "Docker Privileged Mode" and specify a custom Docker command shell.

Click "Save."

# Configuring your Jenkins job to use the new agent

To configure a build to use the newly specified image, click on "Configure" for the build, select "Restrict where this project can be run," and specify the same "Label String":

<a href="/wp-content/uploads/2016/03/velocity-job-build-label-string.png" rel="attachment wp-att-4024"><img src="/wp-content/uploads/2016/03/velocity-job-build-label-string-800x63.png" alt="velocity-job-build-label-string" width="800" height="63" class="aligncenter size-large wp-image-4024" /></a>

Click "Save."

 [1]: https://hub.docker.com/r/mesosphere/jenkins-dind
 [2]: https://github.com/mesosphere/jenkins-dind-agent/blob/master/Dockerfile
 [3]: https://github.com/1science/docker-sbt/blob/latest/Dockerfile