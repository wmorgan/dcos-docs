---
UID: 56f9844782d70
post_title: Labeling Tasks
post_excerpt: ""
layout: page
published: true
menu_order: 105
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
This tutorial illustrates how labels can be defined using the Mesosphere DCOS Marathon web interface and REST API, and how information pertaining to applications that are running can be queried based on label value criteria.

When you deploy applications or containers in a Mesosphere DCOS cluster, you can associate a tag or label with your deployed components in order to track and report usage of the cluster by those components. For example, you may want to assign a cost center identifier or a customer number to a Mesos application and produce a summary report at the end of the month with usage metrics such as the amount of CPU and memory allocated to the applications by cost center or customer.

# Assigning Labels to Applications and Tasks

Mesosphere DCOS includes Marathon for deploying and monitoring long-running and containerized applications. You can use the Marathon web interface to deploy applications manually or you can use the Mesosphere DCOS Marathon command line interface.

[caption id="attachment_2257" align="alignnone" width="800"]<a href="http://live-mesosphere-documentation.pantheon.io/wp-content/uploads/2016/01/labels_demo_figure_1.jpg" rel="attachment wp-att-2257"><img src="http://live-mesosphere-documentation.pantheon.io/wp-content/uploads/2016/01/labels_demo_figure_1-800x540.jpg" alt="Figure 1. Marathon web interface - Labels for Application 1" width="800" height="540" class="size-large wp-image-2257" /></a> Figure 1. Marathon web interface - Labels for Application 1[/caption]

Figure 1 shows how to use the Marathon web interface to specify a label when launching a container or command line application. For the application named `myapp-1`, you can see that a label named `COST_CENTER` has been defined and set to `0001`. When this application is deployed, it will have that cost center value associated with it and can be queried using the Marathon REST API.

Figure 2 shows a second application being deployed using the Marathon web interface, but this time it has a `COST_CENTER` label set to `0002`. This label and value will be shown in the Marathon web interface and returned by calls to the REST API.

[caption id="attachment_2260" align="alignnone" width="800"]<a href="http://live-mesosphere-documentation.pantheon.io/wp-content/uploads/2016/01/labels_demo_figure_2.jpg" rel="attachment wp-att-2260"><img src="http://live-mesosphere-documentation.pantheon.io/wp-content/uploads/2016/01/labels_demo_figure_2-800x540.jpg" alt="Figure 2. web interface - Labels for Application 2" width="800" height="540" class="size-large wp-image-2260" /></a> Figure 2. web interface - Labels for Application 2[/caption]

You can also specify the label values when you deploy the application using the Mesosphere DCOS command line interface like this:

    dcos marathon app add <my json file>
    

Figure 3 shows the JSON format to use with the Mesosphere DCOS command to deploy an application using Marathon. Just as on the Marathon web interface, you can specify more than one label, but each label can only have one value.

[caption id="attachment_2261" align="alignnone" width="800"]<a href="http://live-mesosphere-documentation.pantheon.io/wp-content/uploads/2016/01/labels_demo_figure_3.jpg" rel="attachment wp-att-2261"><img src="http://live-mesosphere-documentation.pantheon.io/wp-content/uploads/2016/01/labels_demo_figure_3-800x385.jpg" alt="Figure 3. Marathon JSON File for Application 2" width="800" height="385" class="size-large wp-image-2261" /></a> Figure 3. Marathon JSON File for Application 2[/caption]

# Displaying Label Information

Now that the applications are deployed and started, you can use the Marathon web interface included with Mesosphere DCOS to view the two applications running with their associated labels. Figure 4 shows the applications running with their COST_CENTER label values displayed.

[caption id="attachment_2262" align="alignnone" width="800"]<a href="http://live-mesosphere-documentation.pantheon.io/wp-content/uploads/2016/01/labels_demo_figure_4.jpg" rel="attachment wp-att-2262"><img src="http://live-mesosphere-documentation.pantheon.io/wp-content/uploads/2016/01/labels_demo_figure_4-800x540.jpg" alt="Figure 4. Marathon web interface – Running Applications" width="800" height="540" class="size-large wp-image-2262" /></a> Figure 4. Marathon web interface – Running Applications[/caption]

You can also use the Marathon REST API to query the running applications based on the label value criteria. Figure 5 shows a REST request issued to the Marathon service running in the Mesos cluster. The curl program is used in this example to submit the HTTP GET request, but you can use any program that is able to send HTTP GET/PUT/DELETE requests. You can see the REST end-point is:

    https://52.88.210.228/marathon/v2/apps
    

And the parameters sent along with the REST request include the label criteria:

    ?label=COST_CENTER==0001
    

[caption id="attachment_2263" align="alignnone" width="757"]<a href="http://live-mesosphere-documentation.pantheon.io/wp-content/uploads/2016/01/labels_demo_figure_5.jpg" rel="attachment wp-att-2263"><img src="http://live-mesosphere-documentation.pantheon.io/wp-content/uploads/2016/01/labels_demo_figure_5.jpg" alt="Figure 5. Marathon REST API Usage" width="757" height="790" class="size-full wp-image-2263" /></a> Figure 5. Marathon REST API Usage[/caption]

You may also specify multiple label criteria like this:

    ?label=COST_CENTER==0001,COST_CENTER==0002
    

When the HTTP GET request is received by Marathon, it replies with a response in the form of a JSON payload. JSON wasn’t designed to be easy to read, but if you use a tool like the python json.tool class, you can format it so it can be somewhat readable. In a real production system, you would have a reporting tool that knows how to decode the JSON formatted response into a nice human readable format (or chart), but here we are just viewing the raw JSON output.

As you can see, the response includes only the applications that have a label `COST_CENTER` defined with a value of `0001`. The resource metrics are included too, such as the number of CPU shares and the amount of memory allocated. At the bottom of the response, you can see the date/time this application was deployed, which can be used to compute the uptime for billing or charge-back purposes.

# Summary

When you use the Mesosphere DCOS Marathon service to deploy containerized applications, you can assign labels like cost center or customer identifiers to help to track cluster resource usage. This document illustrates how labels are defined using the Marathon web interface and REST API, and how information pertaining to running applications are queried based on label value criteria.