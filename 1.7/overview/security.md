---
post_title: Security in DC/OS
nav_title: DC/OS Security
post_excerpt: "Describes security features and best practices in DC/OS"
layout: page
published: true
menu_order: 4
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---

# DC/OS Security

This document discusses some of the security features in DC/OS, in addition to
best practices for deploying DC/OS securely.

## General security concepts

DC/OS is based on a Linux kernel and userspace. The same best practices for
securing any Linux system apply to securing DC/OS, including setting correct
file permissions, restricting root and normal user accounts, protecting
network interfaces with iptables or other firewalls, and regularly applying
updates from the Linux distribution used with DC/OS to ensure that system
libraries, utilities and core services like systemd and OpenSSH are secure.

## Security Zones

At the highest level we can distinguish three security zones in a DC/OS
deployment, namely the admin, private, and public security zones.

### Admin zone

The **admin** zone is accessible via HTTP/HTTPS and SSH connections, and
provides access to the master nodes. It also provides reverse proxy access to
the other nodes in the cluster via URL routing. For security, the DC/OS cloud
template allows configuring a whitelist so that only specific IP address
ranges are permitted to access the admin zone.

### Private zone

The **private** zone is a non-routable network that is only accessible from
the admin zone or through the edge router from the public zone. Deployed
services are run in the private zone. This zone is where the majority of agent
nodes are run.

### Public zone

The optional **public** zone is where publicly accessible applications are
run. Generally, only a small number of agent nodes are run in this zone. The
edge router forwards traffic to applications running in the private zone.

The agent nodes in the public zone are labeled with a special role so that
only specific tasks can be scheduled here. These agent nodes have both public
and private IP addresses and only specific ports should be open in their
iptables firewall.

### Typical AWS deployment

A typical AWS deployment including AWS Load Balancers is shown below:

![Security Zones](img/security-zones.jpg)

## Admin Router

Access to the admin zone is controlled by the Admin Router.

