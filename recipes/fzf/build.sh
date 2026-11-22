#!/bin/bash
# name: fzf
# version: 0.56.3
# depends: jq

set -e
mkdir -p "$DESTDIR/usr/bin"
BASE="https://github.com"
wget -O fzf.tar.gz "$BASE/junegunn/fzf/releases/download/v0.56.3/fzf-0.56.3-linux_amd64.tar.gz"
tar -xf fzf.tar.gz -C "$DESTDIR/usr/bin"
chmod +x "$DESTDIR/usr/bin/fzf"
