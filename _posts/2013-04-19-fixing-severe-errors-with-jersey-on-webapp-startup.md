---
layout: post
title: Fixing SEVERE errors with Jersey on WebApp startup
date: 2013-04-19 08:20:40 +0930
categories:
- IT
- Software Development
tags:
- jersey
author: Tom Saleeba
---
# The problem

As some background, I'm running the following:

* Jersey 1.15
* Apache Tomcat 7

The specific error that we're going to fix is:
```
SEVERE: The following errors and warnings have been detected with resource and/or provider classes:
SEVERE: Missing dependency for method public au.com.your.package.YourResponse au.com.your.package.YourClass.someMethod(au.com.your.package.YourRequest) at parameter at index 0
SEVERE: Method, public au.com.your.package.YourResponse au.com.your.package.YourClass.someMethod(au.com.your.package.YourRequest), annotated with GET of resource, class au.com.your.package.YourClass, is not recognized as valid resource method.
```

If you're running Tomcat like I am then you'll see this in your `catalina.out` log file.

# The fix

Your request object, that is the parameter to the method that's mentioned in the error (`au.com.your.package.YourRequest` in the example), needs a `valueOf` method added. Something like this:

```java
import org.codehaus.jackson.map.ObjectMapper;

  public static YourRequest valueOf(String reqJson) {
    ObjectMapper mapper = new ObjectMapper();
    try {
      return mapper.readValue(reqJson, YourRequest.class);
    } catch (Exception e) {
      throw new RuntimeException(e);
    }
  }
```
