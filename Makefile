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

all: run

.PHONY: all clean 

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS) $(CPPFLAGS) -std=gnu11

%.o: %.S
	$(CC) -c $< -o $@ $(CFLAGS) $(CPPFLAGS)

myos.kernel: $(OBJ_LINK_LIST) $(ARCHDIR)/linker.ld
	$(CC) -T $(ARCHDIR)/linker.ld -o $@ $(CFLAGS) $(OBJ_LINK_LIST) $(LDFLAGS) $(LIBS)

clean:
	rm -f myos.kernel $(OBJS) *.o */*.o */*/*.o
	rm -f myos.iso
	rm -rf isodir

iso: myos.kernel
	./iso.sh

run: iso
	qemu-system-i386 -cdrom myos.iso

debug:
	qemu-system-i386 -s -S -cdrom myos.iso
