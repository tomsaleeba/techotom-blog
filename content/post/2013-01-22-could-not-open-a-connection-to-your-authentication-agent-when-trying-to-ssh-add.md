---
categories:
- Software Development
date: "2013-01-22T12:58:55Z"
summary: How to `ssh-add` on a remote machine.
title: '"Could not open a connection to your authentication agent." when trying to
  ssh-add'
---
This is a reference for myself and hopefully others Googling will find it useful.

**The situation** is that I had SSH'd into a remote machine and I needed to use `ssh-add` to add a key so I could connect to BitBucket from the local machine using SSH (I know I could've used HTTPS instead). On my local machine I would usually run `ssh-add /path/to/key/file`, enter my password and be on my way. In this situation however, it wasn't that easy. I think ssh-add is trying to look on my local machine (i.e. back through the SSH connection) to see if an agent on my machine is providing keys but in my case, nothing was.

**The fix** was to run `exec ssh-agent bash` in the terminal, then run the `ssh-add` command to add my key file. Thanks to **chamstar** for answering his own question here: [http://forum.slicehost.com/index.php?p=/discussion/comment/18819#Comment_18819]().
