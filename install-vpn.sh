#!/usr/bin/env bash
set -euo pipefail

if [ "${EUID}" -ne 0 ]; then
    echo "Run this installer as root: sudo ./install.sh" >&2
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FILES_DIR="${SCRIPT_DIR}/files"

install -d /usr/sbin
install -m 0755 "${FILES_DIR}/usr-sbin/vpn" /usr/sbin/vpn
install -m 0755 "${FILES_DIR}/usr-sbin/vpn_fastest_helper" /usr/sbin/vpn_fastest_helper

install -d /usr/share/vpn
cp -a "${FILES_DIR}/usr-share-vpn/." /usr/share/vpn/
find /usr/share/vpn -type d -exec chmod 0755 {} \;
find /usr/share/vpn -type f -exec chmod 0644 {} \;

install -d /usr/share/icons/hicolor/16x16/apps
install -d /usr/share/icons/hicolor/32x32/apps
install -d /usr/share/icons/hicolor/48x48/apps
install -d /usr/share/icons/hicolor/64x64/apps
install -d /usr/share/icons/hicolor/128x128/apps
install -d /usr/share/icons/hicolor/256x256/apps
install -d /usr/share/icons/hicolor/512x512/apps
install -m 0644 "${FILES_DIR}/icons/vpn-manager-16.png" /usr/share/icons/hicolor/16x16/apps/vpn.png
install -m 0644 "${FILES_DIR}/icons/vpn-manager-32.png" /usr/share/icons/hicolor/32x32/apps/vpn.png
install -m 0644 "${FILES_DIR}/icons/vpn-manager-48.png" /usr/share/icons/hicolor/48x48/apps/vpn.png
install -m 0644 "${FILES_DIR}/icons/vpn-manager-64.png" /usr/share/icons/hicolor/64x64/apps/vpn.png
install -m 0644 "${FILES_DIR}/icons/vpn-manager-128.png" /usr/share/icons/hicolor/128x128/apps/vpn.png
install -m 0644 "${FILES_DIR}/icons/vpn-manager-256.png" /usr/share/icons/hicolor/256x256/apps/vpn.png
install -m 0644 "${FILES_DIR}/icons/vpn-manager-512.png" /usr/share/icons/hicolor/512x512/apps/vpn.png

install -d /usr/share/applications
sed 's#^Exec=.*#Exec=/usr/sbin/vpn#; s#^Icon=.*#Icon=vpn#' "${FILES_DIR}/applications/vpn.desktop" > /usr/share/applications/vpn.desktop
chmod 0644 /usr/share/applications/vpn.desktop

if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    gtk-update-icon-cache -f /usr/share/icons/hicolor >/dev/null 2>&1 || true
fi

if command -v update-desktop-database >/dev/null 2>&1; then
    update-desktop-database /usr/share/applications >/dev/null 2>&1 || true
fi

echo "Installed vpn to /usr/sbin/vpn"
echo "Installed vpn_fastest_helper to /usr/sbin/vpn_fastest_helper"
echo "Installed VPN configs to /usr/share/vpn"
echo "Installed desktop launcher to /usr/share/applications/vpn.desktop"
