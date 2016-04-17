---
post_title: Managing AWS Clusters
menu_order: 9
---

## Finding your public node hostname

The DC/OS AWS CloudFormation template creates 1 Mesos agent node in the [public zone][1].

To find your your public node IP:

1.  Select your stack from the [Amazon CloudFormation Management](https://console.aws.amazon.com/cloudformation/home) page.

2.  Click on the **Outputs** tab.

    <a href="../img/awsec2privatedns.png" rel="attachment wp-att-1496"><img src="../img/awsec2privatedns-800x197.png" alt="awsec2privatedns" width="800" height="197" class="alignnone size-large wp-image-1496" /></a>

    **Tip:** You might have to refresh your browser to see your deployed app.

## Scaling an AWS cluster

The DC/OS AWS CloudFormation template is optimized to run DC/OS, but you might want to change the number of agent nodes based on your needs.

**Important:** Scaling down your AWS cluster could result in data loss. It is recommended that you scale down by 1 node at a time, letting the DC/OS service recover. For example, if you are running a DC/OS service and you scale down from 10 to 5 nodes, this could result in losing all the instances of your service.

To change the number of agent nodes with AWS:

1.  From <a href="https://console.aws.amazon.com/cloudformation/home" target="blank">AWS CloudFormation Management</a> page, select your DC/OS cluster and click **Update Stack**.
2.  Click through to the **Specify Parameters** page, and you can specify new values for the **PublicSlaveInstanceCount** and **SlaveInstanceCount**.
3.  On the **Options** page, accept the defaults and click **Next**. **Tip:** You can choose whether to rollback on failure. By default this option is set to **Yes**.
4.  On the **Review** page, check the acknowledgement box and then click **Create**.

Your new machines will take a few minutes to initialize; you can watch them in the EC2 console. The DC/OS web interface will update as soon as the new nodes register.

## Upgrading a DC/OS cluster in AWS

You can update an existing DC/OS cluster or services to use the latest DC/OS template.

To upgrade a DC/OS cluster:

1.  Create a new DC/OS cluster by using the latest [DC/OS template][2] for AWS.

2.  Migrate your active DC/OS services and apps to the new DC/OS cluster:

    1.  Migrate, Extract, Transform and Load (ETL) the app data to the new cluster.

    2.  Migrate your DC/OS services and apps to the new cluster.

    3.  Change the DNS so that it points to the DC/OS services running in the new cluster.

3.  Shutdown your existing DC/OS cluster.

 [1]: /overview/security/#scrollNav-3FIXME
 [2]: /docs/latest/administration/installing/cloud/aws/

