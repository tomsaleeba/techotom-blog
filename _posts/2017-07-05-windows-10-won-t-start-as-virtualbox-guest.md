---
layout: post
title: Windows 10 won't start as VirtualBox guest
author: Tom Saleeba
tags:
  - windows
  - virtualbox
excerpt: Updating to a newer version of VirtualBox is required to get Windows 10 version 1703 to run as a guest.
---

# TL;DR
Update VirtualBox to at least VirtualBox version `5.1.22` using whatever method you prefer, but I describe using the VirtualBox APT repository here.

# Background
I've installed a real/full version of Windows 10 into VirtualBox. I mean real as opposed to the IE/Edge tester VM images that you can download. I started out with the following versions:

    Windows 10:
      version: 1511
      build: 10586
    VirtualBox: 5.0.32
    Linux Mint: 18.1 x64

I was trying to upgrade to:

    Windows 10:
      version: 1703
      build: 15063

This was the latest VirtualBox from the APT repository at the time of writing and the version of Windows is what you get when you install from the ISO.

# The problem
Everthing was working fine after the initial install but when I tried to use the Upgrade Assistant in Windows, the machine wouldn't boot after the mandatory restart. It would hang at the black screen with the cyan Windows logo (and no loading spinner):

![My helpful screenshot]({{ site.url }}/assets/win10-loading.png)

Once the VM would get to that stage, one CPU would go to 100% usage (it had 4 CPU cores allocated) and it would sit like that until I gave up waiting for it. I even left it overnight just to check.

# The solution
Using my Google-fu I couldn't find anyone else with the exact same problem. I did find someone who had the same behaviour but on the IE tester images [https://superuser.com/questions/1224949/windows-10-guest-os-stuck-booting-in-virtualbox-on-ubuntu-16-04-host/1225433](), which is close enough, but there was no solution posted. 

Next step, I tried the "make sure everything is up to date" approach. For me this meant adding the VirtualBox APT repository so I could get the newest version (newer than what the Ubuntu APT repository hosts).

I followed the instructions for Debian systems from [https://www.virtualbox.org/wiki/Linux_Downloads#Debian-basedLinuxdistributions]():
> Add the following line to your /etc/apt/sources.list:
> 
>     deb http://download.virtualbox.org/virtualbox/debian yakkety contrib
> According to your distribution, replace 'yakkety' by 'xenial', 'vivid', 'utopic', 'trusty', 'raring', 'quantal', 'precise', 'lucid', 'jessie', 'wheezy', or 'squeeze'. ... The Oracle public key for apt-secure can be downloaded...and register[ed]:
> 
>     wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
>     wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
>
> ...snip...
> 
> To install VirtualBox, do
> 
>     sudo apt-get update
>     sudo apt-get install virtualbox-5.1
>
> ...snip...
> 
> Note: Ubuntu/Debian users might want to install the dkms package...through the following command:
> 
>     sudo apt-get install dkms

This took me to VirtualBox `5.1.22`. I then tried to upgrade in Windows and it worked flawlessly. After the mandatory restart the white loading spinner came up almost immediately and from then it all worked as it should.