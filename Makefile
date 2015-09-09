HOST=i686-elf
HOSTARCH=i386

ARCHDIR=arch/$(HOSTARCH)

AR=${HOST}-ar
AS=${HOST}-as
CC=${HOST}-gcc

CFLAGS?=-O2 -g
CPPFLAGS?=
LDFLAGS?=
LIBS?=

CFLAGS:=$(CFLAGS) -ffreestanding -fbuiltin -Wall -Wextra -std=gnu11
CPPFLAGS:=$(CPPFLAGS) -Iinclude
LDFLAGS:=$(LDFLAGS)
LIBS:=$(LIBS) -nostdlib -lgcc

OBJS:=\
	$(ARCHDIR)/boot.o \
	$(ARCHDIR)/tty.o \
	src/kernel.o \
	src/stdio.o \
	src/stdlib.o \
	src/string.o \

OBJ_LINK_LIST:=\
	$(OBJS)

all: myos.kernel

.PHONY: all clean install install-headers install-kernel

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS) $(CPPFLAGS) -std=gnu11

%.o: %.S
	$(CC) -c $< -o $@ $(CFLAGS) $(CPPFLAGS)

myos.kernel: $(OBJ_LINK_LIST) $(ARCHDIR)/linker.ld
	$(CC) -T $(ARCHDIR)/linker.ld -o $@ $(CFLAGS) $(OBJ_LINK_LIST) $(LDFLAGS) $(LIBS)

clean:
	rm -f myos.kernel $(OBJS) *.o */*.o */*/*.o

install: install-headers install-kernel

install-headers:
	mkdir -p $(DESTDIR)$(INCLUDEDIR)
	cp -RTv include $(DESTDIR)$(INCLUDEDIR)

install-kernel: myos.kernel
	mkdir -p $(DESTDIR)$(BOOTDIR)
	cp myos.kernel $(DESTDIR)$(BOOTDIR)

compile: install-headers
	./build.sh

iso: compile
	./iso.sh

run: iso
	qemu-system-i386 -cdrom myos.iso

clean:
	make -C kernel clean
	rm -f myos.iso
	rm -rf isodir

install-headers:
	./headers.sh
	
debug:
	qemu-system-i386 -s -S -cdrom myos.iso
