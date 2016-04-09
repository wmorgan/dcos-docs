---
post_title: Running Ruby on Rails on DC/OS
post_excerpt: ""
layout: page
published: true
menu_order: 1
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---

[Ruby on Rails](http://rubyonrails.org/) is a popular web application framework written in Ruby.

**Time Estimate**:

This tutorial will take about 30 minutes to complete.

**Target Audience**:

- Ruby on Rails developers
- Devops engineers

**Scope**:

This tutorial explains how to run a typical Rails application on DC/OS, using the project management software [Redmine](http://www.redmine.org/) as an example.

# Table of Contents

TODO

# Prerequisites

- [Install](../install/README.md) to get a cluster up and running.
- [Check Cluster Size](../getting-started/cluster-size/README.md). You'll need at least one public and one private node.

## Installing the Database

Redmine stores data in a SQL database.
We'll use MySQL for this tutorial. Please see [MySQL](../mysql/README.md) for detailed installation instructions.
We assume that MySQL is available at the VIP `3.3.0.6:3306`.

## Create a Database and User

Before we can run Redmine, we need to create a database and a user for it.
To connect to MySQL, SSH into a cluster node (e.g. the master).

```
$ ssh <USER>@<MASTER_IP>
```

Then run a container with the MySQL client.
Enter the root password from the [MySQL tutorial](../mysql/README.md) when prompted.

```
$ docker run -it mysql:5.6 mysql -u root -h 3.3.0.6 -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 5.6.29 MySQL Community Server (GPL)

Copyright (c) 2000, 2016, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

From the MySQL CLI, run the following command to create the user 'redmine' with password 'DC/OS_Rocks'.

```
mysql> CREATE USER 'redmine'@'%' IDENTIFIED BY 'DC/OS_Rocks';
Query OK, 0 rows affected (0.00 sec)
```

Then create the database.

```
mysql> CREATE DATABASE IF NOT EXISTS `redmine_production` DEFAULT CHARACTER SET `utf8` COLLATE `utf8_unicode_ci`;
Query OK, 1 row affected (0.00 sec)
```

Finally, give the user access to it.

```
mysql> GRANT SELECT, LOCK TABLES, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER ON `redmine_production`.* TO 'redmine'@'%';
Query OK, 0 rows affected (0.00 sec)
```

## Install an Edge Load Balancer

To route traffic to Redmine we need a load balancer. The `marathon-lb` package provides a load balancer that automatically updates itself when services are installed or updated on Marathon. Install it via the command line:

```
$ dcos package install marathon-lb
```

# Run Redmine

To run Redmine, use the Marathon CLI to add the app defined in the [redmine.json](redmine.json) file.

```
$ dcos marathon app add redmine.json
```

The file sets the label `HAPROXY_0_PORT: 10008` to configure HAProxy to make Redmine available at port `10008` of the public node.

Also take a look at the environment variables defined under the `env` key. They configure how to access the database.

Navigate to `<PUBLIC_IP>:10008` with your browser to view the Redmine UI.
Click the *Sign in* link in the top right corner, and use the default user `admin` and default password `admin`.

And you're done! Redmine is now ready to use.

Should Redmine ever crash it will get restarted automatically by Marathon. If the server that it's running on crashes, Marathon will restart Redmine on a different one. It also periodically performs an HTTP health check (defined under the `healthChecks` key in the JSON file) to make sure that the application is responding.

# Cleanup

To uninstall all the pieces of this tutorial, run the following commands:

```
$ dcos package uninstall marathon-lb
$ dcos marathon app remove /redmine
```

Also follow the uninstall instructions of the [MySQL tutorial](../mysql/README.md).

# Appendix: Next Steps

## Production Checklist

Best practices for running Redmine in production:

1. Change the default database passwords.
1. Change the default password of the Redmine admin user.
1. Change the default value of `REDMINE_SECRET_TOKEN`.

## Next Steps

- Learn how to [debug](../debugging/README.md) services.
