---
post_title: Install Docker on CentOS
menu_order: 2
---
The recommended way to install Docker on CentOS is to use Docker's yum repository. This makes it easy to upgrade in the future and automatically manages installation of dependencies.

The recommended way to run Docker on CentOS is to manage it with systemd. This handles starting docker on boot and restarting it when it crashes.

The recommended way to configure Docker on CentOS is to use the OverlayFS storage driver on an XFS filesystem. This avoids known issues with `devicemapper` in loopback modes and allows containers to use docker-in-docker, if they want.

Docker's <a href="https://docs.docker.com/engine/installation/linux/centos/" target="_blank">CentOS-specific installation instructions</a> are always going to be the most up to date for the latest version of Docker. However, the following simplified instructions make it easy to follow the above recommendations.

1.  Configure yum to use the Docker yum repo:

    ```bash
    $ sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
    [dockerrepo]
    name=Docker Repository
    baseurl=https://yum.dockerproject.org/repo/main/centos/$releasever/
    enabled=1
    gpgcheck=1
    gpgkey=https://yum.dockerproject.org/gpg
    EOF
    ```

2.  Configure systemd to run the Docker Daemon with OverlayFS:

    ```bash
    $ sudo mkdir -p /etc/systemd/system/docker.service.d && sudo tee /etc/systemd/system/docker.service.d/override.conf <<- EOF
    [Service]
    ExecStart=
    ExecStart=/usr/bin/docker daemon --storage-driver=overlay -H fd://
    EOF
    ```

3.  Install the Docker engine, daemon, and service:

    ```bash
    $ sudo yum install -y docker-engine &&
     sudo systemctl start docker &&
      sudo systemctl enable docker
    ```

    When the process completes, you should see:

    ```
    Complete!
    Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.
    ```

4. Test that Docker is properly installed:

    ```bash
    $ sudo docker ps
    ```

For more generic Docker requirements, see [System Requirements: Docker][1].

[1]: /docs/1.7/administration/installing/custom/system-requirements/#docker
