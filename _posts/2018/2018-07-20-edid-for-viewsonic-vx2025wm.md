---
id: 2009
title: EDID for ViewSonic Vx2025wm
date: 2018-07-20T18:33:04+02:00
author: Jan
layout: single
permalink: /2018/07/20/edid-for-viewsonic-vx2025wm/
categories:
  - Linux / Unix
tags:
  - corrupt
  - edid
  - fedora
  - linux
  - viewsonic vx2025wm
---
I recently reinstalled Fedora on my desktop machine, which has (amongst others) a 
[ViewSonic Vx2025wm](https://www.viewsonic.com/uk/products/lcd/vx2025wm.php) screen connected to it. It's an oldie, but
still works (quite well).
  
Unfortunately, Linux just complained that it didn't get a proper 
[EDID](https://en.wikipedia.org/wiki/Extended_Display_Identification_Data) out of it, and refused to activate it - might
also explain why Windows doesn't recognise it as a [PnP](https://en.wikipedia.org/wiki/Plug_and_play) monitor - I guess the chip fried somewhere along the way.

This was found in the `/var/log/messages`:

```
May 16 19:57:29 odin kernel: nouveau 0000:01:00.0: DVI-I-1: EDID is invalid:
May 16 19:57:29 odin kernel: #011[00] BAD 00 ff ff ff ff ff ff 00 5a 63 1d e5 01 01 01 01
May 16 19:57:29 odin kernel: #011[00] BAD 08 10 01 03 80 2b 1b 78 2e cf e5 a3 5a 49 a0 24
May 16 19:57:29 odin kernel: #011[00] BAD 00 50 54 bf ef 80 b3 0f 81 80 81 40 71 4f 31 0a
May 16 19:57:29 odin kernel: #011[00] BAD 01 01 01 01 01 01 21 39 90 30 62 1a 27 40 68 b0
May 16 19:57:29 odin kernel: #011[00] BAD 36 00 b1 0f 11 00 00 1c 00 00 00 ff 00 51 36 59
May 16 19:57:29 odin kernel: #011[00] BAD 30 36 30 38 30 36 38 33 39 0a 00 00 00 fd 00 32
May 16 19:57:29 odin kernel: #011[00] BAD 4b 1e 52 11 00 0a 20 20 20 20 20 20 00 00 00 fc
May 16 19:57:29 odin kernel: #011[00] BAD 00 56 58 32 30 32 35 77 6d 0a 20 20 20 20 00 f4
May 16 19:57:29 odin kernel: nouveau 0000:01:00.0: DRM: DDC responded, but no EDID for DVI-I-1
```

As you can see, the screen connected on connector DVI-I-1 (remember this!) isn't returning a valid EDID.

Luckely, it's rather easy to override your screen's EDID in Linux, allowing you to serve one from a file ;) as long as you have a copy of said EDID. I didn't have one, but was able to get my hands on one online. You can download it here: 
[viewsonic_vx2025wm_edid.bin_.gz](/assets/files/2018/07/viewsonic_vx2025wm_edid.bin_.gz)

To activate this (these instructions are for Fedora, but they'll probably apply to any distro):

  1. Copy it to `/usr/lib/firmware/edid` (make this directory if needed) - and unpack it
  2. Modify your initramfs to include this firmware, since we're going to need it early on in the boot.  
    Fedora uses [dracut](https://dracut.wiki.kernel.org/index.php/Main_Page) - so put this in eg. `/etc/dracut.conf.d/viewsonic_edid.conf`:  
    `install_items+=" /usr/lib/firmware/edid/viewsonic_vx2025wm_edid.bin"`
  3. Rebuild your initramfs: `dracut -f`
  4. Assuming you're using [grub](https://www.gnu.org/software/grub/), modify your default kernel boot line in `/etc/default/grub` and append `drm.edid_firmware=DVI-I-1:edid/viewsonic_vx2025wm_edid.bin` on the line that starts with `GRUB_CMDLINE_LINUX`. You can find the connector the display is on in the messages output above.  
    In the end, mine reads: `GRUB_CMDLINE_LINUX="rd.lvm.lv=fedora_odin/root rd.lvm.lv=fedora_odin/swap rhgb quiet drm.edid_firmware=DVI-I-1:edid/viewsonic_vx2025wm_edid.bin"`
  5. Regenerate your grub config. For [UEFI](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface) booting systems, use `grub2-mkconfig > /boot/efi/EFI/fedora/grub.cfg`, otherwise use `grub2-mkconfig > /boot/grub2/grub.cfg`.
  6. Reboot

And that should be it - the screen should activate now.

(for Windows, you can take a look [here](http://www.komeil.com/blog/fix-edid-monitor-no-signal-dvi)
