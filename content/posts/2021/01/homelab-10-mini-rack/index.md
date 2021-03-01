---
title: "Homelab 10\" mini-rack"
date: "2021-01-05"
author: "Logan Marchione"
categories: 
  - "oc"
  - "pc-hardware"
cover:
    image: "/assets/featured/featured_generic_storage.svg"
    alt: "featured image"
    relative: false
---

# Update: 2021-01-10

I made the following changes and updated the post below (not the pictures) to reflect those changes:

- Replaced [side vent panels](https://smile.amazon.com/Middle-Atlantic-HR-EVT1-Slotted-Aluminum/dp/B00HE8FMHC) with [metal bars](https://smile.amazon.com/gp/product/B07YYY64NK/)
- Added labels to patch panel
- One of the RJ45 couplers was stuck in 100Mbps mode and would not transfer full 1Gbps. I switched it around to a device that only has a 100Mbps NIC (IP camera)

# Introduction

I don't have space in my house for a full-size 19" server rack (but a man can dream). My fiber internet service comes into the basement and terminates at the ONT. A Cat6 cable runs from the ONT in the basement, up through the ceiling directly above it where it plugs into my router. The hole drilled through the first floor is hidden by the entertainment center that houses all the equipment. My entire homelab lives on the bottom shelf of that piece of furniture and is designed to be low-power and quiet (since it's in my living room):

- pfSense router (APU2D4)
- Netgear switch (GS108PE)
- UniFi AP (UAP-AC-PRO)
- Intel NUC (NUC7i3BNH)
- Synology DS 718+
- CyberPower UPS (CP1500PFCLCD)

It's a pretty small setup that only draws 50-60 watts, but lets me run 10+ VMs and 25+ containers. However, physically organizing it has been a pain. I've been using a small cabinet shelf (made for kitchen plates) and zip-ties to separate the router, switch, and AP, but it was ugly and various lengths of Cat6 were everywhere.

{{< img src="20201203_001.jpg" alt="mini-rack" >}}

