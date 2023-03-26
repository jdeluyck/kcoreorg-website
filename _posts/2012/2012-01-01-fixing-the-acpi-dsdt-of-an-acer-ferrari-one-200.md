---
id: 772
title: Fixing the ACPI DSDT of an Acer Ferrari One 200
date: 2012-01-01T13:33:35+02:00
author: Jan
layout: single
permalink: /2012/01/01/fixing-the-acpi-dsdt-of-an-acer-ferrari-one-200/
categories:
  - Linux / Unix
tags:
  - acer ferrari one 200
  - acpi
  - DSDT
---
Last year I installed Debían on my mother in law's network (an [Acer Ferrari One 200](http://en.wikipedia.org/wiki/Acer_Ferrari_products#Acer_Ferrari_One)). The thing ran fine, but gave some "firmware bug?" warnings. Since no new BIOS' were available at that time, I left it at that.

When doing my yearly checkup and update round, there still wasn't any new BIOS to be found. Annoying Acer! So I went around started digging in the [ACPI DSDT](http://en.wikipedia.org/wiki/Advanced_Configuration_and_Power_Interface) tables to see if I could fix anything.

To dump them, you can either use the [acpidump](https://01.org/linux-acpi/utilities) tool (`acpidump -b --table DSDT /tmp/dsdt.aml`) , or just do a `cat /sys/firmware/acpi/tables/DSDT /tmp/dsdt.aml`  
Next, and decompile the thing with the `iasl` (Intel ACPI compiler/decompiler): `iasl -d dsdt.aml`. This should yield a file called `dsdt.dsl`, which is human readable. Sortof :p  
First thing to fish out is to see whether the syntax is correct. To find out, we can just try to recompile it with the command `iasl -tc dsdt.dsl`.

In my case this didn't exactly work:

```
ASL Input: DSDT.orig.dsl - 10886 lines, 405784 bytes, 4948 keywords  
Compilation complete. 21 Errors, 6 Warnings, 18 Remarks, 1759 Optimizations
```

Amazed that this thing even booted!

(the reason for these mistakes is that many manufacturers use the Microsoft compiler which is a lot less strict when it comes to the DSL syntax. Intel's compiler is less forgiving.)  
  
Full list of errors:

```
Intel ACPI Component Architecture
ASL Optimizing Compiler version 20100528 [Jul  2 2010]
Copyright (c) 2000 - 2010 Intel Corporation
Supports ACPI Specification Revision 4.0a

DSDT.dsl   270:    Method (_WAK, 1, NotSerialized)  
Warning  1081 -            ^ Reserved method must return a value (Integer/Package required for _WAK)

DSDT.dsl  1083:            0x00000000,      // Length  
Error   4122 -                   ^ Invalid combination of Length and Min/Max fixed flags

DSDT.dsl  1090:            0x00000000,      // Length  
Error   4122 -                   ^ Invalid combination of Length and Min/Max fixed flags

DSDT.dsl  1388:          Method (AFN0, 0, Serialized)  
Warning  1088 -                  ^ Not all control paths return a value (AFN0)

DSDT.dsl  1392:              Return (\_SB.PCI0.AGP.VGA.AFN0 ())  
Error   4061 -               Called method returns no value ^

DSDT.dsl  1397:              Return (\_SB.PCI0.PB2.VGA.AFN0 ())  
Error   4061 -               Called method returns no value ^

DSDT.dsl  1402:              Return (\_SB.PCI0.PB3.VGA.AFN0 ())  
Error   4061 -               Called method returns no value ^

DSDT.dsl  1414:          Method (AFN3, 2, Serialized)  
Warning  1088 -                  ^ Not all control paths return a value (AFN3)

DSDT.dsl  1418:              Return (\_SB.PCI0.AGP.VGA.AFN3 (Arg0, Arg1))  
Error   4061 -               Called method returns no value ^

DSDT.dsl  1423:              Return (\_SB.PCI0.PB2.VGA.AFN3 (Arg0, Arg1))  
Error   4061 -               Called method returns no value ^

DSDT.dsl  1428:              Return (\_SB.PCI0.PB3.VGA.AFN3 (Arg0, Arg1))  
Error   4061 -               Called method returns no value ^

DSDT.dsl  1432:          Method (AFN4, 1, Serialized)  
Warning  1088 -                  ^ Not all control paths return a value (AFN4)

DSDT.dsl  1436:              Return (\_SB.PCI0.AGP.VGA.AFN4 (Arg0))  
Error   4061 -               Called method returns no value ^

DSDT.dsl  1441:              Return (\_SB.PCI0.PB2.VGA.AFN4 (Arg0))  
Error   4061 -               Called method returns no value ^

DSDT.dsl  1446:              Return (\_SB.PCI0.PB3.VGA.AFN4 (Arg0))  
Error   4061 -               Called method returns no value ^

DSDT.dsl  1450:          Method (AFN5, 0, Serialized)  
Warning  1088 -                  ^ Not all control paths return a value (AFN5)

DSDT.dsl  1454:              Return (\_SB.PCI0.AGP.VGA.AFN5 ())  
Error   4061 -               Called method returns no value ^

DSDT.dsl  1459:              Return (\_SB.PCI0.PB2.VGA.AFN5 ())  
Error   4061 -               Called method returns no value ^

DSDT.dsl  1464:              Return (\_SB.PCI0.PB3.VGA.AFN5 ())  
Error   4061 -               Called method returns no value ^

DSDT.dsl  1468:          Method (AFN6, 0, Serialized)  
Warning  1088 -                  ^ Not all control paths return a value (AFN6)

DSDT.dsl  1472:              Return (\_SB.PCI0.AGP.VGA.AFN6 ())  
Error   4061 -               Called method returns no value ^

DSDT.dsl  1477:              Return (\_SB.PCI0.PB2.VGA.AFN6 ())  
Error   4061 -               Called method returns no value ^

DSDT.dsl  1482:              Return (\_SB.PCI0.PB3.VGA.AFN6 ())  
Error   4061 -               Called method returns no value ^

DSDT.dsl  6315:                0x0068,        // Range Minimum  
Error   4114 -                     ^ Must be a multiple of alignment/granularity value

DSDT.dsl  6316:                0x0068,        // Range Maximum  
Error   4114 -                     ^ Must be a multiple of alignment/granularity value

DSDT.dsl  7850:              Return (PX02 (DerefOf (Index (Arg1, 0x02))))  
Error   4061 -      Called method returns no value ^

DSDT.dsl  7855:              Return (PX03 (DerefOf (Index (Arg1, 0x02))))  
Error   4061 -      Called method returns no value ^

DSDT.dsl  8538:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)

DSDT.dsl  8673:              Name (\_T\_1, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_1)

DSDT.dsl  9243:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)

DSDT.dsl  9359:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)

DSDT.dsl  9443:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)

DSDT.dsl  9681:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)

DSDT.dsl  9898:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)

DSDT.dsl  9988:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)

DSDT.dsl 10245:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)

DSDT.dsl 10301:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)

DSDT.dsl 10404:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)

DSDT.dsl 10532:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)

DSDT.dsl 10578:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)

DSDT.dsl 10611:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)

DSDT.dsl 10619:                  Name (\_T\_1, 0x00)  
Remark   5111 -          Use of compiler reserved name ^  (\_T\_1)

DSDT.dsl 10653:                    Name (\_T\_2, 0x00)  
Remark   5111 -            Use of compiler reserved name ^  (\_T\_2)

DSDT.dsl 10700:                      Name (\_T\_3, 0x00)  
Remark   5111 -              Use of compiler reserved name ^  (\_T\_3)

DSDT.dsl 10771:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)

ASL Input:  DSDT.dsl - 10886 lines, 405784 bytes, 4948 keywords  
Compilation complete. 21 Errors, 6 Warnings, 18 Remarks, 1759 Optimizations
```

To fix them, I used the tools of the trade: Google for looking up the errors, the ACPI spec to see what was supposed to be in there. Luckily for me, none of the errors were actual content errors, more beauty mistakes.

Here's a drilldown of some errors, and how to fix them:  

```
DSDT.dsl   270:    Method (_WAK, 1, NotSerialized)  
Warning  1081 -            ^ Reserved method must return a value (Integer/Package required for _WAK)
```

The _WAK method must always return a value. For this I added  `Return(Package(0x02){0x00, 0x00})` to the end of the function.

```
DSDT.dsl  1083:            0x00000000,      // Length  
Error   4122 -                   ^ Invalid combination of Length and Min/Max fixed flags
```

This one is more interesting to fix. When looking in the file, you see that there are several parameters defined. For us, the interesting ones are Range Minimum, Range Maximum, and Length. In this example, they are 0x00000000, 0x00000000 and 0x00000000 respectively. To correctly calculate the Length, use a programmers calculator (set in HEX mode), and make this sum: Range Maximum - Range Minimum + 1. In this case, that yields 0x00000001. (this makes sense, since even just having address 0x00000000 to 0x00000000 is still one address, namely 0x00000000). So I changed Length to that.

```
DSDT.dsl  1388:          Method (AFN0, 0, Serialized)  
Warning  1088 -                  ^ Not all control paths return a value (AFN0)
```

This basically means that there is one control path in the function that doesn't Return something. I checked the function, and added a `Return (Zero)` at the end - you normally shouldn't even get in that code path.

```
DSDT.dsl  1392:              Return (\_SB.PCI0.AGP.VGA.AFN0 ())  
Error   4061 -               Called method returns no value ^
```

This one was the most rotten to fix. Basically, we're calling a function that doesn't return anything. One fix is to add `Return (Zero)` at the end of the function, another would be to call the function in another way that doesn't require a return code to begin with. I opted for adding the Return.

```
DSDT.dsl  6315:                0x0068,        // Range Minimum  
Error   4114 -                     ^ Must be a multiple of alignment/granularity value
```

Also an interesting one. When you check the section, there's a Range Max of 0x0068, and a Range Min of 0x0068. The Alignment, on the other hand, is 0x10. Which doesn't match up. I changed the alignment to 0x01. (based on the other entries in there)

```
DSDT.dsl  8538:              Name (\_T\_0, 0x00)  
Remark   5111 -      Use of compiler reserved name ^  (\_T\_0)
```

These are very easy to fix. Basically, inside the block, change the name of \_T\_0 to eg. T_0. Solved.

After fixing all this, we finally got down to  

```
Compilation complete. 0 Errors, 0 Warnings, 0 Remarks, 1759 Optimizations
```

Huzzah! And we get a spiffy `DSDT.aml` to boot ;) (literaly :P)

Now, to make the kernel use this modified DSDT table, I had to recompile the kernel, and add the custom DSDT path in the configuration. More info on this can be found [here](http://wiki.debian.org/OverridingDSDT), and I'm letting it up to the reader to execute this step - it's a good exercise ;-)