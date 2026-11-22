#!/bin/bash
# name: jq
# version: 1.7.1
# depends:

set -e
mkdir -p "$DESTDIR/usr/bin"
BASE="https://github.com"
wget -O "$DESTDIR/usr/bin/jq" "$BASE/jqlang/jq/releases/download/jq-1.7.1/jq-linux-amd64"
chmod +x "$DESTDIR/usr/bin/jq"
