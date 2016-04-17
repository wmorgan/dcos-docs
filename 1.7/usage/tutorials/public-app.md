---
post_title: Deploying an App on Public Nodes
nav_title: App on Public Node
menu_order: 999
---

The native Marathon instance is configured to receive offers from the public agent nodes (`--mesos_role="slave_public"`). Marathon apps are configured to use unreserved resources and launch on private agent nodes (`--default_accepted_resource_roles="*"`).

To run a Marathon app on public agent nodes, you must set the `acceptedResourceRoles` property to:

    "acceptedResourceRoles":["slave_public"]

To run a Marathon app on any agent node type, you must set the `acceptedResourceRoles` property to:

    "acceptedResourceRoles":["slave_public", "*"]
