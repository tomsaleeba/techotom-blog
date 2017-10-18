---
layout: post
title: Finding keycloak realm certificate for apiman
author: Tom Saleeba
tags:
  - apiman
  - keycloak
excerpt: The blog post on setting up OAuth2 with apiman has some out of date bits when using apiman v1.3.1. I'll show you where to find that realm certificate.
---

# TL;DR
 1. login to keycloak and open the appropriate realm
 1. Go to Realm Settings -> Keys
 1. Click the `Certificate` button on the Type=`RSA` row

# Background
I've started playing with apiman and keycloak to secure an API using OAuth2. I've been following this useful blog [http://www.apiman.io/blog/gateway/security/oauth2/keycloak/authentication/authorization/1.2.x/2016/01/22/keycloak-oauth2-redux.html]() but as it was last updated at the start of 2016 and it's now October 2017, there's some out of date bits.

# The problem
This [section](http://www.apiman.io/blog/gateway/security/oauth2/keycloak/authentication/authorization/1.2.x/2016/01/22/keycloak-oauth2-redux.html#apiman-oauth2-policy) that talks about configuring the OAuth2 policy in apiman has a link to the keycloak admin UI that apparently gets you the `realm certificate`: [http://localhost:8080/auth/admin/master/console/#/realms/stottie/keys-settings](). This link doesn't work with apiman 1.3.1 (that comes with keycloak 2.5.5 I think). You get a page not found error instead. See below for where to find the certificate.

# The solution
You can find the realm certificate by:
 1. Login to keycloak, probably at a URL like [http://localhost:8080/auth/admin]()
 1. Select the realm that you're using for the apiman OAuth2 policy. That's `Stottie` if you're following the blog.
 1. Select `Realm Settings` from the menu on the left
 1. Click the `Keys` tab at the top
 1. You should have a table of active keys. One should be of type `RSA` and if you look at the far right of that row, there'll be a `Certificate` button. Click this button to get your base64 encoded X.509 certificate that you can use in the OAuth2 policy for apiman.
 