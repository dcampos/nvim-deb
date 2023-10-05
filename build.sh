#!/usr/bin/env bash

set -e

sudo apt-get update
sudo apt-get install -y devscripts equivs

PKGVERSION=$(dpkg-parsechangelog --show-field=Version)
NAME=$(dpkg-parsechangelog --show-field=Source)
VERSION=${PKGVERSION/-*}
RELEASE=${PKGVERSION/*-}
NAME="neovim"

echo "Create build directory"
rm -Rf build
mkdir build
cd build

wget --progress=dot:mega \
    https://github.com/"${NAME}"/"${NAME}"/archive/refs/tags/v"${VERSION}".tar.gz

echo "Prepare sources"
mv v"${VERSION}".tar.gz "${NAME}"_"${VERSION}".orig.tar.gz
tar xf "${NAME}"_"${VERSION}".orig.tar.gz
cd "${NAME}-${VERSION}"

cp -R ../../debian .
cp -R ../../local.mk .

sudo mk-build-deps --install --remove \
    --tool="apt-get -o Debug::pkgProblemResolver=yes --no-install-recommends --yes" \
    debian/control

debuild -us -uc -b
