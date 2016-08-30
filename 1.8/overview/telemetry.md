---
post_title: Telemetry
menu_order: 7
---

To continuously improve the DC/OS experience, we have included a telemetry component that reports anonymous usage data back to us. We use this data to monitor the reliability of core DC/OS components, installations, and to find out which features are most popular.
 
The anonymous usage information is sent back to us by the signal service (`dcos-signal.service`) queries the diagnostics service `/system/health/v1/report` endpoint on the leading master and sends this data to SegmentIO for use in tracking metrics and customer support.The signal service is the telemetry component.

The following information is collected.


<table class="table">
  <tr>
    <th>Type</th>
    <th>Description</th>
  </tr>
    <tr>
    <td>General</td>
    <td>The following data is collected across all tracks.
    <ul>
    <li>Cluster ID (`clusterId`)</li>
    <li>Customer ID (Enterprise DC/OS) (`customerKey`)</li>
    <li>DC/OS host system (`provider`)</li>
    <li>DC/OS type: DC/OS or Mesosphere Enterprise DC/OS (`variant`)</li>
    <li>DC/OS version (`environmentVersion`)</li>
    <li>(`source`)</li>
    </ul>
    </td>
  </tr>  
  <tr>
    <td>Mesos</td>
    <td>The Mesos telemetry data provides the total resources available in the cluster and their current usage. 
    <ul>
    <li>Number of active agents (`agents_active`)</li>
    <li>Number of connected agents (`agents_connected`)</li>
    <li>Cluster ID (`clusterId`)</li>
    <li>Number of CPUs available (`cpu_total`)</li>
    <li>Number of allocated CPUs (`cpu_used`)</li>
    <li>Customer ID (Enterprise DC/OS) (`customerKey`)</li>
    <li>Disk space available in MB (`disk_total`)</li>
    <li>Allocated disk space in MB (`disk_used`)</li>
    <li>Memory available in MB (`mem_total`)</li>
    <li>Memory allocated in MB (`mem_used`)</li>
    <li>DC/OS host system (`provider`)</li>
    <li>Number of installed DC/OS services (`framework_count`)</li>
    <li>Which DC/OS services are installed (`frameworks`)</li>
    <li>Number of tasks (`task_count`)</li>
    <li>DC/OS type: DC/OS or Mesosphere Enterprise DC/OS (`variant`)</li>
    <li>Anonymous cluster ID (`anonymousId`)</li>
    <li>DC/OS action (`event`). For example, `"event": "package_list"`, `"event": "health"`, or `"event": "mesos_track"`.</li>
    </ul>
    </td>
  </tr>
  <tr>
    <td>Package repository</td>
    <td><ul><li>Which packages are installed</li></ul></td>
  </tr>
  <tr>
      <td>System</td>
      <td>We collect the total number of running and unhealthy DC/OS systemd units.
      <ul>
          <li>Number of running services</li>
          <li>Number of active services</li>
          <li>Number of running tasks</li>
          <li>Number of connected agent nodes</li>
          <li>Number of active agent nodes</li></ul>
    </tr>
    <tr>
      <td>User interface</td>
      <td>When using the DC/OS UI, we receive two types of notifications:
      <ul>
          <li>Login information</li>
          <li>The pages you’ve viewed while navigating the UI</li></ul>
    </tr>
</table>


# general

For each track (segment term), the data is the same:
"clusterId": "70b28f00-e38f-41b2-a723-aab344f535b9",
- the `anonymousID` we create for every cluster. created at startup. persists across cluster forever. 

"customerKey": "",
- Enterprise: this is set with the customer key that we give to you.

"environmentVersion": "",
- The version of DC/OS.

"provider": "aws",
- What platform DC/OS is running on: aws, on-prem, azure.

"source": "cluster",
- Hard-coded setting that indicates cluster.

"variant": "open"
- Either OSS or Enterprise

"anonymousId": "70b28f00-e38f-41b2-a723-aab344f535b9",
- an anonymous ID we create for every cluster. created at startup. persists across cluster forever.

"event": "package_list"
- name that appears in segment.io. cosmos, health, mesos_track.

# diagnostics

For every systemd unit, the following is collected:
```
"health-unit-dcos-<UNIT_NAME>-total": 3, "health-unit-dcos-<UNIT_NAME>-unhealthy": 0,
```

# mesos



