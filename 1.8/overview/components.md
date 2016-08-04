---
post_title: Components
nav_title: Components
menu_order: 4
---

What are the core DC/OS components?
<!--more-->
By components, we're referring to the services which work together to bring the DC/OS ecosystem alive. The core component is of course [Apache Mesos](http://mesos.apache.org/) but the DC/OS is actually made of of *many* more services than just this.

If you log into any host in the DC/OS cluster, you can view the currently running services by inspecting `/etc/systemd/system/dcos.target.wants/`.

```bash
$ ls
dcos-3dt.service                 dcos-marathon.service
dcos-adminrouter-reload.service  dcos-mesos-dns.service
dcos-adminrouter-reload.timer    dcos-mesos-master.service
dcos-adminrouter.service         dcos-metronome.service
dcos-cosmos.service              dcos-minuteman.service
dcos-epmd.service                dcos-navstar.service
dcos-exhibitor.service           dcos-oauth.service
dcos-gen-resolvconf.service      dcos-signal.service
dcos-gen-resolvconf.timer        dcos-signal.timer
dcos-history.service             dcos-spartan-watchdog.service
dcos-logrotate-master.service    dcos-spartan-watchdog.timer
dcos-logrotate-master.timer      dcos-spartan.service
```

## Admin Router Service
The Admin Router service (`dcos-adminrouter.service `) is the core internal load balancer for DC/OS. Admin Router is a customized [Nginx](https://www.nginx.com/resources/wiki/) that proxies all of the internal services on port `80`.

```
[Unit]
Description=Admin Router: A high performance web server and a reverse proxy server
After=dcos-gen-resolvconf.service
ConditionPathExists=/var/lib/dcos/cluster-id

[Service]
Restart=always
StartLimitInterval=0
RestartSec=5
EnvironmentFile=/etc/environment
EnvironmentFile=/opt/mesosphere/environment
Type=forking
PIDFile=/opt/mesosphere/packages/adminrouter--1ec9969794ff4fcbde235d029652679b6a51e51e/nginx/logs/nginx.pid
PrivateDevices=yes
StandardOutput=journal
StandardError=journal
ExecStartPre=/bin/ping -c1 ready.spartan
ExecStartPre=/bin/ping -c1 marathon.mesos
ExecStartPre=/bin/ping -c1 leader.mesos
ExecStart=/opt/mesosphere/packages/adminrouter--1ec9969794ff4fcbde235d029652679b6a51e51e/nginx/sbin/nginx
ExecReload=/usr/bin/kill -HUP $MAINPID
KillSignal=SIGQUIT
KillMode=mixed
```

## Cluster ID Service
The cluster-id service generates a universally unique identifier (UUID) for each cluster. We use this ID to track cluster health remotely (if enabled). This remote tracking allows our support team to better assist our customers.

The cluster-id service runs an internal tool called `zk-value-consensus` which uses our internal [ZooKeeper](/docs/1.8/overview/concepts/#exhibitorforzookeeper) to generate a UUID that all the masters agree on. Once an agreement is reached, the ID is written to disk at `/var/lib/dcos/cluster-id`. We write it to `/var/lib/dcos` so the ID is ensured to persist cluster upgrades without changing.

```
[Unit]
Description=Cluster ID: Generates anonymous DC/OS Cluster ID
[Service]
Type=oneshot
EnvironmentFile=/opt/mesosphere/environment
ExecStartPre=/bin/mkdir -p /var/lib/dcos
ExecStart=/bin/sh -c "/opt/mesosphere/bin/python -c 'import uuid; print(uuid.uuid4())'  | /opt/mesosphere/bin/zk-value-consensus /cluster-id > /var/lib/dcos/cluster-id"
```

## Cosmos Service
The Cosmos service (`dcos-cosmos.service `) is our internal packaging API service. This service is accessed every time that you run `dcos package install` from the CLI. This API deploys DC/OS packages from the DC/OS [Universe](https://github.com/mesosphere/universe) to your DC/OS cluster.

```
[Unit]
Description=Package Service: DC/OS Packaging API
After=dcos-mesos-master.service
After=dcos-gen-resolvconf.service

[Service]
Restart=always
StartLimitInterval=0
RestartSec=15
EnvironmentFile=/opt/mesosphere/environment
ExecStartPre=/bin/ping -c1 ready.spartan
ExecStartPre=/opt/mesosphere/bin/exhibitor_wait.py
## CoreOS
ExecStartPre=-/usr/bin/mkdir -p /var/lib/cosmos
## Ubuntu
ExecStartPre=-/bin/mkdir -p /var/lib/cosmos
ExecStart=/opt/mesosphere/bin/java -Xmx2G -jar "/opt/mesosphere/packages/cosmos--e5b42c8cd703c1eb7b83868b1
```

## Diagnostics Service
The diagnostics service (`dcos-3dt.service`) is the diagnostics utility for DC/OS systemd components. This service runs on every host, tracking the internal state of the systemd unit. The service runs in two modes, with or without the `-pull` argument. If running on a master host, it executes `/opt/mesosphere/bin/3dt -pull` which queries Mesos-DNS for a list of known masters in the cluster, then queries a master (usually itself) `:5050/statesummary` and gets a list of agents.

From this complete list of cluster hosts, it queries all 3DT health endpoints (`:1050/system/health/v1/health`). This endpoint returns health state for the DC/OS systemd units on that host. The master 3DT processes, along with doing this aggregation also expose `/system/health/v1/` endpoints to feed this data by `unit` or `node` IP to the DC/OS user interface.

```
[Unit]
Description=Diagnostics: DC/OS Distributed Diagnostics Tool Master API and Aggregation Service
[Service]
EnvironmentFile=/opt/mesosphere/environment
Restart=always
StartLimitInterval=0
RestartSec=5
ExecStart=/opt/mesosphere/bin/3dt -pull
```

## Erlang Port Mapper Daemon Service
The Erlang Port Mapper Daemon (EPMD) (`dcos-epmd.service`) supports the internal DC/OS layer 4 load balancer that is called [minuteman](#minuteman).

```
[Unit]
Description=Erlang Port Mapping Daemon: DC/OS Erlang Port Mapping Daemon

[Service]
Restart=always
StartLimitInterval=0
RestartSec=5
WorkingDirectory=/opt/mesosphere/packages/erlang--8035129e271fc5b27124e3e8e3d7b63395c5ef31
EnvironmentFile=/opt/mesosphere/environment
ExecStart=/opt/mesosphere/packages/erlang--8035129e271fc5b27124e3e8e3d7b63395c5ef31/bin/epmd -port 61420
Environment=HOME=/opt/mesosphere
```

## Exhibitor Service
DC/OS uses Exhibitor (`dcos-exhibitor.service`), a project from [Netflix](https://github.com/Netflix/exhibitor), to manage and automate the deployment of [ZooKeeper](/docs/1.8/overview/concepts/#exhibitorforzookeeper).

```
[Unit]
Description=Exhibitor: ZooKeeper Supervisor Service
After=network-online.target
[Service]
StandardOutput=journal
StandardError=journal
Restart=always
StartLimitInterval=0
RestartSec=5
MountFlags=private
RuntimeDirectory=dcos_exhibitor
EnvironmentFile=/opt/mesosphere/environment
EnvironmentFile=/opt/mesosphere/etc/dns_config
EnvironmentFile=/opt/mesosphere/etc/exhibitor
# run in new mount namespace to create custom resolv.conf
ExecStart=/usr/bin/unshare --mount /opt/mesosphere/packages/exhibitor--8b9dac1cdd3a5ea25ae5a2e66f18000ad72c3f26/usr/exhibitor/start_exhibitor.py
```

## Generate resolv.conf Service
The Generate resolv.conf Service (`dcos-gen-resolvconf.service`) dynamically provisions `/etc/resolv.conf` for your cluster hosts.

```
[Unit]
Description=Generate Resolv.conf: Update systemd-resolved for Mesos-DNS
After=dcos-spartan.service

[Service]
Type=oneshot
StandardOutput=journal
StandardError=journal
EnvironmentFile=/etc/environment
EnvironmentFile=/opt/mesosphere/environment
EnvironmentFile=/opt/mesosphere/etc/dns_config
EnvironmentFile=/opt/mesosphere/etc/dns_search_config
EnvironmentFile=-/opt/mesosphere/etc/dns_config_master
ExecStart=/opt/mesosphere/bin/gen_resolvconf.py /etc/resolv.conf
```

## History Service
The history service (`dcos-history.service`) provides a simple service for storing stateful information about your DC/OS cluster. This data is stored on disk for 24 hours. Along with storing this data, the history service also exposes a HTTP API for the DC/OS user interface to query. All DC/OS cluster stats which involve memory, CPU and disk usage are driven by this service (including the donuts!).

```
[Unit]
Description=Mesos History: DC/OS Resource Metrics History Service/API
After=dcos-mesos-master.service
[Service]
Restart=always
StartLimitInterval=0
RestartSec=5
EnvironmentFile=/opt/mesosphere/environment
Environment=HISTORY_BUFFER_DIR=/var/lib/mesosphere/dcos/history-service
ExecStart=/opt/mesosphere/bin/dcos-history
```

## Logrotate Service
The Logrotate (`dcos-logrotate-master.service`) service ensures DC/OS services don't overload cluster hosts with too much log data on disk.

```
[Unit]
Description=Logrotate: Rotate various logs on the system
[Service]
Type=simple
EnvironmentFile=/etc/environment
EnvironmentFile=/opt/mesosphere/environment
ExecStartPre=/usr/bin/mkdir -p /var/log/mesos/archive
ExecStart=/opt/mesosphere/packages/logrotate--52aee4fc02aab1082880abd4411d7825148ea024/bin/logrotate /opt/mesosphere/packages/logrotate--52aee4fc02aab1082880abd4411d7825148ea024/etc/logrotate.conf
```

## Marathon Service
Marathon (`dcos-marathon.service`) is the distributed init system for the DC/OS cluster. We run an internal [Marathon](/docs/1.8/overview/concepts/#dcosmarathon) for packages and other DC/OS services. 

```
[Unit]
Description=Marathon: DC/OS Init System
After=dcos-mesos-master.service
[Service]
Restart=always
StartLimitInterval=0
RestartSec=15
EnvironmentFile=/opt/mesosphere/environment
EnvironmentFile=-/opt/mesosphere/environment.ip.marathon
ExecStartPre=/opt/mesosphere/bin/exhibitor_wait.py
ExecStartPre=/bin/bash -c 'echo "HOST_IP=$($MESOS_IP_DISCOVERY_COMMAND)" > /opt/mesosphere/environment.ip.marathon'
ExecStartPre=/bin/bash -c 'echo "MARATHON_HOSTNAME=$($MESOS_IP_DISCOVERY_COMMAND)" >> /opt/mesosphere/environment.ip.marathon'
ExecStartPre=/bin/bash -c 'echo "LIBPROCESS_IP=$($MESOS_IP_DISCOVERY_COMMAND)" >> /opt/mesosphere/environment.ip.marathon'
ExecStart=/opt/mesosphere/bin/java -Xmx2G -jar "/opt/mesosphere/packages/marathon--fbc1c97b180500cd4ec6d26520c1db9e105879f8/usr/marathon.jar" --zk zk://localhost:2181/marathon --master zk://localhost:2181/mesos --hostname "$MARATHON_HOSTNAME" --default_accepted_resource_roles "*" --mesos_role "slave_public" --max_tasks_per_offer 100 --task_launch_timeout 86400000 --decline_offer_duration 300000 --revive_offers_for_new_apps --zk_compression --mesos_leader_ui_url "/mesos" --enable_features "vips,task_killing" --mesos_authentication_principal "marathon"
```

## Mesos-DNS Service
Mesos-DNS is the internal DNS service (`dcos-mesos-dns.service`) for the DC/OS cluster. [Mesos-DNS](/docs/1.8/overview/concepts/#mesosdns) provides the namespace `$service.mesos` to all cluster hosts. For example, you can login to your leading mesos master with `ssh leader.mesos`.

```
[Unit]
Description=Mesos-DNS: DNS based Service Discovery
After=dcos-mesos-master.service
[Service]
Restart=always
StartLimitInterval=0
RestartSec=5
EnvironmentFile=/etc/environment
EnvironmentFile=/opt/mesosphere/environment
ExecStart=/opt/mesosphere/bin/mesos-dns --config=/opt/mesosphere/etc/mesos-dns.json -logtostderr=true
```

## <a name="minuteman"></a>Minuteman Service
[Minuteman](https://github.com/dcos/minuteman) (`dcos-minuteman.service`) is the internal DC/OS layer 4 loadbalancer.

```
[Unit]
Description=Layer 4 Load Balancer: DC/OS Layer 4 Load Balancing Service
After=dcos-gen-resolvconf.service
After=dcos-epmd.service
BindsTo=dcos-epmd.service

[Service]
Restart=always
StartLimitInterval=0
RestartSec=5
WorkingDirectory=/opt/mesosphere/packages/minuteman--841ef0a5edaa8cffedf4946c47929e477a3aef92/minuteman
EnvironmentFile=/opt/mesosphere/environment
ExecStartPre=/bin/ping -c1 ready.spartan
ExecStartPre=/bin/ping -c1 leader.mesos
ExecStartPre=/usr/bin/env mkdir -p /var/lib/dcos/minuteman/mnesia
ExecStartPre=/usr/bin/env mkdir -p /var/lib/dcos/minuteman/lashup
ExecStart=/opt/mesosphere/packages/minuteman--841ef0a5edaa8cffedf4946c47929e477a3aef92/minuteman/bin/env foreground
Environment=HOME=/opt/mesosphere
```

## Signal Service
The DC/OS signal service (`dcos-signal.service`) queries the diagnostics service `/system/health/v1/report` endpoint on the leading master and sends this data to SegmentIO for use in tracking metrics and customer support.

```
[Unit]
Description=Signal Service: DC/OS Telemetry and Support Utility
After=dcos-mesos-master.service
[Service]
EnvironmentFile=/opt/mesosphere/environment
EnvironmentFile=-/opt/mesosphere/etc/cfn_signal_metadata
ExecStart=/opt/mesosphere/bin/dcos-signal --write_key=51ybGTeFEFU1xo6u10XMDrr6kATFyRyh
```

## Distributed DNS Proxy
Distributed DNS Proxy (`dcos-spartan.service`) is the internal DC/OS DNS dispatcher. It conforms to RFC5625 as a DNS forwarder for DC/OS cluster services.

```
[Unit]
Description=DNS Dispatcher: An RFC5625 Compliant DNS Forwarder
[Service]
Restart=always
StartLimitInterval=0
RestartSec=5
WorkingDirectory=/opt/mesosphere/active/spartan/spartan
EnvironmentFile=/opt/mesosphere/environment
EnvironmentFile=/opt/mesosphere/etc/dns_config
EnvironmentFile=/opt/mesosphere/etc/dns_search_config
EnvironmentFile=-/opt/mesosphere/etc/dns_config_master
ExecStartPre=/usr/bin/env modprobe dummy
ExecStartPre=-/usr/bin/env ip link add spartan type dummy
ExecStartPre=/usr/bin/env ip link set spartan up
ExecStartPre=-/usr/bin/env ip addr add 198.51.100.1/32 dev spartan
ExecStartPre=-/usr/bin/env ip addr add 198.51.100.2/32 dev spartan
ExecStartPre=-/usr/bin/env ip addr add 198.51.100.3/32 dev spartan
ExecStart=/opt/mesosphere/active/spartan/spartan/bin/spartan foreground
Environment=HOME=/opt/mesosphere
```
