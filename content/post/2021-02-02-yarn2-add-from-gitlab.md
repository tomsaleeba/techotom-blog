---
title: "Yarn2 add from GitLab"
date: 2021-02-02T16:24:45+10:30
summary: "How to install npm/yarn packages direct from a GitLab repo"
tags:
- yarn
- js
---

I have a project that uses Yarn 2 and I wanted to install a dependency directly
from a GitLab (Lab not Hub) repo.

The doco lists all the [supported
protocols](https://yarnpkg.com/features/protocols). There is GitHub specific
support but also a general one for any git repo:

> git@github.com:foo/bar.git

Trying this format gives me an error:

```
$ yarn add "git@gitlab.com:ternandsparrow/strapi-initial-data.git"
➤ YN0000: ┌ Resolution step
➤ YN0001: │ Error: git@gitlab.com:ternandsparrow/strapi-initial-data.git isn't supported by any available resolver
...
```

The HTTPS protocol isn't listed on that page but it used to work with Yarn 1 so
let's try that:

```
$ yarn add https://gitlab.com/ternandsparrow/strapi-initial-data.git\#main
Internal Error: Invalid descriptor (https://gitlab.com/ternandsparrow/strapi-initial-data.git#main)
...
```

That's a big fail.

Looking at the `yarn add -h` help page shows that you need a leading name
fragment that seems to give the package a name:

```
...
Add a package from a GitHub repository (the master branch) to the current workspace using a URL
  $ yarn add lodash@https://github.com/lodash/lodash
...
```

# The solution
Following that advice and redundantly adding that `<name>@` prefix turns out to
work, yay. This is the command that worked for me:

```
yarn add "strapi-initial-data@https://gitlab.com/ternandsparrow/strapi-initial-data.git#main"
```

Note: the default branch in this repo is `main` so I had to specify it as yarn
still expected `master`.
