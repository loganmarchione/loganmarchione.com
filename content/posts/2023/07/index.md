---
title: "Using the Bangle.js 2 smartwatch for one week"
date: "2023-07-16"
author: "Logan Marchione"
categories:
  - "oc"
  - "linux"
cover:
    image: "/assets/featured/featured_tux.svg"
    alt: "featured image"
    relative: false
---

# Introduction

I've been looking for my first smartwatch, but have been in analysis paralysis for a while. I recently found the [Bangle.js 2](https://www.espruino.com/Bangle.js2) and have been using it for a week now. These are my thoughts.

## My daily driver

I'll start by saying that I'm not a "watch person". My daily driver is a [Casio G-SHOCK GWM5610](https://www.casio.com/us/watches/gshock/product.GW-M5610-1/) (the only other watch I own is a dress watch that I wear once a year). 

The GWM5610 is nothing but pragmatic. It has standard G-SHOCK toughness, 200-meter water resistance, and standard digital watch features (e.g., stopwatch, countdown timer, calendar, alarm, etc...). What sold me was that it has a small solar panel on the face and it gets the date/time via radio signals (what Casio calls [Multiband 6](https://gshock.casio.com/us/technology/radio/)). Combined, this means it _never_ needs to be taken off my wrist, _never_ needs to be charged, and the time _never_ needs to be set (talk about pragmatic).

In fact, I'll go as far as to say if you don't own one already, you should purchase one right now (also pick up a set of [these wire "bullbars"](https://www.ebay.com/itm/282968618910)).

## My options

The GWM5610 lacks any "smart" features. I don't really want/need activity tracking, but sleep tracking and notifications would be nice.

For my computers, I run Linux and Windows at home, but I don't use a Mac (except where I'm [forced](/2022/04/impressions-from-a-first-time-mac-user/) to at work). For my mobile phone, I prefer iOS over Android. I think Apple makes nicer hardware, there is no doubt that Apple collects less information than Google, and Apple does more on-device processing. I'm not saying that Apple is amazing, but they're the lesser of two evils. :man_shrugging:

So, given my requirements and background, I was looking for a glorified notification display to wear on my wrist, that worked with my iPhone, and any other features were extra.

I considered these commericially available smartwatches:

- [Apple Watch Series 8](https://www.apple.com/apple-watch-series-8/)
- [Casio G-SHOCK MOVE DWH5600](https://gshock.casio.com/us/products/gshock-move/dw-h5600/) (this was just announced in spring 2023)
- [Garmin Instinct 2 Solar](https://www.garmin.com/en-US/p/775697/pn/010-02627-10) (there are dozens of variants of this model alone)

I also considered these more "hacker-grade" watches:

- [PineTime](https://www.pine64.org/pinetime/)
- [SQFMI Watchy](https://watchy.sqfmi.com/)
- [M5StickC Plus](https://shop.m5stack.com/products/m5stickc-plus-with-watch-accessories)

However, I found the [Bangle.js 2](https://www.espruino.com/Bangle.js2) and immediately bought it just based on the fact that I hadn't heard of it before.

Just a FYI - I don't do sponsored content. I never spoke with anyone at Bangle.js and I paid for my Bangle.js 2 with my own money.

# Hardware

I won't rehash the [specs](https://www.espruino.com/Bangle.js2) of the Bangle.js 2, but the main takeaways are:

- IP67 water resistance (i.e., splash-proof)
- nRF52840 ARM SoC (i.e., an ESP32 alternative) with 8MB flash
- 1.3-inch always-on touchscreen display with hardened glass
- single hardware button
- GPS receiver
- heart-rate monitor
- accelerometer
- magnetometer (i.e., compass)
- barometer
- 200mAh battery (with a claimed 4 weeks of standby time)

For $106, that's a lot of hardware in a small package. I was very impressed with the build quality for what seemed like such a small company.

The package took about a week to arrive to my house in the US from the UK. In the box was the watch body, a strap, and a proprietary magnetic charging cable with pogo pins on one end and USB-A on the other.

The battery was dead on arrival, so I plugged it in and the "Welcome" tutorial ran.

## Battery

I charged the watch to 100% on the evening of 2023-07-09 (Sunday).

# Software

## Espruino

The software that runs on the SoC is [Espruino](https://github.com/espruino/Espruino), an open-source Javascript interpreter for microcontrollers (which is exciting and terrifying at the same time).

Espruino (the software) [powers](https://www.espruino.com/Order) a number of Espruino (the company) boards, and it is compatible with many [third-party boards](https://www.espruino.com/Other+Boards) as well.

## Bangle.js software

The software that runs on the watch is quirky, but once you get the hang of it, it's not too bad.

As far as I understand, _everything_ in the interface is an app. This includes things that are obviously apps (e.g., the compass, the sleep tracker, etc...), but also system-level things (e.g., the launcher, the battery widget, the settings menu). The watch will ship with a default set of apps, but will need to be connected to Espruino's [App Loader](https://banglejs.com/apps/) to download new apps and updates (more on that below).  

The single hardware button is both the "menu" button, as well as the "back" button when navigating menus. Holding the button for two seconds in any screen will take you back to the watch face. Holding the button for ten seconds reboots the watch (you turn the watch off via the Settings menu).

## Loading apps

All apps are loaded from a device (a phone or PC/laptop) via [Web Bluetooth](https://developer.mozilla.org/en-US/docs/Web/API/Web_Bluetooth_API). This means you open a browser with Web Bluetooth support, browse to the App Loader website, connect to the watch inside the browser, then load apps from your device to the watch via Bluetooth. You don't need to use your operating system's Bluetooth pairing menu (the pairing happens inside the browser).

I think this system is really slick (it's platform agnostic), but it does have some drawbacks:

1. Right now, only Chrome/Chromium and Edge have Web Bluetooth [support](https://caniuse.com/web-bluetooth) (it needs to be enabled with an experimental flag)
1. iOS users can't load apps using Safari (instead, you need to use a browser like [WebBLE](https://apps.apple.com/us/app/webble/id1193531073), or just use a PC/laptop)
1. You can't connect the watch to two devices at once (e.g., you can't connect it to your laptop to load apps while it's connected to your phone)

As far as the overall experience goes, the App Loader is very responsive and quick to install apps. The apps are all [open-source](https://github.com/espruino/BangleApps), and because they're Javascript, they're small (which is probably why they're fast to install).

There is a basic dependency management system in place for apps. For example, installing the _iOS Integration_ app installed a few other apps as dependencies. 

Below are some other apps I installed: 

- App Manager
- Barometer
- Battery Level Widget (to show the percentage battery inside the icon)
- Compass
- GPS Info

The App Loader can also detect when a new app provides the same functionality and offers to replace it. For example, since everything is an app (including the battery widget), when you install a new one, if offers to remove the old one.

```
App "Battery Level Widget" provides widget type "battery" which is already provided by "Battery Level Widget (with percentage)". What would you like to do?

[Replace] [Cancel] [Keep Both]
```

## Interface experience

The interface isn't going to be super-fast and 60Hz smooth (like the Apple Watch), but if you remember that you're running Javascript on a SoC the size of a shirt button, then you'll be impressed.

# Recommendations for buyers

If you're buying a Bangle.js 2, here is what I recommend right away.

## Calibrate the LCD

Out of the box, the LCD wasn't registering my touches well, but in the Settings menu there was an option to calibrate the LCD, which made it much more responsive.

## Those digits in the corner

There will be a four-digit code (on two lines) in the top-right corner of the display. This is the watch's identifier. You'll see this used when trying to pair the watch. This is an app that you can remove (if you only have one watch and don't need to tell another apart).

## Install the companion app (and others)

The "smart" features of a smartwatch don't work unless you link it to your phone. I did this by installing the [iOS Integration app](https://banglejs.com/apps/#ios) from the Bangle.js App Loader website. This shares notifications from whatever is in your iOS Notification Center to your watch. Obviously it's not going to display images and clickable links won't work, but it vibrates, beeps, and generally gets your attention. When you dismiss notifications on your iPhone, they are dismissed on the watch.

## Tweak all the settings

Go into every menu in settings and look around. For example, I changed:

- The system theme to dark mode
- Turned off the beep
- Change the vibration pattern for messages and calls
- Change the LCD timeout
- Change the wake settings (e.g., wake on rotate, on hardware button, on touch, on twist)

# Critiques

Below are some critiques I had (in no particular order). They were not show-stoppers, just ideas for a Bangle.js 3...

- Plastic build: I would pay more money for a metal watch body.
- Single hardware button: I'm sure it's patented, but the Apple Watch has a hardware button, as well as Digital Crown that both rotates and presses inwards. Something like this would make navigating the watch interface easier.
- Metal contacts touching skin: The watch has four metal contacts on the back (two outer two are for charging, the inner two are for debugging). [Per the FAQ](https://github.com/espruino/BangleApps/wiki#important-usage-information), the inner two have a small voltage running between them. The watch will ship with a piece of tape covering these two, but if the tape were to fall off, the direct contact with your skin _could_ cause corrosion on the contacts or even [skin irritation](https://www.espruino.com/Bangle.js2#contact-corrosion-skin-irritation). This _did not_ happen to me, but it's something to be away of.
- Magnetic charger orientation: The magnetic charger needs to be attached to the watch from the right-side (if you're looking at the screen). I wish the cable could be omni-directional (or use wireless charging).
- The magnets are weak: The magnets on the charger seem to do a good job aligning the pogo pings to the metal contact points, but they are so weak that the slightest bump makes the pins disconnect. I wish the magnets were stronger (or maybe that the pogo pins had less "spring").
- Make LCD calibration part of the initial "Welcome" tutorial: As I mentioned, the touchscreen response was very poor until I ran the LCD calibration. I wish the LCD calibration was part of the "Welcome" tutorial. Also, I might just have fat fingers.

# Conclusion

For $106, you're obviously not getting Apple-esque levels of hardware and software. But, if you understand what you are getting, you'll be impressed (I was). For an open-source project, you're getting a very capable device. I'm not a developer, but if you are, this could be the perfect device for you.

\-Logan