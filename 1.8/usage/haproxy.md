---
post_title: Configuring HTTP Proxy in Front of DC/OS
nav_title: Configure HTTP Proxy
menu_order: 61
---

You can configure a secure communication channel between HAProxy and the DC/OS Admin Router, using a custom hostname and port.


1.  Install HAProxy [1.6.9](http://www.haproxy.org/#down).

1.  Create an HAProxy configuration for DC/OS. This example is for a DC/OS cluster on AWS. For more information on HAProxy configuration parameters, see the [documentation](https://cbonte.github.io/haproxy-dconv/configuration-1.6.html#3).

    ```json
    #---------------------------------------------------------------------
    # Global settings
    #---------------------------------------------------------------------
    global
      daemon
      log 127.0.0.1 local0
      log 127.0.0.1 local1 notice
      maxconn 20000
      pidfile /var/run/haproxy.pid
    #---------------------------------------------------------------------
    # Common defaults that all the 'frontend' and 'backend' sections will 
    # use if not designated in their block
    #---------------------------------------------------------------------
    defaults
      log            global
      option         dontlog-normal
      mode		 http
      retries             3
      maxconn          20000
      timeout connect  5000
      timeout client  50000
      timeout server  50000
    
    frontend http
      # Bind on port 9090. HAProxy will listen on port 9090 on each 
      # available network for new HTTP connections.
      bind 0.0.0.0:9090
      # Name of backend configuration for DC/OS.
      default_backend dcos
    
      # Store request Host headers temporarily in transaction scope
      # so that its value is accessible during response processing.
      # Note: RFC 7230 requires clients to send the Host header and
      # specifies it to contain both, host and port information.
      http-request set-var(txn.request_host_header) req.hdr(Host)
    
      # Overwrite Host header to 'dcoshost'. This makes the Location
      # header in DC/OS Admin Router upstream responses contain a
      # predictable hostname (nginx uses this header value when
      # constructing absolute redirect URLs). That value is used
      # in the response Location header rewrite logic (see regular
      # expression-based rewrite in the backend section below).
      http-request set-header Host dcoshost
    
    backend dcos
      # Use the source strategy for distributing load amongst the servers.
      balance source
      # DC/OS CA cert downloaded from dcoshost/ca/dcos-ca.crt
      server dcos-1 52.57.1.99:443 check-ssl ssl verify required ca-file dcos-ca.crt verifyhost frontend-ElasticL-JW6HOE0W6MAT-1017800469.eu-central-1.elb.amazonaws.com
    
      # Rewrite response Location header if it contains an absolute URL
      # pointing to the 'dcoshost' host: replace 'dcoshost' with original
      # request Host header (containing hostname and port).
      http-response replace-header Location https?://dcoshost((/.*)?) "http://%[var(txn.request_host_header)]\1"
    ```

1.  Start, restart, or reload start HAProxy with these settings. 


About the Location response header rewrite:

* DC/OS only requires matches to "absolute URL redirects". In RFC 3986 terminology, this is: this regular expression does not match relative absolute-path references and relative-path references. For more information, see <a href="http://tools.ietf.org/html/rfc3986#section-4.2">http://tools.ietf.org/html/rfc3986#section-4.2</a> and/or <a href="http://stackoverflow.com/q/30846693/145400">http://stackoverflow.com/q/30846693/145400</a>.
* This regex ensures that the group capturing the path/query/fragment (the "relative part", group 1 in the regex) always participates in the match (is never a non-participating capturing groups), so that PCRE-based substitution inserts an empty string instead of not matching. Also see [Backreferences to Non-Participating Capturing Groups](http://www.regular-expressions.info/replacebackref.html).
