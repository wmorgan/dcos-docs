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
    <li>Anonymous cluster ID</li>
    <li>Customer ID (Enterprise DC/OS)</li>
    <li>DC/OS host system</li>
    <li>DC/OS type: DC/OS or Mesosphere Enterprise DC/OS</li>
    <li>DC/OS version</li>
    </ul>
    </td>
  </tr>  
  <tr>
    <td>Mesos</td>
    <td>The Mesos telemetry data provides the total resources available in the cluster and their current usage. 
    <ul>
    <li>Allocated disk space in MB</li>
    <li>Disk space available in MB</li>
    <li>Memory allocated in MB</li>
    <li>Memory available in MB</li>
    <li>Number of allocated CPUs</li>
    <li>Number of CPUs available</li>
    <li>Number of installed DC/OS services</li>
    <li>Which DC/OS services are installed</li>
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
