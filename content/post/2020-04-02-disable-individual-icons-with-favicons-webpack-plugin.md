---
title: "Disable individual icons with favicons-webpack-plugin"
date: 2020-04-02T16:37:59+11:00
summary: "If you only want to disable some icons, like the really big Apple ones, here's how"
tags:
- js
- webpack
---
I'm using `favicons-webpack-plugin` as part of my project to generate all the
favicons I could ever what from a single source image. It works great. Some of
the icons it generates are quite large though. I mean, they're as big as they
should be but they're over 1000px in each dimension so they're a few hundred
kilobytes each.

I'm using workbox to generate a precache manifest for the project and all of
these icons get included in the manifest, so I'm making client download all of
the icons in all size no matter what platform they on.

So I had the smart idea to just kill off some of the larger icons. As I write
this, with the benefit of hindsight, I can say this was the wrong approach. The
right approach, and the one I ended up taking was to exclude *all* the icons
from the precache manifest.

However, I don't want my work in figuring this out to go completely to waste so
it's going to live on in this blog post.

I didn't get a full solution but I did manage to exclude any icons I didn't
want. I achieved this by importing the `favicons` module into my script and
directly modifying the config property on it. It's probably worth noting here
that `favicons-webpack-plugin` uses `favicons` internally and we can do this
trick because all modules are singletons (I think, or at least they behave like
it) so modifying it here also takes effect inside the plugin.

The bit I didn't get working was to also exclude the fragments that will
injected into the HTML. They live
[here](https://github.com/itgalaxy/favicons/blob/9fa4945/src/config/html.js) and
you'll see they're all functions so they'll be a bit harder to filter. If I had
to tackle this, I would:
  1. iterate over the root object
  1. reduce each of the child arrays
  1. inside the reducer, I'd call each function and inspect the result for names
     I'd already excluded from the `icons`
  1. assign the result of the reducer to the key in the object
  1. profit

```javascript
const path = require('path')
const FaviconsWebpackPlugin = require('favicons-webpack-plugin')
const favicons = require('favicons')

;(function dontGenerateLargeFavicons() {
  // these icons get precached by our service worker and bloat everything.
  // That's not cool
  delete favicons.config.icons.appleIcon['apple-touch-icon-1024x1024.png']
  delete favicons.config.icons.appleStartup[
    'apple-touch-startup-image-1536x2008.png'
  ]
  delete favicons.config.icons.appleStartup[
    'apple-touch-startup-image-1496x2048.png'
  ]
  delete favicons.config.icons.appleStartup[
    'apple-touch-startup-image-1242x2148.png'
  ]
  delete favicons.config.icons.appleStartup[
    'apple-touch-startup-image-1182x2208.png'
  ]
  delete favicons.config.icons.appleStartup[
    'apple-touch-startup-image-748x1024.png'
  ]
  delete favicons.config.icons.appleStartup[
    'apple-touch-startup-image-768x1004.png'
  ]
  delete favicons.config.icons.appleStartup[
    'apple-touch-startup-image-750x1294.png'
  ]
  delete favicons.config.icons.appleStartup[
    'apple-touch-startup-image-640x1096.png'
  ]
  delete favicons.config.icons.appleStartup[
    'apple-touch-startup-image-640x920.png'
  ]
  delete favicons.config.icons.firefox['firefox_app_512x512.png']
  delete favicons.config.icons.android['android-chrome-512x512.png']
})()

// FIXME still need to exclude corresponding parts of favicons.config.html

module.exports = {
  configureWebpack: {
    plugins: [
      new FaviconsWebpackPlugin({
        logo: './src/assets/icon-seed-white.png',
        inject: true,
        devMode: 'webapp',
        prefix: 'img/icons/',
        favicons: {
          theme_color: '#5683BA',
          background: '#000', // background of flattened icons
          appName: 'Uber Awesome App',
          appShortName: 'UberAwesomeApp',
          appDescription:
            'something, blah blah',
          appleStatusBarStyle: 'default',
          developerName: null,
          developerURL: null,
          start_url: '/index.html',
        },
      }),
    ],
  },
}
```
