#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/clownmdemu.svg
export DESKTOP=/usr/share/applications/com.clownacy.clownmdemu.desktop
export DEPLOY_OPENGL=1

# Deploy dependencies
quick-sharun /usr/bin/clownmdemu

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
