---
UID: 56f984461ae7a
post_title: Security and Authentication
post_excerpt: ""
layout: page
published: true
menu_order: 4
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: true
---
You can enable authorization and authentication in your datacenter with DCOS Enterprise Edition. Authentication is managed through the DCOS web interface. Authorization is defined by access control lists (ACLs). The Admin Router enforces access control.

Users must be authorized in the ACL and then authenticated to access DCOS services. DCOS services are resources that are protected by an ACL. The ACL defines the individual users, user groups, and their list of accessible DCOS services. There is only one level of authorization: authorized or not.

The access control service provides an HTTP API for managing local users, groups and ACLs in a RESTful fashion. The Bootstrap superuser manages the ACL through the DCOS web interface.

You can validate remote user credentials against an external LDAP service.