---
author: Tom Saleeba
categories:
- Software Development
date: "2013-12-09T09:45:31Z"
title: How to time-hack TinyDeathStar without losing a Bitizen to the airlock
---
Note: this was done on a rooted Android. It may work on Apple devices but you definitely require root on Android.

**Background**

I've become a bit addicted to this game and in the course of playing it, I've had it rip me off a few times. This happened when I'd open the game after, it'd been sitting for a while, but then it would crash a few seconds after and when I relaunched it, the extra money I'd earned wouldn't be there.

I've found the best way to avoid this is to kill the game's task before launching it. But, back to the topic at hand, I was feeling like the game owed me something so after looking up some cheats I found a few hack programs that I didn't totally trust and a mention of the time hack but also of the penalty that comes along with it.

**What is the time hack?**

The time hack is where you set some tasks going in the game, close the game, set your device's time forward (by at least the amount the task was going to take) and then open to game to find it all done. This is all fine but when you set the time back and open the game, it will inform you that one of your Bitizens has been lost in an airlock accident.

**How to avoid the airlock accident**

You need to open the following file in a text editor:
```
/data/data/com.lucasarts.tinydeathstar_goo/app_data/UserDefault.xml
```
Then find the `<resignTime>` tag and copy the content of it to somewhere safe. This field is a milliseconds since the epoch value and seems to be what the game checks to see if time has gone backward i.e. system time < resignTime. Now that you have this value saved, you can do the time hack as many times as you want and when you're ready to set your device's time back to the real time, overwrite the value in `<resignTime>` with the value you saved before you open the game and you won't be penalised.
