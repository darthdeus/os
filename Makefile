OPTIMS=-O0
CFLAGS?=-std=c++17 -g
CFLAGS:=$(CFLAGS) -Wall -Wextra

default: compile iso

compile:
	make -C kernel

iso: compile
	./iso.sh

run: iso
	qemu-system-i386 -cdrom myos.iso

clean:
	make -C kernel clean
	rm -f myos.iso
	rm -rf isodir

debug:
	qemu-system-i386 -s -S -cdrom myos.iso
