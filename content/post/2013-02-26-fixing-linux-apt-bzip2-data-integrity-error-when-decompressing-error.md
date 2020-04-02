---
categories:
- IT
- Linux
date: "2013-02-26T01:27:28Z"
summary: How to clear the APT cache to fix failing updates.
title: 'Fixing linux apt "bzip2: Data integrity error when decompressing." error'
aliases:
- /it/linux/2013/02/26/fixing-linux-apt-bzip2-data-integrity-error-when-decompressing-error.html
---
# Background

I came across this problem when I was setting up a new box with Linux Mint 13 Cinnamon (64-bit). This machine lives in a corporate type environment and needs to have a proxy configured to have internet access so I suspect that some incorrect proxy settings could've caused this scenario.

# The symptoms

Here's the output (with boring bits removed) that I got from running `sudo apt-get update`:
```
...snip...
Get:1 http://archive.canonical.com precise/partner i386 Packages [6,030 B]
100% [1 Packages bzip2 15.0 kB] [Waiting for headers] [Waiting for headers] [Waiting for headers] [Waiting for headers]
bzip2: Data integrity error when decompressing.
Input file = (stdin), output file = (stdout)  

It is possible that the compressed file(s) have become corrupted.
You can use the -tvv option to test integrity of such files.  

You can use the `bzip2recover' program to attempt to recover
data from undamaged sections of corrupted files.  

Hit http://security.ubuntu.com precise-security/universe amd64 Packages
...snip...
Err http://archive.canonical.com precise/partner i386 Packages
404 Not Found
Hit http://archive.ubuntu.com precise/main i386 Packages
...snip...
Ign http://packages.medibuntu.org precise/non-free Translation-en_AU
Get:2 http://archive.ubuntu.com precise/multiverse Translation-en_AU [113 kB]
Ign http://packages.medibuntu.org precise/non-free Translation-en
Fetched 2 B in 18s (0 B/s)
W: Failed to fetch http://archive.canonical.com/ubuntu/dists/precise/partner/binary-i386/Packages 404 Not Found  

W: Failed to fetch gzip:/var/lib/apt/lists/partial/archive.ubuntu.com_ubuntu_dists_precise_multiverse_i18n_Translation-en%5fAU Encountered a section with no Package: header  

E: Some index files failed to download. They have been ignored, or old ones used instead.
```
You'll notice the second to last line speaks about a local path, which made me think that the issue is with some data that we've cached locally and it's not being overwritten with fresh stuff.

# The fix

The fix is to delete (or rename) the cached data that apt keeps so it'll refresh everything. I found there's two locations that needed to be deleted/renamed:  
`/var/lib/apt`  
`/var/cache/apt`

Then run `sudo apt-get update` to get fresh copies of all the indexes, etc.

You should be good to go :D
