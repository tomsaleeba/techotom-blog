---
author: Tom Saleeba
categories: android
date: "2017-03-17T11:55:43Z"
summary: Work around this annoying notification by manually enabling the permission
  from the settings menu.
title: Alternative way to fix the "Screen Overlay Detected" error on Android
---
# TL;DR Summary

Manually enable the permissions through the “Apps” menu of the Android settings.

# The problem

You’re trying to run a new app for the first time and it’s asking you to allow (or deny) a specific permission. When you tap “Allow”, you get the error message “Screen Overlay Detected” and it doesn’t let you “Allow” the permission.

There are a heap of articles on the net about how to fix the problem, such as: <https://www.howtogeek.com/271519/how-to-fix-the-screen-overlay-detected-error-on-android/>. I found that this method of going through and disallowing the overlay permission for all my apps isn’t very fun but it also didn’t work. I still couldn’t allow the permission! I kept getting the same error. Super frustrating :frowning:

# The solution

An easier way, and one that actually worked in my situation, is to manually enable the permission(s) for the app in question. The linked HowToGeek article above gives great instructions on how to get to the “Apps” menu for various Android flavours but I’ll give generic instructions here:

 1. Close the app that is asking for the permission
 1. Open the Android settings
 1. Open the Apps menu
 1. Find your App in the list and tap on it
 1. Open the “Permissions” menu
 1. Enable the permission that you were asked about before the “Screen overlay error” happened. You might want to enable more than one permission because presumably you’ll not be able to Allow any other when prompted in the future without the same overlay error.
 1. Close the menu
 1. Open your app again

This has the benefit of not having to manually disallow and then re-allow a possibly huge number of apps from having the screen overlay permission. Or in my case, even after doing that, it still didn’t help.
