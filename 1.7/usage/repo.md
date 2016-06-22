---
post_title: Managing Package Repositories
nav_title: Package Repository
menu_order: 002.5
---

DC/OS provides a number of services within its default Universe package repository. By default, the DC/OS CLI is configured to use the DC/OS [Universe](https://github.com/mesosphere/universe), but other package repositories can also be configured.

You can use either the web interface or the CLI to:

* [Listing](#listing)
* [Searching](#find-packages)
* [Adding](#adding)
* [Removing](#removing)

**Tip:** Before you can use the CLI, you need to [install it](/docs/1.7/usage/cli/install/).

## <a name="listing"></a>Listing repositories

To see which package repositories are currently configured from the DC/OS CLI as follows:

```bash
$ dcos package repo list
Universe: https://universe.mesosphere.com/repo
```

# <a name="finding-packages"></a>Searching for packages

The syntax for searching for packages follows.

```bash
$ dcos package search [--json <query>]
```

The following command will locate big data packages.

```bash
$ dcos package search "big data"
NAME VERSION FRAMEWORK SOURCE DESCRIPTION
spark 1.4.0-SNAPSHOT True https://github.com/mesosphere/universe/archive/version-1.x.zip Spark is a fast and general cluster computing system for Big Data
```

## <a name="adding"></a>Adding a Repository

Add a repo with the name `your-repo` and the repo archive URL `https://yourcompany/archive/stuff.zip`:

```bash
$ dcos package repo add your-repo https://yourcompany/archive/stuff.zip
```

## <a name="removing"></a>Removing a Repository

Remove the repo with the name `your-repo`:

```bash
$ dcos package repo remove your-repo
```