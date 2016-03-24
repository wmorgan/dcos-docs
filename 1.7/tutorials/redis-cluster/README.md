---
post_title: Running Redis Cluster on DC/OS
post_excerpt: ""
layout: page
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---

Create a redis cluster on DC/OS.

### Time Estimate

### Target Audience

- Operators
- Highly-Available

### Table of Contents

### Prerequisites

- [Install](../install/README.md)
- [Docker](https://docker.com)
- Cluster Size - [Check Cluster Size](../getting-started/cluster-size)

# Procedure

### Installing

- `dcos package install redis-cluster`

- Success: Show in CLI + GUI

### Using

- `dcos node ssh --master`
- `docker run -it redis 'exec redis-cli'`

- Success: Add data to redis
- Success: Read data from redis

### Operating

- kill node

- Success: Show restart
- Success: Read old data from redis

# Cleanup

# Appendix: Next Steps

- [Debugging](../debugging/README.md)
- [Operating](../operating/README.md)
