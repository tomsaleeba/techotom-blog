---
title: "More details from Chrome 'Aw snap'"
date: 2020-04-07T22:51:59+11:00
summary: "Trying to get more details about why the page crashes"
tags:
- chrome
---
I've been experiencing [this
bug](https://bugs.chromium.org/p/chromium/issues/detail?id=1042093) while using
Chrome devtools and it's gotten to the point where I wanted to dig deeper to
find out what is causing it.

This is not about debugging Chrome itself, I don't have the skills for that, but
just trying to get some more details to figure out if it's something I've done
wrong in my code. Or if not, gather enough detail to report a useful bug.

The general idea of the bug is:
  1. launch a webpage with a service worker
  1. have the service worker trigger a POST
  1. (try to) inspect the body of the POST in the devtools network tab
  1. the tab will crash
  
It's not all POST requests, I tried to make a minimal reproduction, but there's
something about the ones I make that causes this.

So the goal here is to see what it sent in that POST, just to confirm it's what
I thought, as I can't use devtools to see that. For this we'll use
[`mitmproxy`](https://mitmproxy.org/) to intercept our network traffic.

  1. install `mitmproxy`
  1. run `mitmproxy` listening on port 8081
      ```bash
      mitmproxy \
        --listen-port 8081 \
        --listen-host 0.0.0.0 \
        --ssl-insecure \
        --set block_global=false
      ```

Now we can start Chrome so it uses our proxy. I don't want to mess with my main
profile, plus it's good to verify bugs on a clean profile, so let's start Chrome
with a throw-away profile and ask for extra logging output:
```bash
google-chrome-stable \
  --proxy-server=http://localhost:8081 \
  --user-data-dir=/tmp/chrome1 \
  --enable-logging \
  --v=1
```

Now we need Chrome to trust the HTTPS certificate that `mitmproxy` presents. We
do that by:
1. opening some HTTPS webpage (not google, that just seems to hang) and confirm
   that it fails with an invalid cert
1. now open [mitm.it](mitm.it), the proxy will intercept this and show you a page where you
   can download certs
1. download the pem cert (by clicking *other*)
1. open settings, search for "cert", open the *Manage Certificate* item
1. go to the *Authorities* tab
1. click the *import* button
1. select the pem cert you downloaded
1. check "Trust this certificate for identifying websites"
1. go back and refresh your failed page, it should work now because Chrome trusts the mitmproxy cert

Now, if you look in the running `mitmproxy` you will (should) see flows
appearing as you browse with Chrome.

You'll also see debug logs spewing from Chrome in your terminal where you launched it.

We now have everything in place to trigger the bug and then I can check in
mitmproxy that my app is indeed sending what I expect. It was. It was a pretty
boring JSON object too. I've reported the bug and I can't get a minimal
reproduction to work, so I'll just have to wait and hope for a fix.
