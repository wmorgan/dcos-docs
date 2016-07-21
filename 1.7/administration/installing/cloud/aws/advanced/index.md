---
layout: page
post_title: Advanced DC/OS Installation on AWS
nav_title: AWS Advanced
menu_order: 200
---



The AWS CloudFormation templates bring power and flexibility to creating and extending Enterprise DC/OS clusters. With these templates, you can:
 
 - Instantiate a complete DC/OS cluster on an existing VPC/Subnet combination.
 - Extend and update existing DC/OS clusters by adding more [agent](/docs/1.7/overview/concepts/#agent) nodes (formerly slave node). 
 
The templates are used together in conjunction to create a DC/OS cluster. The templates are driven by parameters that AWS CloudFormation uses to create each stack.  

<!-- Insert graphic -->

### Zen templates
The [Zen](/docs/1.7/administration/installing/cloud/aws/template-reference/#zen) templates orchestrate the individual component templates to create a DC/OS cluster.

### Agent templates
The [agent](/docs/1.7/administration/installing/cloud/aws/template-reference/#private-agent) templates create [public](/docs/1.7/overview/concepts/#public) or [private](/docs/1.7/overview/concepts/#private) agent nodes that are then attached to a DC/OS cluster as a part of an AutoScalingGroup. 

### Master templates
The [master](/docs/1.7/administration/installing/cloud/aws/template-reference/#master) templates create master nodes, on top of the infrastructure stack already created.

### Infrastructure template
The [infrastructure](/docs/1.7/administration/installing/cloud/aws/template-reference/#infrastructure) template defines and creates a DC/OS specific infrastructure that works well with an existing VPC. 
