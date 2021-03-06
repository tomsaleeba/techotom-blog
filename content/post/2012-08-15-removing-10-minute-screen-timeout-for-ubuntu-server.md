---
categories:
- Linux
date: "2012-08-15T01:59:47Z"
title: Removing 10 minute screen timeout for Ubuntu Server
aliases:
- /linux/2012/08/15/removing-10-minute-screen-timeout-for-ubuntu-server.html
---
# The problem

My situation is that I run an Ubuntu Server for normal server-like tasks; web server, file server, etc. I decided to install XMBC on it so I could make it into a HTPC because after all, it already had all my media stored on it. Installing XMBC meant that I also had to install Xserver and along with that install, I scored some defaults for screen saver timeout and monitor timeout (all set to 10 minutes) and this really sucks when you're watching a movie and even 10 minutes the display would turn off unless you gave some input (keyboard, mouse, remote). This guide will show how I fixed it.

# The solution

The magic tool that will help us here is called `xset`, that according to its man pages says it's a _user preference utility for X_. By default it seems to operate on the current X display so if you're doing all these commands on the actual machine, you should be able to get away without the `-display :0` bits that I have in all my commands although leaving them in there won't hurt. The reason that I needed to have them is because I'm SSHing into the server and your SSH session has no X display so you must explicitly state it. For more information on displays, have a look at the section titled _DISPLAY NAMES_ under the man X(7) pages.

The overview of what we're going to do is check to see what the preferences are currently set to and then set them to a value that means the display will never timeout. This is probably a bad thing if your box has a monitor permanently attached to it but I use a TV as my monitor so it gets turned off separately from the server (which never gets turned off).

Note that I've bolded the commands that I submit and if you copy and paste them, be sure to leave off the starting dollar sign ($).

**Update 23 August 2012:** I found that setting the display to never turn off made the UI of XBMC slow down to a snail's pace. I suspect it's the rubbish video card that I have but I fixed the problem by setting the timeout to 3hrs so it effectively never turns off while I'm using it (unless you watched something for longer than 3hrs without pressing anything on the remote/keyboard/mouse) but it will turn off eventually. Now the UI performs as normal. Experiment and see what works for you.

 1. First we need to check where we're starting from by having a look at what the preferences currently are. The important bits are highlighted in <span style="color:#ff0000;">red</span>. We can see that we have a screen saver that is set to come on after 600 seconds and that DPMS is enabled and set to standby, suspend and turn off (so ultimately just turn off) the display.

    <pre style="overflow-x:auto;"><strong>$ xset -display :0 q</strong>
    Keyboard Control:
    auto repeat:  on    key click percent:  0    LED mask:  00000000
    XKB indicators:
    00: Caps Lock:   off    01: Num Lock:    off    02: Scroll Lock: off
    03: Compose:     off    04: Kana:        off    05: Sleep:       off
    06: Suspend:     off    07: Mute:        off    08: Misc:        off
    09: Mail:        off    10: Charging:    off    11: Shift Lock:  off
    12: Group 2:     off    13: Mouse Keys:  off
    auto repeat delay:  660    repeat rate:  25
    auto repeating keys:  00ffffffdffffbbf
    fadfffefffedffff
    9fffffffffffffff
    fff7ffffffffffff
    bell percent:  50    bell pitch:  400    bell duration:  100
    Pointer Control:
    acceleration:  2/1    threshold:  4
    Screen Saver:
    prefer blanking:  yes    allow exposures:  yes
    timeout:  <span style="color:#ff0000;">600</span>    cycle:  <span style="color:#ff0000;">600</span>
    Colors:
    default colormap:  0x20    BlackPixel:  0    WhitePixel:  16777215
    Font Path:
    /usr/share/fonts/X11/misc,/usr/share/fonts/X11/75dpi/:unscaled,/usr/share/fonts/X11/Type1,/usr/share/fonts/X11/75dpi,/var/lib/defoma/x-ttcidfont-conf.d/dirs/TrueType,built-ins
    DPMS (Energy Star):
    Standby: <span style="color:#ff0000;">600</span>    Suspend: <span style="color:#ff0000;">600</span>    Off: <span style="color:#ff0000;">600</span>
    DPMS is <span style="color:#ff0000;">Enabled</span>
    Monitor is Off</pre>

 2. So let's start by turning DPMS off:  
    `$ xset -display :0 -dpms`
 3. **Optional:** We've just turned DPMS off so it's timeouts should no longer have any effect but if you really want to kill all those values, use this command:  
    `$ xset -display :0 dpms 0 0 0`
 4. The command(s) that we've run so far don't give any feedback to the user so we run the same command as in the first step to see if our changes have done anything. I ran both commands in steps 2 and 3 so my timeouts are 0 but the really important bit is that DPMS is Disabled as you can see in <span style="color:#ff0000;">red</span>.

    <pre style="overflow-x:auto;"><strong>$ xset -display :0 q</strong>
    _...unimportant stuff ommitted..._
    DPMS (Energy Star):
    Standby: <span style="color:#ff0000;">0</span>    Suspend: <span style="color:#ff0000;">0</span>    Off: <span style="color:#ff0000;">0</span>
    DPMS is <span style="color:#ff0000;">Disabled</span></pre>

 5. Now, we need to disable the screen saver using the following command:

    <pre style="overflow-x:auto;">**$ xset -display :0 s 0 0**</pre>

 6. Again, let's check that it worked and you'll see the two timeout values for the screen saver set to 0 (and highlighted in <span style="color:#ff0000;">red</span>):

    <pre style="overflow-x:auto;">**$ xset -display :0 q**
    _...unimportant stuff ommitted..._
    Screen Saver:
    prefer blanking:  yes    allow exposures:  yes
    timeout:  <span style="color:#ff0000;">0</span>    cycle:  <span style="color:#ff0000;">0</span>
    _...unimportant stuff ommitted..._</pre>

 7. We're done. Your monitor should stay on all the time now. Note that if you ever want to re-enable the timeouts, you can supply a value of your choosing (in seconds) to the commands we used to set the timeouts to zero. You can also turn DPMS back on using the plus sign (+) instead of the minus sign (-) that we used to turn it off in step 2.

As with all commands in linux/unix, if you want more information then the following two commands are your friend:
```bash
$ xset --help
$ man xset
```
