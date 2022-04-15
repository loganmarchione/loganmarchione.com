---
title: "Raspi-config's mostly undocumented non-interactive mode"
date: "2021-07-22"
author: "Logan Marchione"
categories: 
  - "oc"
  - "linux"
  - "raspberry"
cover:
    image: "/assets/featured/featured_raspberry_logo.svg"
    alt: "featured image"
    relative: false
---

# Introduction

If you've ever used a Raspberry Pi, you've probably used the `raspi-config` [configuration tool](https://www.raspberrypi.org/documentation/configuration/raspi-config.md). This [text-based user interface](https://en.wikipedia.org/wiki/Text-based_user_interface) (TUI) is great for changing 99% of basic settings on the Raspberry Pi, such as the hostname, WiFi country, locale, memory split, etc...

{{< img src="20210722_001.png" alt="resume snippet" >}}

However, if you're managing a fleet of Raspberry Pi devices, or just really like configuration management tools, you're probably looking for a way to automate setting these items from the command line. I'm not sure how I've never come across this, but I _just_ learned that `raspi-config` has a mostly undocumented non-interactive mode that will do precisely that.

# Mostly undocumented

When I say "mostly undocumented", I'm referring specifically to the non-interactive (`nonint`) mode of `raspi-config`. The `raspi-config` tool itself is [documented](https://www.raspberrypi.org/documentation/configuration/raspi-config.md), and the `config.txt` file (where a lot of Raspberry Pi settings are saved) is also [documented](https://www.raspberrypi.org/documentation/configuration/config-txt/README.md). In fact, the only raspberrypi.org page I could find that referenced `nonint` was [this](https://www.raspberrypi.org/magpi-issues/MagPi-EduEdition02.pdf) issue of The MagPi. 

The rest of the documentation for the non-interactive mode is from reading code. First was [here](https://github.com/raspberrypi-ui/rc_gui/blob/master/src/rc_gui.c), in the GTK version of the `raspi-config` tool. You can see all the commands that start with `raspi-config nonint`, such as `raspi-config nonint do_wifi_country`. Second was [here](https://github.com/RPi-Distro/raspi-config/blob/master/raspi-config), in the `raspi-config` tool itself. Since `raspi-config` is just a shell script, this was useful for getting function names, such as `get_can_expand()` and `do_change_locale()`.

The non-interactive mode is basically split into two modes: get and do. `get` is for checking current settings, and `do` is for writing new settings.

# Examples

Keep in mind that some of these changes will need a reboot to take effect.

## Hostname

* To get the current hostname: `sudo raspi-config nonint get_hostname`
* To set a new hostname: `sudo raspi-config nonint do_hostname NEW_HOSTNAME`

## WiFi country

* To get the current WiFi country: `sudo raspi-config nonint get_wifi_country`
* To set a new WiFi country: `sudo raspi-config nonint do_wifi_country US`

## Locale

I didn't see a `raspi-config` command to get the current locale, but you can just run `locale`.

* To set a new locale: `sudo raspi-config nonint do_change_locale en_US.UTF-8`

## Memory split

* To get current GPU memory split: `sudo raspi-config nonint get_config_var gpu_mem /boot/config.txt`
* To set a new GPU memory split: `sudo raspi-config nonint do_memory_split 256`

## Wait for network on boot

* To get current network on boot setting: `sudo raspi-config nonint get_boot_wait`
* To enable waiting for network on boot: `sudo raspi-config nonint do_boot_wait 0`

## Pi hardware

These commands won't return any output to the terminal, but exit code 0 means true, exit code 1 means false. Interestingly, I didn't see a command to check for a Pi 3.

* To see if your device is a Pi 1: `sudo raspi-config nonint is_pione`
* To see if your device is a Pi 2: `sudo raspi-config nonint is_pitwo`
* To see if your device is a Pi Zero: `sudo raspi-config nonint is_pizero`
* To see if your device is a Pi 4: `sudo raspi-config nonint is_pifour`

# Use cases

If you had a cluster of Raspberry Pi devices and wanted to see the GPU memory split on them, you could use an Ansible playbook or [ad-hoc command](https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html).

```
ansible host_or_group_name_here -a "raspi-config nonint get_config_var gpu_mem /boot/config.txt"
```

Then, if you wanted to change the devices in that cluster to have a minimal memory split, you could use another ad-hoc command (this assumes you have SSH and sudo setup on the target device(s)).

```
ansible host_or_group_name_here -a "raspi-config nonint do_memory_split 16" --become --ask-become-pass
```

I'm using this exact setup in my homelab to keep my Pi settings the same across the board.

# Conclusion

Because these command are undocumented, I'm guessing they're unsupported from the command line and could change at any time (see changes to `raspi-config` [here](https://github.com/RPi-Distro/raspi-config/commits/master)). However, if you're feeling adventurous and/or want to keep your settings in scripts or configuration management, this might be the option for you.

\-Logan