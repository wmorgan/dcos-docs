---
UID: 56f98449c9e25
post_title: Package Repository
post_excerpt: ""
layout: page
published: true
menu_order: 3
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
[DCOS services][1] are generally installed in one of two ways, either through Marathon directly or from a DCOS package repository. By default, the [DCOS Command-Line Interface][2] is configured to use the primary public package repository: [Mesosphere Universe][1].

## Install a Packaged Service

DCOS services can be installed on your cluster with a single command from the DCOS CLI:

    $ dcos package install <service-name>


## Search for Packages

If you're looking for big data packages, use:

    $ dcos package search "big data"
    NAME VERSION FRAMEWORK SOURCE DESCRIPTION
    spark 1.4.0-SNAPSHOT True https://github.com/mesosphere/universe/archive/version-1.x.zip Spark is a fast and general cluster computing system for Big Data


## List Repositories

By default, the DCOS CLI is configured to use the Mesosphere Universe, but other package repositories may also be configured.

See which package repositories are currently configured:

    $ dcos package repo list
    Universe: https://universe.mesosphere.com/repo


## Add a Repository

Add a repo with the name `your-repo` and the repo archive URL `https://yourcompany/archive/stuff.zip`:

    $ dcos package repo add your-repo https://yourcompany/archive/stuff.zip


## Remove a Repository

Remove the repo with the name `your-repo`:

    $ dcos package repo remove your-repo

 [1]: /usage/services/
 [2]: /usage/cli/