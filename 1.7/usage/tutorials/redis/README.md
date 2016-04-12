---
post_title: Running Redis on DC/OS
post_excerpt: ""
layout: docs.jade
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
Take Redis and run it on DC/OS.

### Time Estimate

### Target Audience

- Operators
- Proof of concept

### Table of Contents

### Prerequisites

- [Install](../install/README.md)
- [Docker](https://docker.com)
- Cluster Size - [Check Cluster Size](../getting-started/cluster-size)

# Installing

- `dcos package install redis`

- Success: Show in CLI + GUI

# Using

- `dcos node ssh --master`
- `docker run -it redis 'exec redis-cli'`

- Success: Add data to redis
- Success: Read data from redis

# Cleanup

# Appendix: Next Steps

- [Service Integration](../service-one/README.md) # Integrate Redis with your application
- [Service Discovery](../internals/service-discovery/README.md)
- [Debugging](../debugging/README.md)
- [Operating](../operating/README.md)
