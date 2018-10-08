#!/bin/bash

# -g parameter adds debug codes for debugging
nasm -g -f bin potatos.asm
qemu-system-i386 -s -fda potatos -boot a
