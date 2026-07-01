#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================


#移植设备
# linux/rockchip/image/armv8.mk添加fnet-3399设备型号
echo -e "\\ndefine Device/erya_fnet-3399
  DEVICE_VENDOR := Erya
  DEVICE_MODEL := FNET 3399
  SOC := rk3399
  UBOOT_DEVICE_NAME := fnet3399-rk3399
  IMAGE/sysupgrade.img.gz := boot-common | boot-script | pine64-img | gzip | append-metadata
  DEVICE_PACKAGES := brcmfmac-firmware-43430b0-sdio brcmfmac-nvram-43430b0-sdio \
	kmod-brcmfmac kmod-gpio-button-hotplug kmod-usb-net-rtl8152 wpad
endef
TARGET_DEVICES += erya_fnet-3399" >> target/linux/rockchip/image/armv8.mk

# 复制修改好的uboot/Makefile到对应目录
cp -f $GITHUB_WORKSPACE/fnet3399v2/uboot-rockchip/Makefile package/boot/uboot-rockchip/Makefile

# 复制patch到对应的目录
cp -f $GITHUB_WORKSPACE/fnet3399v2/uboot-rockchip/patches/993-rk3399-fnet3399-uboot.patch package/boot/uboot-rockchip/patches/993-rk3399-fnet3399-uboot.patch

cp -f $GITHUB_WORKSPACE/fnet3399v2/kernel-rockchip/patches/993-rockchip-rk3399-fnet3399-kernel.patch target/linux/rockchip/patches-6.6/993-rockchip-rk3399-fnet3399-kernel.patch

cp -f $GITHUB_WORKSPACE/fnet3399v2/kernel-rockchip/02_network target/linux/rockchip/armv8/base-files/etc/board.d/02_network


# 集成wifi
cp -a $GITHUB_WORKSPACE/fnet3399v2/packages/* package/firmware/
cp -f $GITHUB_WORKSPACE/fnet3399v2/opwifi package/base-files/files/etc/init.d/opwifi
chmod 755 package/base-files/files/etc/init.d/opwifi
echo "
CONFIG_PACKAGE_brcmfmac-firmware-fnet3399=y
" >> .config


# 集成CPU性能跑分脚本
# cp -f $GITHUB_WORKSPACE/configfiles/coremark/coremark-arm64 package/base-files/files/bin/coremark-arm64
# cp -f $GITHUB_WORKSPACE/configfiles/coremark/coremark-arm64.sh package/base-files/files/bin/coremark.sh
# chmod 755 package/base-files/files/bin/coremark-arm64
# chmod 755 package/base-files/files/bin/coremark.sh


# iStoreOS-settings
# git clone --depth=1 -b main https://github.com/xiaomeng9597/istoreos-settings package/default-settings

# add luci-app-fancontrol
echo "src-git fancontrol https://github.com/DHDAXCW/luci-app-fancontrol.git" >> feeds.conf.default
./scripts/feeds update fancontrol && ./scripts/feeds install -a -f -p fancontrol
echo "
CONFIG_PACKAGE_luci-app-fancontrol=y
" >> .config
#sed -i "s/hwmon9/hwmon2/g" feeds/fancontrol/luci-app-fancontrol/htdocs/luci-static/resources/view/fancontrol.js
sed -i "s/hwmon9/hwmon2/g" feeds/fancontrol/fancontrol/files/fancontrol.config
sed -i "s/255/125/g" feeds/fancontrol/fancontrol/files/fancontrol.config
sed -i "s/55/45/g" feeds/fancontrol/fancontrol/files/fancontrol.config

echo "
CONFIG_TARGET_ROOTFS_TARGZ=y
" >> .config

# add qmodem
echo 'src-git qmodem https://github.com/FUjr/QModem.git;main' >> feeds.conf.default
./scripts/feeds update qmodem
./scripts/feeds install -a -f -p qmodem
# git clone -b v3.0.0 --depth=1 https://github.com/FUjr/QModem.git package/qmodem
sed -i "s/CONFIG_PACKAGE_sms-tool/#CONFIG_PACKAGE_sms-tool/g" .config  
sed -i "s/CONFIG_PACKAGE_luci-app-modem/#CONFIG_PACKAGE_luci-app-modem/g" .config  
sed -i "s/CONFIG_PACKAGE_luci-app-sms-tool/#CONFIG_PACKAGE_luci-app-sms-tool/g" .config
echo "
CONFIG_PACKAGE_luci-i18n-qmodem-zh-cn=y
# CONFIG_PACKAGE_luci-i18n-qmodem-hc-zh-cn=y
# CONFIG_PACKAGE_luci-i18n-qmodem-mwan-zh-cn=y
# CONFIG_PACKAGE_luci-i18n-qmodem-ru is not set
CONFIG_PACKAGE_luci-i18n-qmodem-sms-zh-cn=y
CONFIG_PACKAGE_luci-app-qmodem=y
CONFIG_PACKAGE_luci-app-modem=n
CONFIG_PACKAGE_luci-app-qmodem_INCLUDE_vendor-qmi-wwan=y
# CONFIG_PACKAGE_luci-app-qmodem_INCLUDE_generic-qmi-wwan is not set
CONFIG_PACKAGE_luci-app-qmodem_USE_TOM_CUSTOMIZED_QUECTEL_CM=y
# CONFIG_PACKAGE_luci-app-qmodem_USING_QWRT_QUECTEL_CM_5G is not set
# CONFIG_PACKAGE_luci-app-qmodem_USING_NORMAL_QUECTEL_CM is not set
# CONFIG_PACKAGE_luci-app-qmodem_INCLUDE_ADD_PCI_SUPPORT=y
# CONFIG_PACKAGE_luci-app-qmodem_INCLUDE_ADD_QFIREHOSE_SUPPORT is not set
#CONFIG_PACKAGE_luci-app-qmodem-hc=y
#CONFIG_PACKAGE_luci-app-qmodem-mwan=y
CONFIG_PACKAGE_luci-app-qmodem-sms=y
#CONFIG_PACKAGE_luci-app-qmodem-ttl=y
CONFIG_PACKAGE_qmodem=y
CONFIG_PACKAGE_quectel-CM-5G=y
CONFIG_PACKAGE_quectel-CM-5G-M=y
" >> .config