HTTP requests incoming to your DC/OS cluster are proxied through the Admin
Router (using [Nginx](http://nginx.org) with
[OpenResty](https://openresty.org) at its core). The Admin Router denies
access to most HTTP endpoints for unauthenticated requests. In order for a
request to be authenticated, it needs to present a valid authentication token
in its Authorization header. A token can be obtained by going through the
authentication flow, as described in the next section.

Authenticated users are authorized to perform arbitrary actions in their
cluster. That is, there is currently no fine-grained access control in DC/OS
besides having access or not having access to services.

## Authentication Flow

This section describes the authentication flow in DC/OS.

To understand the authentication flow, it helps to know more about the
authentication tokens that clients present to the server and how the server
verifies them. DC/OS uses the JSON Web Token (JWT) format for its tokens. JWT
is an open, industry standard ([RFC
7519](https://tools.ietf.org/html/rfc7519)) method for securely representing
claims between two parties.

JWTs are obtained using
[OpenID Connect 1.0](https://openid.net/specs/openid-connect-core-1_0.html),
which is a simple identity layer built on top of the
[OAuth 2.0](http://oauth.net/2/) protocol.

We've set up an OpenID Connect 1.0 endpoint at
[dcos.auth0.com](https://dcos.auth0.com/.well-known/openid-configuration) (in
cooperation with [Auth0](https://auth0.com/)) with connections to Google,
GitHub and Microsoft to make it possible to have basic authentication for
DC/OS installations included out of the box.

An authentication operation via the DC/OS UI proceeds as follows:

1. The user opens the cluster front page URL in their browser.
2. If the user has a valid authentication token cookie (checked by Admin Router)
   they may proceed to the cluster front page. If not, they are redirected to
   the login page.
3. The login page in the DC/OS UI loads the login page at `dcos.auth0.com`,
   which presents the user a choice of identity providers, including Google,
   GitHub, and Microsoft account.
4. The user selects an identity provider and completes the OAuth protocol flow
   in a popup window that returns an RS256-signed JWT for the user. The
   token is currently issued to be valid for 5 days, based on the standard
   `exp` claim.
5. The login page dispatches a request with the user token to the
   `/acs/api/v1/auth/login` Admin Router endpoint which forwards it to the
   [dcos-oauth](https://github.com/dcos/dcos-oauth) service. If the user is the
   first user accessing the cluster, an account is automatically created. Any
   subsequent users must be added by any other user in the cluster as described
   in the [User Management](../administration/user-management) page.
   If the user logging into the cluster is determined to be valid, they are
   issued with a HS256-signed JWT containing a `uid` claim which is specific to
   the cluster they are logging in to.

For the dcos-oauth service to validate tokens it receives during login operations,
it needs to have access to `dcos.auth0.com` to fetch required public keys via
HTTPS. Using a proxy to make this request is not currently supported.

The shared secret used to sign the cluster-specific tokens with the HS256
algorithm is generated during cluster boot and stored at
`/var/lib/dcos/auth-token-secret` on each master node and in the
`/dcos/auth-token-secret` znode in ZooKeeper.

As noted above, to ease the setup process, DC/OS will automatically add the first
user that logs in to the DC/OS cluster. Care should be taken to restrict network
access to the cluster until the first user has been configured. A future release
will allow users to be provisioned at installation time.

Care should be taken to protect authentication tokens, as an unauthorized
third party may use them to log in to your cluster if obtained. Invalidation
of individual tokens is not currently supported. In case a token is exposed,
it is recommended that the affected user be removed from the cluster.

The [JWT.IO](https://jwt.io) service can be used to decode JWTs to inspect
their contents.

## Authentication via CLI

To login, run `dcos auth login`.

- You will be prompted with "Please go to the following link in your browser".
- Open the given link and authenticate with your account. Once you
  authenticate, you should see a JSON Web Token.
- Copy the token from the browser to your CLI.
- If you correctly entered your token you should see "Login successful!".
- Your CLI is now authenticated and can be used normally.

To logout, run `dcos auth logout`.

Authentication is only supported for DC/OS CLI version 0.4.3 and above. See
[here](../docs/usage/cli/update/) for upgrade instructions.

The DC/OS CLI stores the token in a configuration file in the `.dcos`
directory under the home directory of the user running the CLI.

This token can be used with the curl command to access DC/OS APIs, using
curl or wget. For example, `curl -H 'Authorization: token=<token>' http://cluster`.

## Debugging

To debug authentication problems, refer to the Admin Router and dcos-oauth
logs on the masters, by running `sudo journalctl -u dcos-adminrouter.service`
or `sudo journalctl -u dcos-oauth.service`, respectively.

## User Database in ZooKeeper

The DC/OS user database is currently persisted in ZooKeeper running on the
master nodes in znodes under the path `/dcos/users`.

## HTTP Authorization Header

Tokens sent to DC/OS in a HTTP Authorization header must be of the format
`token=<token>` instead of the more common `Bearer <token>`. The latter format
will be supported in addition to the current format in a future release.

## Improved security

## Use your own certificate for Admin Router

We encourage administrators to replace the SSL certificate used by Admin Router on the
master nodes. Refer to the [Nginx documentation](http://nginx.org/en/docs/http/configuring_https_servers.html)
and the Admin Router configuration file at
`/opt/mesosphere/active/adminrouter/nginx/conf/nginx.conf` on the master nodes.

### Your own Auth0 account

For improved security, administrators may choose to configure their own Auth0
account or integrate directly with the OpenID Connect endpoints provided by
Google, GitHub, Microsoft Accounts, Azure Active Directory and many others.

If you are performing a custom advanced installation, you may configure DC/OS
to use an alternative Auth0 account by adding the following directive to
`genconf/config.yaml`:

```
oauth_issuer_url: https://youraccount.auth0.com/
oauth_client_id: <client id from application>
oauth_auth_redirector: https://youraccount.auth0.com
oauth_auth_host: https://youraccount.auth0.com
```

To obtain the client ID, complete the following steps:

1. Sign up for [Auth0](https://auth0.com/).
2. Create a new application in your Auth0 dashboard.
3. Skip the Quick Start documentation and switch to the Settings tab to obtain
   the client ID.
4. Add `https://youraccount.auth0.com` to the Allowed Origins (CORS) setting.
5. Show Advanced Settings at the bottom of the Settings page and change the
   JWT Signature Algorithm in the OAuth tab to RS256.
6. Create a custom Login Page in Auth0, using the HTML/JavaScript source of
   the [DC/OS login page](https://dcos.auth0.com/login?client=3yF5TOSzdlI45Q1xspxzeoGBe9fNxm9m).

The custom login page is currently required to work with the current version
of the DC/OS UI. A future release will remove the need for a custom login page
when using your own Auth0 account or using another identity provider directly,
but will require configuring a callback URL specific to your cluster.

Similar functionality to customize the installation on AWS and Azure will also
be made available in a future release.

## Authentication opt-out

If you are performing a custom advanced installation, you may opt out of
Auth0-based authentication by adding the following directive to
`genconf/config.yaml` (note that the quotes are currently required):

```
oauth_enabled: 'false'
```

On AWS, when creating a stack, at the Specify Details step, you may choose to
set the `OAuthEnabled` option to `false` to disable authentication for the DC/OS
installation.

The same option is not currently available when installing DC/OS through the
Azure Marketplace, but will be added in a future release along with other
options to customize authentication.

## Ad Blockers and the DC/OS UI

During testing, we have observed issues with loading the DC/OS UI login page
when certain ad blockers such as HTTP Switchboard or Privacy Badger are active.
Other ad blockers like uBlock Origin are known to work.

## Further reading

- [Let’s encrypt DCOS!](https://mesosphere.com/blog/2016/04/06/lets-encrypt-dcos/):
  a blog post about using [Let's Encrypt](https://letsencrypt.org/) with
  services running on DC/OS.

## Future work

We are looking forward to working with the DC/OS community on improving existing
security features as well as on introducing new ones in the coming releases.
