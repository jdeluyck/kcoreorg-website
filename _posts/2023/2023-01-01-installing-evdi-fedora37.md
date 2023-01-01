---
title: Installing Displaylink drivers on Fedora 37
date: 2023-01-01
author: Jan
layout: single
categories:
  - Linux / Unix
tags:
  - displaylink
  - fedora
---

I have an [Asus ZenScreen MB16AC](https://www.asus.com/displays-desktops/monitors/zenscreen/zenscreen-mb16ac/) which uses [Displaylink]() as its display technology. On [usb-c](https://en.wikipedia.org/wiki/USB-C) you can just plug this in and it'll work, but on my ancient laptop I only have [usb-a](https://en.wikipedia.org/wiki/USB) ports. The display does come with an USB-A to USB-C convertor - so let's try ;)

After plugging the display helpfully told me it couldn't detect any DisplayLink support, and switched off. Heh.

After some digging I found the way to get this to work:

* Install [RPMFusion](https://rpmfusion.org)
* Install [RPMSphere](https://rpmsphere.github.io/) (for `evdi`)
* Install the `evdi` package:   
  ```shell
  $ sudo dnf install evdi
  ```
At this point the build will fail because of compatibility issues with the latest packaged version of evdi and the 6.x linux kernels. [Patches](https://github.com/DisplayLink/evdi/issues/384) are available, and the master branch also works.

* Clone the latest master branch of `https://github.com/DisplayLink/evdi` and use its version of the evdi source  
  ```shell
  $ git clone https://github.com/DisplayLink/evdi
  $ cd evdi
  $ sudo cp evdi/module/* /usr/src/evdi-1.12.0
  ```
* Rebuild the `evdi` module  
  ```shell
  $ sudo dkms build -m evdi -v 1.12.0 --force
  $ sudo dkms install -m evdi -v 1.12.0
  ```
Next, to get the displaylink driver:
* download the official Ubuntu driver from [https://www.synaptics.com/products/displaylink-graphics/downloads/ubuntu](https://www.synaptics.com/products/displaylink-graphics/downloads/ubuntu) somewhere. `/tmp` for instance.
* install it:
  
  **Before executing `displaylink-installer.sh` you should review that it does not do anything nefarious!**
  ```shell
  $ unzip DisplayLink\ USB\ Graphics\ Software\ for\ Ubuntu5.6.1-EXE.zip
  $ chmod +x displaylink-driver-5.6.1-59.184.run
  $ ./displaylink-driver-5.6.1-59.184.run --target DL-extracted --noexec
  $ cd DL-extracted
  $ sudo ./displaylink-installer.sh
  ```

Et voila.