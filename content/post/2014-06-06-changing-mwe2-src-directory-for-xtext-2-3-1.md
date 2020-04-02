---
categories:
- Software Development
date: "2014-06-06T06:51:54Z"
title: Changing mwe2 src directory for Xtext 2.3.1
aliases:
- /software%20development/2014/06/06/changing-mwe2-src-directory-for-xtext-2-3-1.html
---
**Problem**

The Xtext project I'm working with had, what I assume is, the default project structure where all the java source code lives in a src directory and the generated code goes into src-gen. I wanted to change the structure to a more maven-like structure and have the java code living under src/main/java. I wasn't too fussed about the src-gen directory, that can stay where it is. I Googled for a while but I couldn't find anyone asking the same question as me so hopefully this will help any others (and my future self).

**Solution**

In the `.mwe2` file, I have a section like:
```
Workflow {
  ...snip...
  component = Generator {
    pathRtProject = runtimeProject
    pathUiProject = "${runtimeProject}.ui"
    projectNameRt = projectName
    projectNameUi = "${projectName}.ui"
    language = {
      uri = grammarURI
      fileExtensions = file.extensions
      ...snip....
```
Note: the Generator is an `org.eclipse.xtext.generator.Generator`.

This fix was to add:
```
srcPath = "/src/main/java"
```

...to the Generator. The leading slash is important otherwise you'll end up with a directory called something like `ExampleProjectsrc/main/java`, assuming your project is called ExampleProject.

So you'll end up with the following:
```
Workflow {
  ...snip...
  component = Generator {
    pathRtProject = runtimeProject
    pathUiProject = "${runtimeProject}.ui"
    projectNameRt = projectName
    projectNameUi = "${projectName}.ui"
    srcPath = "/src/main/java" // added line
    language = {
      uri = grammarURI
      fileExtensions = file.extensions
      ...snip....
```

Then re-run your `.mwe2` workflow to make sure everything gets generated to the expected spot. If you have other code living in the old `src`, you'll want to move that to `src/main/java` too.
