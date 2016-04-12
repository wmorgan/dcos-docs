---
post_title: Install DC/OS on AWS
layout: docs.jade
published: true
---

# Overview

This document explains how to install DC/OS via AWS.

# System requirements

## Hardware

In order to [use](/usage/) all of the services offered in DC/OS you should choose 

Selecting smaller-sized VMs is not recommended, and selecting fewer VMs will likely cause certain resource-intensive services such as distributed datastores not to work properly (from installation issues to operational limitations).

## Software

You will need an AWS account.

Also, in order to access nodes in the DC/OS cluster you will need `ssh` installed and configured.

# Install DC/OS

## Step 1: Creating a SSH key pair

The AWS key pair uses public-key cryptography to provide secure login to your AWS cluster. In order to create the key pair, go to [console.aws.amazon.com/ec2](https://console.aws.amazon.com/ec2/):

First, select your region; this should be the same region where you will create your cluster:

![Select region](aws/img/dcos-aws-step1a.png)

In the navigation pane, under `Network & Security`, click `Key Pairs` and then click the `Create Key Pair` button:

![Create key pair](aws/img/dcos-aws-step1b.png)

Save the `.pem` file locally for use later. Note that this is the only chance to save file!


## Step 2: Launching DC/OS cluster

First, select a launch region (the one you created the key pair in) and the preferred cluster configuration:

![Configure template](aws/img/dcos-aws-step2a.png)

Launch stack (just click `Next`, nothing to change on this screen):

![Launch stack](aws/img/dcos-aws-step2b.png)

On the `Create stack` page, enter a name for your cluster, accept the EULA, select number of private Agents and click `Next`:

![Create stack](aws/img/dcos-aws-step2c.png)

On the `Options` page, accept the defaults and click Next. On the Review page, check the acknowledgement box and click `Create`:

![Confirm stack](aws/img/dcos-aws-step2d.png)

The stack spins up over a period of 10 to 15 minutes. The status changes from `CREATE_IN_PROGRESS` to `CREATE_COMPLETE`:

![Monitor stack creation](aws/img/dcos-aws-step2e.png)

## Step 3: Accessing DC/OS

From the CloudFormation Management page, click on the `Outputs` tab and copy/paste the Mesos Master hostname into your browser:

![Monitor stack creation](aws/img/dcos-aws-step3a.png)


# Next steps

- [Scaling considerations](https://aws.amazon.com/autoscaling/)
