#!/bin/sh

if [ "$(id -u)" = "0" ]; then
  echo
  echo "please don't run the script as user, exiting .."
  exit 10
fi

cd $(dirname $0)
SETUPDIR="$(pwd)"
TMPWKDIR="/tmp/.aaa_ventoy_lasdfx"
OUTDIR1="$SETUPDIR/.00_built/"

echo
read -p "before to prepare directories, press enter to continue ..." RDVAR_XYZ
rm -rf $TMPWKDIR/
mkdir -p $TMPWKDIR/

echo
read -p "before unpack, press enter to continue ..." RDVAR_XYZ
cd $TMPWKDIR/
tar xf $SETUPDIR/downloaded/ventoy-1.0.94-linux.tar.gz
mkdir -p $TMPWKDIR/src
cp -r $SETUPDIR/* $TMPWKDIR/src/

echo
read -p "before patch, press enter to continue ..." RDVAR_XYZ
cd $TMPWKDIR/
# patch -p1 < $TMPWKDIR/001_mod_install_dir.patch
# OLDSTRING='$HOME/.local/share/'
# NEWSTRING='"usr/share/'
# grep -rl $OLDSTRING ./ | xargs sed -i "s@$OLDSTRING@$NEWSTRING@g"
# patch -p1 < $TMPWKDIR/002_cursors_theme.patch

echo
read -p "before moving the filesystem, press enter to continue ..." RDVAR_XYZ
cd $TMPWKDIR/
mkdir -p $TMPWKDIR/_00_fsbuild/opt/
mv $TMPWKDIR/ventoy-1.0.94 $TMPWKDIR/_00_fsbuild/opt/ventoy-usb

echo
read -p "before copying custom files, press enter to continue ..." RDVAR_XYZ
mkdir -p /$TMPWKDIR/_00_fsbuild/usr/bin/
cp $TMPWKDIR/src/files/ventoy2disk /$TMPWKDIR/_00_fsbuild/usr/bin/
chmod a+x /$TMPWKDIR/_00_fsbuild/usr/bin/ventoy2disk
cp $TMPWKDIR/src/files/ventoy-web /$TMPWKDIR/_00_fsbuild/usr/bin/
chmod a+x /$TMPWKDIR/_00_fsbuild/usr/bin/ventoy-web
mkdir -p /$TMPWKDIR/_00_fsbuild/usr/share/icons/hicolor/128x128/apps/
cp /$TMPWKDIR/_00_fsbuild/opt/ventoy-usb/WebUI/static/img/VentoyLogo.png /$TMPWKDIR/_00_fsbuild/usr/share/icons/hicolor/128x128/apps/ventoy.png

echo
read -p "before deb package building, press enter to continue ..." RDVAR_XYZ
cd $TMPWKDIR/src/
dash /opt/program_files/q4os-devpack/appsetup/create_q4app_setup.sh installer.cfg

echo
read -p "before copying resulted files, press enter to continue ..." RDVAR_XYZ
rm -rf $OUTDIR1/
mkdir -p $OUTDIR1/
cp $TMPWKDIR/_00_setup_out/*.esh $TMPWKDIR/_00_setup_out/*.qsi $OUTDIR1/
