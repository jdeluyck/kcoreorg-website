---
title: Generating a Plex Auth Token using curl
date: 2019-06-16T08:33:04+02:00
author: Jan
layout: single
permalink: /2019/06/16/generating-plex-token-curl/
categories:
  - Linux / Unix
tags:
  - plex
  - curl
  - home assistant
  - authentication token
---
I recently started using [Plex](https://www.plex.tv/), and since I'm also using [Home Assistant](https://www.home-assistant.io/), and Home Assistant
can do stuff with Plex, I wanted to combine the two.

For this, you need to generate an Authentication Token so that Home Assistant is seen as a client by Plex.

Do do this via the cli, using curl, you can use the following command:

```
curl -X POST -H "Content-Type: application/x-www-form-urlencoded; charset=utf-8" \ 
-H 'X-Plex-Version: <SOME VERSION NUMBER>' \
-H 'X-Plex-Product: <SOME PRODUCT NAME>' \
-H 'X-Plex-Client-Identifier: <SOME UNIQUE IDENTIFIER>' \
--data-urlencode "user[password]=<YOURPASSHERE>" \
--data-urlencode "user[login]=<YOURUSERHERE>" \
https://plex.tv/users/sign_in.json
```
replacing the stuff between <> with your actual values.

When you run this command, you'll get some json back, in which you need to look for `"authToken":"osadjfs5928aosdjfosX"`.
This string will be the authentication token you will need to give to Home Assistant. 


