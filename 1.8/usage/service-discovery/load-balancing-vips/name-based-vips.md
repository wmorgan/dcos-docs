---
post_title: Name-based VIPs
menu_order: 20
---

Name-based VIPs allow clients connect with a service address instead of an IP address. DC/OS generates name-based VIPs such that the cannot collide with IP VIPs, which means that administrators don't need to carefully manage name-based VIPs to avoid collision. This also means that name-based VIPs can be automatically created when the service is installed.

# How to Create Name-Based VIPs

1. Create a Marathon application definition that specifies a name-based VIP.

In the following Marathon application definition, which we will call `myapp.json`, the `portDefinitions: labels` parameter creates a name-based VIP that is discoverable within the cluster at `{{schema-registry.name}}.marathon.l4lb.thisdcos.directory:8082`. 

```json
{
	"id": "/{{schema-registry.name}}",
	"cpus": 1,
	"mem": 128,
	"container": {
		"docker": {
			"image": "confluent/schema-registry",
			"forcePullImage": false,
			"privileged": false,
			"network": "HOST"
		}
	},
	"portDefinitions": [{
		"protocol": "tcp",
		"port": 8082,
		"labels": {
			"VIP_0": "{{schema-registry.name}}:8082"
		}
	}]
}
```

2. From the DC/OS CLI, deploy your application definition:

```bash
dcos marathon app add myapp.json
```

# Using Name-Based VIPs with Kafka

When installing on DC/OS 1.8 or later, a name-based VIP will be automatically created for each DC/OS Kafka Service cluster. The naming convention is: `broker.{{service.name}}.l4lb.thisdcos.directory:9092`.

Run `dcos kafka connection` from the DC/OS CLI to see the name-based VIP. The following is a sample response:

{
	"vip": [
		"broker.kafka.l4lb.thisdcos.directory:9092"
	],
	"address": [
		"10.0.0.211:9843",
		"10.0.0.217:10056",
		"10.0.0.214:9689"
	],
	"dns": [
		"broker-0.kafka.mesos:9843",
		"broker-1.kafka.mesos:10056",
		"broker-2.kafka.mesos:9689"
	],
	"zookeeper": "master.mesos:2181/kafka"
}
