---
date: "2017-09-28T00:00:00Z"
summary: How to connect to Adelaide University's VPN using openconnect from the command
  line in *nix based systems now that they're introduced 2FA using Duo.
tags:
- adelaide university
- openconnect
- linux
- duo
- 2fa
title: Adelaide University VPN, Openconnect and Duo
---

# The backstory

Adelaide University recently introduced two factor authentication (2FA) on their VPN using Duo. Previously you could connect to the VPN using `openconnect` on *nix systems and it worked fine. Now that there's 2FA, you need to slightly change how you connect.

I'm running on Linux Mint 18 using openconect v7.06 in case you're looking at this years in the future and versions matter.

Big thanks to [https://dmoerner.wordpress.com/2015/11/04/howto-openconnect-vpn-with-duo-multifactor-authentication/]() for explaining the double password prompt. This post is just explaining Daniel's work for the command line.

# The fix

This assumes that you've already installed the Duo 2FA app on your phone ([https://www.adelaide.edu.au/technology/selfhelp/docs/diy-android-allos-2favpn.pdf]()) and that you've set it up.

You still run the same command that you would have previously:
```bash
sudo openconnect \
  -b \
  -u <your a-number> \
  vpn.adelaide.edu.au
```

...then you'll be prompted to enter your password but once you've entered it, you'll be prompted a second time for `password`. This second prompt is actually asking you what 2FA method you would like to use. You'll want to use `push` most likely to have it send the prompt to your Duo app on your mobile. You can see a bit more discussion about available methods on the [Duo site](https://duo.com/docs/openvpn):

> Users will provide a passcode or factor identifier (eg. "push", "phone", "sms") as their OpenVPN password.

See the output from the previous command with two password prompts.
```
POST https://vpn.adelaide.edu.au/
Attempting to connect to server 129.127.45.49:443
SSL negotiation with vpn.adelaide.edu.au
Connected to HTTPS on vpn.adelaide.edu.au
XML POST enabled
Please enter your username and password.
Password:
Password:
POST https://vpn.adelaide.edu.au/
Got CONNECT response: HTTP/1.1 200 OK
CSTP connected. DPD 30, Keepalive 20
```

You should get a prompt on your phone from the Duo app, which you can confirm, then the connection will (should) complete and you're connected.
