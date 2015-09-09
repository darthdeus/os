HOST=i686-elf
HOSTARCH=i386

ARCHDIR=arch/$(HOSTARCH)

OPTIMS=-O0
CFLAGS?=$(OPTIMS) -g -Iinclude
CPFLAGS?=
CXXFLAGS?=-Iinclude
LDFLAGS?=
LIBS?=

CFLAGS:=$(CFLAGS) -ffreestanding -fbuiltin -Wall -Wextra -std=gnu11
CPFLAGS:=$(CPFLAGS)
CXXFLAGS:=$(CXXFLAGS) -ffreestanding -fno-exceptions -fno-rtti -Wall -Wextra -std=c++17

LDFLAGS:=$(LDFLAGS)
LIBS:=$(LIBS) -nostdlib -lgcc

CC=$(HOST)-gcc
AR=$(HOST)-ar
AS=$(HOST)-as

OBJS:=\
	$(ARCHDIR)/boot.o \
	$(ARCHDIR)/tty.o \
	src/kernel.o

OBJ_LINK_LIST:=\
	$(OBJS)

all: myos.kernel

%.o: %.c
	$(CC) -c $< -o $@ $(CFLAGS) $(CPFLAGS)

%.o: %.cpp
	$(CC) -c $< -o $@ $(CXXFLAGS)

%.o: %.S
	$(CC) -c $< -o $@ $(CFLAGS) $(CPFLAGS)

myos.kernel: $(OBJ_LINK_LIST) $(ARCHDIR)/linker.ld
	$(CC) -T $(ARCHDIR)/linker.ld -o $@ $(CFLAGS) $(OBJ_LINK_LIST) $(LDFLAGS) $(LIBS)

clean:
	rm -f myos.kernel $(OBJS)
