---
post_title: Generating Custom AWS CF Templates
nav_title: Custom CF Template
menu_order: 102
---

You can create custom advanced AWS CloudFormation templates for DC/OS and store in a private S3 bucket. With custom templates you can deploy and run DC/OS from your own private S3 bucket. 

**Prerequisites:**

- Your cluster must meet the software and hardware [requirements](/docs/1.8/administration/cloud/aws/advanced/system-requirements/) for AWS.
- The [DC/OS installer](https://dcos.io/releases/).
- Write access to an Amazon S3 bucket.
- AWS [Command Line Interface](https://aws.amazon.com/cli/).

1.  Download the [DC/OS installer](https://dcos.io/releases/) to your node.

1.  Create a directory named `genconf` on your node and navigate to it.
    
    ```bash
    $ mkdir -p genconf
    ```

1.  Create a configuration file and save as `config.yaml`. This configuration file specifies your AWS credentials and the S3 location to store the generated artifacts.
    
    These are the required parameters:
    ```bash
    aws_template_storage_bucket: cody-test-advanced
    aws_template_storage_bucket_path: <path-to-directory>
    aws_template_storage_region_name: us-west-2
    aws_template_upload: true
    aws_template_storage_access_key_id: <your_access_key_id>
    aws_template_storage_secret_access_key: <your_secret_access_key>
    ```
    
    #### aws_template_storage_bucket
    Specify the name of your S3 bucket. For example, `aws_template_storage_bucket: dcos-aws-advanced`.
    
    #### aws_template_storage_bucket_path
    Specify the S3 bucket storage path. For example, `aws_template_storage_bucket_path: templates/dcos`.
    
    #### aws_template_storage_region_name
    Specify the S3 region. For example, `aws_template_storage_region_name: us-west-2`
    
    #### aws_template_upload
    Specify whether to automatically upload the customized advanced templates to your S3 bucket. For example, `aws_template_upload: true`. If you specify `true`, you must also specify these parameters:
    
        -  #### aws_template_storage_access_key_id
           Specify the AWS [Access Key ID](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html). For example, `aws_template_storage_access_key_id: AKIAIOSFODNN7EXAMPLE`  
        
        -  #### aws_template_storage_secret_access_key
           Specify the AWS [Secret Access Key](http://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSGettingStartedGuide/AWSCredentials.html). For example, `aws_template_storage_secret_access_key: wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY`.
    
1.  Run the DC/OS installer script with the AWS argument specified. This command creates and uploads a custom build of the DC/OS artifacts and templates uploaded to the specified S3 bucket.

    ```bash
    $ dcos_generate_config.sh --aws-cloudformation
    ```

     The root URL for this bucket location is printed at the end of this step. You should see a message like this:
    
    ```bash
    Generated templates locally available at genconf/cloudformation/config_id/736890b6e6391d263ba66a1672f1532318e164c2
    ```
1.  Go to [CloudFormation](https://console.aws.amazon.com/cloudformation/home) and click **Create Stack**.
1.  On the **Select Template** page, specify the Amazon S3 template URL path to your Zen template. For example, `https://s3-us-west-2.amazonaws.com/<path-to-directory>/cloudformation/el7-zen-1.json`

    