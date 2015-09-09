HOST=i686-elf
HOSTARCH=i386

ARCHDIR=arch/$(HOSTARCH)

AR=${HOST}-ar
AS=${HOST}-as
CC=${HOST}-gcc
CXX=${HOST}-g++

CFLAGS?=-O2 -g
CXXFLAGS?=
CPPFLAGS?=
LDFLAGS?=
LIBS?=

CFLAGS:=$(CFLAGS) -ffreestanding -fbuiltin -Wall -Wextra -std=gnu11
CXXFLAGS:=$(CXXFLAGS) -ffreestanding -fbuiltin -fno-exceptions -fno-rtti -Wall -Wextra -std=c++17
CPPFLAGS:=$(CPPFLAGS) -Iinclude
LDFLAGS:=$(LDFLAGS)
LIBS:=$(LIBS) -nostdlib -lgcc

CRTI_OBJ:=$(ARCHDIR)/crti.o
CRTBEGIN_OBJ:=$(shell $(CC) $(CFLAGS) $(LDFLAGS) -print-file-name=crtbegin.o)
CRTEND_OBJ:=$(shell $(CC) $(CFLAGS) $(LDFLAGS) -print-file-name=crtend.o)
CRTN_OBJ:=$(ARCHDIR)/crtn.o

OBJS:=\
	$(ARCHDIR)/boot.o \
	$(ARCHDIR)/tty.o \
	src/kernel.o \
	src/stdio.o \
	src/stdlib.o \
	src/string.o \
	src/icxxabi.o \

ALL_OUR_OBJS:=\
	$(CRTI_OBJ) \
	$(OBJS) \
	$(CRTN_OBJ) \

OBJ_LINK_LIST:=\
	$(CRTI_OBJ) \
	$(CRTBEGIN_OBJ) \
	$(OBJS) \
	$(CRTEND_OBJ) \
	$(CRTN_OBJ) \

all: run

.PHONY: all clean 

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS) $(CPPFLAGS) -std=gnu11

%.o: %.cpp
	$(CXX) -c $< -o $@ $(CXXFLAGS) $(CPPFLAGS) 

%.o: %.S
	$(CC) -c $< -o $@ $(CFLAGS) $(CPPFLAGS)

myos.kernel: $(OBJ_LINK_LIST) $(ARCHDIR)/linker.ld
	$(CC) -T $(ARCHDIR)/linker.ld -o $@ $(CFLAGS) $(OBJ_LINK_LIST) $(LDFLAGS) $(LIBS)

clean:
	rm -f myos.kernel $(OBJS) $(ALL_OUR_OBJS) *.o */*.o */*/*.o
	rm -f myos.iso
	rm -rf isodir

iso: myos.kernel
	./iso.sh

run: iso
	qemu-system-i386 -cdrom myos.iso

debug:
	qemu-system-i386 -s -S -cdrom myos.iso
