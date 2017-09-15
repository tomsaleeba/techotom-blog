---
layout: post
title: Fixing "The default package '.' is not permitted by the Import-Package syntax."
  with maven-bundle-plugin
date: 2014-10-21 01:05:03 +1030
categories:
- Software Development
author: Tom Saleeba
---
# Overview

I found this problem when I was trying to bundle a maven project as an OSGi bundle to use with Tycho. The bundle I was trying to make was effectively a shaded/uber JAR that has all the dependencies inlined inside of the final artifact JAR.

# The cause

This problem is caused by a Java class file existing in the default/unamed package. It could come from anywhere in the dependency chain, including your own project, but in this case it came from one of my dependencies; JDOM.

# The fix

A Google for this error message finds lots of mail archive discussions on ways to fix it but none of them allude to the fact that it might be coming from an dependency. It's my hope that this post will link searches for this error message to the fix that is posted here: [https://developer.atlassian.com/display/DOCS/Using+JDOM+in+OSGi]()

In case that site ever changes or goes down, here's what they posted:

> # [Using JDOM in OSGi](https://developer.atlassian.com/display/DOCS/Using+JDOM+in+OSGi)
> 
> [JDOM](http://www.jdom.org/) is a difficult package to use in [OSGi](http://www.osgi.org/), for the following reasons:
> 
> 
> *   [JDOM has Classes in the Root Package](https://developer.atlassian.com/display/DOCS/Using+JDOM+in+OSGi?continue=https%3A%2F%2Fdeveloper.atlassian.com%2Fdisplay%2FDOCS%2FUsing%2BJDOM%2Bin%2BOSGi&application=dac#UsingJDOMinOSGi-JDOMhasClassesintheRootPackage)
> *   [JDOM Imports a Number of Optional Packages](https://developer.atlassian.com/display/DOCS/Using+JDOM+in+OSGi?continue=https%3A%2F%2Fdeveloper.atlassian.com%2Fdisplay%2FDOCS%2FUsing%2BJDOM%2Bin%2BOSGi&application=dac#UsingJDOMinOSGi-JDOMImportsaNumberofOptionalPackages)
> 
> ### JDOM has Classes in the Root Package
> 
> For some reason, the author of JDOM decided to break one of the fundamental rules of Java, that is, do not put classes in the root package. JDOM has a class called `JDOMAuthor` in the root package. If you want to include JDOM in your OSGi bundle, you'll need to remove these classes. In Maven, you can do it like this:
> 
> 
> Additionally, if using the Maven Bundle Plugin, you will need to manually include this library, for example:
> 
> ```
> <plugin>
>   <groupId>org.apache.maven.plugins</groupId>
>   <artifactId>maven-dependency-plugin</artifactId>
>   <executions>
> 	...
> 	<execution>
> 	  <id>unpack-jdom</id>
> 	  <phase>compile</phase>
> 	  <goals>
> 		<goal>unpack</goal>
> 	  </goals>
> 	  <configuration>
> 		<artifactItems>
> 		  <artifactItem>
> 			<groupId>jdom</groupId>
> 			<artifactId>jdom</artifactId>
> 			<version>1.0</version>
> 			<outputDirectory>
> 			  ${project.build.directory}/jdom
> 			</outputDirectory>
> 		  </artifactItem>
> 		</artifactItems>
> 	  </configuration>
> 	</execution>
> 	...
>   </executions>
> </plugin>
> ...
> <plugin>
>   <groupId>org.apache.maven.plugins</groupId>
>   <artifactId>maven-antrun-plugin</artifactId>
>   <executions>
> 	...
> 	<execution>
> 	  <!-- Remove classes from the root package and re jar -->
> 	  <id>fix-jdom</id>
> 	  <phase>process-classes</phase>
> 	  <goals>
> 		<goal>run</goal>
> 	  </goals>
> 	  <configuration>
> 		<tasks>
> 		  <delete>
> 			<fileset dir="${project.build.directory}/jdom" includes="*.class"/>
> 		  </delete>
> 		  <jar destfile="${project.build.directory}/jdom-1.0-fixed.jar">
> 			<fileset dir="${project.build.directory}/jdom"/>
> 		  </jar>
> 		</tasks>
> 	  </configuration>
> 	</execution>
> 	...
>   </executions>
> </plugin>
> ```
> 
> Make sure JDOM is not included in your bundled Maven dependencies. You can usually do this by marking JDOM as 'provided'.
> 
> ### JDOM Imports a Number of Optional Packages
> 
> 'Optional' is the default setting for imports, if you do not include an OSGi manifest. But if you are using the Maven Bundle Plugin, the default is 'mandatory'.
> 
> Note that if you are not marking all packages as optional imports by default, then you will need to add at least the following to your imports:
> 
> ```
> oracle*;resolution:=optional,org.jaxen*;resolution:=optional
> ```

A huge thanks to jproper and [Sarah Maddox](https://developer.atlassian.com/display/~smaddox) for posting the fix.
