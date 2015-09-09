OPTIMS=-O0
CFLAGS?=-std=c++17 -g
CFLAGS:=$(CFLAGS) -Wall -Wextra

.PHONY: compile iso run clean install-headers debug

# default: compile iso

compile: install-headers
	./build.sh

iso: compile
	./iso.sh

run: iso
	qemu-system-i386 -cdrom myos.iso

clean:
	make -C kernel clean
	make -C libc clean
	rm -f myos.iso
	rm -rf isodir

install-headers:
	./headers.sh
	
debug:
	qemu-system-i386 -s -S -cdrom myos.iso
