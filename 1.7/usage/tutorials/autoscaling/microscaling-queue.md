---
post_title: Microscaling based on queue length
nav_title: Microscaling
---

While autoscaling adjusts the size of your compute cluster when you need more (or fewer) resources, [microscaling](http://microscaling.org) 
adjusts the balance of tasks running within your existing compute cluster. This allows your infrastructure to react within 
seconds to a change in demand, which is much faster than waiting several minutes for a new virtual machine. 

This tutorial walks through setting up a microscaling demonstration from [Microscaling Systems](http://microscaling.com). 

**Time Estimate**:

If you already have a DC/OS cluster available, a Microsoft Azure account, and Ruby installed on your local machine, you'll have the microscaling demo running in around 10-15 minutes. 

**Scope**:

In this demo, microscaling adjusts the balance between two tasks - one high priority and one background - based on the number of items in 
an Azure Storage Queue. 

![microscaling-queue.png](../img/microscaling-queue.png)

The demo creates four Marathon Apps that run as Docker containers.

* **Producer** instances add items to the queue. The more producers there are, the faster the queue will fill up. We start 3 producers on startup and you can scale these manually using the Marathon UI.
* **Consumer** instances remove items from the queue and are scaled by the Microscaling Engine.
* **Remainder** is a background task. Any spare capacity is used for this background task. You can change the Docker image to use your own using the Marathon UI.
* **Microscaling** is the engine that monitors the queue length, and scales the Consumer and Remainder tasks. It also sends data to our Microscaling-in-a-Box site so you can see what's happening.

# Prerequisites

* A [Microsoft Azure](http://azure.microsoft.com) account. Your DC/OS cluster can be running anywhere (it doesn't have to be running on Azure) 
but the demo uses an Azure Storage Queue. If you don't already have an account you can get a [free trial](https://azure.microsoft.com/en-us/pricing/free-trial/?WT.mc_id=AA4C1C935). 
* A [running DC/OS cluster](/docs/1.7/administration/installing/). If you don't already have one, you can follow these [instructions for setting up a DC/OS cluster on Azure](https://azure.microsoft.com/en-us/documentation/articles/container-service-deployment/). 
* You'll need the Marathon REST API address. If you set up an [SSH tunnel on port 80 to your Marathon master node](https://github.com/Azure/azure-quickstart-templates/blob/master/101-acs-dcos/docs/SSHKeyManagement.md#create-port-80-tunnel-to-the-master) you can access the Marathon REST API at http://localhost/marathon.
* You'll need [Ruby](https://www.ruby-lang.org/en/documentation/installation/) on your local machine to run the demo scripts 

# Set up an Azure Storage Account

* Sign in to the [Azure Portal](http://portal.azure.com).
* Navigate to New -> Data + Storage -> Storage Account
* Create a storage account with the following settings:

![microscaling-azure-storage.png](../img/microscaling-azure-storage.png)

* **Name** - this must be globally unique across all Azure Storage Accounts. Make a note of this - you will use this as the environment variable AZURE_STORAGE_ACCOUNT_NAME later. 
* **Replication** - choose Locally-redundant storage for the queue.
* **Resource Group** - create a new resource group for the queue. 

Once the storage account has been created navigate to Settings -> Access Keys and make a note of your access key. You'll set this as the environment variable AZURE_STORAGE_ACCOUNT_KEY later. 

# Set up Microscaling-in-a-box

* Go to the [Microscaling-in-a-box](http://app.microscaling.com) site and sign up for an account if you don't have one already.
* In Step 1, pick the Mesos / Marathon option

![microscaling-step-1.png](../img/microscaling-step-1.png)

* Skip through steps 2 & 3 to use the default values. 
* Navigate to the step 4 (Run) page and find your user ID and the default value for the queue we'll be using in the demo. You will use these as the values for environment variables MSS_USER_ID and AZURE_STORAGE_QUEUE_NAME later.

![microscaling-step-4.png](../img/microscaling-step-4.png)

# Get the microscaling scripts

We have prepared some scripts to configure and start the four apps in Marathon. Go to a terminal on your local machine and get these scripts with the following command.

```
git clone http://github.com/microscaling/queue-demo
```

Move into the queue-demo directory.

```
cd queue-demo
```

# Run the microscaling install script

Set up the following environment variables 

```
export AZURE_STORAGE_ACCOUNT_NAME=<storage account name>
export AZURE_STORAGE_ACCOUNT_KEY=<storage account key>
export AZURE_STORAGE_QUEUE_NAME=<queue name>
export MSS_USER_ID=<user ID>
export MSS_MARATHON_API=http://localhost/marathon
```
You're now ready to run the demo: 
```
./marathon-install
```

This script starts all four tasks. You can view these in the Marathon web UI.  

![microscaling-marathon-apps.png](../img/microscaling-marathon-apps.png)

Once Marathon has launched the apps the results will start to appear in the Microscaling-in-a-Box UI. You'll see the Microscaling Engine scaling the consumer and remainder containers to maintain the target queue length.

![microscaling-chart-ui.png](../img/microscaling-chart-ui.png)

You can use the Marathon UI to scale the number of Producer tasks up or down, and see how Microscaling reacts to keep the queue length under control. 

# Cleanup

## Uninstall the Marathon Apps

You can use the marathon-uninstall command to remove the demo apps from your cluster.
```
./marathon-uninstall
```

## Delete the Azure Resources

Once you've finished with the demo you'll want to delete the Azure resources so that you don't get charged. 

* Sign in to the [Azure Portal](http://portal.azure.com).
* Select Resource Groups from the left hand menu.
* Find and delete the Resource Group you created for the Azure Queue.
* If you created an ACS cluster for this demo, you'll want to delete the Resource Group for that too. 

# Appendix: Next Steps

- Try modifying some of the configuration settings in Step 3 of Microscaling-in-a-Box before you run the demo. You'll need to stop the tasks (manually or by running `./marathon-uninstall`) and restart them again with `./marathon-install` to pick up configuration changes. 
- See the settings for each of the Marathon apps in JSON files contained within the `marathon-apps` directory.
- Here's the [microscaling engine code](http://github.com/microscaling/microscaling). 
- Find more information about microscaling on the [Microscaling Systems website](http://microscaling.com).
