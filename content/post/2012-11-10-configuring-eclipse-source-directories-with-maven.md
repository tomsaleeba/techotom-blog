---
author: Tom Saleeba
categories:
- Software Development
date: "2012-11-10T00:19:20Z"
tags:
- eclipse
- maven
title: Configuring Eclipse source directories with maven
---
When you generate a Java project using maven and then import it into Eclipse, often you want to add extra directories that are treated as source directories. This guide will show you how to do it.

First lets look at (a snippet of) the [Super POM](http://maven.apache.org/guides/introduction/introduction-to-the-pom.html#Super_POM) to see what we get by default:
```xml
<build>
  <sourceDirectory>src/main/java</sourceDirectory>
  <scriptSourceDirectory>src/main/scripts</scriptSourceDirectory>
  <testSourceDirectory>src/test/java</testSourceDirectory>
  <resources>
    <resource>
      <directory>src/main/resources</directory>
    </resource>
  </resources>
</build>
```
We can override what we get from here which is probably what you'll do most of the time; adding another resource directory. When you add another resource remember that you're overriding the default so if you still want `src/main/resources` then you'll have to explicitly add it.

As an example, let's assume you're creating a `webapp` and want the `src/main/webapp` directory to be treated as a source directory. We'll also assume the we still want the `src/main/resources` directory and we're happy with the rest of the default paths. For this, we'd add this block to our `pom.xml`:
```xml
<build>
  <resources>
    <resource>
      <directory>src/main/resources</directory>
    </resource>
    <resource>
      <directory>src/main/webapp</directory>
    </resource>
  </resources>
</build>
```
Now you need to refresh your Eclipse project files so run this command in the directory where you pom.xml lives:
```bash
mvn eclipse:eclipse
```
This will update the existing project files but if you want to blow them away and start from scratch, you can add a clean goal:
```bash
mvn eclipse:clean eclipse:eclipse
```
Finally, jump back into Eclipse and you'll have to refresh your project (select the project and press F5). If it still doesn't show the changes, you may have to delete the project from your workspace and re-import it.