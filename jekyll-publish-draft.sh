#!/usr/bin/env bash
if [ -z "$1" ]; then
  echo "[ERROR] you must supply a draft post path"
  echo "usage: $0 _drafts/my-new-draft.md"
  exit 1
fi
docker run \
 --rm \
 --label=jekyll \
 --volume=$(pwd):/srv/jekyll \
 -it \
 -p 127.0.0.1:4000:4000 \
 jekyll/jekyll \
 jekyll publish $1

