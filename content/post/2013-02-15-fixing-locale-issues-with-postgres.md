---
author: Tom Saleeba
categories:
- Linux
- Software Development
date: "2013-02-15T02:25:55Z"
title: Fixing locale issues with postgres
---
I came across this problem the other day and thought I'd post up the fix because it's simple to fix but a show stopper if you can't.

I'm running Linux Mint 64-bit Cinnamon and Postgres 9.1 as a refenece in case you can't copy-paste my commands.

Basically, when I copied an already running version of postgres to a new box and it failed to start. When I took a look in the postgres log for when you try to start it, I could see that it was complaining about a missing locale. For me, it was `en_AU.UTF-8`.

To generate (install) the new locale, run this command:
```bash
sudo locale-gen _yourLocale_
```
so for me, it was:
```bash
sudo locale-gen en_AU.UTF-8
```
Then, we need to tell the system that there are new locales with this command:
```bash
sudo dpkg-reconfigure locales
```
You're done, try to fire up postgres or whatever it was you were trying and you should be in business.
