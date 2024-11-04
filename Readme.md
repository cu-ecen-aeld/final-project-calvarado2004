# Raspberry Pi 5 Buildroot Project

This project provides a Buildroot-based environment for the Raspberry Pi 5, including WiFi support, networking tools, and integration with the BCM2835 library for sensor interaction.

## Author

Carlos Alvarado Martinez

## Prerequisites

The following resources are required for this project:
- A Raspberry Pi 5
- Access to the [Buildroot repository, branch `2024.08.x`](https://github.com/buildroot/buildroot/tree/2024.08.x)
- A Linux-based build environment with Git

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

This configuration provides a base setup for the Raspberry Pi 5; however, additional configurations are necessary to support WiFi, network tools, and sensor functionality.

### 3. Enable WiFi Support

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

### 4. Configure DHCP Client

Ensure that `dhclient` is available to obtain an IP address automatically:

1. **Install `dhclient`**:
    - Navigate to `Target packages` > `Networking applications` and enable `dhclient`.

### 5. Set Up the BCM2835 Library for Sensor Integration

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

### 6. Automate WiFi Connection on Boot

To automate the WiFi startup process, a script named `wifi_startup.sh` can be created. This script should be placed in `base_external/rootfs_overlay/etc/init.d/` in the Buildroot overlay.

```bash
WPA_CONF="/etc/wpa_supplicant.conf"

case "$1" in
  start)
    echo "Starting WiFi..."
    # Ensure WiFi interface is up
    ifconfig wlan0 up
    # Start wpa_supplicant with the specified configuration file
    wpa_supplicant -B -i wlan0 -c "$WPA_CONF"
    # Obtain IP via DHCP
    dhclient wlan0
    ;;
  stop)
    echo "Stopping WiFi..."
    # Stop wpa_supplicant
    killall wpa_supplicant
    # Release DHCP
    dhclient -r wlan0
    ;;
  restart)
    $0 stop
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

### 7. Exclude WiFi Credentials from Version Control

To prevent committing WiFi credentials, add `wpa_supplicant.conf` to `.gitignore`:

```plaintext
base_external/rootfs_overlay/etc/wpa_supplicant.conf
```

### 8. Build the Project

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

Insert the SD card into the Raspberry Pi 5, power it on, and it will automatically connect to WiFi and enable BCM2835-based sensor integration.

---

This setup provides a comprehensive Buildroot environment tailored for the Raspberry Pi 5, complete with automated WiFi connection and sensor support via the BCM2835 library.