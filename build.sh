#!/bin/bash
#
# Build a bootable ubuntu touch image for librem5 devkit
#

UBPORTS_TAR='ubports-touch.rootfs-xenial-armhf.tar'
UBPORTS_SRC="https://ci.ubports.com/job/xenial-rootfs-armhf/lastSuccessfulBuild/artifact/out/${UBPORTS_TAR}.gz"
UBPORTS_TMP="tmp/${UBPORTS_TAR}"

if [ -f $UBPORTS_TMP ]
then
  echo "Using existing rootfs tarball under ${UBPORTS_TMP}"
else
  echo 'Attempting to download new rootfs tarball'
  wget -O "${UBPORTS_TMP}.gz" $UBPORTS_SRC
  gunzip "${UBPORTS_TMP}.gz"
  # ostree can't handle device files
  # tar --delete --file $UBPORTS_TMP dev/
fi

echo 'Merging overlay into root tarball'
OVERLAY_TMP='tmp/overlay.tar'
rm -f $OVERLAY_TMP
pushd overlay > /dev/null
  tar --create --file "../${OVERLAY_TMP}" --owner root --group root .
popd > /dev/null
tar --concat --file $UBPORTS_TMP $OVERLAY_TMP
