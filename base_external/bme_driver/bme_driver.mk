################################################################################
#
# bme_driver
#
################################################################################

BME_DRIVER_VERSION = cb6ab52
BME_DRIVER_SITE = https://github.com/calvarado2004/bme280-driver.git
BME_DRIVER_SITE_METHOD = git
BME_DRIVER_LICENSE = GPL-2.0
BME_DRIVER_LICENSE_FILES = COPYING
BME_DRIVER_DEPENDENCIES = linux

# Retrieve the kernel version from the target directory or from the current system
ACTUAL_KERNEL_VERSION = $(shell basename $(shell ls $(TARGET_DIR)/lib/modules/))

# Build using the Makefile, accounting for the commit hash in the directory name
BME_DRIVER_BUILD_DIR = $(BUILD_DIR)/bme_driver-$(BME_DRIVER_VERSION)

define BME_DRIVER_BUILD_CMDS
	$(MAKE) -C $(LINUX_DIR) ARCH=arm64 CROSS_COMPILE=$(TARGET_CROSS) M=$(BME_DRIVER_BUILD_DIR) modules
endef

define BME_DRIVER_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(BME_DRIVER_BUILD_DIR)/bme_driver.ko $(TARGET_DIR)/lib/modules/$(ACTUAL_KERNEL_VERSION)/kernel/drivers/misc/bme_driver.ko
endef

# Evaluate the package
$(eval $(generic-package))
