#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake    \
    libdecor \
    sdl3

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building ClownMDEmu..."
echo "---------------------------------------------------------------"
REPO="https://github.com/Clownacy/clownmdemu-frontend"
if [ "${DEVEL_RELEASE-}" = 1 ]; then
	echo "Making nightly build of ClownMDEmu..."
	echo "---------------------------------------------------------------"
	VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
	git clone --recursive --depth 1 "$REPO" ./clownmdemu
else 
	echo "Making stable build of ClownMDEmu..."
	VERSION="$(git ls-remote --tags --sort="v:refname" https://github.com/Clownacy/clownmdemu-frontend | tail -n1 | sed 's/.*\///; s/\^{}//; s/^v//')"
	git clone --branch v"$VERSION" --single-branch --recursive --depth 1 "$REPO" ./clownmdemu
fi
echo "$VERSION" > ~/version

cd ./clownmdemu
mkdir -p build && cd build
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="/usr" \
    -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
    -DCMAKE_POLICY_DEFAULT_CMP0069=NEW \
    -DCLOWNMDEMU_FRONTEND_FREETYPE=ON
make -j$(nproc)
make install
