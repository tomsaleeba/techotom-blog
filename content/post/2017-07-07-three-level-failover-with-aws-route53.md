---
date: "2017-07-07T00:00:00Z"
summary: How to create a 3 level failover DNS setup from the AWS web console
tags:
- aws
- route53
title: Three level failover with AWS Route53
---

# TL;DR
{% capture main_dns_layout %}
    resilient-site.techotom.com
        Type: CNAME
        Alias: No
        Value: primary.resilient-site.techotom.com
        Routing Policy: Failover
        Failover record type: Primary
        Associate with health check: Yes
        Health check to associate: primary.resilient-site
        
    resilient-site.techotom.com
        Type: CNAME
        Alias: No
        Value: backup.resilient-site.techotom.com
        Routing Policy: Failover
        Failover record type: Secondary
        Associate with health check: No
{% endcapture %}
{% capture backup_dns_layout %}
    backup.resilient-site.techotom.com
        Type: CNAME
        Alias: No
        Value: secondary.resilient-site.techotom.com
        Routing Policy: Failover
        Failover record type: Primary
        Associate with health check: Yes
        Health check to associate: secondary.resilient-site

    backup.resilient-site.techotom.com
        Type: CNAME
        Alias: No
        Value: tertiary.resilient-site.techotom.com
        Routing Policy: Failover
        Failover record type: Secondary
        Associate with health check: No
{% endcapture %}

Configure a health check for the primary and secondary hosts. Configure a pair of failover DNS records named `backup.resilient-site.` that is a traditional failover between `secondary.` and `tertiary.`. Then configure the DNS name you want to use as a traditional failover between `primary.` and `backup.`. For example:
{{ main_dns_layout }}{{ backup_dns_layout }}

# Background
AWS Route53 supports a two level failover configuartion for DNS out of the box but I wanted to create a three level setup. Let's not get too worried about why I wanted to do this, because I'm not sure I could make a convincing argument. If you're running 3 servers anyway, then you might be better off doing a load balancing setup to get more use of what you're paying for.

# The problem
You can't configure a three level failover directly in the console so instead, we'll construct it with two, two-level setups.

# The solution
Let's assume we have the following:

    resilient-site.techotom.com: domain we want to have 3 levels of failover
    1.1.1.1:                     IP of the primary server
    2.2.2.2:                     IP of the seconary server
    3.3.3.3:                     IP of the tertiary server

To test our DNS configuration, it'll be handy to have a simple server that we can run on any port and easily bring up and down. Netcat is a great tool for the job and is available on (most?) Linux out of the box. It might go by the name `nc` as it does for me. I'll explain how to run it later but for now, let's say our server will run on port `8888`.

Let's assign some domain names to our three servers to make life easier for ourselves. We'll [create one A record](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/resource-record-sets-creating.html) for each:

    primary.resilient-site.techotom.com ->   1.1.1.1
    secondary.resilient-site.techotom.com -> 2.2.2.2
    tertiary.resilient-site.techotom.com ->  3.3.3.3

**Health checks**

Next we need to [create some health checks](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/health-checks-creating.html). The health checks are what Route53 will use to decide if it should route to a particular host. If a host fails a health check (it's unhealthy) then route53 won't route to it and will instead go to the next host in the failover chain. We only need two health checks; one for `primary` and another for `secondary`. There's no point health checking the `tertiary` record because if it's unhealthy, there's nothing we can do, we have nowhere else to send traffic. We'll create the two health checks as:

    Name: primary.resilient-site
    What to monitor: Endpoint
    IP address: 1.1.1.1
    Port: 8888

    Name: secondary.resilient-site
    What to monitor: Endpoint
    IP address: 2.2.2.2
    Port: 8888

**Backup failover records**

We need to encapsulate the `secondary.` and `tertiary.` failover behaviour inside a single domain name, which we'll call `backup.resilient-site.techotom.com`. So let's create the following two records to achieve that:

{{ backup_dns_layout }}

**Main failover records**

Now we can create the "main" domain name record pair in basically the same fashion as we just did for the "backup". The point to focus on here is that the health check secondary for this record we're about to create points to `backup.resilient-site.techotom.com`. This target encapsulates a health check to so by pointing to it, we'll get `secondary.` if it's healthy, otherwise `tertiary.`. So let's create two more record as:

{{ main_dns_layout }}

**Testing it all**

Let's make sure what we've created works. As mentioned earlier, we'll use netcat for the task of a simple server. Here's a script that will create a simple netcat server that will respond multiple times. The loop achieves the multiple responses, without it, the "server" will respond once, then exit.
```bash
#!/usr/bin/env bash
srvnum=1 # edit for each server
port=8888
while true; do
    echo -e "HTTP/1.1 200 OK\n\n $(date) on server #$srvnum" | nc -l -p $port -q 1
done
```

You'll need to SSH into each of the 3 servers and run the script on each. Make sure to change the `srvnum` variable for each so you know which server you end up at.

Once you start the "servers" on `primary.` and `secondary.`, you'll see the AWS health check requests coming in, like:

    GET / HTTP/1.1
    Host: 1.1.1.1:8888
    Connection: close
    User-Agent: Amazon Route 53 Health Check Service; ref:97aace80-62b8-a461-bd0f-580344e8b53a; report http://amzn.to/1vsZADi
    Accept: */*
    Accept-Encoding: *

At this stage, you should be able to go to your main domain name (either in a browser or using cURL), `resilient-site.techotom.com` in our example, and get a response like:

    Fri Jul  7 12:26:21 ACST 2017 on server #1

The main thing is we're getting a response from server **#1**. You did remember to change the variable for each server, right?

Now we can kill (ctrl+c) the server on `primary.` (`1.1.1.1`) to simulate our primary server going down. Route53 doesn't react instantly, it takes ~30-60 seconds according to my tests. During this time you'll probably get errors when you try to connect to the, now dead, primary server. Once the DNS records update, you should start seeing a response that has server **#2** in it. This is great! It means we've failover-ed to the `seconary.` host (or the primary of the `backup.` domain).

Finally we can kill the netcat server on the `secondary.` (`2.2.2.2`) host. After the 30-60 second wait we should see a response containing server **#3**. Yay, it's all working.

You can test servers coming back online by starting the netcat "server" on `seconary.` or `primary.` and seeing the responses change.