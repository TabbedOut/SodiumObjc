#!/bin/bash

################################################################################
#
# Copyright (c) 2008-2009 Christopher J. Stawarz
#
# Modified by Nathaniel Gray in 2012 to support Clang, custom dev tool locations, 
# and armv7.  Also removed "make install" phase, since that can easily be done by
# hand.
#
# Modified to fix paths, clear out unecessary interaction and add a lipo step
# for simulator
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
################################################################################



# Disallow undefined variables
set -u
set -e

if [ $# -ne 1 ]; then
	echo "Only argument should be a path where libsodium lives"
	exit 1
fi

cd "$1"

default_iphoneos_version=7.1
default_macos_version=10.6
developer_dir="/Applications/Xcode.app/Contents/Developer"
thumb_opt=thumb

export IPHONEOS_DEPLOYMENT_TARGET="${IPHONEOS_DEPLOYMENT_TARGET:-$default_iphoneos_version}"
export MACOSX_DEPLOYMENT_TARGET="${MACOSX_DEPLOYMENT_TARGET:-$default_macos_version}"
export DEVELOPER_DIR="${DEVELOPER_DIR:-$developer_dir}"

function build {
	arch="$1"
	platform="$2"
	extra_cflags="$3"

	cc=gcc
	cxx=g++

	platform_dir="$DEVELOPER_DIR/Platforms/${platform}.platform/Developer"
	platform_bin_dir="${DEVELOPER_DIR}/usr/bin"
	platform_sdk_dir="${platform_dir}/SDKs/${platform}${IPHONEOS_DEPLOYMENT_TARGET}.sdk"
	prefix="${prefix:-${HOME}${platform_sdk_dir}}"

	export CC="${platform_bin_dir}/${cc}"
	export CFLAGS="-arch ${arch} -pipe -Os -gdwarf-2 -isysroot ${platform_sdk_dir} ${extra_cflags}"
	export LDFLAGS="-arch ${arch} -isysroot ${platform_sdk_dir}"
	export CXX="${platform_bin_dir}/${cxx}"
	export CXXFLAGS="${CFLAGS}"
	export CPP="${CC} -E"
	export CXXCPP="${CPP}"

	make clean
	./configure \
	    --prefix="${prefix}" \
	    --host="${arch}-apple-darwin" \
	    --disable-shared \
	    --enable-static

	make -j 4
	mv src/libsodium/.libs/libsodium.a /tmp/libsodium.a_arch_${arch}
}

build "armv7" "iPhoneOS" ""
build "armv7s" "iPhoneOS" ""
build "i386" "iPhoneSimulator" "-D__IPHONE_OS_VERSION_MIN_REQUIRED=${IPHONEOS_DEPLOYMENT_TARGET%%.*}0000"

cd -

lipo -create /tmp/libsodium.a_arch_armv7 /tmp/libsodium.a_arch_armv7s /tmp/libsodium.a_arch_i386 -output ./libsodium.a
rm /tmp/libsodium.a_arch_armv7 /tmp/libsodium.a_arch_armv7s /tmp/libsodium.a_arch_i386

