#!/bin/bash
set -e
USER_AGENT="WireGuard-AndroidROMBuild/0.1 ($(uname -a))"

[[ $(( $(date +%s) - $(stat -c %Y "net/wireguard/.check" 2>/dev/null || echo 0) )) -gt 86400 ]] || exit 0

[[ $(curl -A "$USER_AGENT" -LSs https://git.zx2c4.com/WireGuard/refs/) =~ snapshot/WireGuard-([0-9.]+)\.tar\.xz ]]

rm -rf net/wireguard
mkdir -p net/wireguard
curl -A "$USER_AGENT" -LsS "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20190601.tar.xz" | tar -C "net/wireguard" -xJf - --strip-components=2 "WireGuard-0.0.20190601/src"
sed -i 's/tristate/bool/;s/default m/default y/;' net/wireguard/Kconfig
touch net/wireguard/.check
