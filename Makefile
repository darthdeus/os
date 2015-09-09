all: compile link image run

OPTIMS=-O0
CFLAGS?=-std=c++17 -g
CFLAGS:=$(CFLAGS) -Wall -Wextra

compile:
	i686-elf-as boot.s -o boot.o
	i686-elf-gcc -c kernel.cpp -o kernel.o -ffreestanding -fno-exceptions -fno-rtti $(CFLAGS) $(OPTIMS)

link:
	i686-elf-gcc -T linker.ld -o myos.bin -ffreestanding -nostdlib boot.o kernel.o $(OPTIMS)

image:
	cp myos.bin isodir/boot/myos.bin
	grub-mkrescue -o myos.iso isodir

run:
	qemu-system-i386 -cdrom myos.iso

clean:
	rm -f myos.iso kernel.o boot.o

debug:
	qemu-system-i386 -s -S -cdrom myos.iso
