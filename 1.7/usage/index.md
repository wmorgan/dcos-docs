---
post_title: Usage
nav_title: Usage
layout: docs.jade
lunr: true
tags: usage, tutorials, "first steps"
search_blurb: "DC/OS usage including first steps and an overview of available tutorials."
---

## Baby steps

It looks like you've just [installed](https://dcos.io/install/) DC/OS. Welcome aboard! Now that you have the DC/OS CLI set up on your local machine, you might be looking at the DC/OS Dashboard wondering, 'What now?'.

You probably already know how to use `docker run ...` to launch a web server, right? You can do the same thing with DC/OS but in a way that is production ready, right off the bat. DC/OS will keep your web server running if it crashes, and allow you to scale it via CLI or the UI, update its config at runtime and much more!

Ready? Let's launch a production-grade containerized web server with this command from the DC/OS CLI:

    $ dcos marathon app add https://dcos.io/docs/latest/usage/nginx.json

Now go to the DC/OS Dashboard and open the Marathon service and you should see the web server up and running and ready to serve traffic.

## Beginners

Once you've had a good look around in the DC/OS Dashboard and familiarized yourself with the DC/OS CLI, here are a few more exercises that you might want to try.

If you have a DevOps role:

- How to run [NGINX](/docs/1.7/usage/tutorials/nginx/)
- How to run a [Ruby on Rails](/docs/1.7/usage/tutorials/ruby-on-rails/) app
- How to run a [.NET](/docs/1.7/usage/tutorials/asp-dot-net/) app
- How to run [Tomcat](/docs/1.7/usage/tutorials/tomcat/)
- How to run [Jekyll](/docs/1.7/usage/tutorials/jekyll/)
- How to run [MySQL](/docs/1.7/usage/tutorials/mysql/)
- How to run [PostgreSQL](/docs/1.7/usage/tutorials/postgres/)
- How to run [Wordpress](/docs/1.7/usage/tutorials/wordpress/)
- How to run [Jenkins](/docs/1.7/usage/tutorials/jenkins/)

If you have a data engineering or data scientists role:

- How to run [Spark](/docs/1.7/usage/tutorials/spark/)
- How to run [Cassandra](/docs/1.7/usage/tutorials/cassandra/)
- How to run [Kafka](/docs/1.7/usage/tutorials/kafka/)
- How to run [Elasticsearch](/docs/1.7/usage/tutorials/elasticsearch/)
- How to run [Redis](/docs/1.7/usage/tutorials/redis/)

If you a DC/OS administrator role:

- How to [resize](/docs/1.7/administration/resizing/) a DC/OS cluster
- How to [upgrade](/docs/1.7/administration/upgrading/) a DC/OS cluster
- How to [monitor](/docs/1.7/administration/monitoring/) a DC/OS cluster

## Intermediate

Check these out if you've been playing around with DC/OS for a bit and want a deeper dive.

If you want to learn more about how DC/OS works:

- Check out the [DC/OS Architecture](/docs/1.7/overview/architecture/)
- Check out the [High Availability](/docs/1.7/overview/high-availability/) characteristics of DC/OS
- Check out the [Security](/docs/1.7/overview/security/) characteristics of DC/OS
- Check out [Container Operations](/docs/1.7/overview/container-operations/) using DC/OS

If you have a DevOps role:

- How to implement a [microservices](/docs/1.7/usage/tutorials/microservices/) architecture
- How to deal with [service discovery](/docs/1.7/usage/tutorials/service-discovery/)
- How to [debug](/docs/1.7/usage/tutorials/debugging/) your app
- How to run [MySQL HA](/docs/1.7/usage/tutorials/mysql-ha/)
- How to run [PostgreSQL HA](/docs/1.7/usage/tutorials/postgres-ha/)

If you a DC/OS administrator role:

- How to run a [Docker registry](/docs/1.7/usage/tutorials/docker-registry/)
- How to run a [Vault](/docs/1.7/usage/tutorials/vault/)
- How to run [Consul](/docs/1.7/usage/tutorials/consul/)
- How to handle [logging](/docs/1.7/usage/tutorials/logging/)
- How to handle [monitoring](/docs/1.7/usage/tutorials/monitoring/)
- How to handle [auto-scaling](/docs/1.7/usage/tutorials/autoscaling/)
- How to handle [load-balancing](/docs/1.7/usage/tutorials/load-balancing/)

## Advanced

Check these out if you are now a seasoned DC/OS user and want to adapt, extend and learn how to [contribute](/contribute) to DC/OS.

If you have a DevOps role:

- How to handle [stateful services](/docs/1.7/usage/tutorials/stateful-services/)
- How to [package](/docs/1.7/usage/tutorials/packaging/) your service
- How do I [migrate](/docs/1.7/overview/migration/) an existing app to DC/OS

If you a DC/OS administrator role:

- Understand the [system components](/docs/1.7/administration/system-components/) of DC/OS
- Understand DC/OS [telemetry](/docs/1.7/administration/telemetry/)
- How to monitor DC/OS using [Nagios](/docs/1.7/administration/monitoring/nagios/)
- How to set up a [proxy](/docs/1.7/administration/proxy/)

We hope you have a good time with DC/OS and enjoy using it as much as we are having creating it.
