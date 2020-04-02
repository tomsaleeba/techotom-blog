---
categories:
- Linux
date: "2016-05-31T03:00:40Z"
title: Can't rename files in Linux Mint using Nemo
aliases:
- /linux/2016/05/31/cant-rename-files-in-linux-mint-using-nemo.html
---
# TL;DR:

I installed Zoom which brought ibus in as a dependency. During a dist-update
ibus was set to my main input method and it doesn't work well (for me). Use the
Input Method app to set the input method back to XIM and restart the display
manager.

# Background:

I'm running Linux Mint 17.1 and I recently experienced the same issue described
in this
thread: [https://forums.linuxmint.com/viewtopic.php?t=171086](https://forums.linuxmint.com/viewtopic.php?t=171086).
Basically, I could press F2 to rename a file using Nemo, the out-of-the-box file
manager but then I typing would have no effect. All permissions were OK as I
could rename the file from the terminal so it was a problem with the UI.

I was having some other problems too:

*   I couldn't find files in Nemo by typing the start of the file name
*   some keyboard shortcuts like launching the calculator or locking the screen no longer worked, and
*   a few other apps weren't responding to tab and enter key presses like they used to.

I had recently done a dist-upgrade so I was worried that something had broken
because of that. I had installed Zoom (a web-meeting client, not important for
this though) before the upgrade but my system was still working fine. Zoom
depends on the ibus package and during the upgrade, my input method must've been
updated to start using ibus. I also got  a new system tray icon for ibus: a
black keyboard with a transparent background

{{< figure src="ibus-icon.png" alt="ibus icon" >}}

# The fix:

I don't need to use languages other than English and it seems the reason to use
ibus is for other languages. This means the fix for me was to swap from ibus
back to whatever I had before, because that worked well. Note that I couldn't
uninstall ibus because Zoom depends on it.

I used the Input Method app that you can find in the applications menu:

{{< figure src="selection_012.jpg" >}}

1.  I pressed OK to the first dialogue
2.  Then I selected **Yes** on the second dialogue because I do want to select a new method
3.  And finally I selected XIM as the input method, the good old trusty one

{{< figure src="input-method-configuration-im-config-ver-0-24-1ubuntu4-2_013.jpg" alt="Input Method Configuration (im-config, ver. 0.24-1ubuntu4.2)_013" >}}


Once you press OK, you're told what to do next but basically, you have to
restart the display manager. You can restart the machine or in a terminal run:
```bash
sudo service mdm restart
```
You should have a working system back.
