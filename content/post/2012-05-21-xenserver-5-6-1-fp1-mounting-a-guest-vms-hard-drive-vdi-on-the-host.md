---
categories:
- Infrastructure
- IT
date: "2012-05-21T10:58:40Z"
tags:
- XenServer
title: 'XenServer 5.6.1 FP1: Mounting a guest VM''s hard drive (VDI) on the host'
aliases:
- /infrastructure/it/2012/05/21/xenserver-5-6-1-fp1-mounting-a-guest-vms-hard-drive-vdi-on-the-host.html
---
# Back story

This is a problem that I ran up against because I was running the host machine as a bare host and all the functionality that I needed was in the guest machine. The purpose of this was to insulate myself from changes in hardware and to be able to easily backup the entire server (the guest) so it could be restored from image. This meant that occasionally I'd need to access files on the guest machine's "hard drive" but it wasn't running so methods that require networking were out. The  solution is to mount the guest's hard drive image on the host to access it like any other partition.

# Assumptions

1.  You're running XenServer 5.6.1 Feature Pack 1\. It may work with other versions but I haven't tested.
2.  If you need to mount the file systems on the VDI then your host machine needs to be able to read the file system of the guest's VDI

# Prerequisites

1.  The guest VM must be turned off
2.  No other machines are accessing the disk image (two machines cannot share the same disk image)

# Basic glossary

*   UUID: Universally unique identifier. It's a long string of characters that XenServer, in this case, will use to uniqely identify a particular object. You can read more at [http://en.wikipedia.org/wiki/UUID]()
*   Host: the machine that runs XenServer
*   Guest: virtual machines that run within the XenServer process
*   Dom0: A virtual machine that represents the XenServer host
*   VBD: Virtual Block Device, a way to connect a VDI to a virtual machine
*   VDI: Virtual Disk Image, an image or file that represents a virtual hard disk.

# How to do it

These instructions are for mounting a guest VM's hard drive, stored in the VDI format on the host.

 1. Get the UUID of the Dom0 machine (the host) with
    ```bash
    xe vm-list
    ```
 1. Get the UUID of the VDI (the virtual disk hooked up to the VM) with  
    ```bash
    xe vm-disk-list --multiple
    ```
 1. Create a new VBD to plug the virtual disk into the host machine (Dom0) with
    ```bash
    xe vbd-create \
      device=0 \
      vm-uuid=<uuid-of-dom0> \
      vdi-uuid=<uuid-of-the-vm-disk> \
      bootable=false \
      mode=RW \
      type=Disk
    ```
 1. The previous command would've returned a UUID. This is the UUID of the newly created VBD. Now we need to plug the newly created VBD in with
    ```bash
    xe vbd-plug \
      uuid=<uuid-of-new-vbd-returned-from previous-command>
    ```

The trick is that `Dom0` represents the host machine but behaves exactly like a virtual machines so we simply need to create a new VDB that allows a disk image (VDI) to be connected to that machine. The same method works when connecting a VDI to any other guest.

# What now?

You should be able to see the disk just like you would with any other physical disk attached to the host, so running something like:
```bash
df -h
```
...should list all the disks attached to the machine and you can then use something like this to mount the disk to a mount point (note you might need to be superuser for this):
```bash
mount /dev/sdb1 /mnt/point
```
