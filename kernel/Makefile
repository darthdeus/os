HOST=i686-elf
HOSTARCH=i386

ARCHDIR=arch/$(HOSTARCH)

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
	src/kernel.o

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
