---
author: Tom Saleeba
categories:
- Infrastructure
- IT
date: "2012-05-21T11:48:28Z"
tags:
- Oneiric Ocelot
- Ubuntu
- Ubuntu Server
title: Blacklisting a module on Ubuntu Server 11.10 Oneiric Ocelot
---
This assumes you have vim (the command line text editor) installed. If not, you can use vi or any command line text editor in its place.

 1. Change to the modprobe directory:
    ```bash
    cd /etc/modprobe
    ```
 1. We need to create a new blacklist file to store our blacklistings in. If there are already other files in this directory, you can reuse one of them but for the sake of separating configuration you've made from the out-of-the-box setup, we'll create a new file. you can name this file anything you want as long as it ends in a `.conf` suffix and it would make sense to add blacklist and the type of device you're blacking list to the name so it's obvious what things live in there (as the module names might not give this information away). Note that you'll need to be superuser or sudo and this command requires vim:
    ```bash
    sudo vim blacklist-<deviceType>.conf
    ```
 1. Add one blacklisting per line in the file using the format
    ```
    blacklist <module>
    ```
    for example:
    ```
    blacklist pcspkr
    ```
    If in doubt, have a look in the other blacklist files for examples.
 1. Save and exit the file
 1. Restart your machine

Credit to: [http://ubuntuforums.org/showthread.php?t=1850267]()
