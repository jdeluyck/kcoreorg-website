---
title: 'Dark theme in Flatpak apps'
date: 2022-11-16
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - flatpak
  - dark theme
  - linux
---

To get flatpak's to honor your systems dark mode and not show you horrible white menubars, you can use this little snipplet:

First make sure that `gtk-application-prefer-dark-theme` is set to `true` in  `~/.config/gtk-3.0/settings.ini`. Install whatever flatpacks you want.
Then run this:

```shell
for flatpak in $HOME/.var/app/*/
do
  confdir="${flatpak}config/gtk-3.0"

  mkdir -p $confdir
  cp $HOME/.config/gtk-3.0/settings.ini $confdir/settings.ini
done
```


Source: [https://www.linuxuprising.com/2018/05/how-to-get-flatpak-apps-to-use-correct.html#comment-5174655826](https://www.linuxuprising.com/2018/05/how-to-get-flatpak-apps-to-use-correct.html#comment-5174655826)