#!/bin/bash

nasm -f bin potatos.asm
qemu-system-i386 -s -fda potatos -boot a
