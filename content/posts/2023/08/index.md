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

:warning: WARNING :warning:

- This is an image-heavy post (I have lazy-loading enabled, so images should only load as you scroll)
- My only "good" lighting is in the kitchen, and I don't have a DSLR or macro lens, so excuse the blurry close-up shots and shadows :man_shrugging:

I've been using a [WASD CODE 87-key mechanical keyboard with Cherry MX Clear switches](https://www.wasdkeyboards.com/code-v3-87-key-mechanical-keyboard-cherry-mx-clear.html) since 2017. I liked it so much that I bought another (for when I used to work in the office).

{{< figure src="20230714_001.jpg" width="75%" alt="code keyboard" attr="Image from WASD" attrlink="https://www.wasdkeyboards.com/code-v3-87-key-mechanical-keyboard-cherry-mx-clear.html">}}

{{< figure src="20230714_002.jpg" width="75%" alt="code keyboard" attr="Image from WASD" attrlink="https://www.wasdkeyboards.com/code-v3-87-key-mechanical-keyboard-cherry-mx-clear.html">}}

I spend *a lot* of time in front of my computer, both for work and for hobbies. In an effort to not end up with [repetitive strain injury](https://en.wikipedia.org/wiki/Repetitive_strain_injury) years from now, I've been looking into more ergonomic keyboards.

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

I do mostly office work and only a little gaming, so my only hard requirements were 75% layout (I wanted the F-row and arrow keys) and hotswap sockets. This left the following boards:

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

# Build process

I won't document the complete build process here, as Keebio already has a [build video](https://www.youtube.com/watch?v=M0lVrFJ1gDc).

The first thing was to snap off the macropad on the left side (since I chose plates without the macropad).

{{< img src="20230821_001.jpg" alt="macropad" >}}

{{< img src="20230821_002.jpg" alt="macropad" >}}

I purchased the Sinc with a rotary encoder on the right side, which takes the place of a switch. This board layout is really clever in that you can choose a rotary encoder or switch in the same slot (see the multiple sets of holes).

{{< img src="20230821_003.jpg" alt="rotary encoder" >}}

This was the only soldering required (if you wanted a switch here, then no soldering at all).

{{< img src="20230821_004.jpg" alt="rotary encoder" >}}

Next were the stabilizers. It took me forever to figure out that they were supposed to be mounted in these [castellated mounting holes](https://www.pcbdirectory.com/community/what-are-castellated-holes-on-a-pcb) (i.e., the semi-circles on the very edge of the board).

{{< img src="20230821_005.jpg" alt="castellated mounting holes" >}}

Again, this board layout is really clever and allows a delete/backspace split or a single backspace key (see the three sets of holes). I was going with a delete/backspace split, so I didn't add a stabilizer here.

{{< img src="20230821_007.jpg" alt="backspace key" >}}

The Sinc is powered by a [RP2040](https://www.raspberrypi.com/products/rp2040/)!

{{< img src="20230821_006.jpg" alt="rp2040" >}}

Here, I added the switches to the plate. After both halves were completed, I plugged it in and tested each switch using VIA.

{{< img src="20230821_008.jpg" alt="left half completed" >}}

{{< img src="20230821_009.jpg" alt="both halves completed" >}}

Hard to see here, but I attached the bottom plate to the top.

{{< img src="20230821_010.jpg" alt="attached bottom plate" >}}

Here is the final product (note that I moved some switches around for the right-side Alt/Super/Ctrl).

{{< img src="20230821_011.jpg" alt="final assembly" >}}

Here are the obligatory [blinkenlights](https://en.wikipedia.org/wiki/Blinkenlights).

{{< video mp4="20230821_012.mp4" >}}

Here is the clack clack (unmute the video).

{{< video mp4="20230822_001.mp4" >}}

# Firmware

The Sinc [supports QMK](https://docs.keeb.io/flashing-firmware), but [VIA](https://docs.keeb.io/via) gives you a [web interface](https://usevia.app/) and programs the board in real-time (i.e., when you change something in VIA, it updates the board right away).

This was my first time using VIA, and I was blown away by the options. :exploding_head:

I was able to change so many things:

* remapping keys (e.g., F13 and left-spacebar to backspace)
* rotary encoder control (turn for volume, press for play/pause)
* create multiple layers (e.g., FN+H/FN+L to move media tracks backward/forward)
* so, so, so many RGB options

{{< img src="20230822_002.png" alt="via" >}}

# Other keycaps

I also considered these two sets of keycaps, but decided to wait and see how I liked the DCX Solarized.

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

# Learning curve

Having the keyboard split and slightly angled wasn't an issue for typing using the alphabet keys (e.g., QWERTY). However, anything requiring modifiers was a challenge to get used to. For example:

* I'm still reaching to F13 for backspace, when I should be using my left-spacebar
* the right-side Shift is smaller than the normal 2.75U
* the right-side Alt/Super/Ctrl are all 1U
* the arrow key cluster has no space around it, so I'm hitting other keys

The big win here is that as I find places I can improve, I can tweak my settings on the fly with VIA.

I'm not a great typist to begin with, but I think I'm able to keep up pretty well.

{{< img src="20230829_001.png" alt="monkey type" >}}

# Conclusion

My CODE keyboard was from a time before custom mechanical keyboards were really a thing. I'm absolutely amazed by how configurable this board is and how comfortable it is to use. Paired with VIA, this provides so much more flexibility than I'm used to.

\-Logan