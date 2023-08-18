---
title: "Keebio Sinc split keyboard"
date: "2023-08-01"
author: "Logan Marchione"
categories:
  - "oc"
  - "linux"
  - "pc-hardware"
cover:
    image: "/assets/featured/featured_generic_keyboard.svg"
    alt: "featured image"
    relative: false
---

# Introduction

I've been using a [WASD CODE 87-key mechanical keyboard with Cherry MX Clear switches](https://www.wasdkeyboards.com/code-v3-87-key-mechanical-keyboard-cherry-mx-clear.html) since 2017.

{{< figure src="20230714_001.jpg" width="75%" alt="code keyboard" attr="Image from WASD" attrlink="https://www.wasdkeyboards.com/code-v3-87-key-mechanical-keyboard-cherry-mx-clear.html">}}

{{< figure src="20230714_002.jpg" width="75%" alt="code keyboard" attr="Image from WASD" attrlink="https://www.wasdkeyboards.com/code-v3-87-key-mechanical-keyboard-cherry-mx-clear.html">}}

I actually have two of them (one for when I used to work in the office), but have been looking more at ergonomic keyboards and decided to make the jump to a split keyboard.

# The search

## Why ergo?

A traditional keyboard can cause a few ergonomic problems:

1. Ulnar Deviation - This is when your wrists bend outwards (toward your pinky finger) and can lead to carpal tunnel syndrome.

{{< figure src="20230717_001.jpg" width="50%" alt="ulnar deviation" attr="Image from Kinesis" attrlink="https://kinesis-ergo.com/solutions/keyboard-risk-factors/">}}

2. Forearm Pronation - When typing with your palms face-down, it causes your radius and ulna to twist, which can lead to poor circulation and repetitive strain injuries (RSI).

{{< figure src="20230717_002.jpg" width="50%" alt="forearm pronation" attr="Image from Kinesis" attrlink="https://kinesis-ergo.com/solutions/keyboard-risk-factors/">}}

3. Wrist extension - This is when your wrists bend upwards and can cause poor circulation and numbness.

{{< figure src="20230717_003.jpg" width="50%" alt="wrist extension" attr="Image from Kinesis" attrlink="https://kinesis-ergo.com/solutions/keyboard-risk-factors/">}}

There are a number of ways to solve these problems, but the "perfect" keyboard would be:
1. Split in half to allow the arms to naturally rest shoulder-width apart (not bending the wrists)
2. Each half would be slightly tilted downwards to allow the forearms to sit naturally (not twisting the radius and ulna)
3. The slope of the keyboard would be minimized (or zero) to allow the wrists to rest naturally (this could also be accomplished by raising the wrists with a rest)

It won't win any awards for looks, but the [Kinesis Freestyle2](https://kinesis-ergo.com/keyboards/freestyle2-keyboard/) with the [VIP3 tenting and palm rest kit](https://kinesis-ergo.com/shop/freestyle2-vip3-accessory/) is designed to tackle these exact problems (also note the ergonomic vertical mouse).

{{< figure src="20230717_004.jpg" width="100%" alt="kinesis freestyle2" attr="Image from Kinesis" attrlink="https://kinesis-ergo.com/keyboards/freestyle2-keyboard/">}}

## My options

Unfortunately, the Kinesis Freestyle2 isn't "aesthetic" and is lacking a lot of enthusiast-level niceties (hotswap sockets, QMK support, USB-C, etc...).

