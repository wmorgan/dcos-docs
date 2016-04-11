---
UID: 56f9844aa8e6c
post_title: Usage
post_excerpt: ""
layout: page
published: true
menu_order: 36
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---

## Baby steps

You got [installed](http://dcos.io/install) DC/OS? You have the DC/OS CLI `dcos` on your local computer set up and now you're looking at the DC/OS Dashboard, wondering 'What now?'. You know how to use `docker run ...` to launch a webserver, right? Now you will do the same using DC/OS, with the difference that this deployment is production-ready from the get-go. DC/OS will keep the webserver running if it crashes, you can scale it, update the config at runtime, and many more things but I'm getting ahead of myself now. Let's launch a production-ready containerized webserver:

    $ curl -sO http://dcos.io/docs/resources/nginx.json && dcos marathon app add nginx.json

If you now go to the DC/OS Dashboard and open the Marathon service you [see](img/usage_marathon_webserver.png) the webserver up and running and ready to serve traffic.

## Beginners

Once you had a good look around in the DC/OS Dashboard and familiarized yourself with the DC/OS CLI, here are a few things you might want to check out:

- If you are have a devops role:
  - How to run [NGINX](/usage/examples/nginx) on DC/OS
  - How to run [MySQL](/usage/examples/mysql) on DC/OS
  - How to run [PostgreSQL](/usage/examples/postgres) on DC/OS
  - How to run a [Ruby on Rails](/usage/examples/ruby-on-rails) app on DC/OS
  - How to run a [.NET](/usage/examples/asp-dot-net) app on DC/OS
  - How to run [Tomcat](/usage/examples/tomcat) on DC/OS
  - How to run [Jekyll](/usage/examples/jekyll) on DC/OS
  - How to run [Jenkins](/usage/services/jenkins) on DC/OS
  - How to run [Spark](/usage/examples/Spark) on DC/OS
  - How to run [Cassandra](/usage/services/cassandra) on DC/OS
  - How to run [Kafka](/usage/examples/kafka) on DC/OS
  - How to run [Elasticsearch](/usage/examples/elasticsearch) on DC/OS
  - How to run [Redis](/usage/examples/redis) on DC/OS
- If you are administrating a DC/OS cluster:
  - /administration/resizing
  - /administration/upgrading
  - /overview/monitoring

## Intermediate

So you've been playing around with DC/OS for a bit now and want to dive a bit deeper into its features? Here we go:

- Check out the [DC/OS Architecture](/overview/architecture)
- Check out the [High Availability](/overview/high-availability) characteristics of DC/OS
- Check out the [Security](/overview/security) characteristics of DC/OS
- If you are have a devops role:
  - /usage/stateful-services
  - /overview/service-discovery
  - /overview/container-operations
  - /usage/examples/wordpress
  - /usage/examples/consul
  - /usage/examples/docker-registry
  - /usage/examples/microservices
  - /usage/examples/vault
  - /usage/debugging
- If you are administrating a DC/OS cluster:
  - /administration/logging
  - /administration/monitoring
  - /administration/monitoring/nagios
  - /overview/autoscaling
  - /overview/load-balancing

## Advanced

You are now a seasoned DC/OS user and want to adapt and extend DC/OS? Have a look at the following content:

- Learn how to [contribute](/overview/contribution) to DC/OS
- If you are have a devops role:
  - /usage/packaging
- If you are administrating a DC/OS cluster:
  - /administration/system-services
  - /administration/telemetry
  - /administration/proxy
  - /overview/migration
