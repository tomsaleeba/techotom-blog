---
layout: post
title: My workstation setup
author: Tom Saleeba
excerpt: #%excerpt here%
---

# Extra packages:
 - openconnect
 - sqlite3
 - virtualbox-5.1 (from [https://www.virtualbox.org/wiki/Linux_Downloads#Debian-basedLinuxdistributions]())
   - extensions pack
 - dropbox
   - python-gpgme
 - fish
   - oh my fish
   - bobthefish
   - [https://github.com/ryanoasis/nerd-fonts/releases/download/v1.0.0/Meslo.zip](Meslo LG S Nerd Font) (install to `~/.local/share/fonts/`)
 - vscode
   - chenxsan.vscode-standardjs
   - ow.vscode-subword-navigation
   - robertohuertasm.vscode-icons
 - gparted
 - yarn
    - curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -; and echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list; and sudo apt-get update; and sudo apt-get -y install yarn
 - nvm (for NodeJS)
    - `curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash` or whatever the [https://github.com/creationix/nvm#install-script](latest) is
    - `omf install nvm` to get fish NVM support
    - `nvm install 6.10`

# VSCode user config
Edit the `~/.config/Code/User/settings.json` file with:
{% highlight json %}
    {
      "editor.tabSize": 2,
      "window.zoomLevel": 0,
      "terminal.integrated.fontFamily": "'MesloLGS Nerd Font'"
      "workbench.iconTheme": "vs-seti",
      "editor.minimap.enabled": false,
      "standard.options": {
        "globals": [
          "$",
          "jQuery",
          "fetch",
          "angular",
          "describe",
          "it",
          "expect",
          "fail"
        ],
        "ignore": [
          "node_modules/**"
        ]
      },
      "standard.autoFixOnSave": true
    }
{% endhighlight %}

Edit the `~/.config/Code/User/keybinding.json` file with:
{% highlight json %}
[
  {
    "key": "ctrl+d",
    "command": "editor.action.deleteLines",
    "when": "editorTextFocus"
  },
  {
    "key": "shift+alt+left",
    "command": "editor.action.smartSelect.grow",
    "when": "editorTextFocus"
  },
  {
    "key": "shift+alt+right",
    "command": "editor.action.smartSelect.shrink",
    "when": "editorTextFocus"
  },
  {
    "key": "ctrl+.",
    "command": "editor.action.marker.next",
    "when": "editorFocus"
  },
  {
    "key": "ctrl+shift+s",
    "command": "workbench.action.files.saveAll",
    "when": "editorFocus"
  },
  {
    "key": "ctrl+left",
    "command": "subwordNavigation.cursorSubwordLeft",
    "when": "editorTextFocus"
  },
  {
    "key": "ctrl+right",
    "command": "subwordNavigation.cursorSubwordRight",
    "when": "editorTextFocus"
  },
  {
    "key": "ctrl+shift+left",
    "command": "subwordNavigation.cursorSubwordLeftSelect",
    "when": "editorTextFocus"
  },
  {
    "key": "ctrl+shift+right",
    "command": "subwordNavigation.cursorSubwordRightSelect",
    "when": "editorTextFocus"
  },
  {
    "key": "alt+left",
    "command": "workbench.action.navigateBack"
  },
  {
    "key": "ctrl+alt+-",
    "command": "-workbench.action.navigateBack"
  },
  {
    "key": "alt+right",
    "command": "workbench.action.navigateForward"
  },
  {
    "key": "ctrl+shift+-",
    "command": "-workbench.action.navigateForward"
  },
  {
    "key": "ctrl+shift+x",
    "command": "editor.action.transformToUppercase"
  }
]
{% endhighlight %}

# TL;DR
summary here

# Background
what's the situation?

# The problem
what's the specific problem?

# The solution
how'd you fix it?