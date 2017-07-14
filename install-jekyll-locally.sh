#!/usr/bin/env bash
# Installs Jekyll and all requirements on your local (Ubuntu 16.04) machine. Might work with other versions too
set -e
cd `dirname $0`
fishconfig=~/.config/fish/config.fish
bashconfig=~/.bash_profile
echo 'Updating shell config'
grep --quiet 'set -gx GEM_HOME' $fishconfig || printf '\nset -gx GEM_HOME "$HOME/.gems"'         >> $fishconfig
grep --quiet 'export GEM_HOME'  $bashconfig || printf '\nexport GEM_HOME="$HOME/.gems"'          >> $bashconfig
grep 'set -gx PATH' $fishconfig | grep --quiet 'gems' || printf '\nset -gx PATH "$HOME/.gems/bin" $PATH\n' >> $fishconfig
grep 'export PATH'  $bashconfig | grep --quiet 'gems' || printf '\nexport PATH="$HOME/.gems/bin:$PATH"\n'  >> $bashconfig
echo 'Reloading shell config'
source ~/.bash_profile
echo 'Installing required packages for ruby'
sudo apt-get -y install ruby-dev zlib1g-dev
echo 'Installing jekyll'
gem install jekyll bundler
echo 'Installing gems required by jekyll'
bundle install
echo 'Done, you can now run: bundle exec jekyll serve # to run locally'
