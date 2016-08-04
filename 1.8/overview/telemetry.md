---
post_title: Telemetry
menu_order: 7
---

To continuously improve the DC/OS experience, we have included a telemetry component that reports anonymous usage data back to us. We use this data to monitor the reliability of core DC/OS components, installations, and to find out which features are most popular. 

The following is collected:

* Number of running services
* Number of active services 
* Which packages are installed
* Total amount of CPU, disk, and memory
* Number of running tasks
* Number of connect agent nodes
* Number of active agent nodes

There are two sections that have the telemetry component implemented:

## System

We collect the total number of running and unhealthy DC/OS systemd units.

## User Interface

When using the DC/OS UI, we receive two types of notifications:

- Login information
- The pages you’ve viewed while navigating the UI

<hr>

## Opt-Out

- For more information, see the [dcoumentation](/docs/1.8/administration/opt-out/).
