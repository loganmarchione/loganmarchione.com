---
title: "LoRa and Meshtastic"
date: "2023-05-10"
author: "Logan Marchione"
categories:
  - "oc"
  - "linux"
cover:
    image: "/assets/featured/featured_drone.svg"
    alt: "featured image"
    relative: false
---

# Introduction

I've been itching to work on some hardware projects lately and kept seeing ESP32-related things pop up on Reddit. 

# LoRa

[LoRa](https://en.wikipedia.org/wiki/LoRa) (from **lo**ng **ra**nge) is a proprietary radio technology that is owned by [Semtech](https://en.wikipedia.org/wiki/Semtech). It is designed for long-range (e.g., 10 miles), low-bandwidth (i.e., measured in Kbps), low-power communication, primarily for the [internet of things](https://en.wikipedia.org/wiki/Internet_of_things) (IoT) network.

LoRa defines the **physical** layer that controls how the radio signals are modulated. Specifically, LoRa uses [chirp spread spectrum](https://en.wikipedia.org/wiki/Chirp_spread_spectrum) (CSS) to encode information. You can view more about LoRa and CSS in [this](https://www.youtube.com/watch?v=dxYY097QNs0) video.

LoRa operates in a license-free, sub-gigahertz frequency band (i.e., under 1GHz or 1000MHz), but each frequency varies from region to region due to regulatory requirements. If you're buying a LoRa device, make sure you pick one tuned to the correct frequency band for your region.

* China - 470-510MHz and 779-787MHz
* Europe - 863–870MHz (typically 868MHz)
* India - 865–867 MHz (typically 865MHz)
* Japan - 920-923MHz
* USA - 902–928 MHz (typically 915MHz)
* South America - 915–928 MHz (typically 915 or 923MHz)

## Why LoRa?

LoRa tries to bridge the gap between current communication technologies, like WiFi, Bluetooth, and cellular (4G/5G).

{{< figure src="20230510_001.png" width="100%" alt="lora vs other communication types" attr="Image from The Things Network" attrlink="https://www.thethingsnetwork.org/docs/lorawan/what-is-lorawan/">}}

LoRa is useful for long-range, low-bandwidth, low-power communication, which is perfect for IoT devices. Some examples include:

* a water sensor in a well in a remote location
* a factory with hundreds of smoke alarms that all need to communicate
* a large nature preserve trying to track animal migration
* a natural gas provider needing to monitor each customer's meter for usage
* a weather station that only occasionally needs to transmit information

## LoRa and LoRaWAN

LoRaWAN builds on top of LoRa to define the communication protocol and system architecture. 

It's important to note that you can use LoRa **without** using LoRaWAN. Other LoRa-based networks (that are not LoRaWAN) include [Helium](https://www.helium.com/), [The Things Network](https://www.thethingsnetwork.org/), [Disaster.radio](https://disaster.radio/), and [Meshtastic](https://meshtastic.org/).

# Meshtastic

[Meshtastic](https://meshtastic.org/) builds on LoRa (not LoraWAN) to produce a decentralized mesh network. Features include:

* Text-based, encrypted communication
* No phone required (e.g., you can use a computer with the right hardware), but there are [iOS](https://apps.apple.com/us/app/meshtastic/id1586432531) and [Android](https://play.google.com/store/apps/details?id=com.geeksville.mesh) applications
* Decentralization
* Great battery life
* Optional GPS location sharing

Unlike the traditional cellular network, each end-user device (e.g., phone, laptop, etc...) connects to a LoRa radio running Meshtastic, and all LoRa radios running Meshtastic can mesh together. Messages are relayed through LoRa radios until they reach their destination.

{{< img src="20230510_003.png" alt="meshtastic network" >}}

## Devices

Meshtastic firmware is available for a handful of [devices](https://meshtastic.org/docs/supported-hardware), but I was looking for:

* 915MHz support (because I'm in the US)
* WiFi and Bluetooth (this meant the MCU needed to be an ESP32 instead of the nRF52840, which lacks WiFi)
* USB-C
* display
* GPS (optional)

I was also looking for the SX1262 instead of the older SX1276 (source [here](https://www.semtech.com/uploads/design-support/SG-SEMTECH-WSP.pdf)).

{{< img src="20230510_002.png" alt="semtech chip comparison" >}}

This left me with the following options:

* [Heltec WiFi LoRa 32 (V3)](https://heltec.org/project/wifi-lora-32-v3/) - No GPS
* [Heltec Wireless Stick Lite (V3)](https://heltec.org/project/wireless-stick-lite-v2/) - No GPS or display
* [LILYGO TTGO T-Beam v1.1](https://www.aliexpress.us/item/2255800992363816.html) - MicroUSB, older NEO-6M GPS, Semtech SX1276
* [LILYGO TTGO T-Beam v1.1 with NEO-M8N](https://www.aliexpress.us/item/2251832703268452.html) - MicroUSB, newer NEO-M8N, Semtech SX1276
* [LILYGO TTGO T-Beam v1.1 with NEO-M8N and SX1262](https://www.aliexpress.us/item/2255801100907218.html) - MicroUSB, newer NEO-M8N, Semtech SX1262
* [LILYGO® TTGO Lora T3S3-V1.0](https://www.aliexpress.us/item/3256804440825086.html) - No GPS


In the end, I purchased 2x:

* [LILYGO® TTGO Lora T3S3-V1.0](https://www.aliexpress.us/item/3256804440825086.html) - No GPS
* [3D printed case](https://www.etsy.com/listing/1470821285/ttgo-t3s3-case-for-meshtastic)
* [915MHz antenna](https://www.amazon.com/915MHz-LoRa-Gateway-Antenna-Connector/dp/B091PRHPTJ) (with SMA male connector)

## Device flashing

I don't mind using the CLI, so I used the Python installer, but they also have a [web-based installer](https://meshtastic.org/docs/getting-started/flashing-firmware/esp32/) available too.

```
mkdir -p ~/Downloads/lora
cd ~/Downloads/lora
python3 -m venv venv
source venv/bin/activate
pip install meshtastic-flasher
meshtastic-flasher
```

# Conclusion

https://www.thethingsnetwork.org/docs/lorawan/what-is-lorawan/
https://lora-alliance.org/resource_hub/what-is-lorawan/
https://tylercipriani.com/blog/2022/07/31/meshtastic-a-review/

asdf

\-Logan