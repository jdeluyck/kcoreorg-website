---
title: A new theme
date: 2026-03-15
categories: [Life & Musings, Site Updates]
tags:
  - blog
  - kcore.org
  - static
  - jekyll
  - site
  - chirpy
  - minimal mistakes
---

My static blog to-do list kept growing, so I decided to do something about it.

I've switched from [Minimal Mistakes](https://github.com/mmistakes/minimal-mistakes/) to [Chirpy](https://chirpy.cotes.page/) as a theme, because it offers built-in dark/light theme support and has share-to-Mastodon functionality. At the same time I've done some spring cleaning in my posts - moved some really old stuff off to the side.

In the end it was more work than I had anticipated:

* Re-categorising everything since I had conflated tags and categories with Minimal Mistakes - it is a lot more forgiving and you can add as many categories as you want, but Chirpy doesn't work that way
* Figuring out how to add a custom font to have my CodeBerg icon
* Reworking the `feed.xml` file so the output is more like what Minimal Mistakes generates - avoiding RSS readers to mark the old posts as new
* Cleaning out the [front matter](https://jekyllrb.com/docs/front-matter/) which contained left-overs from my [wordpress to jekyll migration](/2019/06/26/a-new-home/)
* Adjusting the markdown heading level so it shows up properly in the table of content
* Linted everything using [rumdl](https://rumdl.dev)
* Implemented some quality of viewing things of Chirpy
* Replaced a bunch of dead links with links to the [Internet Archive](https://archive.org) [Wayback Machine](https://web.archive.org/)
* Probably some other stuff that I forgot about

I'm happy with the end result. If you're reading this via RSS, you shouldn't notice much ;)