Racks typically come in 19" widths, but I had seen a few Reddit posts about 10" racks ([one](https://www.reddit.com/r/Ubiquiti/comments/c1zysd/low_on_space_so_built_a_10_rack/), [two](https://www.reddit.com/r/Ubiquiti/comments/cwr7hk/10_mini_rack/)) and a bunch of 3D printed solutions ([one](https://www.reddit.com/r/homelab/comments/bempjc/micro_homelab/), [two](https://www.reddit.com/r/3Dprinting/comments/brbjvi/3d_printed_a_miniature_raspberry_pi_server_rack/), [three](https://www.reddit.com/r/Ubiquiti/comments/8y7lcy/my_mini_rack/), [four](https://www.reddit.com/r/Ubiquiti/comments/cy8h13/selfmade_10_rack/), [five](https://www.reddit.com/r/UNIFI/comments/h8eld9/my_3d_printed_unifi_rack/), [six](https://www.reddit.com/r/homelab/comments/kmt8uh/keeping_my_holidays_busy_3d_printed_a_small/)). However, these racks were usually custom-made, or typically sourced from parts in Europe (apparently 10" is a [popular rack size there](https://www.netstoredirect.com/ccs-home-cabinets/9508-8u-10-mini-office-cabinet-350mm-deep.html)).

Then, I stumbled onto [this post](https://www.reddit.com/r/homelab/comments/k47m0t/5_months_and_all_i_got_was_this_10_rack/). It stuck out to me because the user was based in the US, it required very little metal-work, no 3D printing, and he included a parts list. It was a proper rack, just shrunk down to 10". This is my attempt to recreate that rack.

# Presenting: The mini-rack

## Pictures

{{< img src="20210104_001.jpg" alt="mini-rack" >}}

{{< img src="20210104_002.jpg" alt="mini-rack" >}}

{{< img src="20210104_003.jpg" alt="mini-rack on shelf" >}}

And here is the obligatory GIF of the [blinkenlights](https://en.wikipedia.org/wiki/Blinkenlights).

{{< video mp4="20210104_004.mp4" >}}

## Parts

This rack is based on the post from [u/othugmuffin](https://www.reddit.com/user/othugmuffin), but I changed a few things to better suit my needs.

| Part | Link | Quantity | Price (per unit) | Total price | Comments |
| --- | --- | --- | --- | --- | --- |
| Rack posts | [Penn Elcom Online](https://www.pennelcomonline.com/us/Penn-Elcom-5U-Full-Hole-Rack-Strip-with-Square-Holes-2mm008-R08632MM-05/m-6533.aspx) | 4 | $1.94 | $7.76 | The shelf where this rack is going only fits a full 4U rack (5U is too tall), but I was able to cut off 1/3-of-a-U on a 5U rack (for a total of 4.66U height) |
| Cage nuts | [Penn Elcom Online](https://www.pennelcomonline.com/us/Penn-Elcom-Cage-Nut-For-2mm-S1172/m-6130.aspx) | 50 | $0.18 | $9.00 | I'm only using 24 |
| Cage screws (M6) | [Penn Elcom Online](https://www.pennelcomonline.com/us/Penn-Elcom-Pack-of-100-x-M6-High-Point-Screws-SM6HPWA100/m-9897.aspx) | 1 | $12.24 | $12.24 | The ones with the tapered ends make catching the threads so much easier |
| Cage nut tool | [Penn Elcom Online](https://www.pennelcomonline.com/us/Penn-Elcom-Delux-Cage-Nut-Tool-CN01/m-6134.aspx) | 1 | $16.05 | $16.05 | Optional, but makes life much easier |
| 10" blank patch panel | [Amazon](https://smile.amazon.com/uxcell-12-Port-Keystone-Rackmount-Shielded/dp/B0744XHTK3) | 1 | $25.39 | $25.39 | This patch panel has a mounting plate for the keystones, whereas the panel u/othugmuffin used did not (which would cause the keystones to stick out in the front) |
| 10" rack shelf | [Amazon](https://smile.amazon.com/Intellinet-714839-Cantilever-Shelf-Vented/dp/B078WCBFFM) | 3 | $15.95 | $47.85 | I wish these were a little deeper |
| 10" vent panel | [Amazon](https://smile.amazon.com/Middle-Atlantic-HR-EVT1-Slotted-Aluminum/dp/B00HE8FMHC) | 2 | $12.00 | $24.00 | These are used on the back (where u/othugmuffin used aluminum bars that he had to cut/drill) |
| 7.8” mending plate 6-pack | [Amazon](https://smile.amazon.com/gp/product/B07YYY64NK/) | 1 | $14.97 | $14.97 | Used on the sides. I was originally using the 10" vent panels but ended up switching to these |
| Cat6 RJ45 shielded coupler keystones | [FS.com](https://www.fs.com/products/41312.html) | 12 | $2.00 | $24.00 | I only used shielded because I liked the silver color |
| Cat6 patch cables 5-pack (1ft) | [Amazon](https://smile.amazon.com/gp/product/B00C2DZ85U) | 2 | $9.99 | $19.98 | I tried 6-inch cables, but they were so stiff they lifted the switch off the shelf |
| Rubber feet | [Amazon](https://smile.amazon.com/gp/product/B07K198ZH4) | 1 | $8.22 | $8.22 | To cover the cut ends of the rack posts |
| Misc screws/washers/nuts | Lowes |  | ~$8 | ~$8 |  |
|  |  |  |   | **$217.46 total** |  |

## Physical layout

Here is how everything is physically connected.
```
      -----------------------------------------------------------
      |                                                         |
      |  ------------                                           |
------|->| UniFi AP |                                           |
|     |  ------------                                           |
|     |                                                         |
|     -----------------------------------------------------------
|     
|
|     -----------------------------------------------------------
|     |   AP     Camera               NAS    NUC    Roku   LAN  |
|     | ------ ------ ------ ------ ------ ------ ------ ------ |           -----------------
|     | | 01 | | 02 | | 03 | | 04 | | 05 | | 06 | | 07 | | 08 | |           |               |
|     | ------ ------ ------ ------ ------ ------ ------ ------ |           | FiOS Internet |
|     |    ^      ^                    ^      ^      ^      ^   |           |           ^   |
|     -----|------|--------------------|------|------|------|----           ------------|----
|          |      |                    |      |      |      |                           |
|          |      |                    |      |      |      --------------------------------------
|          |      |                    |      |      |                                  |        |
|     -----|------|--------------------|------|------|----------------------------------|----    |
|     |    v      v                    v      v      v                                  v   |    |
|     | ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ |    |
|     | | 01 | | 02 | | 03 | | 04 | | 05 | | 06 | | 07 | | 08 | | 09 | | 10 | | 11 | | 12 | |    |
|     | ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ |    |
|     |    ^                                                                            ^   |    |
|     -----|----------------------------------------------------------------------------|----    |
|          |                                                                            |        |
------------                                                                            |        |
                                                                                        |        |
      -----------------------------------------------------------                       |        |
      |                                                         |                       |        |
      |    -------              -------              -------    |                       |        |
      |    | WAN |              | LAN |              | OPT |    |                       |        |
      |    -------              -------              -------    |                       |        |
      |       ^                    ^                            |                       |        |
      --------|--------------------|-----------------------------                       |        |
              |                    |                                                    |        |
              ---------------------|-----------------------------------------------------        |
                                   |                                                             |
                                   ---------------------------------------------------------------
```

# To-do

- ~~Replace side vent panels with metal bars (will require cutting and drilling)~~
    - ~~Cheaper~~
    - ~~Custom length~~
- ~~Add labels to patch panel~~
- Try [Monoprice SlimRun Cat6 patch cables](https://www.monoprice.com/product?p_id=13527) (which should bend easier)
- Find deeper shelves
    - https://commsonline.co.uk/products/1u-10-inch-mini-cabinet-shelf

# Conclusion

If you have a 10" rack, let me know about it! I'm looking to improve mine and would love to find other parts retailers in the US.

Also, shout-out to my wife for letting me put this monstrosity in the living room. Her only complaint during the whole thing was "it's no uglier than what you have there now".

![](20210104_005.gif)

Thanks for reading!

\-Logan