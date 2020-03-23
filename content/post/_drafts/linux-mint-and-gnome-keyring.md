---
layout: post
title: Linux Mint and Gnome keyring
author: Tom Saleeba
tags:
  - mint
excerpt: How to set up the keyring to automatically load your SSH key
---

# TL;DR
Follow what it says [https://wiki.gnome.org/Projects/GnomeKeyring/Ssh#Automatically_loading_SSH_Keys](here) but instead of copying your keys into .ssh, just symlink them

    ln -s /path/to/private.pem /home/user/.ssh/id_rsa          # link private key
    ln -s /path/to/private.pem.pub /home/user/.ssh/id_rsa.pub  # link public key (you NEED to do this too)

# Background
what's the situation?

# The problem
what's the specific problem?

# The solution
how'd you fix it?