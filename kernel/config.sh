PROJECTS="libc kernel"
SYSTEM_HEADER_PROJECTS="libc kernel"

export HOST=i686-elf
export MAKE=${MAKE:-make}

export AR=${HOST}-ar
export AS=${HOST}-as
export CC=${HOST}-gcc

export PREFIX=/usr
export EXEC_PREFIX="$PREFIX"
export BOOTDIR=/boot
export LIBDIR=$EXEC_PREFIX
export INCLUDEDIR=$PREFIX/include

export CFLAGS="-O2 -g"
export CPPFLAGS=''

export CC="$CC --sysroot=$PWD/sysroot"

if echo "$HOST" | grep -Eq -- '-elf($|-)'; then
  export CC="$CC -isystem=$INCLUDEDIR"
fi