---
categories:
- IT
- Virtualisation
date: "2012-09-22T01:19:45Z"
summary: How to eject an ISO when you only have the command line (no GUI).
tags:
- virtualbox
title: Ejecting an ISO from a VirtualBox VM using VBoxManage
---
# The problem

You've connected an ISO to your vm already and now you want to leave the drive connected to the controller but eject the medium from it. This isn't a particularly challenging problem but it wasn't immediately apparent to me so hopefully this saves someone else some time.

# How-To

 1. Let's make sure we get all the right details for the command first up, so we want to look at the info about our vm. All you need to know at this stage is the name or the UUID of the vm. The information we're looking for is the name of the controller, the port on the controller and the device number of the CD/DVD drive.  
    This is the format of the command:  
    `$ VBoxManage showvminfo <name|uuid>`  
    So as an example, when my vm is named "xp", we'd do this (I prefer names to UUIDs):
    ```bash
    $ VBoxManage showvminfo "xp"
    _...unimportant stuff ommitted..._
    Storage Controller Name (0):IDE Controller
    Storage Controller Type (0): PIIX4
    Storage Controller Instance Number (0): 0
    Storage Controller Max Port Count (0): 2
    Storage Controller Port Count (0): 2
    Storage Controller Bootable (0): on
    IDE Controller (0, 0): /path/to/hdd.vdi (UUID: 00000000-0000-0000-0000-000000000000)
    IDE Controller (0, 1): /usr/share/virtualbox/VBoxGuestAdditions.iso (UUID: 4bbb3ddf-b5f2-47ae-92f5-fbc23a304fae) // this is the important stuff
    _...unimportant stuff ommitted..._
    ```
    The information we get from this is the controller's name is `IDE Controller`, the port on the controller is `0` and the device number on the port is `1`.

 2. We then use these values that we found in the command to eject the disc or make the drive empty. This is the format that we use (the `\` lets you continue commands on a new line):
    ```bash
    $ VBoxManage storageattach "<vm name>" \
      --storagectl "<storage controller name>" \
      --port <port number on controller> \
      --device <device number on port> \
      --medium emptydrive
    ```
    So for my "xp" vm and using the values I found in the previous step, I would run:
    ```bash
    $ VBoxManage storageattach "xp" \
      --storagectl "IDE Controller" \
      --port 0 \
      --device 1 \
      --medium emptydrive**
    ```

 3. If the command ran successfully, there won't be any output to the console. You can double check that it worked by running the showvminfo command again and checking to see that the device is now empty:
    ```bash
    $ VBoxManage showvminfo "xp"**
    _...unimportant stuff ommitted..._
    Storage Controller Name (0): IDE Controller
    Storage Controller Type (0): PIIX4
    Storage Controller Instance Number (0): 0
    Storage Controller Max Port Count (0): 2
    Storage Controller Port Count (0): 2
    Storage Controller Bootable (0): on
    IDE Controller (0, 0): /path/to/hdd.vdi (UUID: 00000000-0000-0000-0000-000000000000)
    IDE Controller (0, 1): Empty // yay, it's empty!
    _...unimportant stuff ommitted..._
    ```

# Errors you might encounter
```
VBoxManage: error: No DVD/Floppy Drive attached to the controller 'IDE Controller'at the port: 1, device: 0
```
If you get an error like this, make sure that you didn't get the port and device numbers around the wrong way. The example I've got here is because I should have used `port = 0` and `device = 1`. In fact, on my VM, there isn't anything plugged into port `1` at all.

Credit to [https://forums.virtualbox.org/viewtopic.php?f=6&t=46265]().
