# Running Tomcat in Docker on DC/OS

Take an existing multi-tier Tomcat application and run it on DC/OS.

### Time Estimate

### Target Audience

- Developers
- Proof of Concept
- ???

### Table of Contents

### Prerequisites

- [Install](../install/README.md)
- [Docker](https://docker.com)
- Cluster Size - [Check Cluster Size](../getting-started/cluster-size)

# The database

- [MySQL](../database/mysql/README.md)
- [Postgres](../database/postgres/README.md)

# Build the container

- [Mesos vs. Docker Container](../internals/mesos-docker.md)
- [Run without Docker](../tomcat-mesos/README.md)

- Success: Run container locally

#### Format

- Explain what this step will do.
- Walk through the steps to complete this task.
- Show this step's success (running docker container and curling endpoint for example).

- Note that all assets should be either included locally or already uploaded to the correct storage (Docker Hub, S3).

# Run the container

- [Service Discovery](../internals/service-discovery.md)

- Success: Show container logs via. CLI + GUI

# The load balancer

- [Haproxy](../loadbalancer/haproxy/README.md)

- Success: Show load balancer placement
- Success: Show container logs via. CLI + GUI
- Success: Route "externally"

# Cleanup

# Appendix: Next Steps

- [Debugging](../debugging/README.md)
- [Operating](../operating/README.md)
