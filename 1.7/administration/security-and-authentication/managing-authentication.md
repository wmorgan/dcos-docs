---
post_title: Managing Authentication
menu_order: 1
---
Authentication is managed in the DC/OS web interface.

You can authorize individual users. You can grant access to users who are local or remote to your datacenter. 

The DC/OS user database is persisted in ZooKeeper running on the master nodes in znodes under the path `/dcos/users`.

Tokens sent to DC/OS in a HTTP Authorization header must be of the format `token=<token>` instead of the `Bearer <token>`. Both formats
will be supported in a future release.

## User management

Users are granted access to DC/OS by another authorized user. A default user is automatically created by the first user that logs in to the DC/OS cluster.

To manage users:

1.  Launch the DC/OS web interface and login with your username (Google, GitHub, and Microsoft) and password.

2.  Click on the **System** -> **Organization** tab and choose your action.
    
    ### Add users
    
    From the **Users** tab, click **New User** and fill in the new user email address. New users are automatically sent an email notifying them of access to DC/OS. 
    
    **Tip:** Any user with access to DC/OS can invite more users. Each DC/OS user is an administrator, there is no explicit concept of privileges with DC/OS.
    
    ![new DC/OS user](../img/ui-add-user.gif)
 
    ### Delete users
    
    1.  From the **Users** tab, select the user name and click **Delete**. 
    2.  Click **Delete** to confirm the action.
    
    ### Switch users
    
    To switch users, you must log out of the current user and then back in as the new user.
    
    *   To log out of the DC/OS web interface, click on your username in the lower left corner and select **Sign Out**.
        
        ![log out](../img/auth-enable-logout-user.gif)
        
        You can now log in as another user.
    
    *   To log out of the DC/OS CLI, enter the this command:
        
            $ dcos config unset core.dcos_acs_token
            Removed [core.dcos_acs_token]
            
        
        You can now log in as another user.


## <a name="log-in-cli"></a>Logging in to the DC/OS CLI
Authentication is only supported for DC/OS CLI version 0.4.3 and above. See [here](/docs/1.7/usage/cli/update/) for upgrade instructions.

The DC/OS CLI stores the token in a configuration file in the `.dcos` directory under the home directory of the user running the CLI. This token can be used with the curl command to access DC/OS APIs, using curl or wget. For example, `curl -H 'Authorization: token=<token>' http://cluster`.

1.  Run this CLI command to authenticate to your cluster:

        $ dcos auth login
        
        
   Here is an example of the output:
        
        Please go to the following link in your browser:
        
            https://<public-master-ip>/login?redirect_uri=urn:ietf:wg:oauth:2.0:oob
        
        Enter authentication token: 
        
1.  Paste the link from the CLI into your browser and sign in. 
    
    ![alt](../img/auth-login.gif)
    
1.  Copy the authentication token from your browser.
    
    ![alt](../img/auth-login-token.gif)
    
1.  Paste the authentication token in to your terminal. You should see output similar to this:
    
    
        Please go to the following link in your browser:
        
            https://<public-master-ip>/login?redirect_uri=urn:ietf:wg:oauth:2.0:oob
        
        Enter authentication token: eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImtpZCI6Ik9UQkVOakZFTWtWQ09VRTRPRVpGTlRNMFJrWXlRa015Tnprd1JrSkVRemRCTWpBM1FqYzVOZyJ9.eyJlbWFpbCI6ImpvZWxAbWVzb3NwaGVyZS5pbyIsImVtYWlsX3ZlcmlmaWVkIjp0cnVlLCJpc3MiOiJodHRwczovL2Rjb3MuYXV0aDAuY29tLyIsInN1YiI6Imdvb2dsZS1vYXV0aDJ8MTAxMzg1ODk3MzgxOTI5NzQwODQyIiwiYXVkIjoiM3lGNVRPU3pkbEk0NVExeHNweHplb0dCZTlmTnhtOW0iLCJleHAiOjE0NjE2MjY1NzUsImlhdCI6MTQ2MTE5NDU3NX0.sjRbqzDzr3WcL8Ay2gYl-OoMmbLoAnsjGd1UWjGhsAvwzisoonx8LVml4E8aACzNAZ9tpshuIq-yUWvZ-S2FUSFogjhS9F-dap6GPPyyCzixNuVNFAU8vaKEhqmjr8C0TJg7BSflQurHvAWUu_DHWDtpUc5VCWfhIfDynvVL2pyvVaCWqm_j4OIPx_fKLxoYVHhSbKT91RV6C6ma0NAHK7ZPJdaJmCK0lwUnluRP_QTXtWbZPmgorvhHXciZ2tEFwSB_NZMznrmE__shbFDz_sNNIBmIXlH0zUgPogeOw-1roy1Ss8_sXL1DsRj1qUPQNY-TN8UUcw_GrOEFO7BCdQ
        [core.dcos_acs_token]: set
        Login successful!
    
    You are now an authorized user!

  
## Logging out of the DC/OS CLI

To logout, run this command:

    $ dcos auth logout
        
## Debugging

To debug authentication problems, refer to the Admin Router and dcos-oauth logs on the masters, by running `sudo journalctl -u dcos-adminrouter.service`
or `sudo journalctl -u dcos-oauth.service`, respectively.

## Authentication opt-out

If you are doing an [advanced installation](/administration/installing/custom/advanced/), you can opt out of
Auth0-based authentication by adding this parameter to your configuration file (`genconf/config.yaml`). For more information, see the configuration [documentation](/administration/installing/custom/configuration-parameters/). 

```yaml
oauth_enabled: 'false'
```

If you are doing a cloud installation on [AWS](/administration/installing/cloud/aws/), you can set the `OAuthEnabled` option to `false` on the **Specify Details** step to disable authentication.

If you are doing a cloud installation on [Azure](/administration/installing/cloud/azure/), you currently cannot disable authentication. This will be added in a future release along with other
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

## Next Steps

- [Understand DC/OS security](/docs/1.7/overview/security/)
- [Learn how to monitor a DC/OS cluster](/docs/1.7/administration/monitoring/)
 
 [1]: https://en.wikipedia.org/wiki/STARTTLS
 
 