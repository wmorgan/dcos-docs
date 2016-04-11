---
UID: 56f9844aa8e6c
post_title: Usage
post_excerpt: ""
layout: page
published: true
menu_order: 36
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---

## The 30sec baby steps

You got [installed](http://dcos.io/install) DC/OS? You have the DC/OS CLI `dcos` on your local computer set up and now you're looking at the DC/OS Dashboard, wondering 'What now?'. You know how to use `docker run ...` to launch a webserver, right? Now you will do the same using DC/OS, with the difference that this deployment is production-ready from the get-go. DC/OS will keep the webserver running if it crashes, you can scale it, update the config at runtime, and many more things but I'm getting ahead of myself now. Let's launch a production-ready containerized webserver:

    $ curl -sO http://dcos.io/docs/resources/nginx.json  && dcos marathon app add nginx.json

If you now go to the DC/OS Dashboard and open the Marathon service you see the webserver up and running and ready to serve traffic:

![Usage Marathon Webserver](img/usage_marathon_webserver.png)

## Next steps


### Basic


### Advanced

