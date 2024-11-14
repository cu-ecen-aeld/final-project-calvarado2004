################################################################################
#
# bme_sensor
#
################################################################################

BME_SENSOR_VERSION = 1.0
BME_SENSOR_SITE = $(BR2_EXTERNAL_FINAL_PROJECT_BASE_EXTERNAL_PATH)/bme_sensor
BME_SENSOR_SITE_METHOD = local

# Build using the Makefile
define BME_SENSOR_BUILD_CMDS
	$(MAKE) -C $(BME_SENSOR_SITE) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)"
endef

define BME_SENSOR_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(BME_SENSOR_SITE)/bme_sensor $(TARGET_DIR)/usr/bin/bme_sensor
endef

# Evaluate the package
$(eval $(generic-package))
