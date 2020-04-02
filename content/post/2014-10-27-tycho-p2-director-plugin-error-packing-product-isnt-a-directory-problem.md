---
categories:
- IT
- Software Development
date: "2014-10-27T00:00:58Z"
title: 'tycho-p2-director-plugin "Error packing product:  isn''t a directory" problem'
aliases:
- /it/software%20development/2014/10/27/tycho-p2-director-plugin-error-packing-product-isnt-a-directory-problem.html
---
# The problem

You're trying to build an Eclipse update site project, specifically `<packaging>eclipse-repository</packaging>`, with maven and you're getting the following error:

<pre style="white-space:pre;overflow-x:auto;">[INFO] --- tycho-p2-director-plugin:0.21.0:archive-products (default) @ YourProject.UpdateSite ---
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 1:00.627s
[INFO] Finished at: Mon Oct 27 09:56:51 CST 2014
[INFO] Final Memory: 84M/764M
[INFO] ------------------------------------------------------------------------
<span style="color:#ff0000;">[ERROR] Failed to execute goal org.eclipse.tycho:tycho-p2-director-plugin:0.21.0:archive-products (default) on project YourProject.UpdateSite: Error packing product: /path/to/YourProject.UpdateSite/target/products/your.product/linux/gtk/x86 isn't a directory. -> [Help 1]</span>
[ERROR]
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR]
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoExecutionException</pre>

This error message is specific to this environment block that you would have defined in your POM:
```xml
<environment>
  <os>linux</os>
  <ws>gtk</ws>
  <arch>x86</arch>
</environment>
```

For the sake of making this post easier to find for people Googling for error messages, you might get one of the following error messages for other common environments:
```
[ERROR] Failed to execute goal org.eclipse.tycho:tycho-p2-director-plugin:0.21.0:archive-products (default) on project YourProject.UpdateSite: Error packing product: /path/to/YourProject.UpdateSite/target/products/your.product/linux/gtk/x86_64 isn't a directory. -> [Help 1]
[ERROR] Failed to execute goal org.eclipse.tycho:tycho-p2-director-plugin:0.21.0:archive-products (default) on project YourProject.UpdateSite: Error packing product: /path/to/YourProject.UpdateSite/target/products/your.product/win32/win32/x86 isn't a directory. -> [Help 1]
[ERROR] Failed to execute goal org.eclipse.tycho:tycho-p2-director-plugin:0.21.0:archive-products (default) on project YourProject.UpdateSite: Error packing product: /path/to/YourProject.UpdateSite/target/products/your.product/win32/win32/x86_64 isn't a directory. -> [Help 1]
[ERROR] Failed to execute goal org.eclipse.tycho:tycho-p2-director-plugin:0.21.0:archive-products (default) on project YourProject.UpdateSite: Error packing product: /path/to/YourProject.UpdateSite/target/products/your.product/macosx/cocoa/x86_64 isn't a directory. -> [Help 1]
```

# The fix

For me, the problem was the order that I executed the goals in the maven build. They get executed in the order that you define them so when I wrote:
```xml
<build>
  ...
  <plugins>
  ...
  <plugin>
    <groupId>org.eclipse.tycho</groupId>
    <artifactId>tycho-p2-director-plugin</artifactId>
    <version>${tycho-version}</version>
    <executions>
    <execution>
      <phase>package</phase>
      <!-- Incorrect goal order -->
      <goals>
        <goal>archive-products</goal>
        <goal>materialize-products</goal>
      </goals>
    </execution>
    </executions>
    <configuration>
    <products>
      <product>
      <id>your.product</id>
      </product>
    </products>
    </configuration>
  </plugin>
  ...
  </plugins>
  ...
</build>
```

...it meant that they were executed like that. The fix is simple, swap the two goals around so you materialize the products before you try to archive them. It makes sense: how can you archive something that doesn't exist yet. The fixed goals block looks like this:
```xml
<!-- Correct goal order -->
<goals>
  <goal>materialize-products</goal>
  <goal>archive-products</goal>
</goals>
```

Hope this works for you too.
