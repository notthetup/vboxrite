vboxrite
========

Simple script to automate running spinrite ISO on a VirtualBox.

Based on the instructions from [JT's Digs](http://jtsdigs.com/blog/2013/2/3/spinrite-on-a-mac-yes-you-can)


## Introduction ##
The script automates the creation of a VirtualBox VM which runs Spinrite from an .iso file and attaches a given disk device as a "rawdisk" to the VM, thus making it visible to Spinrite running on the VM.

This can be used to run Spinrite on your MacOSX machine while booting from another disk.


## Dependencies ##
1. [Spinrite](http://www.grc.com/sr/spinrite.htm) (.iso format)
2. [VirtualBox](https://www.virtualbox.org/)
3. bash
4. OSX

Only tested on Mac OSX Lion with Virtualbox 4.2.12


## Issues & Bugs##
Please raise github issues if you find any bugs.


## License ##
"vboxrite" is distributed under the MIT License, see LICENSE.










