---
title: "Using the Bangle.js 2 smartwatch for one week"
date: "2023-07-16"
author: "Logan Marchione"
categories:
  - "oc"
  - "linux"
cover:
    image: "/assets/featured/featured_generic_thumb_up.svg"
    alt: "featured image"
    relative: false
---

# TL;DR

This is a long post. If you don't want to read the whole thing, the TL;DR is below.

The [Bangle.js 2](https://www.espruino.com/Bangle.js2) is an open-source, hackable smartwatch that runs Javascript (yes, you read that correctly). Is it as shiny and fast as the Apple Watch? No. However, comparing an Apple Watch to the Bangle.js 2 is like comparing apples (no pun intended) to oranges. The Bangle.js 2 isn't going to be super-fast and 60Hz smooth (like the Apple Watch), but if you remember that you're running Javascript on a SoC the size of a shirt button, then you'll be impressed.

# Introduction

I've been looking for my first smartwatch, but have been in analysis paralysis for a while. I recently found the [Bangle.js 2](https://www.espruino.com/Bangle.js2) and have been using it for a week now. These are my thoughts.

## My daily driver

I'll start by saying that I'm not a "watch person". My daily driver is a [Casio G-SHOCK GWM5610](https://www.casio.com/us/watches/gshock/product.GW-M5610-1/) (the only other watch I own is a dress watch that I wear once a year). 

The GWM5610 is nothing but pragmatic. It has standard G-SHOCK toughness, 200-meter water resistance, and standard digital watch features (e.g., stopwatch, countdown timer, calendar, alarm, etc...). What sold me was that it has a small solar panel on the face and it gets the date/time via radio signals (what Casio calls [Multiband 6](https://gshock.casio.com/us/technology/radio/)). Combined, this means it _never_ needs to be taken off my wrist, _never_ needs to be charged, and the time _never_ needs to be set (talk about pragmatic).

{{< figure src="20230710_001.jpg" width="35%" alt="GWM5610" attr="Image from Casio" attrlink="https://www.casio.com/us/watches/gshock/product.GW-M5610-1/">}}

In fact, I'll go as far as to say if you don't own one already, you should purchase one right now (also pick up a set of [these wire "bullbars"](https://www.ebay.com/itm/282968618910)).

## My options

The GWM5610 lacks any "smart" features. I didn't really want/need activity tracking, but sleep tracking and notifications would be nice.

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

## Specs

I won't rehash the [specs](https://www.espruino.com/Bangle.js2+Technical) of the Bangle.js 2, but the main takeaways are:

- IP67 water resistance (i.e., splash-proof)
- nRF52840 ARM SoC (i.e., an ESP32 alternative) with 8MB flash
- 1.3-inch always-on touchscreen display with hardened glass
- single hardware button
- GPS receiver
- heart-rate monitor
- accelerometer
- magnetometer
- barometer
- 200mAh battery (with a claimed four weeks of standby time)

For $106, that's a lot of hardware in a small package. I was very impressed with the build quality for what seemed like such a small company.

## Unboxing

The package took about a week to arrive to my house in the US from the UK. In the box was the watch body, a strap, and a proprietary magnetic charging cable with pogo pins on one end and USB-A on the other.

{{< img src="20230707_001.jpeg" alt="bangle.js 2 box" >}}

{{< img src="20230707_002.jpeg" alt="bangle.js 2 box" >}}

{{< img src="20230707_003.jpeg" alt="bangle.js 2 box" >}}

The battery was dead on arrival, so I plugged it in and the "Welcome" tutorial ran.

{{< video mp4="20230709_001.mp4" >}}

## Battery

The battery has a claimed four weeks of standby time. However, I'm not sure if "standby" means powered off, or with the screen on but backlight off, etc... Also, the battery life depends on what apps you're using, and how often you receive notifications.

I charged the watch to 100% on a Sunday night, and it used about 15-20% per 24-hour period, which gave me about four days (Friday morning) before needing a recharge. During this time, I wasn't running any sleep tracking or heart-rate monitoring.

# Software

## Espruino

The software that runs on the SoC is [Espruino](https://github.com/espruino/Espruino), an open-source Javascript interpreter for microcontrollers (which is exciting and terrifying at the same time).

Espruino (the software) powers a number of Espruino (the company) [boards](https://www.espruino.com/Order), and it is compatible with many [third-party boards](https://www.espruino.com/Other+Boards) as well. Obviously, because it's open-source, you can make your own apps for the watch (more on apps later).

## Bangle.js software

The software that runs on the watch is quirky, but once you get the hang of it, it's not too bad.

As far as I understand, _everything_ in the interface is an app. This includes things that are obviously apps (e.g., the compass, the sleep tracker, etc...), but also system-level things (e.g., the launcher, the battery widget, the settings menu, etc...). The watch will ship with a default set of apps, but will need to be connected to Espruino's [App Loader](https://banglejs.com/apps/) to download new apps and updates (more on that process below).  

The single hardware button is both the "menu" button, as well as the "back" button when navigating menus. Holding the button for two seconds in any screen will take you back to the watch face. Holding the button for ten seconds reboots the watch (you turn the watch off via the Settings menu).

{{< figure src="20230710_003.png" width="25%" alt="single hardware button" attr="Image from Bangle.js 2" attrlink="https://banglejs.com/start2">}}

## Loading apps

All apps are loaded from a device (a phone or PC/laptop) via [Web Bluetooth](https://developer.mozilla.org/en-US/docs/Web/API/Web_Bluetooth_API). This means you open a browser with Web Bluetooth support, browse to the App Loader website, connect to the watch inside the browser, then load apps from your device to the watch via Bluetooth.

{{< img src="20230710_006.png" alt="app loader" >}}

I think this system is really slick (it's also platform-agnostic), but it does have some drawbacks:

1. Right now, only Chrome/Chromium and Edge have Web Bluetooth [support](https://caniuse.com/web-bluetooth) (and it needs to be enabled with an experimental flag)
1. iOS users can't load apps using Safari (instead, you need to use a browser like [WebBLE](https://apps.apple.com/us/app/webble/id1193531073), or just use a PC/laptop)
1. You can't connect the watch to two devices at once (e.g., you can't connect it to your laptop to load apps while it's connected to your phone)

As far as the overall experience goes, the App Loader is very responsive and quick to install apps. I should mention that the apps are all [open-source](https://github.com/espruino/BangleApps), and Espruino makes development easy with [documentation](https://www.espruino.com/Bangle.js+Development), a [web IDE](https://espruino.com/ide), and [tutorials](https://www.espruino.com/Bangle.js+First+App).

There is a basic dependency management system in place for apps. For example, installing the _iOS Integration_ app installed a few other apps as dependencies. 

The App Loader can also detect when a new app provides the same functionality as an existing app and offer to replace it. For example, since everything is an app (including the battery widget), when you install a new one, it offers to remove the old one.

```
App "Battery Level Widget" provides widget type "battery" which is already provided by "Battery Level Widget (with percentage)". What would you like to do?

[Replace] [Cancel] [Keep Both]
```

# Recommendations for buyers

If you're buying a Bangle.js 2, here is what I recommend right away.

## Calibrate the LCD

Out of the box, the LCD wasn't registering my touches well, but in the Settings menu there was an option to calibrate the LCD, which made it much more responsive.

## Those digits in the corner

There will be a four-digit code (on two lines) in the top-right corner of the display. This is the watch's identifier.

{{< img src="20230709_002.jpeg" alt="bluetooth identifier" >}}

You'll see this used when trying to pair the watch.

{{< img src="20230709_003.png" alt="iphone pairing" >}}

If you only have one watch (and don't need to uniquely identify it), you can remove the app that displays this on the watch face (since everything in the watch is an app).

## Install the companion app (and others)

The "smart" features of a smartwatch don't work unless you link it to your phone. I did this by installing the [iOS Integration app](https://banglejs.com/apps/#ios) from the Bangle.js App Loader website. This shares notifications from whatever is in your iOS [Notification Center](https://support.apple.com/en-us/HT201925) to your watch. Obviously it's not going to display images and clickable links won't work, but it vibrates, beeps, and generally gets your attention. When you dismiss notifications on your iPhone, they are dismissed on the watch.

One of the dependencies that was pulled in for the _iOS Integration_ app was an app called [Message Icons](https://banglejs.com/apps/?id=messageicons), which displays colored icons for [a lot of different apps](https://github.com/espruino/BangleApps/tree/master/apps/messageicons/icons). This was really helpful because I could just glance at the watch to see which app gave me a notification, instead of having to open the notifications menu.

There are also a ton of [other applications](https://banglejs.com/apps/) (471 as-of the time of this writing), ranging from different watch faces, to compasses, barometers, a sleep tracker, GPS, games, and more...

## Tweak all the settings

Go into every menu in Settings and look around. For example, I made the changes below:

- Set the system theme to dark mode
- Turned off the beep
- Changed the vibration pattern for messages and calls
- Changed the LCD brightness and timeout
- Changed the wake settings (e.g., wake on rotate, on hardware button, on touch, on twist, etc...)

# Critiques

Below are some critiques I had (in no particular order). They were not show-stoppers, just ideas for a possible Bangle.js 3...

- Plastic build: I would pay more money for a metal watch body.
- Single hardware button: I'm sure it's patented, but the Apple Watch has a hardware button, as well as Digital Crown that both rotates and presses inwards. Something like this would make navigating the watch interface easier.
- Metal contacts touching skin: The watch has four metal contacts on the back (the outer two are for charging, the inner two are for debugging). [Per the FAQ](https://github.com/espruino/BangleApps/wiki#important-usage-information), the inner two have a small voltage running between them. The watch will ship with a piece of tape covering these two, but if the tape were to fall off, the direct contact with your skin _could_ cause corrosion on the contacts or even [skin irritation](https://www.espruino.com/Bangle.js2#contact-corrosion-skin-irritation). This _did not_ happen to me, but it's something to be aware of.
{{< figure src="20230710_005.jpg" width="75%" alt="corrosion" attr="Image from Bangle.js 2" attrlink="https://www.espruino.com/Bangle.js2#contact-corrosion-skin-irritation">}}
- Magnetic charger orientation: The magnetic charger needs to be attached to the watch from the right-side (if you're looking at the screen). I wish the cable could be omni-directional, or use wireless charging (this would also remove the need for the metal contacts).
{{< figure src="20230710_002.png" width="25%" alt="watch charging cable" attr="Image from Bangle.js 2" attrlink="https://banglejs.com/start2">}}
- The magnets are weak: The magnets on the charger seem to do a good job aligning the pogo pings to the metal contact points, but they are so weak that the slightest bump makes the pins disconnect. I wish the magnets were stronger (or maybe that the pogo pins had less "spring").
- Make LCD calibration part of the initial "Welcome" tutorial: As I mentioned, the touchscreen response was very poor until I ran the LCD calibration. I wish the LCD calibration was part of the "Welcome" tutorial. Also, I might just have fat fingers.
- The watch needs to track the phone's silent mode: If your iPhone is in silent mode or using a [Focus](https://support.apple.com/en-us/HT212608) (like Sleep or Do Not Disturb), your watch will still get notifications. I had to manually set the watch to "quiet" time each night, then set it back each morning.

# Conclusion

What did I learn from this?

First, I learned that I'm not a smartwatch person. I don't like having to charge another gadget. Plus, I don't really like my phone buzzing to begin with, so having a device strapped to me that buzzes is honestly annoying.

However, this is a very nice device for what it is. For $106, you're obviously not getting Apple-esque levels of hardware and software. But, if you understand what you are getting, you'll be impressed (I was). For an open-source project, this is a very capable device. I'm not a developer, but if you are, this could be the perfect device for you.

\-Logan