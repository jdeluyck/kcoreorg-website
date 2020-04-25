---
id: 252
title: Copying files and dirs with tar
date: 2008-06-21T20:37:54+02:00
author: Jan
layout: single
guid: http://sadevil.org/blog/?p=252
permalink: /2008/06/21/copying-files-and-dirs-with-tar/
categories:
  - Linux / Unix
tags:
  - copy files
  - hint
  - permissions
  - tar
---
If you want to copy a bunch of files from one spot to another, but preserve links/permissions/ownership/..., it's usually a big hassle.

With [tar](http://en.wikipedia.org/wiki/Tar_(file_format)), you can make this hassle disappear!

Copying a directory tree and its contents to another filesystem using tar will preserve ownership, permissions, and timestamps. You can use pipe tar to another tar to prevent having to create an intermediate file to store the stuff you want to copy around.

To copy all of the files and subdirectories in the current working directory to the directory /destination, use: 

`tar cf - * | ( cd /destination; tar xfp -)`

The first part of the command - tar - makes a tarball of all the files, and writes this to stdout. The second part of the command part will first change directory, and then extract the tarball in that location, reading from it's stdin. 

Since the cd and tar commands are contained within parentheses, their actions are performed together. 

The _p_ option in the tar command instructs tar to preserve the permission and ownership information, if possible. So if you want to move a lot of files around, it's advisable to do so with the root user to keep all them permissions!