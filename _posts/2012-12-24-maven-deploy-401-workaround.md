---
layout: post
title: Maven deploy to Sonatype Nexus "401 Premission Denied" workaround
date: 2012-12-24 05:37:53 +1030
categories:
- Infrastructure
- IT
author: Tom Saleeba
---
My current infrastructure has an instance of Jenkins as the Continuous Integration server and Sonatype Nexus as the repository manager. The POMs for my project and the `settings.xml` file for maven are configured so that Jenkins can automatically deploy SNAPSHOTs to the Nexus repository but the problem arose when I had a build that went to production and I needed to deploy that pre-built artifact to Nexus' RELEASE repository. This was easier that going back and checking out the correct versions of the many dependencies. In the future I'll use the [maven-release-plugin](http://maven.apache.org/maven-release/maven-release-plugin/index.html) but for now, this is how I solved this problem.

First up, this is snippet from the maven output that shows the 401 response. I'm trying to deploy my artifact with a modified POM (to remove the snapshot tag) to Nexus via its exposed web API.
```
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-deploy-plugin:2.7:deploy-file (default-cli) on project standalone-pom: Failed to update metadata au.org.aekos:mywebapp/maven-metadata.xml: Could not write metadata /home/path/to/mavenrepo/com/group/mywebapp/maven-metadata-releases.xml: /home/path/to/mavenrepo/com/group/mywebapp/mywebapp/maven-metadata-releases.xml (Permission denied) -> [Help 1]
```
...and you see more of the log output here:
```
ubuntu@server:~/$ mvn deploy:deploy-file -Durl=http://my-server.com/nexus/content/repositories/releases/ -DrepositoryId=releases -Dfile=mywebapp-1.0-20121221.065121-119.war -DpomFile=mywebapp-1.0-20121221.065121-119.pom -DuniqueVersion=false -Dsources=mywebapp-1.0-20121221.065121-119-sources.jar
[INFO] Scanning for projects...
[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] Building Maven Stub Project (No POM) 1
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-deploy-plugin:2.7:deploy-file (default-cli) @ standalone-pom ---
Uploading: http://my-server.com/nexus/content/repositories/releases/au/org/aekos/mywebapp/1.0.0/mywebapp-1.0.0.war
Uploaded: http://my-server.com/nexus/content/repositories/releases/au/org/aekos/mywebapp/1.0.0/mywebapp-1.0.0.war (19503 KB at 8550.2 KB/sec)
Uploading: http://my-server.com/nexus/content/repositories/releases/au/org/aekos/mywebapp/1.0.0/mywebapp-1.0.0.pom
Uploaded: http://my-server.com/nexus/content/repositories/releases/au/org/aekos/mywebapp/1.0.0/mywebapp-1.0.0.pom (10 KB at 190.4 KB/sec)
Downloading: http://my-server.com/nexus/content/repositories/releases/au/org/aekos/mywebapp/maven-metadata.xml
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 4.829s
[INFO] Finished at: Mon Dec 24 14:14:29 CST 2012
[INFO] Final Memory: 7M/59M
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-deploy-plugin:2.7:deploy-file (default-cli) on project standalone-pom: Failed to update metadata au.org.aekos:mywebapp/maven-metadata.xml: Could not write metadata /home/path/to/mavenrepo/com/group/mywebapp/maven-metadata-releases.xml: /home/path/to/mavenrepo/com/group/mywebapp/mywebapp/maven-metadata-releases.xml (Permission denied) -> [Help 1]
[ERROR] 
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR] 
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoExecutionExceptions
```
The workaround for this issue is to bypass the web API and deploy it directly on the local filesystem. I could do this because I have SSH access to the server but obviously, if you don't have access then this won't work for you. Here's the command that I ran:
```bash
mvn deploy:deploy-file \
  -Durl=file:///path/to/nexus/sonatype-work/nexus/storage/releases/ \
  -Dfile=mywebapp-1.0-20121221.065121-119.war \
  -DpomFile=mywebapp-1.0-20121221.065121-119.pom \
  -DuniqueVersion=false
```
The difference to note is the URL, I use a file path for the local filesystem rather than a URL to talk to Nexus. In this way, we deploy it straight the the maven repo and Nexus will simply notice it is there and update itself.