```json
{
    "cosmos": {
        "properties": {
            "clusterId": "70b28f00-e38f-41b2-a723-aab344f535b9",
            "customerKey": "",
            "environmentVersion": "",
            "package_list": [],
            "provider": "aws",
            "source": "cluster",
            "variant": "open"
        },
        "anonymousId": "70b28f00-e38f-41b2-a723-aab344f535b9",
        "event": "package_list"
    },
    "diagnostics": {
        "properties": {
            "clusterId": "70b28f00-e38f-41b2-a723-aab344f535b9",
            "customerKey": "",
            "environmentVersion": "",
            "health-unit-dcos-3dt-service-total": 3,
            "health-unit-dcos-3dt-service-unhealthy": 0,
            "health-unit-dcos-3dt-socket-total": 2,
            "health-unit-dcos-3dt-socket-unhealthy": 0,
            "health-unit-dcos-adminrouter-agent-service-total": 2,
            "health-unit-dcos-adminrouter-agent-service-unhealthy": 0,
            "health-unit-dcos-adminrouter-reload-service-total": 3,
            "health-unit-dcos-adminrouter-reload-service-unhealthy": 0,
            "health-unit-dcos-adminrouter-reload-timer-total": 3,
            "health-unit-dcos-adminrouter-reload-timer-unhealthy": 0,
            "health-unit-dcos-adminrouter-service-total": 1,
            "health-unit-dcos-adminrouter-service-unhealthy": 0,
            "health-unit-dcos-cosmos-service-total": 1,
            "health-unit-dcos-cosmos-service-unhealthy": 0,
            "health-unit-dcos-epmd-service-total": 3,
            "health-unit-dcos-epmd-service-unhealthy": 0,
            "health-unit-dcos-exhibitor-service-total": 1,
            "health-unit-dcos-exhibitor-service-unhealthy": 0,
            "health-unit-dcos-gen-resolvconf-service-total": 3,
            "health-unit-dcos-gen-resolvconf-service-unhealthy": 0,
            "health-unit-dcos-gen-resolvconf-timer-total": 3,
            "health-unit-dcos-gen-resolvconf-timer-unhealthy": 0,
            "health-unit-dcos-history-service-total": 1,
            "health-unit-dcos-history-service-unhealthy": 0,
            "health-unit-dcos-logrotate-agent-service-total": 2,
            "health-unit-dcos-logrotate-agent-service-unhealthy": 0,
            "health-unit-dcos-logrotate-agent-timer-total": 2,
            "health-unit-dcos-logrotate-agent-timer-unhealthy": 0,
            "health-unit-dcos-logrotate-master-service-total": 1,
            "health-unit-dcos-logrotate-master-service-unhealthy": 0,
            "health-unit-dcos-logrotate-master-timer-total": 1,
            "health-unit-dcos-logrotate-master-timer-unhealthy": 0,
            "health-unit-dcos-marathon-service-total": 1,
            "health-unit-dcos-marathon-service-unhealthy": 0,
            "health-unit-dcos-mesos-dns-service-total": 1,
            "health-unit-dcos-mesos-dns-service-unhealthy": 0,
            "health-unit-dcos-mesos-master-service-total": 1,
            "health-unit-dcos-mesos-master-service-unhealthy": 0,
            "health-unit-dcos-mesos-slave-public-service-total": 1,
            "health-unit-dcos-mesos-slave-public-service-unhealthy": 0,
            "health-unit-dcos-mesos-slave-service-total": 1,
            "health-unit-dcos-mesos-slave-service-unhealthy": 0,
            "health-unit-dcos-metronome-service-total": 1,
            "health-unit-dcos-metronome-service-unhealthy": 0,
            "health-unit-dcos-minuteman-service-total": 3,
            "health-unit-dcos-minuteman-service-unhealthy": 0,
            "health-unit-dcos-navstar-service-total": 3,
            "health-unit-dcos-navstar-service-unhealthy": 0,
            "health-unit-dcos-oauth-service-total": 1,
            "health-unit-dcos-oauth-service-unhealthy": 0,
            "health-unit-dcos-pkgpanda-api-service-total": 3,
            "health-unit-dcos-pkgpanda-api-service-unhealthy": 0,
            "health-unit-dcos-pkgpanda-api-socket-total": 3,
            "health-unit-dcos-pkgpanda-api-socket-unhealthy": 0,
            "health-unit-dcos-rexray-service-total": 2,
            "health-unit-dcos-rexray-service-unhealthy": 0,
            "health-unit-dcos-signal-service-total": 1,
            "health-unit-dcos-signal-service-unhealthy": 0,
            "health-unit-dcos-signal-timer-total": 3,
            "health-unit-dcos-signal-timer-unhealthy": 0,
            "health-unit-dcos-spartan-service-total": 3,
            "health-unit-dcos-spartan-service-unhealthy": 0,
            "health-unit-dcos-spartan-watchdog-service-total": 3,
            "health-unit-dcos-spartan-watchdog-service-unhealthy": 0,
            "health-unit-dcos-spartan-watchdog-timer-total": 3,
            "health-unit-dcos-spartan-watchdog-timer-unhealthy": 0,
            "health-unit-dcos-vol-discovery-priv-agent-service-total": 1,
            "health-unit-dcos-vol-discovery-priv-agent-service-unhealthy": 0,
            "health-unit-dcos-vol-discovery-pub-agent-service-total": 1,
            "health-unit-dcos-vol-discovery-pub-agent-service-unhealthy": 0,
            "provider": "aws",
            "source": "cluster",
            "variant": "open"
        },
        "anonymousId": "70b28f00-e38f-41b2-a723-aab344f535b9",
        "event": "health"
    },
    "mesos": {
        "properties": {
            "agents_active": 2,
            "agents_connected": 2,
            "clusterId": "70b28f00-e38f-41b2-a723-aab344f535b9",
            "cpu_total": 8,
            "cpu_used": 0,
            "customerKey": "",
            "disk_total": 71154,
            "disk_used": 0,
            "environmentVersion": "",
            "framework_count": 2,
            "frameworks": [
                {
                    "name": "marathon"
                },
                {
                    "name": "metronome"
                }
            ],
            "mem_total": 28036,
            "mem_used": 0,
            "provider": "aws",
            "source": "cluster",
            "task_count": 0,
            "variant": "open"
        },
        "anonymousId": "70b28f00-e38f-41b2-a723-aab344f535b9",
        "event": "mesos_track"
    }
}
```


## Opt-Out

- For more information, see the [documentation](/docs/1.8/administration/opt-out/).
