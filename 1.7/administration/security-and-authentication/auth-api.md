---
post_title: Authentication HTTP API Endpoint
layout: page
---
You can make external calls to HTTP API endpoints in your DC/OS cluster.

You must first obtain an authentication token and then include it in your HTTP request. 

By default authentication tokens expire after 5 days. You can view the expiration time in the ["exp" (Expiration Time) Claim](https://tools.ietf.org/html/rfc7519#section-4.1.4) of the JSON Web Token (JWT). You can refresh your JWT by re-logging in to DC/OS. 

# Generate the authentication token

### Request

Log in to the DC/OS CLI to obtain the auth [token](/administration/security-and-authentication/managing-authentication#log-in-cli).

![auth token](../img/auth-token.gif)

# Make HTTP request using the Authorization header

To authenticate an HTTP request against a DC/OS component, specify the `<authtoken>` in the request header.

For example, to access the Marathon API:

    $ curl --header "Authorization: token=<authtoken>" http://<master-host-name>/service/marathon/v2/apps
    

For example, to access the Mesos API:

    $ curl --header "Authorization: token=<authtoken>" http://<master-host-name>/mesos/master/state.json
    