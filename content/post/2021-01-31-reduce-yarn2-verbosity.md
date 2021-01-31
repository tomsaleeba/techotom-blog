---
title: "Reduce Yarn 2 Verbosity"
date: 2021-01-31T11:55:45+10:30
summary: "I think the default log output of yarn v2 is too verbose, so I show how to tame it."
tags:
- yarn
- js
---


I've recently moved one of my projects from yarn v1 to v2. Everything has gone
well but the new version of yarn seems to be *very* verbose in its log output.

Namely, lots of these informational level logs explaining what's happening with
each dependency:

```
$ yarn install
➤ YN0000: ┌ Resolution step
➤ YN0002: │ @buffetjs/core@npm:3.3.3-next.2 [29e54] doesn't provide @babel/runtime (peb6c0), requested by react-dates
➤ YN0002: │ @buffetjs/core@npm:3.3.3-next.2 [2c39f] doesn't provide @babel/runtime (p5ef06), requested by react-dates
➤ YN0002: │ @buffetjs/core@npm:3.3.3-next.2 [526e4] doesn't provide @babel/runtime (p70a11), requested by react-dates
➤ YN0002: │ @buffetjs/core@npm:3.3.3-next.2 [77946] doesn't provide @babel/runtime (p82dce), requested by react-dates
➤ YN0002: │ @buffetjs/core@npm:3.3.3-next.2 [b3fd8] doesn't provide @babel/runtime (pf9b95), requested by react-dates
➤ YN0002: │ @buffetjs/core@npm:3.3.3-next.2 [df35a] doesn't provide @babel/runtime (p01176), requested by react-dates
➤ YN0002: │ @buffetjs/custom@npm:3.3.3-next.2 [29e54] doesn't provide react-dom (pb4e73), requested by @buffetjs/core
➤ YN0002: │ @buffetjs/custom@npm:3.3.3-next.2 [77946] doesn't provide react-dom (p49d12), requested by @buffetjs/core
➤ YN0002: │ @buffetjs/custom@npm:3.3.3-next.2 [b3fd8] doesn't provide react-dom (pe5a5d), requested by @buffetjs/core
➤ YN0002: │ @buffetjs/styles@npm:3.3.3-next.2 [29e54] doesn't provide @babel/runtime (p89727), requested by react-dates
➤ YN0002: │ @buffetjs/styles@npm:3.3.3-next.2 [29e54] doesn't provide moment (pbdbf3), requested by react-dates
➤ YN0002: │ @buffetjs/styles@npm:3.3.3-next.2 [29e54] doesn't provide react-dom (pedb8f), requested by react-dates
➤ YN0002: │ @buffetjs/styles@npm:3.3.3-next.2 [29e54] doesn't provide react-dom (p4a416), requested by react-tooltip
...snip...
```

I'm sure it's useful but I don't want to see it *all the time*, especially during
a Docker build.

I did the usual searches: "yarn 2 log verbosity", "yarn 2 lots of output", etc
to see if anyone else was asking how to reduce the verbosity but nothing turned
up. Apparently I'm alone.

So for anyone who lands on this page, I hope this helps.

# The solution
Yarn config has a
[logFilters](https://yarnpkg.com/configuration/yarnrc#logFilters) key that we
can use to control log outputs.

In my case, I don't want to see those `YN0002` log lines. They can be filtered
out by adding the following lines to your
[`.yarnrc.yml`](https://yarnpkg.com/configuration/yarnrc):

```yml
logFilters:
  - code: "YN0002"
    level: "discard"
```

All sorted.
