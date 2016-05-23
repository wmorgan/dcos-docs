---
post_title: Autoscaling with Marathon
nav_title: Autoscaling
---

You can use autoscaling to automatically increase or decrease computing resources based on usage so that you're using only the resources you need. We've created some examples to show you how to implement autoscaling for your services.

- [Autoscaling via. CPU/Memory](cpu-memory/)
- [Autoscaling via. requests/second](requests-second/)

Adding a new virtual machine typically takes several minutes, but you can use [microscaling](http://microscaling.org) to adjust running tasks 
within the existing cluster in response to real-time demand metrics. This can work alongside autoscaling, to scale up high-priority tasks as soon as they're needed
while new virtual machines are created. 

- [Microscaling based on queue length](microscaling-queue/)