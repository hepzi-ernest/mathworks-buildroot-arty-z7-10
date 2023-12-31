################################################################################
#
# arm-trusted-firmware
#
################################################################################

ARM_TRUSTED_FIRMWARE_VERSION = $(call qstrip,$(BR2_TARGET_ARM_TRUSTED_FIRMWARE_VERSION))
ARM_TRUSTED_FIRMWARE_LICENSE = BSD-3-Clause
ARM_TRUSTED_FIRMWARE_LICENSE_FILES = license.rst

ARM_TRUSTED_FIRMWARE_DEPENDENCIES += uboot

ifeq ($(ARM_TRUSTED_FIRMWARE_VERSION),custom)
# Handle custom ATF tarballs as specified by the configuration
ARM_TRUSTED_FIRMWARE_TARBALL = $(call qstrip,$(BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_TARBALL_LOCATION))
ARM_TRUSTED_FIRMWARE_SITE = $(patsubst %/,%,$(dir $(ARM_TRUSTED_FIRMWARE_TARBALL)))
ARM_TRUSTED_FIRMWARE_SOURCE = $(notdir $(ARM_TRUSTED_FIRMWARE_TARBALL))
BR_NO_CHECK_HASH_FOR += $(ARM_TRUSTED_FIRMWARE_SOURCE)
else ifeq ($(BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_GIT),y)
ARM_TRUSTED_FIRMWARE_SITE = $(call qstrip,$(BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_REPO_URL))
ARM_TRUSTED_FIRMWARE_SITE_METHOD = git
else
ARM_TRUSTED_FIRMWARE_SITE = $(call github,ARM-software,arm-trusted-firmware,$(ARM_TRUSTED_FIRMWARE_VERSION))
endif

ARM_TRUSTED_FIRMWARE_INSTALL_IMAGES = YES

ARM_TRUSTED_FIRMWARE_PLATFORM = $(call qstrip,$(BR2_TARGET_ARM_TRUSTED_FIRMWARE_PLATFORM))

ARM_TRUSTED_FIRMWARE_MAKE_OPTS += \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	BL33=$(BINARIES_DIR)/u-boot.bin \
	$(call qstrip,$(BR2_TARGET_ARM_TRUSTED_FIRMWARE_ADDITIONAL_VARIABLES)) \
	PLAT=$(ARM_TRUSTED_FIRMWARE_PLATFORM) \
	all fip

ifeq ($(BR2_TARGET_VEXPRESS_FIRMWARE),y)
ARM_TRUSTED_FIRMWARE_MAKE_OPTS += SCP_BL2=$(BINARIES_DIR)/scp-fw.bin
ARM_TRUSTED_FIRMWARE_DEPENDENCIES += vexpress-firmware
endif

define ARM_TRUSTED_FIRMWARE_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) $(ARM_TRUSTED_FIRMWARE_MAKE_OPTS) \
			$(ARM_TRUSTED_FIRMWARE_MAKE_TARGET)
endef

define ARM_TRUSTED_FIRMWARE_INSTALL_IMAGES_CMDS
	cp -dpf $(@D)/build/$(ARM_TRUSTED_FIRMWARE_PLATFORM)/release/*.bin $(BINARIES_DIR)/
endef

# Configuration ckeck
ifeq ($(BR2_TARGET_ARM_TRUSTED_FIRMWARE)$(BR_BUILDING),yy)

ifeq ($(ARM_TRUSTED_FIRMWARE_VERSION),custom)
ifeq ($(call qstrip,$(BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_TARBALL_LOCATION))),)
$(error No tarball location specified. Please check BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_TARBALL_LOCATION))
endif
endif

ifeq ($(BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_GIT),y)
ifeq ($(call qstrip,$(BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_REPO_URL)),)
$(error No repository specified. Please check BR2_TARGET_ARM_TRUSTED_FIRMWARE_CUSTOM_REPO_URL)
endif
endif

endif

$(eval $(generic-package))
