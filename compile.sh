#!/bin/bash

rm -rf out
mkdir out

# Let's prepare completely empty floppy image
rm -rf out/floppy.img
dd if=/dev/zero of=out/floppy.img bs=512 count=2880

# Format image with FAT12
mkdosfs out/floppy.img

# Let's compile bootloader
nasm -f bin src/bootloader.asm -o out/bootloader

# Put bootloader at the begining of the floppy image
dd if=out/bootloader of=out/floppy.img conv=notrunc

# Let's compile kernel
#nasm -f bin src/kernel.asm -o out/kernel
gcc -c -m16 -masm=intel -o out/kernel.o src/kernel.c
objcopy -O binary out/kernel.o out/kernel

# Copy kernel inside the floppy image
#mkdir out/temp
#sudo mount -t auto out/floppy.img out/temp
#sudo cp out/kernel out/temp/
#sudo umount out/temp/

# Let's start emulator
#qemu-system-i386 -s -fda out/floppy.img -boot a -m size=1
