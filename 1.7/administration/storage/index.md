---
post_title: Storage
menu_order: 10
---

You can use local storage to create stateful services in DC/OS using either mount disk resources or persistent volumes. DC/OS applications lose their state when they terminate and are relaunched. In some contexts, for instance, if your application uses MySQL, or if you are using a stateful service like Kafka or Cassandra, you'll want your application to preserve its state. You can create a stateful application by either using mount disk resources or by specifying a persistent volume. These storage methods enable tasks to be restarted without data loss.
