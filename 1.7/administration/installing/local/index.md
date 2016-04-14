---
post_title: Install DC/OS on Vagrant
layout: docs.jade
published: true
---

# Overview

This installation method creates a cluster of virtual machines on your local machine that can be used for demos, development, and testing.

DC/OS Vagrant installation and usage instructions are maintained in the [dcos-vagrant github repository](https://github.com/mesosphere/dcos-vagrant).

DC/OS Vagrant is for production use.

# System requirements

## Hardware

**[Minimum](https://github.com/mesosphere/dcos-vagrant#minimal-cluster)**:

- 5GB free memory (8GB system memory)

Most services *cannot* be installed on the Minimal cluster.

**[Recommended (Medium)](https://github.com/mesosphere/dcos-vagrant#medium-cluster)**:

- 10GB free memory (16GB system memory)

Most services *can* be installed on the Medium cluster, but not all at the same time.

## Software

- Git
- Vagrant
- VirtualBox

See the [dcos-vagrant readme](https://github.com/mesosphere/dcos-vagrant#requirements) for more details.

# Releases

The dcos-vagrant repository must be cloned to your machine. Select a release appropriate to the version of DC/OS you wish to install.

- [Latest](https://github.com/mesosphere/dcos-vagrant/releases/latest) - Tested with the most recent Stable and Early Access DC/OS releases.
- [Previous](https://github.com/mesosphere/dcos-vagrant/releases) - Tested with older DC/OS releases.
- [Master](https://github.com/mesosphere/dcos-vagrant/tree/master) - Newest features and bug fixes, but not necessarily stable.
