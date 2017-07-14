#!/usr/bin/env bash
cd `dirname $0`
echo "Serving WITH DRAFTS"
bundle exec jekyll serve --drafts
