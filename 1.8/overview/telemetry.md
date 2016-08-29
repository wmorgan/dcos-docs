---
post_title: Telemetry
menu_order: 7
---

To continuously improve the DC/OS experience, we have included a telemetry component that reports anonymous usage data back to us. We use this data to monitor the reliability of core DC/OS components, installations, and to find out which features are most popular. 

The following information is collected.



<table class="table">
  <tr>
    <th>Type</th>
    <th>Description</th>
  </tr>
    <tr>
    <td>General</td>
    <td>
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


## Opt-Out

- For more information, see the [documentation](/docs/1.8/administration/opt-out/).
