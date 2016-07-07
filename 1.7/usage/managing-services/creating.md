---
post_title: Creating A Universe Package
nav_title: Creating
menu_order: 005
---

You can create your own package for the DC/OS Universe. [Universe](https://github.com/mesosphere/universe) is the DC/OS package repository that contains services like Spark, Cassandra, Jenkins, and many others.  

Packages are published to the Mesosphere Universe repository on GitHub. At their simplest, DC/OS packages are bundled containerized apps that can be deployed onto a cluster. 

## Getting Started

1.  Install these prerequisite tools.
    
    -  Install the DC/OS and the DC/OS CLI using this [guide](/docs/1.7/administration/installing/). You must have at least 1 [public agent](https://docs.mesosphere.com/1.7/overview/concepts/#public) node.
    -  Install [pip](https://pip.pypa.io/en/stable/installing.html#install-pip)
    -  Install jsonschema:
    
       ```bash
       $ pip install jsonschema
       ```
       
1.  Fork the [Universe](https://github.com/mesosphere/universe) repository, then clone the fork:

    ```bash
    $ git clone https://github.com/<your-username>/universe
    ```
    
    As you look around the Universe repository you'll notice that the repository (`/repo/packages`) consists of packages arranged alphabetically. Each package consists of 4 JSON files:
    
    -  `config.json` -  configuration properties supported by the package, represented as a json-schema.
    -  `package.json` -  high-level metadata about the package.
    -  `marathon.json.mustache` - a [mustache](http://mustache.github.io/) template that when rendered will create a [Marathon](http://github.com/mesosphere/marathon) app definition capable of running your service.
    -  `resource.json` - contains all of the externally hosted resources (e.g. Docker images, HTTP objects and images) that are required to install the application.

1.  Install the Universe repository pre-commit hooks.

    ```bash
    $ bash scripts/install-git-hooks.sh
    ```

1.  Create a new directory for the your package in `repo/packages/`. For example, to create a package named `helloworld` the structure is `repo/packages/H/helloworld/0`. The `0` directory corresponds to the release number of the package.  If you look at other packages in Universe, many have multiple releases (directories `0`, `1`, `2`, etc).

Now, you're ready to start creating your package!  

## Step One: Create package.json

Every package in Universe must have a package.json file which specifies the high level metadata about the package. This file specifies the highest-level metadata about the package (comparable to a `package.json` in Node.js or `setup.py` in Python).

Currently, a package can specify one of two values for `.packagingVersion`, either 2.0 or 3.0. The version is declared will dictate which other files are required for the complete package as well as the schemas all the files must adhere to. 

Below is a snippet that represents a version 2.0 package. See [`repo/meta/schema/package-schema.json`](https://github.com/mesosphere/universe/blob/version-3.x/repo/meta/schema/package-schema.json) for the full JSON schema outlining what properties are available for each corresponding version of a package.

```javascript
{
  "packagingVersion": "2.0", // use either 2.0 or 3.0
  "name": "foo", // your package name
  "version": "1.2.3", // the version of the container that you are launching
  "tags": ["mesosphere", "framework"],
  "maintainer": "help@bar.io", // who to contact for help
  "description": "Does baz.", // description of package
  "scm": "https://github.com/bar/foo.git", 
  "website": "http://bar.io/foo", 
  "framework": true,
  "postInstallNotes": "Have fun foo-ing and baz-ing!"
}
```

## Step Two: Create resource.json

This file declares all the externally hosted assets the package will need &mdash; for example: Docker containers, images, or native binary CLI.  See the resource schema version [2.0](https://github.com/mesosphere/universe/blob/version-3.x/repo/meta/schema/v2-resource-schema.json) or [3.0](https://github.com/mesosphere/universe/blob/version-3.x/repo/meta/schema/v3-resource-schema.json) for the available assets for each.

```javascript
{
  "images": {
    "icon-small": "http://some.org/foo/small.png",
    "icon-medium": "http://some.org/foo/medium.png",
    "icon-large": "http://some.org/foo/large.png",
    "screenshots": [
      "http://some.org/foo/screen-1.png",
      "http://some.org/foo/screen-2.png"
    ]
  },
  "assets": {
    "uris": {
      "log4j-properties": "http://some.org/foo/log4j.properties"
    },
    "container": {
      "docker": {
        "23b1cfe8e04a": "some-org/foo:1.0.0"
      }
    }
  }
}
```

##### Docker Images

For the Docker image, please use the image ID for the referenced image. You can find this by
pulling the image locally and running `docker images some-org/foo:1.0.0`.

##### Images

While `images` is an optional field, it is highly recommended you include icons and screenshots
in `resource.json` and update the path definitions accordingly. Specifications are as follows:

* `icon-small`: 48px (w) x 48px (h)
* `icon-medium`: 96px (w) x 96px (h)
* `icon-large`: 256px (w) x 256px (h)
* `screenshots[...]`: 1200px (w) x 675px (h)

**NOTE:** To ensure your service icons look beautiful on retina-ready displays,
please supply 2x versions of all icons. No changes are needed to
`resource.json` - simply supply an additional icon file with the text `@2x` in
the name before the file extension.
For example, the icon `icon-cassandra-small.png` would have a retina-ready
alternate image named `icon-cassandra-small@2x.png`.

## Step Three: Create config.json

This file declares the packages configuration properties, such as the amount of CPUs, number of instances, and allotted memory.  In step four, these properties will be injected into the` marathon.json.mustache file`.

Each property can provide a default value, specify whether it's required, and provide validation (minimum and maximum values).  Users can then override specific values at installation time by passing an options file to the DC/OS CLI or by setting config values through the DC/OS [UI](https://docs.mesosphere.com/current/usage/webinterface/#universe).


```javascript
{
  "type": "object",
  "properties": {
    "foo": {
      "type": "object",
      "properties": {
        "baz": {
          "type": "integer",
          "description": "How many times to do baz.",
          "minimum": 0,
          "maximum": 16,
          "required": false,
          "default": 4
        }
      },
      "required": ["baz"]
    }
  },
  "required": ["foo"]
}
```

## Step Four: Create marathon.json.mustache

This file is a [mustache template](http://mustache.github.io/) that when rendered will create a
[Marathon](http://github.com/mesosphere/marathon) app definition capable of running your service.

Variables in the mustache template will be evaluated from a union object created by merging three objects in the
following order:

1. Defaults specified in `config.json`

2. User supplied options from either the DC/OS CLI or the DC/OS UI

3. The contents of `resource.json`

```json
{
  "id": "foo",
  "cpus": "1.0",
  "mem": "1024",
  "instances": "1",
  "args": ["{{{foo.baz}}}"],
  "container": {
    "type": "DOCKER",
    "docker": {
      "image": "{{resource.assets.container.docker.foo23b1cfe8e04a}}",
      "network": "BRIDGE",
      "portMappings": [
        {
          "containerPort": 8080,
          "hostPort": 0,
          "servicePort": 0,
          "protocol": "tcp"
        }
      ]
    }
  }
}
```

For information about health checks and volumes, reference the [Marathon documentation](https://mesosphere.github.io/marathon/docs/rest-api.html).

## Step Five: Install Your Package

At this point, your package has all the required files for running on DC/OS.  Push all of these changes up to your fork of Universe on GitHub.

The next step is to verify that your new package works as expected.  To test this you are going to install it on a DC/OS cluster.

You must have DC/OS and DC/OS CLI [installed](/docs/1.7/administration/installing/).

#### Verify and build package

Run the following from the root of the cloned Universe repository:

    $ scripts/build.sh

#### Install package on your cluster

1.  Add your fork as a remote repository for your cluster:

    ```bash
    $ dcos package repo add Development https://github.com/<your-username>/universe/archive/<your-branch-name>.zip
    ```

    This prepares your cluster to install your package, but doesn't actually install it.
    
1.  Install your package with this command.
    
        $ dcos package install <your-package>
    
    It may take a few minutes for your package to deploy on your cluster.  When it's done deploying, you will see your package listed in the DC/OS UI Services tab.
    
## Next steps

[Deploying public services](/docs/1.7/usage/tutorials/public-app/)