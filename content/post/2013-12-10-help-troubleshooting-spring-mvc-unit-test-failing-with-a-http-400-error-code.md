---
categories:
- Software Development
date: "2013-12-10T06:32:17Z"
title: Help troubleshooting Spring MVC unit test failing with a HTTP 400 error code
aliases:
- /software%20development/2013/12/10/help-troubleshooting-spring-mvc-unit-test-failing-with-a-http-400-error-code.html
---
Note: I'm working in Eclipse with Spring 3 and using jUnit for my tests.

**Background**

I was writing a unit test for a file upload method on a controller that looks like:
```java
mockMvc.perform(fileUpload("/fileUpload")
    .param("description", "blah")
  )
  .andExpect(status().isOk());
```
The test was failing with the message:
```
java.lang.AssertionError: Status expected:<200> but was:<400>
```
This isn't super helpful because I wasn't sure why I was getting the 400. I tried changing the URL that I was testing and the error code changed to a 404 so I knew the request was trying to get to the right controller method. I also put a breakpoint in my controller method but it was never hit so I knew it was the configuration of the test and not the code in the controller method that was causing the issue.

**How to get more info**

To find out what the problem is, we need to use the debugger to get to a useful message. In my example above, we need to set a breakpoint inside the `.andExpect()` method call. To do this, and you'll need a newish version of Eclipse to support this feature, hold _control_ (or _command_ in OSX) and mouse over the `.andExpect()` method call, then click _Open Implementation_ and it should open something like the following code in your editor:
```java
public ResultActions andExpect(ResultMatcher matcher) throws Exception {
  matcher.match(mvcResult);
  return this;
}
```
We need to set our breakpoint on the first line; the `matcher.match()` call. Now run your unit test in debug mode and wait for the breakpoint to trigger. When it triggers, we'll need the **Variables** view in Eclipse to inspect stuff. If it's not in your perspective, add it using _Window -> Show View_. In the **Variables** view, you'll need to navigate to the following path:
```
this -> val$mvcResult -> mockResponse -> errorMessage
```
The `errorMessage` variable is a String and for me, the message was:
```
Required MultipartFile parameter 'file' is not present
```
Ta-da! Now we have some useful information. For my example, the way to fix the message is to call the `.file()` method on the result from the `fileUpload()` method, so:
```java
MockMultipartFile file = new MockMultipartFile("file", "orig", null, "bar".getBytes());
mockMvc.perform(fileUpload("/questionFileUpload")
  .file(file)
  .param("description", "blah")
  )
  .andExpect(status().isOk());
```
Unfortunately I can't tell you how to fix your problem if it's not what I've experienced but hopefully I've given you some help in fixing it yourself.
