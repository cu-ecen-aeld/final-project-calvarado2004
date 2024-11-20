# Raspberry Pi 5 Buildroot Project

This project provides a Buildroot-based environment for the Raspberry Pi 5, integrating a custom BME280 sensor driver that uses I2C headers and IOCTL, WiFi support, networking tools, and integration with the BCM2835 library for sensor interaction.

## Author

Carlos Alvarado Martinez

## Wiki Pages

- [Overview](https://github.com/cu-ecen-aeld/final-project-calvarado2004/wiki)
- [Schedule](https://github.com/cu-ecen-aeld/final-project-calvarado2004/wiki/Schedule)

## Prerequisites

The following resources are required for this project:
- A Raspberry Pi 5
- Access to the [Buildroot repository, branch `2024.08.x`](https://github.com/buildroot/buildroot/tree/2024.08.x)
- A Linux-based build environment with Git

## External Repositories

This project uses the following external repositories:

- **BME280 Driver**: Custom kernel space driver that uses I2C headers and IOCTL for communication with the BME280 sensor.
  - Repository: [BME280 Driver](https://github.com/calvarado2004/bme280-driver)
  - Commit: `40d7e48`
- **BME280 Sensor User-Space Program**: User-space program for reading temperature, humidity, and pressure data from the BME280 sensor.
  - Repository: [BME280 Sensor](https://github.com/calvarado2004/bme280-sensor)
  - Commit: `a15648d`

## Project Setup

### 1. Clone the Buildroot Repository

Clone the Buildroot repository and check out the `2024.08.x` branch:

```bash
git clone https://github.com/buildroot/buildroot.git
cd buildroot
git checkout 2024.08.x
```

### 2. Configure Buildroot for the Raspberry Pi 5

Load the Raspberry Pi 5 default configuration:

```bash
make raspberrypi5_defconfig
```

This configuration provides a base setup for the Raspberry Pi 5; additional configurations are necessary to support WiFi, network tools, sensor functionality, and external repositories.

### 3. Integrate the Custom BME280 Driver

Ensure the Buildroot project is configured to build the BME280 driver from the external repository.

- **BME280 Driver Setup**:
  - Add the `bme_driver` package to your Buildroot setup.
  - Update `bme_driver.mk` to fetch and build from the external repository using the specific commit.

### 4. Integrate the BME280 User-Space Program

Configure Buildroot to include the user-space program for reading BME280 sensor data.

- **BME280 Sensor Program Setup**:
  - Add the `bme_sensor` package to your Buildroot setup.
  - Update `bme_sensor.mk` to point to the GitHub repository and use the specified commit.

### 5. Enable WiFi Support

To enable WiFi, perform the following steps:

1. **Enable Firmware**:
    - Navigate to `Target packages` > `Hardware handling` > `Firmware`.
    - Select the following options:
      ```
      [*] linux-firmware
          [*] rpi-wifi-firmware
      ```

2. **Add Wireless Tools**:
    - Go to `Target packages` > `Networking applications`.
    - Enable the following packages:
      ```
      [*] wireless_tools
      [*] wpa_supplicant
          [*] Enable nl80211 driver
          [*] Enable WPA2
      ```

### 6. Configure DHCP Client

Ensure that `dhclient` is available to obtain an IP address automatically:

1. **Install `dhclient`**:
    - Navigate to `Target packages` > `Networking applications` and enable `dhclient`.

### 7. Set Up the BCM2835 Library for Sensor Integration

The BCM2835 library enables low-level access to the Raspberry Pi’s GPIO pins and hardware features, which is essential for sensor functionality.

1. **Download the BCM2835 Library**:
    - Obtain the library from the official [BCM2835 Library website](https://www.airspayce.com/mikem/bcm2835/).

2. **Configure the Buildroot Overlay**:
    - Integrate the BCM2835 library source files into the Buildroot overlay or compile and install it manually after Buildroot setup:
      ```bash
      ./configure
      make
      sudo make install
      ```

3. **Add the Library Path**:
    - Ensure that the path to the BCM2835 library is correctly specified in application build scripts to facilitate sensor interaction.

### 8. Automate WiFi Connection on Boot

Create a script named `wifi_startup.sh` to automate the WiFi startup process. Place it in `base_external/rootfs_overlay/etc/init.d/`.

```bash
WPA_CONF="/etc/wpa_supplicant.conf"

case "$1" in
  start)
    echo "Starting WiFi..."
    ifconfig wlan0 up
    wpa_supplicant -B -i wlan0 -c "$WPA_CONF"
    dhclient wlan0
    ;;
  stop)
    echo "Stopping WiFi..."
    killall wpa_supplicant
    dhclient -r wlan0
    ;;
  restart)
    $0 stop
    sleep 3
    $0 start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    exit 1
    ;;
esac

exit 0
```

- Place this file in `base_external/rootfs_overlay/etc/init.d/S99wifi_startup`.

### 9. Exclude WiFi Credentials from Version Control

Add `wpa_supplicant.conf` to `.gitignore` to prevent committing sensitive credentials:

```plaintext
base_external/rootfs_overlay/etc/wpa_supplicant.conf
```

### 10. Build the Project

Once all configurations are complete, build the project:

```bash
make
```

## Flashing the SD Card

After building, flash the generated image to an SD card:

```bash
sudo dd if=output/images/sdcard.img of=/dev/sdX bs=4M
sync
```

Replace `/dev/sdX` with the actual device identifier for the SD card.

## Running on the Raspberry Pi 5

Insert the SD card into the Raspberry Pi 5, power it on, and it will automatically connect to WiFi and enable BCM2835-based sensor interaction, leveraging the custom BME280 kernel driver and user-space program.