Below are the keyboards I considered. They don't solve all ergonomic challenges, but they're all split boards (you'll need to scroll left and right to see the entire table).

| Item                                                                                                            | Starting price | Size    | Layout               | Hotswap | Connectivity                | Software               | Thumb cluster | Wrist-wrist | Tenting  | Comments                |
|-----------------------------------------------------------------------------------------------------------------|----------------|---------|----------------------|---------|-----------------------------|------------------------|---------------|-------------|----------|-------------------------|
| [Dygma Raise](https://dygma.com/pages/raise)                                                                    | $399           | 60%     | Staggered            | Yes     | USB-C                       | Custom (Linux support) | Yes           | Included    | Extra    |                         |
| [Dygma Defy](https://dygma.com/pages/defy)                                                                      | $329           | 60%     | Ortholinear          | Yes     | USB-C, Bluetooth, RF (WiFi) | Custom (Linux support) | Yes           | Included    | Extra    |                         |
| [Ultimate Hacking Keyboard](https://ultimatehackingkeyboard.com/)                                               | $320           | 60%     | Staggered            | Yes     | USB-C                       | Custom (Linux support) | Extra         | Extra       | Extra    | Removable thumb modules |
| [ZSA Moonlander](https://www.zsa.io/moonlander/)                                                                | $365           | 60%     | Ortholinear          | Yes     | USB-C                       | QMK                    | Yes           | Included    | Included |                         |
| [ZSA ErgoDox EZ](https://ergodox-ez.com/)                                                                       | $354           | 60%     | Ortholinear          | Yes     | USB-C (as-of Feb 2022)      | QMK                    | Yes           | Included    | Included |                         |
| [Keychron Q11](https://www.keychron.com/products/keychron-q11-qmk-custom-mechanical-keyboard)                   | $208           | 75%     | Staggered            | Yes     | USB-C                       | QMK/VIA                | No            | Extra       | None     | 2 rotary encoders       |
| [Keebio Sinc](https://keeb.io/collections/sinc/products/sinc-rev-4-split-staggered-75-keyboard)                 | $89            | 75%     | Staggered            | Yes     | USB-C                       | QMK/VIA                | No            | No          | No       | this is a kit only, 1 rotary encoder  |
| [nullbits SNAP](https://nullbits.co/snap/)                                                                      | $99            | 75%     | Staggered            | Yes     | USB-C                       | QMK/VIA                | No            | No          | No       | this is a kit only, 1 rotary encoder  |
| [Cloud Nine ErgoTKL](https://cloudnineergo.com/products/cloud-nine-ergotkl-ergonomic-split-mechanical-keyboard) | $169           | 75%     | Staggered            | No      | USB-C                       | Custom (Windows-only)  | No            | Included    | Included | 1 rotary encoder        |
| [MoErgo Glove80](https://www.moergo.com/collections/glove80-keyboards/products/glv80-soldered)                  | $399           | 75%     | Ortholinear          | No      | USB-C, Bluetooth            | ZMK                    | Yes           | Included    | Included |                         |
| [Kinesis Advantage360](https://kinesis-ergo.com/shop/adv360/)                                                   | $449           | 60%     | Ortholinear          | No      | USB-C                       | Custom (Windows/Mac)   | Yes           | Included    | Included |                         |
| [Kinesis Freestyle Pro](https://kinesis-ergo.com/shop/freestyle-pro/)                                           | $179           | 75%     | Staggered            | No      | USB-A                       | Custom (Windows/Mac)   | No            | Extra       | Extra    |                         |
| [Kinesis Freestyle2 for PC](https://kinesis-ergo.com/shop/freestyle2-for-pc-us/)                                | $99            | 75%     | Staggered            | No      | USB-A                       | Custom (Windows/Mac)   | No            | Extra       | Extra    |                         |

## Requirements

I do mostly office work and only a little gaming, so my only hard requirements were 75% layout (I need the F-row and arrow keys) and hotswap sockets. This left the following boards:

| Item                                                                                                            | Starting price | Size    | Layout               | Hotswap | Connectivity                | Software               | Thumb cluster | Wrist-wrist | Tenting  | Comments                |
|-----------------------------------------------------------------------------------------------------------------|----------------|---------|----------------------|---------|-----------------------------|------------------------|---------------|-------------|----------|-------------------------|
| [Keychron Q11](https://www.keychron.com/products/keychron-q11-qmk-custom-mechanical-keyboard)                   | $208           | 75%     | Staggered            | Yes     | USB-C                       | QMK/VIA                | No            | Extra       | None     | 2 rotary encoders       |
| [Keebio Sinc](https://keeb.io/collections/sinc/products/sinc-rev-4-split-staggered-75-keyboard)                 | $89            | 75%     | Staggered            | Yes     | USB-C                       | QMK/VIA                | No            | No          | No       | this is a kit only, 1 rotary encoder  |
| [nullbits SNAP](https://nullbits.co/snap/)                                                                      | $99            | 75%     | Staggered            | Yes     | USB-C                       | QMK/VIA                | No            | No          | No       | this is a kit only, 1 rotary encoder  |


# My purchases

## Board

I ended up purchasing the [Keebio Sinc](https://keeb.io/collections/sinc/products/sinc-rev-4-split-staggered-75-keyboard). I was initially looking at the Keychron Q11, but the extra macro keys on the left (below) would make finding keycap sets more difficult (especially if the keys were sculpted).

{{< figure src="20230718_003_q11.png" width="100%" alt="q11 layout" attr="Image from Keychron" attrlink="https://www.keychron.com/pages/keychron-q11-keycap-size">}}

The Sinc comes in a [Rev. 3](https://keeb.io/collections/split-keyboards/products/sinc-split-staggered-75-keyboard) and [Rev. 4](https://keeb.io/collections/sinc/products/sinc-rev-4-split-staggered-75-keyboard) PCB, with the Rev. 4 having an additional circuit for more reliable startup as well as more layout options on the bottom row (see comparison below).

{{< figure src="20230718_001_sinc_rev3.png" width="100%" alt="sinc rev3 layout" attr="Rev. 3 image from Keebio" attrlink="https://keeb.io/collections/split-keyboards/products/sinc-split-staggered-75-keyboard">}}

{{< figure src="20230718_002_sinc_rev4.png" width="100%" alt="sinc rev4 layout" attr="Rev. 4 image from Keebio" attrlink="https://keeb.io/collections/sinc/products/sinc-rev-4-split-staggered-75-keyboard">}}

Below are the options I chose for the Sinc Rev. 4.

{{< img src="20230718_006.png" alt="sinc rev4 options" >}}

## Switches

For switches, I like tactile and have been using [Cherry MX Clear switches](https://www.cherrymx.de/en/cherry-mx/mx-special/mx-clear.html) on my CODE board.

{{< figure src="20230718_004_cherry_clear.png" width="30%" alt="cherry mx clear" attr="Image from Cherry" attrlink="https://www.cherrymx.de/en/cherry-mx/mx-special/mx-clear.html">}}

I decided to go with [Gateron](https://www.gateron.co/) this time, just to try something different. Gateron Clear switches are linear (not tactile), so I went with the [Gateron G Pro 3.0 Brown switches](https://www.gateron.co/products/gateron-g-pro-3-0-switch-set?variant=40479582945369) (the Pro series is pre-lubed). Side-note: [This page](https://thegamingsetup.com/gaming-keyboard/buying-guides/keyboard-switch-chart-table) is a great place to compare switches.

{{< figure src="20230718_005_gateron_brown.png" width="100%" alt="gateron pro brown" attr="Image from Gateron" attrlink="https://www.gateron.co/products/gateron-g-pro-3-0-switch-set">}}

## Keycaps

The Sinc has a split spacebar, so that removed a lot of keycap options right away. Below are some keycap sets I considered, but ultimately passed on because they didn't have a split spacebar.

| Manufacturer       | Name                                                                                        | Profile        | Material           |
|--------------------|---------------------------------------------------------------------------------------------|----------------|--------------------|
| Kono               | [SA Granite](https://kono.store/products/sa-granite-keycap-set)                             | SA             | dye-sublimated PBT |
| Kono               | [KDS Solarized Dark](https://kono.store/products/kds-solarized-dark)                        | Cherry         | dye-sublimated PBT |
| Novelkeys???       | [Cherry Milkshake](https://novelkeys.com/collections/keycaps/products/cherry-milkshake)     | Cherry         | dye-sublimated PBT |
| Novelkeys???       | [DSA Milkshake](https://novelkeys.com/collections/keycaps/products/dsa-milkshake)           | DSA            | dye-sublimated PBT |
| Drop               | [/dev/tty](https://drop.com/buy/drop-matt3o-mt3-dev-tty-keycap-set)                         | MT3            | dye-sublimated PBT |
| Drop               | [Camillo](https://drop.com/buy/drop-mt3-camillo-keycap-set)                                 | MT3            | doubleshot ABS     |

In addition to the split spacebar, I also had to decide if I wanted to use a delete/backspace split or a single backspace key (see below). 

{{< figure src="20230730_001.png" width="100%" alt="sinc rev4 layout backspace" attr="Rev. 4 image from Keebio" attrlink="https://keeb.io/collections/sinc/products/sinc-rev-4-split-staggered-75-keyboard">}}

Below are keycap sets that seemed like they would fit the Sinc (i.e., they had a split spacebar and a 1U key to take the place of backspace).

| Manufacturer       | Name                                                                                        | Profile        | Material           | Comments                    |
|--------------------|---------------------------------------------------------------------------------------------|----------------|--------------------|-----------------------------|
| Milkyway           | [MW Retro Lights](https://spaceholdings.net/products/mw-retro-lights)                       | Cherry         | dye-sublimated PBT |                             |
| Domikey            | [DMK Ghost](https://www.ashkeebs.com/product/dmk-ghost-keycaps/)                            | Cherry         | doubleshot ABS     | Spacebar kit sold out       |
| GMK                | [GMK Foundation](https://cannonkeys.com/products/pre-order-gmk-foundation)                  | Cherry         | doubleshot ABS     | Novelties kit sold out      |
| GMK                | [GMK DUALSHOT 2](https://omnitype.com/collections/keycaps/products/gmk-dualshot-2-keycaps)  | Cherry         | doubleshot ABS     |                             |
| GMK                | [MTNU WOB](https://novelkeys.com/collections/keycaps/products/mtnu-wob)                     | MTNU           | doubleshot PBT     | Pre-order                   |
| GMK                | [MTNU SUSU](https://novelkeys.com/collections/keycaps/products/mtnu-susu)                   | MTNU           | doubleshot PBT     | Pre-order                   |
| Signature Plastics | [DSA Granite](https://pimpmykeyboard.com/sp-dsa-granite-keyset-sublimated/)                 | DSA            | dye-sublimated PBT | Individual keys separate    |
| Signature Plastics | [DSA Petrikeys](https://vala.supply/products/dsa-petrikeys)                                 | DSA            | doubleshot ABS     | Would prefer text modifiers |
| Signature Plastics | [Oblivion V2](https://drop.com/buy/drop-oblotzky-sa-oblivion-v2)                            | SA             | doubleshot ABS     |                             |
| Signature Plastics | [DSS Honeywell](https://www.primekb.com/products/dss-honeywell)                             | DSS            | doubleshot ABS     |                             |
| Drop               | [Susuwatari](https://drop.com/buy/drop-matt3o-mt3-susuwatari-custom-keycap-set)             | MT3            | doubleshot ABS     |                             |
| Drop               | [/dev/tty R3](https://drop.com/buy/drop-matt3o-devtty-custom-keycap-set)                    | MT3            | dye-sublimated PBT | Unicorn barf kit sold out   |
| Drop               | [DCX Solarized](https://drop.com/buy/drop-dcx-solarized-keycap-set)                         | DCX            | doubleshot ABS     |                             |
| PBTfans            | [Cookies 'n Creme](https://kbdfans.com/products/pbtfans-cookies-n-creme)                    | Cherry         | doubleshot ABS     | Would prefer text modifiers |
| PBTfans            | [Retro Dark Lights](https://kbdfans.com/products/pbtfans-retro-dark-lights)                 | Cherry         | doubleshot PBT     |                             |

In the end, I purchased the [DCX Solarized](https://drop.com/buy/drop-dcx-solarized-keycap-set) set. It didn't have a dedicated 1U backspace key, so the F13 key would have to make due. This set cost $99.

{{< figure src="20230731_007.jpg" width="100%" alt="dcx solarized" attr="Image from Drop" attrlink="https://drop.com/buy/drop-dcx-solarized-keycap-set">}}

I also considered these two sets, but decided to wait and see how I liked the DCX Solarized.

First was the [Oblivion V2](https://drop.com/buy/drop-oblotzky-sa-oblivion-v2). These six sets would have been $203.

{{< figure src="20230731_001.jpg" width="100%" alt="oblivion v2" attr="Image from Drop" attrlink="https://drop.com/buy/drop-oblotzky-sa-oblivion-v2">}}

{{< figure src="20230731_002.jpg" width="100%" alt="oblivion v2" attr="Image from Drop" attrlink="https://drop.com/buy/drop-oblotzky-sa-oblivion-v2">}}

{{< figure src="20230731_003.jpg" width="100%" alt="oblivion v2" attr="Image from Drop" attrlink="https://drop.com/buy/drop-oblotzky-sa-oblivion-v2">}}

{{< figure src="20230731_004.jpg" width="100%" alt="oblivion v2" attr="Image from Drop" attrlink="https://drop.com/buy/drop-oblotzky-sa-oblivion-v2">}}

{{< figure src="20230731_005.jpg" width="100%" alt="oblivion v2" attr="Image from Drop" attrlink="https://drop.com/buy/drop-oblotzky-sa-oblivion-v2">}}

{{< figure src="20230731_006.jpg" width="100%" alt="oblivion v2" attr="Image from Drop" attrlink="https://drop.com/buy/drop-oblotzky-sa-oblivion-v2">}}

Next was the [DSA Granite](https://pimpmykeyboard.com/sp-dsa-granite-keyset-sublimated/). These four sets would have been $180 (plus $10 for two split spacebars). DSA is nice because all the keys are the same profile, so any key can go anywhere.

{{< figure src="20230818_001.jpg" width="100%" alt="dsa granite" attr="Image from Pimp My Keyboard" attrlink="https://pimpmykeyboard.com/sp-dsa-granite-keyset-sublimated/">}}

{{< figure src="20230818_002.jpg" width="100%" alt="dsa granite" attr="Image from Pimp My Keyboard" attrlink="https://pimpmykeyboard.com/sp-dsa-granite-keyset-sublimated/">}}

{{< figure src="20230818_003.jpg" width="100%" alt="dsa granite" attr="Image from Pimp My Keyboard" attrlink="https://pimpmykeyboard.com/sp-dsa-granite-keyset-sublimated/">}}

{{< figure src="20230818_004.jpg" width="100%" alt="dsa granite" attr="Image from Pimp My Keyboard" attrlink="https://pimpmykeyboard.com/sp-dsa-granite-keyset-sublimated/">}}

## Wrist wrest

I'm currently using a wrist wrest (technically palm rest?) from Etsy, so I decided to look there again.

## Prices

All-in-all, here is what I purchased. This was definitely expensive, but not out of line compared to some of the higher-end boards above.

| Item                       | Price        |
|----------------------------|--------------|
| Board (PCB and plates)     | $134.92      |
| Switches                   | $31          |
| Keycaps                    | $99          |
| Wrist/palm rest            | $XXX         |
|                            | $XXX (total) |

# Build

I won't document the complete build process here, as Keebio already has a [build guide](https://docs.keeb.io/sinc-rev3-build-guide) (it's actually for their [Quefrency](https://docs.keeb.io/quefrency-hotswap-build-guide) board, but they're so similar that it works the same).

I purchased the Sinc with a rotary encoder on the right side, which takes the place of a switch. The first step was to solder that in place, and that's all the soldering that was required (the rest was hotswap).

# Firmware

The Sinc [supports QMK](https://docs.keeb.io/flashing-firmware), but I prefer [VIA](https://docs.keeb.io/via), since it gives you a GUI and programs in real-time.

# Conclusion


\-Logan
