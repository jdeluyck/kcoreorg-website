---
title: Increasing Mastodon's post size
date: 2022-12-18
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - mastodon
  - fediverse
---

[Mastodon](https://joinmastodon.org/) comes with a default post size of 500 characters. This is not set in stone, and can be increased fairly easily (*last tested on Mastodon 4.2.0*):

Edit `live/app/javascript/mastodon/features/compose/components/compose_form.js` (pre-v4.2.0) or `live/app/javascript/mastodon/features/compose/components/compose_form.jsx` (v4.2.0+), search for the number 500 and replace it (should pop up twice)
   
Edit `live/app/validators/status_length_validator.rb`, search for the number 500 again and replace it (should show up once)
  
Edit `live/app/serializers/rest/instance_serializer.rb`, search for the block
```ruby
attributes :domain, :title, :version, :source_url, :description,
           :usage, :thumbnail, :languages, :configuration,
           :registrations
  ``` 
and add `, :max_post_chars` behind `:registrations`, so it becomes 
```ruby
attributes :domain, :title, :version, :source_url, :description,
           :usage, :thumbnail, :languages, :configuration,
           :registrations, :max_post_chars
```

At the bottom of that same file, before the keyword `private`, add the following block (replacing YOUR_POST_LENGTH with the number of chars you want):
```ruby
def max_post_chars
  YOUR_POST_LENGTH
end
```
Now recompile Mastodon (as the Mastodon user):
```shell
$ cd live
$ RAILS_ENV=production bundle exec rails assets:precompile
```

Restart Mastodon (as root, or via `sudo`):
```shell
# systemctl restart mastodon-sidekiq.service mastodon-streaming.service mastodon-web.service
```

Now your post length will be whatever you chose ;)