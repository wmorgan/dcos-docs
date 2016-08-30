---
post_title: Installing DC/OS Using AWS AMI
nav_title: AWS AMI
menu_order: 199
---
You can use a customized [Amazon Machine Images (AMI)](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) to launch DC/OS instances. 

- A custom AMI can be used to integrate DC/OS installation with your own in-house configuration management tools.
- A custom AMI can be used if you want kernel or driver customization.

For an example of the DC/OS CentOS 7 AMI, see <a href="https://github.com/dcos/dcos/tree/master/cloud_images">https://github.com/dcos/dcos/tree/master/cloud_images</a>.


**Prerequisites:**

- DC/OS [system requirements](/docs/1.8/administration/installing/cloud/aws/advanced/quickstart/) for AWS.
- An AWS AMI in the same target region as your DC/OS stack. For more information about AMI regions, see the [AWS documentation](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/CopyingAMIs.html). 
- An Amazon EC2 Key Pair for the same region as your cluster. Key pairs cannot be shared across regions. The AWS key pair uses public-key cryptography to provide secure login to your AWS cluster. For more information about creating an Amazon EC2 Key Pair, see the <a href="http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair" target="_blank">documentation</a>.
 
1.  Open the [CloudFormation](https://console.aws.amazon.com/cloudformation/) console.
1.  Click **Create Stack**.
1.  Specify the S3 template URL for the DC/OS advanced template ([zen](/docs/1.8/administration/installing/cloud/aws/advanced/template-reference/#zen), [master](/docs/1.8/administration/installing/cloud/aws/advanced/template-reference/#master), [agent](/docs/1.8/administration/installing/cloud/aws/advanced/template-reference/#private-agent)) and click **Next**.
1.  On the **Specify Details** page, specify a cluster name (`Stack name`), AMI ID (`CustomAMI`), Key Pair (`KeyName`), authentication (`OAuthEnabled`), public agent (`PublicSlaveInstanceCount`), private agent (`SlaveInstanceCount`), and click **Next**.

Specify AMI in the advanced template (zen, master, agent).