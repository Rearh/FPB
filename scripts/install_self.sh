#!/bin/bash
set -e
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

install -Dm755 "$REPO_DIR/bin/fml_pkg_bin" /usr/bin/fml_pkg_bin
if [ ! -f /etc/fml_pkg_bin.conf ]; then
    install -Dm644 "$REPO_DIR/config/fml_pkg_bin.conf" /etc/fml_pkg_bin.conf
fi
echo "[+] fml_pkg_bin установлен в /usr/bin/fml_pkg_bin."
