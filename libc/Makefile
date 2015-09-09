HOST=i686-elf
HOSTARCH=i386

ARCHDIR=arch/$(HOSTARCH)

CFLAGS?=-g -O2
CPPFLAGS?=
LDFLAGS?=
LIBS?=

DESTDIR?=
PREFIX?=/usr/local
EXEC_PREFIX?=$(PREFIX)
INCLUDEDIR?=$(PREFIX)/include
LIBDIR?=$(EXEC_PREFIX)/lib

CFLAGS:=$(CFLAGS) -Wall -Wextra -ffreestanding
CPPFLAGS:=$(CPPFLAGS) -Iinclude

LDFLAGS:=$(LDFLAGS)
LIBS:=$(LIBS) -nostdlib -lgcc

BINARIES:=libc.a

OBJS:=\
	stdio.o \
	stdlib.o \
	string.o

OBJ_LINK_LIST:=\
	$(OBJS)

.PHONY: all clean install install-headers

all: libc.a

libc.a: $(OBJS)
	$(AR) rcs $@ $(OBJS)

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS) $(CPPFLAGS) -std=gnu11

%.o: %.S
	$(CC) -c $< -o $@ $(CFLAGS) $(CPPFLAGS)

clean:
	rm -f $(BINARIES) $(OBJS) *.o */*.o */*/*.o

install: install-headers install-libs

install-headers:
	mkdir -p $(DESTDIR)$(INCLUDEDIR)
	cp -RTv include $(DESTDIR)$(INCLUDEDIR)

install-libs: $(BINARIES)
	mkdir -p $(DESTDIR)$(LIBDIR)
	cp $(BINARIES) $(DESTDIR)$(LIBDIR)
