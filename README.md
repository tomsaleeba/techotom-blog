# Create a new post
```bash
hugo new post/some-post-title.md
```

# Start server
```bash
hugo server
```

# Resize and EXIF-scrub all images in directory
```bash
for curr in *.jpg; do ../../../scrub-and-resize-image.sh $curr; done
```

# Emoji
We have emoji support. Use the [GitHub
codes][https://www.webfx.com/tools/emoji-cheat-sheet/] like `:blush:`.
