---
UID: 56f98447c920b
post_title: Managing AWS Clusters
post_excerpt: ""
layout: page
published: true
menu_order: 13
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
# Finding your public node hostname

The DCOS AWS CloudFormation template creates 1 Mesos agent node in the [public zone][1].

To find your your public node IP:

1.  Select your stack from the <a href="https://console.aws.amazon.com/cloudformation/home" target="_blank">Amazon CloudFormation Management</a> page.

2.  Click on the **Outputs** tab and copy/paste the Public slaves hostname into your browser to open the Oinker web interface.
    
    <a href="/wp-content/uploads/2015/12/awsec2privatedns.png" rel="attachment wp-att-1496"><img src="/wp-content/uploads/2015/12/awsec2privatedns-800x197.png" alt="awsec2privatedns" width="800" height="197" class="alignnone size-large wp-image-1496" /></a>
    
    **Tip:** You might have to refresh your browser to see your deployed app.

# Scaling an AWS cluster

The DCOS AWS CloudFormation template is optimized to run the DCOS, but you might want to change the number of agent nodes based on your needs.

**Important:** Scaling down your AWS cluster could result in data loss. It is recommended that you scale down by 1 node at a time, letting the DCOS service recover. For example, if you are running a DCOS service and you scale down from 10 to 5 nodes, this could result in losing all Mesos name nodes or journals at once, taking your entire cluster down.

To change the number of agent nodes with AWS:

1.  From <a href="https://console.aws.amazon.com/cloudformation/home" target="blank">AWS CloudFormation Management</a> page, select your DCOS cluster and click **Update Stack**.
2.  Click through to the **Specify Parameters** page, and you can specify new values for the **PublicSlaveInstanceCount** and **SlaveInstanceCount**.
3.  On the **Options** page, accept the defaults and click **Next**. **Tip:** You can choose whether to rollback on failure. By default this option is set to **Yes**.
4.  On the **Review** page, check the acknowledgement box and then click **Create**.

Your new machines will take a few minutes to initialize; you can watch them in the EC2 console. The DCOS web interface will update as soon as the new nodes register.

# Upgrading a DCOS cluster in AWS

You can update an existing DCOS Community Edition (CE) cluster or services to use the latest DCOS template.

To upgrade a DCOS cluster:

1.  Create a new DCOS cluster by using the latest [DCOS template][2] for AWS.

2.  Migrate your active DCOS services and apps to the new DCOS cluster:
    
    1.  Migrate, Extract, Transform and Load (ETL) the app data to the new cluster.
    
    2.  Migrate your DCOS services and apps to the new cluster.
    
    3.  Change the DNS so that it points to the DCOS services running in the new cluster.

3.  Shutdown your existing DCOS cluster.

 [1]: /overview/security/#scrollNav-3
 [2]: /administration/installing/installing-community-edition/awscluster/