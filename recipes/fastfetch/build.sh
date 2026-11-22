#!/bin/bash
# name: fastfetch
# version: 2.31.0
# depends:

set -e
wget https://github.com/fastfetch-cli/fastfetch/releases/download/2.71.0/fastfetch-linux-amd64.tar.gz
tar -xf fastfetch-linux-amd64.tar.gz
cp -r fastfetch-linux-amd64/usr "$DESTDIR/"
