#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* ./build-aux

# skip the creation of man pages by faking existance of help2man
if [ `uname` == Darwin ]; then
    export HELP2MAN=/usr/bin/true
fi
if [ `uname` == Linux ]; then
    export HELP2MAN=/bin/true
fi

if [[ ${HOST} =~ .*linux.* ]]; then
    export CC=${GCC}
    # TODO :: Handle cross-compilation properly here
    export CC_FOR_BUILD=${GCC}
fi

./configure --prefix="$PREFIX"  \
            --host=${HOST}      \
            --build=${BUILD}

make -j${CPU_COUNT} ${VERBOSE_AT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
make check
fi
make install
