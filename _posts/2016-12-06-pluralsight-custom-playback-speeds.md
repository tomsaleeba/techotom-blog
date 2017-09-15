---
layout: post
title: PluralSight custom playback speeds
date: 2016-12-06 04:21:48 +0930
categories:
  - Software Development
author: Tom Saleeba
excerpt: Learn even faster by watching videos at faster than 2x playback speed.
---
**Edit 10 April 2017**: there's now a GitHub repo for this script at https://github.com/tomsaleeba/custom-pluralsight-playback-speed and it contains the fix for the new player released over the past few days. They changed `playbackSpeed` to `playbackRate` and it's no longer multiplied by 10.

**Edit 13 Feb 2017**: added instructions on how to use the script

I've been getting into PluralSight recently and I think it's pretty great. As of writing this (Dec 2016) the player has a widget to adjust playback speed but it won't go any higher than 2.0x. For me, I need it to go a bit higher on some videos.

I contacted them to ask about getting more speeds added to the widget or telling me how to do it in the developer tools myself but they weren't keen on either, so *puts hacker hat on*.

The current playback speed is stored in the browser's **Local Storage** under the key `playbackSpeed`. You can adjust this value really easily in the developer console of your browser like you would for any value:
```javascript
localStorage.setItem("playbackRate",  2.1);
```
You need to pause and unpause the player to make that take effect. You can achieve this programatically with:
```javascript
document.getElementById('play-control').click();
document.getElementById('play-control').click();
```

That's the basics of it. Of course it's nice to have a UI with your own custom speeds on it so I wrote the following Grease/Tamper Monkey script to add a div over the video, populate it with some custom speeds and bind the click events to make the change for me. Yeah, it looks horrible but I'm the type of person that watches videos faster than 2x (sometimes at least) so ain't nobody got time for styling.

### Note about using the script

This is a script for [Tampermonkey for Google Chrome](https://tampermonkey.net/) or presumably [Greasemonkey for Firefox](https://addons.mozilla.org/en-US/firefox/addon/greasemonkey/) although I haven't tested that. The steps below are asking you to install my script in your browser so it can run on the PluralSight video player. All the code is there so you can audit it but if you're security conscious and don't trust me, don't install the script. In order to use it:

 1. install the appropriate add-on for your browser, either Tampermoney or Greasemonkey
 1. open the dashboard for the add-on
 1. create a new, empty script (as if you were about to write your own)
 1. copy and paste my follow script into the editor (overwrite everything already there)
 1. save the script
 1. go to PluralSight and start a video
 1. enjoy custom playback speeds

### The script
```javascript
// ==UserScript==
// @name PluralSight custom speeds
// @namespace http://techotom.wordpress.com
// @version 0.2
// @description more fasterer
// @author Tom
// @match https://app.pluralsight.com/player*
// @grant none
// ==/UserScript==

(function() {
    'use strict';

    var console = console || {};
    var className = 'speed-selector';
    function resetBoldness() {
        var speedSelectors = document.getElementsByClassName(className);
        for (var i = 0;i &lt; speedSelectors.length;i++) {
            var curr = speedSelectors[i];
            curr.style.fontWeight = 'normal';
        }
    }

    function appendSpeedControl(div, speed) {
        var speedAnchor = document.createElement("a");
        speedAnchor.style.display = "block";
        speedAnchor.style.cursor = "pointer";
        speedAnchor.onclick = function() {
            localStorage.setItem("playbackRate", (speed));
            document.getElementById('play-control').click();
            document.getElementById('play-control').click();
            resetBoldness();
            this.style.fontWeight = "bold";
        };
        speedAnchor.classList.add('speed-selector');
        var label = document.createTextNode(speed + "x");
        speedAnchor.appendChild(label);
        div.appendChild(speedAnchor);
    }

    var body = document.getElementsByTagName('body')[0];
    var div = document.createElement("div");
    div.style.position = "fixed";
    div.style.margin = "1em";
    div.style.fontSize = "1.5em";
    div.style.background = "#FFF";
    div.style.zIndex = "2";
    div.style.width = "3em";
    div.style.marginTop = "6em";
    div.style.opacity = ".5";
    appendSpeedControl(div, 1);
    appendSpeedControl(div, 1.2);
    appendSpeedControl(div, 1.3);
    appendSpeedControl(div, 1.5);
    appendSpeedControl(div, 1.7);
    appendSpeedControl(div, 1.8);
    appendSpeedControl(div, 2);
    appendSpeedControl(div, 2.1);
    appendSpeedControl(div, 2.2);
    appendSpeedControl(div, 2.5);
    appendSpeedControl(div, 2.7);
    appendSpeedControl(div, 3);
    body.insertBefore(div, body.childNodes[0]);
})();
```
