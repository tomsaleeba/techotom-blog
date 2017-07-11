#!/usr/bin/env bash
# Installs Jekyll and all requirements on your local (Ubuntu 16.04) machine. Might work with other versions too
echo 'set -gx GEM_HOME "$HOME/.gems"' >> ~/.config/fish/config.fish
echo 'set -gx PATH "$HOME/.gems/bin" $PATH' >> ~/.config/fish/config.fish
source ~/.config/fish/config.fish
sudo apt-get -y install ruby-dev zlib1g-dev
gem install jekyll bundler
bundle install
echo "run: bundle exec jekyll serve # to run locally"