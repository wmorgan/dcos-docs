---
post_title: Advanced AWS Templates
menu_order: 1
---

The advanced templates for AWS CloudFormation bring power and flexibility to creating and extending DC/OS clusters. With these advanced templates, you can:
 
 - Instantiate a complete DC/OS cluster on an existing VPC/Subnet combination
 - Extend and update an existing DC/OS clusters by adding more agents 
 
The advanced templates are used together in conjunction to create a DC/OS cluster. 
 
* **zen.json** This template file orchestrates the component stacks to form an entire DC/OS cluster. Since this is a meta template, it requires the least number of parameters to get a cluster up and running. 
* **infra.json** This template file defines and creates a DC/OS specific infrastructure that works well with a VPC already created. This is the lowest building block of a DC/OS cluster and the components created in this stack are consumed by the dependent templates (`advanced-master.json`, `advanced-pub-agent.json`, and `advanced-priv-agent.json`).
* **advanced-master.json** This template file configures the master nodes.
* **advanced-priv-agent.json** This template configures the private agent nodes.
* **advanced-pub-agent.json** This template configures the public agent nodes.


<!-- Insert graphic -->


# System requirements

### Hardware

An Amazon EC2 <a href="https://aws.amazon.com/ec2/pricing/" target="_blank">m3.xlarge</a> instance. Selecting smaller-sized VMs is not recommended, and selecting fewer VMs will likely cause certain resource-intensive services, such as distributed datastores, to not work properly.

### Software

- An Amazon Web Services account with root [IAM](https://aws.amazon.com/iam/) privileges. Advanced privileges are required to install the advanced templates. Contact your AWS admin for more information.
- AWS [Command Line Interface](https://aws.amazon.com/cli/)
- [jquery](https://github.com/stedolan/jq/wiki/Installation)

# Quick Start
You can quickly get up and running with the DC/OS advanced templates by running this script. The script automatically creates the top level `zen.json` template.
 
Before running this script, configure these parameters for your environment: `STACK_NAME`, `VPC_CIDR`, ` PRIVATE_SUBNET_CIDR`, and `PUBLIC_SUBNET_CIDR`.


## Create the zen.json template

    ```bash
    #!/bin/bash
    set -o errexit -o nounset -o pipefail
    
    if [ -z "${1:-}" ]
    then
      echo Usage: $(basename "$0") STACK_NAME
      exit 1
    fi
    
    STACK_NAME="$1"
    VPC_CIDR=10.0.0.0/16
    PRIVATE_SUBNET_CIDR=10.0.0.0/17
    PUBLIC_SUBNET_CIDR=10.0.128.0/20
    
    echo "Creating Zen Template Dependencies"
    
    vpc=$(aws ec2 create-vpc --cidr-block "$VPC_CIDR" --instance-tenancy default | jq -r .Vpc.VpcId)
    aws ec2 wait vpc-available --vpc-ids "$vpc"
    aws ec2 create-tags --resources "$vpc" --tags Key=Name,Value="$STACK_NAME"
    echo "VpcId: $vpc"
    
    ig=$(aws ec2 create-internet-gateway | jq -r .InternetGateway.InternetGatewayId)
    aws ec2 attach-internet-gateway --internet-gateway-id "$ig" --vpc-id "$vpc"
    aws ec2 create-tags --resources "$ig" --tags Key=Name,Value="$STACK_NAME"
    echo "InternetGatewayId: $ig"
    
    private_subnet=$(aws ec2 create-subnet --vpc-id "$vpc" --cidr-block "$PRIVATE_SUBNET_CIDR" | jq -r .Subnet.SubnetId)
    aws ec2 wait subnet-available --subnet-ids "$private_subnet"
    aws ec2 create-tags --resources "$private_subnet" --tags Key=Name,Value="${STACK_NAME}-private"
    echo "Private SubnetId: $private_subnet"
    
    public_subnet=$(aws ec2 create-subnet --vpc-id "$vpc" --cidr-block "$PUBLIC_SUBNET_CIDR" | jq -r .Subnet.SubnetId)
    aws ec2 wait subnet-available --subnet-ids "$public_subnet"
    aws ec2 create-tags --resources "$public_subnet" --tags Key=Name,Value="${STACK_NAME}-public"
    echo "Public SubnetId: $public_subnet"
    ```

Now that you have your `zen.json` template