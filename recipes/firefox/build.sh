#!/bin/bash
# name: firefox
# version: latest
# depends:

set -e
mkdir -p "$DESTDIR/opt" "$DESTDIR/usr/bin" "$DESTDIR/usr/share/applications"

HOST="https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
wget -O firefox.tar.xz "${HOST}${QUERY}"

tar -xf firefox.tar.xz -C "$DESTDIR/opt/"
ln -s /opt/firefox/firefox "$DESTDIR/usr/bin/firefox"

cat << 'DESKTOP' > "$DESTDIR/usr/share/applications/firefox.desktop"
[Desktop Entry]
Name=Firefox
Comment=Web Browser
Exec=/usr/bin/firefox %u
Terminal=false
Type=Application
Icon=/opt/firefox/browser/chrome/icons/default/default128.png
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;
DESKTOP
