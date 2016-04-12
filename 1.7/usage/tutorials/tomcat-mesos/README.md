---
post_title: Running Tomcat on DC/OS
post_excerpt: ""
layout: docs.jade
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
Take an existing multi-tier Tomcat application and run it on DC/OS.

### Time Estimate/Scope

### Target Audience

- Developers
- Proof of Concept
- ???

### Table of Contents

# Prerequisites

- [Install](../install/README.md)
- Cluster Size - [Check Cluster Size](../getting-started/cluster-size)

### The database

- [MySQL](../database/mysql/README.md)
- [Postgres](../database/postgres/README.md)

# Procedure

#### Format

- Explain what this step will do.
- Walk through the steps to complete this task.
- Show this step completing (running docker container and curling endpoint for example).

- Note that all assets should be either included locally or already uploaded to the correct storage (Docker Hub, S3).

### Run the container

- [Mesos vs. Docker Container](../internals/mesos-docker.md)
- [Service Discovery](../internals/service-discovery.md)

- Success: SSH into machine, show running 'container'
- Success: Show container logs via. CLI + GUI

### The load balancer

- [Haproxy](../loadbalancer/haproxy/README.md)

- Success: Show load balancer placement
- Success: Show container logs via. CLI + GUI
- Success: Route "externally"

# Cleanup

# Appendix: Next Steps

- [Debugging](../debugging/README.md)
- [Operating](../operating/README.md)
