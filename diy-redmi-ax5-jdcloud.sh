#!/bin/bash
set -e

# 修改默认 LAN IP 为 192.168.10.1
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate

# 稀疏克隆 OpenClash
git clone --depth=1 -b master --single-branch --filter=blob:none --sparse https://github.com/vernesong/OpenClash openclash_tmp
cd openclash_tmp
git sparse-checkout set luci-app-openclash
mv -f luci-app-openclash ../package/luci-app-openclash
cd ..
rm -rf openclash_tmp

# 预置 ARM64 Clash Meta (mihomo) 内核，避免首次启动无内核
mkdir -p files/etc/openclash/core
curl -fsSL "https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz" | tar -xzO > files/etc/openclash/core/clash_meta
chmod 755 files/etc/openclash/core/clash_meta

# 更新并安装 feeds
./scripts/feeds update -a
./scripts/feeds install -a
