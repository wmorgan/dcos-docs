---
UID: 5705936c00b4a
post_title: Listing Tasks
post_excerpt: ""
layout: page
published: true
menu_order: 0
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
The [DCOS CLI][1] allows you to easily view completed tasks.

# Completed Tasks

In this example, all completed HDFS tasks are shown:

    $ dcos task --completed hdfs
     NAME  USER  STATE                      ID
     hdfs  root    F    hdfs.6b18a882-00a5-11e5-9926-56847afe9799
     hdfs  root    K    hdfs.6eacf2d3-00a5-11e5-9926-56847afe9799
     hdfs  root    F    hdfs.71165c45-00a6-11e5-9926-56847afe9799
     hdfs  root    F    hdfs.74125e36-00a6-11e5-9926-56847afe9799
     hdfs  root    F    hdfs.770e6027-00a6-11e5-9926-56847afe9799
     hdfs  root    F    hdfs.7b3bdd38-00a6-11e5-9926-56847afe9799
     hdfs  root    F    hdfs.7f698159-00a6-11e5-9926-56847afe9799
     hdfs  root    F    hdfs.809b71aa-00a6-11e5-9926-56847afe9799
     hdfs  root    F    hdfs.82fe19cb-00a6-11e5-9926-56847afe9799
     hdfs  root    F    hdfs.86928b2c-00a6-11e5-9926-56847afe9799
     hdfs  root    F    hdfs.8ac02f4d-00a6-11e5-9926-56847afe9799
     hdfs  root    F    hdfs.8e54528e-00a6-11e5-9926-56847afe9799

 [1]: /usage/cli/