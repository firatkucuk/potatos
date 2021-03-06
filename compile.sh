#!/bin/bash

rm -rf floppy.img
nasm -f bin bootloader.asm
nasm -f bin kernel.asm
dd if=/dev/zero of=floppy.img bs=512 count=2880
mkdosfs floppy.img
dd if=bootloader of=floppy.img conv=notrunc
mkdir temp
sudo mount -t auto floppy.img temp
sudo cp kernel temp/
sudo umount temp
rm -rf temp bootloader kernel
qemu-system-i386 -s -fda floppy.img -boot a -m size=1
