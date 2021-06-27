This is the source code for my personal blog: https://blog.techotom.com/

# Development

## Create a new post
```bash
hugo new post/$(date +'%Y-%m-%d')-some-post-title.md
```

## Start server
```bash
hugo server --buildDrafts
```

## Resize and EXIF-scrub all images in directory
```bash
for curr in *.jpg; do ../../../scrub-and-resize-image.sh $curr; done
```

## Emoji
We have emoji support. Use the [GitHub
codes][https://www.webfx.com/tools/emoji-cheat-sheet/] like `:blush:`.
