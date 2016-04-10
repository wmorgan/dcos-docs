---
post_title: The Architecture of DC/OS
post_excerpt: "Explains the Architecture of DC/OS, boot sequence and distributed process management"
layout: page
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---

# The Architecture of DC/OS

An operating system abstracts resources such as CPU, RAM and networking and provides common services to applications. DC/OS is a distributed operating system that abstracts the resources of a cluster of machines and provides common services, such as running processes across a number of nodes, service discovery, and package management, just to name a few. In the following, we have a look at the architecture of DC/OS and the interaction of its components. 

## 100,000ft view

In DC/OS, the **kernel space** comprises Mesos Masters and Mesos Agents. System Components such as Mesos-DNS or Spartan as well services like Marathon or Spark and processes managed by said services (for example a Marathon application) make up the **user space**.

![DC/OS architecture 100,000ft view](img/dcos-architecture-100000ft.png)

### Kernel space

- One or more Mesos Masters. When a leading Mesos Master fails due to a crash or goes offline for an upgrade, a standby Mesos Master automatically becomes the leader without causing any disruption to running services. Leader election is performed via ZooKeeper.
- The `mesos-master` process on a Mesos Master orchestrates tasks that are run on Mesos Agents. The Mesos Master process receives resource offers from Mesos Agents and distributes those resources to registered DC.OS services, such as Marathon or Spark.
- There are two types of Mesos Agents: private agent nodes run the deployed apps and services. The optional public agent nodes can provide public access to DC/OS services and applications.
- The `mesos-slave` process on a Mesos Agent manages its local resources (CPU cores, RAM, etc.) and reports it to the Mesos Masters. It also accepts schedule requests from the Mesos Master and invokes an executor to launch a task.
  - The Mesos Containerizer provides lightweight containerization and resource isolation of executors using Linux-specific functionality such as cgroups and namespaces. For more information, see the [Mesos Containerizer][3] documentation.
  - The Mesos Docker Containerizer provides support for launching tasks that contain Docker images. For more information, see the [Docker Containerizer][4] documentation.

### User space

- System Components
  - [Admin router](https://github.com/mesosphere/adminrouter-public) is an open source NGNIX configuration that provides central authentication and proxy to DC/OS services within the cluster.
  - Exhibitor automatically configures your Zookeeper installation on the master nodes during installation.
  - Mesos-DNS provides service discovery within the cluster. Mesos DNS allows applications and services that are running on Mesos to find each other by using the domain name system (DNS), similar to how services discover each other throughout the Internet.
  - Minuteman-TBD
  - Spartan-TBD
  - System Marathon, the native Marathon instance that is the 'init system' for DC/OS, starts and monitors DC/OS services.
  - Zookeeper, a high-performance coordination service that manages the DC/OS services.
- Services
  - A service in DC/OS is technically a Mesos Framework (scheduler and executor)
  - User apps (for example a Marathon app)

## Boot sequence

In the following, we have a look at how a DC/OS cluster boots up, this means, we have a cluster of nodes with DC/OS installed and switch on the power. What happens?

### Master nodes

- Exhibitor starts up, creates ZK config, launches ZK
- Mesos Master are launched, looks at local ZK, discovers other Masters
- Mesos-DNS is launched on the master nodes
- Mesos-DNS keeps hitting `master/state.json` via leading Mesos Master
- Spartan (DNS proxy) runs on all nodes (master/agents) and forward to MesosDNS
- Marathon is launched
- Marathon goes to localhost for ZK, discovers leading Master
- Admin router depends on Master, MesosDNS and Spartan and runs on each of the master nodes (== DCOS UI)
- Auth is managed by OAuth (only masters)
- History services provides the data for the graphs in the UI (only masters)
- DCOS diagnostics (also systemd service, on every node)

### Agent nodes

- Mesos Agent starts up and discovers the leading Mesos Master via ZK
- Mesos Agent registers with the leading Mesos Master
- Mesos Master confirms and Mesos Agent starts sending status reports (what resources are available) to Mesos Master

### Services

For each service:

- Service scheduler starts up and discovers the leading Mesos Master via ZK
- Service scheduler registers with leading Mesos Master
- Mesos Master confirms and framework scheduler stores framework ID in ZK
- Once a service is registered the resource offer cycle between Mesos Master and framework scheduler kicks in (see also last section in this doc)

## Distributed process management

We now focus on the management of processes in a DC/OS cluster: from the resource allocation to the execution of a process.

Before we dive into the details of the interaction between different DC/OS components, let's define the terminology used in the following:

- Master: this is the leading Mesos Master in the DC/OS cluster (`mesos.master`).
- Scheduler: the scheduler component of a service, for example the Marathon scheduler.
- User: also known as Client, is a cluster-external or internal app that kicks off a process, for example a human user that submits a Marathon app spec.
- Agent: a private or public Mesos Agent; originally was called Mesos Slave and you might still see references to it in the codebase. 
- Executor: is part of a service running on an Agent, managing one or more tasks
- Task: a Mesos task
- Process: a logical collection of tasks initiated by client, for example a Marathon app or a Chronos job

On a high level, the following interaction takes place between the DC/OS components when a User requests to launch a process. Note that communication takes place between the different layers (such as the User interacting with the Scheduler) as well as within a layer, for example, a Master communicating with Agents.

![Concept of distributed process management in DC/OS](img/dcos-architecture-distributed-process-management-concept.png)

Let’s now have a look at a concrete example, using the Marathon service and a User wanting to launch a container based on a Docker image:

![Example of distributed process management in DC/OS](img/dcos-architecture-distributed-process-management-example.png)

From a timing perspective, the interaction between above components looks as follows (note that Executors and Task are folded into one block since in practice this is often the case):

![Sequence diagram for distributed process management in DC/OS](img/dcos-architecture-distributed-process-management-seq-diagram.png)

The steps in detail are:

| Step | Description |
| ---- | ----------- |
| 1    | Client/Scheduler init: the Client needs to know how to connect to the Scheduler in order to launch a process, for example via Mesos-DNS or DC/OS CLI |
| 2    | Mesos Master sends resource offer to Scheduler: the resource offers are based on cluster resources managed through Agents and the [DRF](https://www.cs.berkeley.edu/~alig/papers/drf.pdf) algorithm in Mesos Master.|
| 3    | Scheduler declines resource offer since no process requests from Clients are pending. As long as no clients have initiated a process, the scheduler will reject offers from the Master |
| 4    | Client initiates process launch. For example, this could be a user creating a Marathon app via the UI or via the HTTP endpoint `/v2/app` |
| 5    | Mesos Master sends resource offers . For example, `cpus(*):1; mem(*):128; ports(*):[21452-21452]` |
| 6    | If resource offer matches the requirements the Scheduler has for the process, it accepts the offer and sends a `launchTask` request to Mesos Master |
| 7    | Mesos Master directs Mesos Agent(s) to launch tasks |
| 8    | Mesos Agent launches tasks via Executor |
| 9    | Executor reports task status to Mesos Agent |
| 10   | Mesos Agent reports task status to Mesos Master |
| 11   | Mesos Master report task status to framework scheduler |
| 12   | Framework scheduler reports process status to client |
