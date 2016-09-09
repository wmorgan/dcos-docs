---
post_title: Generating Custom AWS CF Templates
nav_title: Custom CF Template
menu_order: 102
---

You can create a customized DC/OS CloudFormation template by using the DC/OS setup file.

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

1.  Create a configuration file and save as `config.yaml`.
    
    These parameters are required:
    ```bash
    aws_template_storage_bucket: cody-test-advanced
    aws_template_storage_bucket_path: some/path
    aws_template_storage_region_name: us-west-2
    aws_template_upload: <true_or_false>
    # If aws_template_upload is true you must provide 
    # aws_template_storage_access_key_id and aws_template_storage_secret_access_key.
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
    
1.  `dcos_generate_config.sh --aws-cloudformation`

    You should see a message like this:
    
    ```bash
    Generated templates locally available at genconf/cloudformation/config_id/736890b6e6391d263ba66a1672f1532318e164c2
    ```
    
1.  Go to `/genconf/cloudformation/<path-to-directory>` to view your customized advanced templates. 

    Your directory should look similar to this:

    ```bash
    ── aws.html
    ├── bootstrap
    │   ├── ce97e96cd66eed4b1f329df1ce7dc229b9c06090.active.json
    │   └── ce97e96cd66eed4b1f329df1ce7dc229b9c06090.bootstrap.tar.xz
    ├── bootstrap.latest
    ├── cloudformation
    │   ├── coreos-advanced-master-1.json
    │   ├── coreos-advanced-master-3.json
    │   ├── coreos-advanced-master-5.json
    │   ├── coreos-advanced-master-7.json
    │   ├── coreos-advanced-priv-agent.json
    │   ├── coreos-advanced-pub-agent.json
    │   ├── coreos-zen-1.json
    │   ├── coreos-zen-3.json
    │   ├── coreos-zen-5.json
    │   ├── coreos-zen-7.json
    │   ├── el7-advanced-master-1.json
    │   ├── el7-advanced-master-3.json
    │   ├── el7-advanced-master-5.json
    │   ├── el7-advanced-master-7.json
    │   ├── el7-advanced-priv-agent.json
    │   ├── el7-advanced-pub-agent.json
    │   ├── el7-zen-1.json
    │   ├── el7-zen-3.json
    │   ├── el7-zen-5.json
    │   ├── el7-zen-7.json
    │   ├── infra.json
    │   ├── multi-master.cloudformation.json
    │   └── single-master.cloudformation.json
    ├── complete.latest.json
    ├── config_id
    │   └── 736890b6e6391d263ba66a1672f1532318e164c2
    │       ├── aws.html
    │       ├── bootstrap.latest
    │       ├── cloudformation
    │       │   ├── coreos-advanced-master-1.json
    │       │   ├── coreos-advanced-master-3.json
    │       │   ├── coreos-advanced-master-5.json
    │       │   ├── coreos-advanced-master-7.json
    │       │   ├── coreos-advanced-priv-agent.json
    │       │   ├── coreos-advanced-pub-agent.json
    │       │   ├── coreos-zen-1.json
    │       │   ├── coreos-zen-3.json
    │       │   ├── coreos-zen-5.json
    │       │   ├── coreos-zen-7.json
    │       │   ├── el7-advanced-master-1.json
    │       │   ├── el7-advanced-master-3.json
    │       │   ├── el7-advanced-master-5.json
    │       │   ├── el7-advanced-master-7.json
    │       │   ├── el7-advanced-priv-agent.json
    │       │   ├── el7-advanced-pub-agent.json
    │       │   ├── el7-zen-1.json
    │       │   ├── el7-zen-3.json
    │       │   ├── el7-zen-5.json
    │       │   ├── el7-zen-7.json
    │       │   ├── infra.json
    │       │   ├── multi-master.cloudformation.json
    │       │   └── single-master.cloudformation.json
    │       ├── complete.latest.json
    │       └── metadata.json
    ├── metadata.json
    └── packages
        ├── dcos-config
        │   ├── dcos-config--setup_171007caecd10aaa9568bd6b8b9625f6fe1a8f71.tar.xz
        │   ├── dcos-config--setup_2f831a8ae7a04c3cd4d0d7592f1928535630d5ec.tar.xz
        │   ├── dcos-config--setup_4e717dc2ec031e60eabafee110206271ed53f9c0.tar.xz
        │   ├── dcos-config--setup_636da46e152881a724a1da3caef1c98561be447b.tar.xz
        │   ├── dcos-config--setup_6d86bd822914131516c76e81fafac325214cc7d9.tar.xz
        │   ├── dcos-config--setup_74023e9e9251031fd61b1dee56099c652fa3b903.tar.xz
        │   ├── dcos-config--setup_85a89bebab71735ec5920f84d7ff269b3496b7df.tar.xz
        │   ├── dcos-config--setup_8c6a31f5803c259c2eeb2d42be44e868cddf0e1d.tar.xz
        │   ├── dcos-config--setup_8fe8659a0801c133ccc8884e869246d24c35a949.tar.xz
        │   ├── dcos-config--setup_91cc3334c467e9c1d1182110a9aa17eca65d78ea.tar.xz
        │   ├── dcos-config--setup_9dda93bf7bbd79f78ad3af76157e226625952d3b.tar.xz
        │   ├── dcos-config--setup_b8d301f73b45090575a3aa62b153836a4bbd3cf2.tar.xz
        │   ├── dcos-config--setup_d3ef79cc585e0e6e2dd44de4ba1adabbcd467fec.tar.xz
        │   └── dcos-config--setup_ff2f6dcce56bc8f7bb0e54569b5b3379f46f906b.tar.xz
        └── dcos-metadata
            ├── dcos-metadata--setup_171007caecd10aaa9568bd6b8b9625f6fe1a8f71.tar.xz
    ```
    
1.  