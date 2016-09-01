---
post_title: Installing Using a Custom AMI
nav_title: Custom AMI
menu_order: 199
---

You can use customized [Amazon Machine Images (AMI)](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) based on CentOS 7 or CoreOS to launch DC/OS with the advanced templates. 

- A custom AMI can be used to integrate DC/OS installation with your own in-house configuration management tools.
- A custom AMI can be used if you want kernel or driver customization.

To get started, build a custom AMI and then install DC/OS by using the advanced templates. 

# Build a custom AMI
Here is the recommend method to build your AMI:

1.  Using the DC/OS [cloud_images](https://github.com/dcos/dcos/tree/master/cloud_images) scripts for CentOS 7 as a template, create an AWS AMI in the same target region as your DC/OS stack. 

    **Important:** The AMI must satisfy all of the DC/OS AMI prerequisites as shown in the template.

1.  Build and deploy your AMI. For an example of how to build and deploy AMIs to multiple regions, see the DC/OS Packer build scripts [here](https://github.com/dcos/dcos/blob/master/cloud_images/centos7/packer.json).

# Install DC/OS

Launch the DC/OS advanced template on CloudFormation and specify your custom AMI. For more information, see the QuickStart [documentation](/docs/1.8/administration/installing/cloud/aws/advanced/quickstart/#launch).