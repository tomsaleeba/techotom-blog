---
categories:
- Software Development
date: "2016-03-22T07:23:14Z"
title: Xtend 2.8.2, Java 8 and .sort()
---
# Background

Warning: this post could probably be countered with a simple RTFM! But for those who are Googling for this, I hope it helps.

Today I tested out how our Xtend 2.8 code that works in Java 7 would go in a Java 8 JDK. For the most part it was ok but one problem that we experienced was related to sorting collections.

We had code like:
```xtend
val someCustomerComparator = ... // a java.util.Comparator
for(item : someEObject.items.sort(someCustomComparator)) {
  // do stuff
}
```
The sort method here is:
```java
<T> List<T> org.eclipse.xtext.xbase.lib.IterableExtensions.sort(Iterable<T> iterable, Comparator<? super T> comparator)
```
It's deprecated in Xtext/Xtend 2.8.2 but it still works with JDK7 but once I tried to compile with JDK8, the sort method call was failing to compile with the message:
```
Type mismatch: cannot convert from void to Iterable<? extends SomeValueItem> | SomeValueItem[] (at SomeProcessor:192)
```
Sure enough, when you look at what the method is calling, it's changed from the IterableExtensions one to: `void java.util.List.sort(Comparator<? super E> c)`

# The Fix

As the [javadoc](http://download.eclipse.org/modeling/tmf/xtext/javadoc/2.8/org/eclipse/xtext/xbase/lib/IterableExtensions.html#sort(java.lang.Iterable%2C%20java.util.Comparator)) for the deprecated `IterableExtensions.sort()` tells us, we should use [sortWith()](http://download.eclipse.org/modeling/tmf/xtext/javadoc/2.8/org/eclipse/xtext/xbase/lib/IterableExtensions.html#sortWith(java.lang.Iterable%2C%20java.util.Comparator)) instead.

Updating the code is as easy as changing `.sort()` to `.sortWith()`.
