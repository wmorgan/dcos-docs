---
UID: 5705936ad654f
post_title: Inline App Update
post_excerpt: ""
layout: page
published: true
menu_order: 0
page_options_require_authentication: false
page_options_show_link_unauthenticated: false
hide_from_navigation: false
hide_from_related: false
---
The [DCOS CLI][1] Marathon plugin allows you to easily view and update the configuration of existing applications.

# Update an Environment Variable

The [Marathon `env` variable][2] can be updated by specifying a JSON string in a command argument.

1.  Specify this CLI command with the JSON string included:
    
        dcos marathon app update test-app env='{"APISERVER_PORT":"25502"}'
        

2.  Run the command below to see the result of your update:
    
        dcos marathon app show test-app | jq '.env'
        

# Update all Environment Variable

The [Marathon `env` variable][1] can also be updated by specifying a JSON file in a command argument.

1.  Save the existing environment variables to a file:
    
        dcos marathon app show test-app | jq .env >env_vars.json
        
    
    The file will look like this:
    
            { "SCHEDULER_DRIVER_PORT": "25501", }
        

2.  Edit the `env_vars.json` file. Make the JSON a valid object by enclosing the file contents with `{ "env" :}` and add your update:
    
        { "env" : { "APISERVER_PORT" : "25502", "SCHEDULER_DRIVER_PORT" : "25501" } }
        

3.  Specify this CLI command with the JSON file specified:
    
        dcos marathon app update test-app < env_vars.json
        
    
    View the results of your update:
    
           dcos marathon app show test-app | jq '.env'

 [1]: /usage/cli/
 [2]: https://mesosphere.github.io/marathon/docs/task-environment-vars.html