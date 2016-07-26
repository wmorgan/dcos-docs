---
post_title: Getting Started
nav_title: Getting Started
menu_order: 10
---

You can create and administer jobs in the DC/OS web interface, the DC/OS CLI, or via the API. You can add permissions to your job via an access control list (ACL). [Learn more](/1.8/administration/id-and-access-mgt/permissions/service-acls).

# DC/OS Web Interface

## Add a Job

From the DC/OS web interface, click the **Jobs** tab, then the **New Job** button. Fill in the following fields, or toggle to JSON mode to edit the JSON directly:

* **CPU**
* **Memory**
* **Disk space**
* **Command** - The command your job will execute. Leave this blank if you will use a Docker image.
* **Schedule** - Specify the schedule in chron format, as well as the time zone and starting deadline.
* **Docker Container** - Fill in this field if you will use a Docker image to specify the action of your job.
* **Labels**

## Modify, View, or Remove a Job

From the "Jobs" tab, click the name of your job to modify or delete your job. While the job is running you can click the job instance to drill down to "Details," "Files," and "Logs" data. 

# DC/OS CLI

You can create and manage jobs from the DC/OS CLI using `dcos job` commands. To see a full list of available commands, run `dcos job`.

## Add a Job

1. Create a job file in JSON format:

    ```json
    {
      "id": "myjob",
      "description": "A job that sleeps regularly",
      "run": {
        "cmd": "sleep 20000",
        "cpus": 0.01,
        "mem": 32,
        "disk": 0
      },
      "schedules": [
        {
          "id": "sleep-schedule",
          "enabled": true,
          "cron": "20 0 * * *",
          "concurrencyPolicy": "ALLOW"
        }
      ]
    }
    ```
    
    **Note:** You can only assign one schedule to a job.
  
  1. Add the job:
    ```
    dcos job add <job-id>.json
    ```
    
  1. Go to the "Jobs" tab of the DC/OS web interface to verify that you have added your job, or verify from the CLI:
     ```
     dcos job list
     ```

## Remove a Job

1. Enter the following command on the DC/OS CLI:
   ```
   dcos job remove <job-id>.json
   ```

1. Go to the "Jobs" tab of the DC/OS web interface to verify that you have removed your job, or verify from the CLI:
   ```
   dcos job list
   ```
## Modify or View a Job

To modify your job, by update your JSON job file, then run

```
dcos job update <job-file.json>
```

To modify the schedule of your job, modify the `schedules` parameter of your jobs file. <!--is this right? or do you have a separate file? --> Then, run one of the following commands:

```
dcos job schedule add <job-id> <schedule-file>
dcos job schedule remove <job-id> <schedule-id>
dcos job schedule update <job-id> <schedule-id> <schedule-file>
```
        
To view details about your job, run:

```
dcos job show <job-id>
```

To view details about your job's schedule, run:

```
dcos job schedule show <job-id>
```

# Metronome API

You can also create and administer jobs via the API. [View the full API here](http://dcos.github.io/metronome/docs/generated/api.html).

## Add a Job

## Remove a Job

## Modify or View a Job


```
curl -H "Authorization: token=$(dcos config show core.dcos_acs_token)" 'http://ken-lbp4x-elasticl-krb05uru8k26-1417807583.us-west-2.elb.amazonaws.com/service/metronome/v1/jobs?embed=activeRuns&embed=schedules' | python -m json.tool
```
