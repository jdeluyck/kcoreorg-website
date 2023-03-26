---
title: Now using less external services!
date: 2023-03-26
author: Jan
layout: single
categories:
  - Personal
tags:
  - blog
  - kcore.org
  - giscus
  - disqus
  - cloudflare
  - github pages
---

So back in 2019 I [moved the site](/2019/06/26/a-new-home/) from [WordPress](https://wordpress.org/) to [Jekyll](https://jekyllrb.com/) (using [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/)), and from [Gandi](https://www.gandi.net/) to [AWS Serverless](https://aws.amazon.com/serverless/). 

About a year later I moved it to [Github Pages](https://pages.github.com/), which [supports Jekyll out of the box](https://docs.github.com/en/pages/setting-up-a-github-pages-site-with-jekyll). Site was fronted with [Cloudflare](https://cloudflare.com) for HTTPS.

Some changes I've done this week:
* Removed [Google analytics](https://analytics.google.com/analytics/web/). I've never looked at the data, I don't really care either.
* Removed Cloudflare from the equation as [Github pages supports HTTPS these days](https://docs.github.com/en/pages/getting-started-with-github-pages/securing-your-github-pages-site-with-https).
* Removed [Disqus](https://disqus.com/) for commenting and converted everything to [Giscus](https://giscus.app). I used [Brice Dutheil](https://blog.arkey.fr/2022/10/16/moving-from-disqus-to-giscus/)'s excellent [conversion tool](https://gist.github.com/bric3/af915687717d9aa06b0f9b06d600c127) to convert the comments to Github Discussions.

