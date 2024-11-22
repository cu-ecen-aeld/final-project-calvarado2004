################################################################################
#
# bme_sensor
#
################################################################################

BME_SENSOR_VERSION = 00f18aa
BME_SENSOR_SITE = https://github.com/calvarado2004/bme280-sensor.git
BME_SENSOR_SITE_METHOD = git

# Build using the Makefile
define BME_SENSOR_BUILD_CMDS
	$(MAKE) -C $(BUILD_DIR)/bme_sensor-$(BME_SENSOR_VERSION) CC=$(TARGET_CC) CFLAGS="$(TARGET_CFLAGS)" LDFLAGS="$(TARGET_LDFLAGS)"
endef

define BME_SENSOR_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(BUILD_DIR)/bme_sensor-$(BME_SENSOR_VERSION)/bme_sensor $(TARGET_DIR)/usr/bin/bme_sensor
endef

# Evaluate the package
$(eval $(generic-package))
