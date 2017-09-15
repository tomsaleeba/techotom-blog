---
layout: post
title: Fixing "XMLGregorianCalendarImpl is internal proprietary API and may be removed in a future release"
date: 2015-02-03 07:43:51 +1030
categories:
- Software Development
author: Tom Saleeba
---
# Background:

I wrote some code that required an XMLGregorianCalendar so when I poked around with code completion, the first thing I found was a constructor on `com.sun.org.apache.xerces.internal.jaxp.datatype.XMLGregorianCalendarImpl`. This got my code working but when you build with Maven, you get given a warning (and rightly so):

> XMLGregorianCalendarImpl is internal proprietary API and may be removed in a future release

# The fix:

The correct way to get something that conforms to the XMLGregorianCalendar interface is to call this factory:
```java
XMLGregorianCalendar cal = javax.xml.datatype.DatatypeFactory.newInstance().newXMLGregorianCalendar();
```

Credit to the SO answer at [http://stackoverflow.com/a/5402007/1410035]() for how to do it.
