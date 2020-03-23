---
author: Tom Saleeba
date: "2018-02-21T00:00:00Z"
summary: Get that newly provisioned VM running like you want.
tags:
- cloud
title: eRSA Tango Ubuntu VM setup
---
# Some background
I've just started playing with [eRSA's Tango cloud](https://www.ersa.edu.au/service/cloud/tango-cloud/) and found that a fresh Ubuntu VM isn't the same as what I'm used to when launching something on OpenStack or AWS. I'll run through each issue I found and how I fixed it.

# Connecting to the VM
This is a good first step. In the OpenStack or AWS EC2 worlds, you'll be used to setting up a keypair and using a `.pem` file to authenticate when connecting via SSH. Tango is different, it uses your username and password for your eRSA account. These are the details that you used to login to the Tango dashboard. You'll connect with something like
```bash
ssh <username>@<ip address>
# assuming username = bob and IP address = 11.22.33.44
ssh bob@11.22.33.44
```

# Changing from password auth to `.pem` auth
You need a public/private key pair for this step. If you don't have one, you can read how to get one over at [DigitalOcean](https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys--2). If you follow their guide, we're talking about the `id_rsa.pub` file in their guide.

First, copy the contents of your public key file to your clipboard, then we'll connect via SSH and add it to the VM's trusted keys
```bash
ssh <username>@<ip address> # SSH to the VM, using your password
touch ~/.ssh/authorized_keys # create the file if it doesn't exist
nano ~/.ssh/authorized_keys # edit the file
```
Now paste the contents of your public key (`id_rsa.pub`) onto a new line in this `authorized_keys` file. The line will start with something like: `ssh-rsa AAAAC...`. Save and exit the editor, `Ctrl+x` will do this, answer `y` to save the file and exit.

Now we'll disable password authentication to force use of the public/private keys.
```bash
sudo nano /etc/ssh/sshd_config # open editor
```
Change `PasswordAuthentication` from `yes` to `no` and uncomment the line (remove the leading `#`).
```bash
PasswordAuthentication no
```

Open a new terminal for the next bit, it can't hurt to leave the existing SSH session connected in case you've locked yourself out of new connections.
```bash
# SSH to the VM, using your private key
ssh -i ~/.ssh/id_rsa <username>@<ip address>
```
If it connected, you've successfully set it up.

# No password for `sudo`
Even after we've set up `.pem` auth for SSH, you'll still be prompted for your password every time you need to sudo (or every 10 minutes at least). You can stop this with the following
```bash
# ssh to the VM
sudo visudo # this is the last time you'll need to use your password ;)
```
Then add a line to this file with the following format
```
<username> ALL=(ALL) NOPASSWD: ALL
```
Just replace `<username>` with your username. You can get that by running `id -un`. Save and exit the editor (`Ctrl+x`). Now run a test command to make sure you don't get prompted for a password
```bash
sudo ls
```

# Change your default shell
The default shell for me was `/dev/tcsh`. That might be your thing but assume you want to change it to good old bash. Normally you could use `chsh` to change your shell but that will (likely) fail
```bash
$ chsh
Password: 
Changing the login shell for user1
Enter the new value, or press ENTER for the default
	Login Shell [/bin/tcsh]: /bin/bash
chsh: user 'user1' does not exist in /etc/passwd
```
The error message makes a valid point, we aren't in `/etc/passwd` because ActiveDirectory powers our auth.

A very useful [answer](https://serverfault.com/a/742130/265053) at serverfault.com gives the solution to this.

>     getent passwd USERNAME
> This will have the valid entry equivalent for your user in /etc/passwd, take this, paste it in to /etc/passwd and update the shell at the end for the valid path of the shell you want to use. This way it doesn't change it for all users, and you can make sure that shell is on the machine you're configuring this on before making the change.

We can chain that command into tee so we can append it to `/etc/passwd` with the following
```bash
getent passwd `id -un` | sudo tee -a /etc/passwd
```

Now we can run our command to change shell
```bash
chsh
```
...or you could just edit the `/etc/passwd` file directly to change your shell.

You'll need to exit your SSH session and connect again to see your new default shell.
