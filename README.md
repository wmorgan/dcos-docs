# DC/OS Documentation
Documentation for the Datacenter Operating System (DC/OS)

These documents are used as source to generate [dev.dcos.io/docs](https://dev.dcos.io/docs) (staging) and [dcos.io/docs](https://dcos.io/docs) (production). They are submoduled into [dcos-website](https://github.com/dcos/dcos-website) for deployment.


**Issue tracking is moving to the [DCOS JIRA](https://dcosjira.atlassian.net/) ([docs component](https://dcosjira.atlassian.net/issues/?jql=project%20%3D%20DCOS%20AND%20component%20%3D%20dcos-docs)).
Issues on Github will be disabled soon.**

## Versions

- [1.7](1.7) (latest)

## Formatting

Markdown in this repository is formatted for rendering by using [Jekyll](https://jekyllrb.com/).

- Links must include the full directory path, including version, relative to the root of dcos.io (e.g. `/docs/1.7/administration/sshcluster/`). Note that these links will not work in the GitHub code browser. It is recommended that you run a [local Jekyll build](https://jekyllrb.com/docs/quickstart/) to test links before submitting your PR.
- Final page links are directory names, not filenames (e.g. `https://dcos.io/docs/latest/usage/service-discovery/mesos-dns/`).
- You must have an `index.md` page for all parent directories (rather than using Github's README.md indexing). For example, the parent directory `/dcos-docs/1.7/administration/` must also contain `/dcos-docs/1.7/index.md`.
- The table of contents of each page is automatically generated based on the top-level headers.
- Directory tables of contents are automatically generated based on `post_title` and `post_excerpt` headers.

## Contributing

Contribute to the documentation by using one of these options:

* Create a GitHub issue with a suggestion for a tutorial (for example: I'd like to see a tutorial on Apache Kafka).
* Update or write a new doc yourself by following the [Contributing Guidelines](CONTRIBUTING.md).

## License and Authors

Copyright 2016 Mesosphere, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this repository except in compliance with the License.

The contents of this repository are solely licensed under the terms described in the [LICENSE file](./LICENSE) included in this repository.

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Authors are listed in [AUTHORS.md file](./AUTHORS.md).
