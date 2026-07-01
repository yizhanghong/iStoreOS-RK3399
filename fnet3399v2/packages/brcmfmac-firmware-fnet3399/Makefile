include $(TOPDIR)/rules.mk

PKG_NAME:=brcmfmac-firmware-fnet3399

PKG_SOURCE_URL:=https://github.com/yizhanghong/rk3399-firmware.git
PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=ee9df54cab893ccf4c4030b6b813f9741fcb8687
PKG_MIRROR_HASH:=skip

include $(INCLUDE_DIR)/package.mk

define Package/brcmfmac-firmware-fnet3399
  SECTION:=firmware
  CATEGORY:=Firmware
  URL:=https://github.com/ophub/firmware.git
  TITLE:=Fnet3399 BCM43430b0 Firmware
endef

define Build/Compile
	true
endef

define Package/brcmfmac-firmware-fnet3399/install
	$(INSTALL_DIR) $(1)/lib/firmware/brcm
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/firmware/brcm/BCM43430B0.hcd \
		$(1)/lib/firmware/brcm/BCM43430B0.hcd
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/firmware/brcm/brcmfmac43430b0-sdio.bin \
		$(1)/lib/firmware/brcm/brcmfmac43430b0-sdio.bin
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/firmware/brcm/brcmfmac43430b0-sdio.txt \
		$(1)/lib/firmware/brcm/brcmfmac43430b0-sdio.txt
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/firmware/brcm/brcmfmac43430-sdio.clm_blob \
		$(1)/lib/firmware/brcm/brcmfmac43430-sdio.clm_blob
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/firmware/brcm/brcmfmac43430b0-sdio.erya,fnet-3399.bin \
		$(1)/lib/firmware/brcm/brcmfmac43430b0-sdio.erya,fnet-3399.bin
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/firmware/brcm/brcmfmac43430b0-sdio.erya,fnet-3399.txt \
		$(1)/lib/firmware/brcm/brcmfmac43430b0-sdio.erya,fnet-3399.txt
endef

$(eval $(call BuildPackage,brcmfmac-firmware-fnet3399))
