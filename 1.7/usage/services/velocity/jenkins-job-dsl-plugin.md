---
UID: 56f984455d36f
post_title: Using the Jenkins Job DSL plugin
post_excerpt: ""
layout: page
published: true
menu_order: 120
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
This is a guide to building Jenkins job pipelines using the Jenkins Job DSL plugin. This guide will offer a brief overview of the Job DSL plugin and walk you through creating a new Jenkins seed job, templating the creation of additional pipeline jobs, and storing job configurations in a version control system.

The document assumes the reader has [a working Velocity installation][1], which includes Job DSL.

# Background

Over time, the creation and maintenance of hundreds of Jenkins jobs can become a burden. The Job DSL plugin allows for jobs to be scripted and templated, allowing entire pipelines to be defined within code rather than manually. In addition, once pipelines are defined in code, you can backup and version control your job configurations.

# The seed job

A "seed job" is an initial Jenkins job template that is used to build additional jobs. The seed job is a standard "free-style" job, meaning it includes all the standard benefits of any Jenkins job: history, logs, emails, etc.

The first step is to manually create a seed job via the Jenkins UI. Click "New Item", give your seed job a name (we’re using "Job DSL Tutorial"), select "Freestyle project", and click "OK":

<a href="/wp-content/uploads/2016/03/velocity-jobdsl-seed-job.png" rel="attachment wp-att-4050"><img src="/wp-content/uploads/2016/03/velocity-jobdsl-seed-job-800x315.png" alt="velocity-jobdsl-seed-job" width="800" height="315" class="aligncenter size-large wp-image-4050" /></a>

Next, define which project repository to monitor, how often, and the steps associated with testing the project.

For this tutorial, we’ll be checking the `mesosphere/jenkins-mesos` repository every 15 minutes and running a simple directory listing (`ls -l`) of the repository.

Scroll down to the "Build" section, click "Add build step", and select "Process Job DSLs" from the dropdown list. For this build step, select "Use the provided DSL script" and paste the following code into the provided text box:

    def owner = 'mesosphere'
    def project = 'jenkins-mesos'
    def jobName = "${owner}-${project}".replaceAll('/','-')
    job(jobName) {
      scm {
          git {
              remote {
                github("${owner}/${project}")
              }
              createTag(false)
          }
      }
      triggers {
          scm('*/15 * * * *')
      }
      steps {
          shell('ls -l')
      }
    }
    

<a href="/wp-content/uploads/2016/03/velocity-jobdsl-add-build-step.png" rel="attachment wp-att-4051"><img src="/wp-content/uploads/2016/03/velocity-jobdsl-add-build-step-800x280.png" alt="velocity-jobdsl-add-build-step" width="800" height="280" class="aligncenter size-large wp-image-4051" /></a>

**Note**: rather than pasting inline, you can also version control your Job DSL scripts in a Git repository. To do so, have the seed job clone the Git repository and use the "Look on Filesystem" option to process one or more of the Job DSL scripts within the build’s workspace.

Click "Save" and you’ll be presented with an overview of the seed job you’ve just created.

<a href="/wp-content/uploads/2016/03/velocity-jobdsl-seed-overview.png" rel="attachment wp-att-4052"><img src="/wp-content/uploads/2016/03/velocity-jobdsl-seed-overview-800x315.png" alt="velocity-jobdsl-seed-overview" width="800" height="315" class="aligncenter size-large wp-image-4052" /></a>

Click "Build Now" on the seed job. A new "Generated Jobs" folder will appear in the overview containing the job we’ve justed templated, `mesosphere-jenkins-mesos`.

<a href="/wp-content/uploads/2016/03/velocity-jobdsl-seed-overview-generated.png" rel="attachment wp-att-4053"><img src="/wp-content/uploads/2016/03/velocity-jobdsl-seed-overview-generated-800x315.png" alt="velocity-jobdsl-seed-overview-generated" width="800" height="315" class="aligncenter size-large wp-image-4053" /></a>

You can follow the link to the new job and see it’s relation to the seed job in the overview.

<a href="/wp-content/uploads/2016/03/velocity-jobdsl-generated-overview.png" rel="attachment wp-att-4054"><img src="/wp-content/uploads/2016/03/velocity-jobdsl-generated-overview-800x315.png" alt="velocity-jobdsl-generated-overview" width="800" height="315" class="aligncenter size-large wp-image-4054" /></a>

In the seed job, we configured the `mesosphere-jenkins-mesos` job to trigger every 15 minutes. Rather than wait for this trigger, let’s click "Build Now" to see the resulting console build log, which is a directory listing (`ls -l`) of the specified repository.

<a href="/wp-content/uploads/2016/03/velocity-jobdsl-generated-console.png" rel="attachment wp-att-4055"><img src="/wp-content/uploads/2016/03/velocity-jobdsl-generated-console-800x411.png" alt="velocity-jobdsl-generated-console" width="800" height="411" class="aligncenter size-large wp-image-4055" /></a>

# Extending the seed job

To show the power of the Job DSL let’s extend the functionality of the seed job to monitor all branches of our target repository (`mesosphere/jenkins-mesos`).

Go back to the "Job DSL Tutorial" seed job and click "Configure". Modify the code in the "Process Job DSLs" text box to find all repository branches and iterate over each one:

    def owner = 'mesosphere'
    def project = 'jenkins-mesos'
    def branchApi = new URL("https://api.github.com/repos/${owner}/${project}/branches")
    def branches = new groovy.json.JsonSlurper().parse(branchApi.newReader())
    branches.each {
      def branchName = it.name
      def jobName = "${owner}-${project}-${branchName}".replaceAll('/','-')
      job(jobName) {
        scm {
            git {
                remote {
                  github("${owner}/${project}")
                }
                branch("${branchName}")
                createTag(false)
            }
        }
        triggers {
            scm('*/15 * * * *')
        }
        steps {
            shell('ls -l')
        }
      }
    }
    

Click "Save" button, then "Build Now". You should see three new Generated Items, one for each existing branch of the `mesosphere/jenkins-mesos` repository.

<a href="/wp-content/uploads/2016/03/velocity-jobdsl-generated-per-branch.png" rel="attachment wp-att-4056"><img src="/wp-content/uploads/2016/03/velocity-jobdsl-generated-per-branch-800x379.png" alt="velocity-jobdsl-generated-per-branch" width="800" height="379" class="aligncenter size-large wp-image-4056" /></a>

# Further reading

That’s it! While this tutorial is meant to show the simplest workflow possible using seed jobs, the Job DSL provides the full power of the Groovy scripting language. See the following links for more information:

*   <https://jenkinsci.github.io/job-dsl-plugin/>
*   <https://github.com/jenkinsci/job-dsl-plugin/wiki/Real-World-Examples>

 [1]: /usage/services/velocity/