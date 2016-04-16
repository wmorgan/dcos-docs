---
post_title: Monitoring
menu_order: 4
---

Monitoring the health of all the pieces that make up DC/OS is vital to data center operators and for troubleshoooting hard-to-diagnose bugs. In DC/OS v1.7 we released a new system health API to monitor the core DC/OS components (more on the terminology of 'components' later). In the futrue we're hoping to expand the usage of the system health API to other metrics as well as exposing a plugins-style architecture to allow operators to customize system health monitoring.
<!-- More -->

## Getting Started
If you're using DC/OS 1.7, getting started with System Health is easy. When you launch your new cluster, you'll notice a new application badge in the main DC/OS user interface:

![login](https://dl.dropboxusercontent.com/u/77193293/systemHealthScreens/dcos_ui.png) FIXME

You can click on this badge, taking you to the main system health user interface:

![badge](https://dl.dropboxusercontent.com/u/77193293/systemHealthScreens/badge_close.png) FIXME

You can sort by health:

![sort](https://dl.dropboxusercontent.com/u/77193293/systemHealthScreens/sort_by_health.png) FIXME

When a component isn't healthy, you can drill in on it, seeing all the nodes on which that component runs:

![view](https://dl.dropboxusercontent.com/u/77193293/systemHealthScreens/sys_unhealthy_view.png) FIXME

You can debug more by clicking the node, where you'll be able to see the unhealthy component journald (log) output:

![log](https://dl.dropboxusercontent.com/u/77193293/systemHealthScreens/sys_unhealthy.png) FIXME

## Components
What we refer to as components are in fact the [systemd units](https://www.freedesktop.org/wiki/Software/systemd/) that make up the core of the DC/OS application. These systemd 'components' are monitored by our internal diagnostics utility (dcos-diagnostics.service). This utility scans all the DC/OS units, and then exposes an HTTP API on each host.

You can query this HTTP API for any host in the cluster:

```
curl <host_ip>:1050/api/v1/health
```

## Aggregation
Aggregation of the cluster health endpoints is actually accomplished by the same diagnostics application, except this aggregation mode is only ran on master hosts. You can explore this API further by making a few queries to any master in your cluster:

```
curl <master_ip>:1050/api/v1/health/units
curl <master_ip>:1050/api/v1/health/nodes
curl <master_ip>:1050/api/v1/health/report
```

The DC/OS user interface uses these aggregation endpoints to generate the data you explore in the system health console.

## Health States
Today, there are only binary health states, ```healthy``` and ```unhealthy```. We infer this from codes 0 and 1 respectively. We did however build the system health API to have four possible states: 0 - 3, OK; CRITICAL; WARNING; UNKNOWN.

In the future we will leverage these codes to give more robust and detailed cluster health state information.

## Known Issues

### Misinterpreting System Health by Unit

You can sort system health by systemd unit. However, this search can bring up misleading information as the service itself can be healthy but the node on which it runs is not. This manifests itself as a service showing "healthy" but nodes associated with that service as "unhealthy". Some people find this behavior confusing.

### Missing Cluster Hosts

The system health API relies on Mesos-DNS to know about all the cluster hosts. It finds these hosts by combining a query from `mesos.master` A records as well as `leader.mesos:5050/slaves` to get the complete list of hosts in the cluster.

This system has a known bug where an agent will not show up in the list returned from `leader.mesos:5050/slaves` if the Mesos slave service is not healthy. This means the system health API will not show this host.

If you experience this behavior it's most likely your Mesos slave service on the missing host is unhealthy.

## Troubleshooting

If you have any problems, you can check if the diagnostics service is running by SSH’ing to the Mesos leading master and checking the systemd status of the `dcos-ddt.service`.

## That's It!
That's it for the system health addition to the DC/OS ecosystem. We're going to be adding many more features in upcoming releases to DC/OS, stay tuned to this blog for more information.
