---
title: "Homelab 10\" mini-rack v2"
date: "2025-09-01"
author: "Logan Marchione"
categories: 
  - "oc"
  - "pc-hardware"
cover:
    image: "/assets/featured/featured_generic_storage.svg"
    alt: "featured image"
    relative: false
---

{{% series/s_minirack %}}

# TL;DR

I built a new rack out of 20x20mm aluminum. Read more to build your own!

# Introduction

I've been using my home-made [mini-rack](/2021/01/homelab-10-mini-rack/) for a few years now. My main complaint is that the shelves *themselves* are the horizontal structure on the front face of the unit. If I start removing them, the unit flexes.

{{< img src="20220915_001.jpeg" alt="mini-rack" >}}

However, mini-racks have come a long way since then. DeskPi has their [wildly popular RackMate line](https://deskpi.com/collections/deskpi-rack-mate) of mini-racks, and Jeff Geerling started [Project MINI RACK](https://mini-rack.jeffgeerling.com/). All of this left my home-made mini-rack feeling a little old.

I only have space for 4U, so a [DeskPi Rack Mate T0](https://deskpi.com/products/deskpi-rackmate-t1-rackmount-10-inch-4u-server-cabinet-for-network-servers-audio-and-video-equipment) would have been perfect. However, there is a problem. My mini-rack sits on a very short shelf, and the RackMate T0 is too tall by about an inch, due to the large aluminum "forehead" at the top of the rack.

{{< figure src="20250814_001.jpg" width="74%" loading="lazy" alt="deskpi rackmate t0" attr="DeskPi RackMate T0 from DeskPi" attrlink="https://deskpi.com/products/deskpi-rackmate-t1-rackmount-10-inch-4u-server-cabinet-for-network-servers-audio-and-video-equipment">}}

So naturally, I over-engineered (and over-paid for), my own rack 🤷.

# Standards

As I [discussed in the past](/2022/09/homelab-10-mini-rack-shelves/#10-inch-racks), there is no standard for mini-racks. They're generally half the size of a 19-inch rack, which would put them at 9.5-inches, but people actually refer to them as 10-inch racks, or half-racks.

Also, in my last post, I said:

> I know that the [imperial system](https://en.wikipedia.org/wiki/Imperial_units) of units is inferior to the metric system, but these are 10-inch racks, not 254mm racks :man_shrugging:

Well, I'm eating my words now. Because of the small dimensions I'm working with, I decided to do all of my measurements in millimeters. With that said, the holes on the [shelves](https://deskpi.com/products/deskpi) I'm using are 235mm center-to-center, so that was my basis for the mini-rack.

# Design

I've been seeing a ton of racks made of extruded aluminum. I guess I'm late on this, but extruded aluminum is like Lego for adults. It's really lightweight, easy to work with, has exact dimensions, and has slots on all four sides to connect pieces, accessories, etc... The different sizes are named for their dimensions (below are examples of 20x20mm and 20x40mm, respectively).

{{< figure src="20250814_002.jpg" width="25%" loading="lazy" alt="20x20 aluminum" attr="20x20 aluminum from 8020.net" attrlink="https://8020.net/20-2020.html">}}

{{< figure src="20250814_003.jpg" width="25%" loading="lazy" alt="20x40 aluminum" attr="20x40 aluminum from 8020.net" attrlink="https://8020.net/20-2040.html">}}

From what I can tell, [8020.net](https://8020.net) and [Misumi](https://us.misumi-ec.com/) are the biggest and/or most popular distributors, though you can also get this stuff cheap on Amazon and AliExpress. What's nice is that since aluminum is a relatively soft metal, you can cut it with a bandsaw or chop saw. I don't have one of those, but both 8020.net and Misumi will cut it for you (for a small fee).

I decided on 20x20 aluminum rails. They are relatively small, but I have seen rails as small as 15x15 or 10x10. I decided to mount the shelves directly to the aluminum rails (in-place of [traditional rack rails](https://www.penn-elcom.com/us/4u-rack-rail-with-full-holes-0-08in-thick-r0863-2mm-04)).

Both 8020.net and Misumi have 3D building tools (and they both let you download 3D models of their products for use in other tools). 8020.net has the browser-based [IdeaBuilder](https://ideabuilder.io/) that lets you model *almost* anything in their catalog, while Misumi has [Frames](https://us.misumi-ec.com/service/promotion/frames/) (I wasn't able to use this because it is Windows-only). In IdeaBuilder, you can save your model to the cloud or a local file, and then upload the Bill of Materials (BoM) to your cart to get a list of all the parts you need. Below is what I built in just a few minutes in IdeaBuilder. If you're interested, [here is the JSON file](/2025/09/homelab-10-mini-rack-v2/v2.json) that you can upload to IdeaBuilder to get started. 

{{< img src="20250814_004.png" alt="IdeaBuilder" >}}

To get an idea of price, below are the parts that are part of my IdeaBuilder 3D design (i.e., this is what you get if you upload the JSON file).

| Part                            | Link                                            | Quantity | Price (per unit) | Total price       | Comments     |
|---------------------------------|-------------------------------------------------|----------|------------------|-------------------|--------------|
| 20x20 aluminum                  | [8020.net](https://8020.net/20-2020.html)       | 4        | $5.35            | $21.40            | Cut to 225mm |
| 20x20 aluminum                  | [8020.net](https://8020.net/20-2020.html)       | 4        | $5.29            | $21.16            | Cut to 220mm |
| 20x20 aluminum                  | [8020.net](https://8020.net/20-2020.html)       | 4        | $5.24            | $20.96            | Cut to 215mm |
| 2-hole corner bracket           | [8020.net](https://8020.net/20-4119.html)       | 24       | $4.67            | $112.08           |              |
| M5 x 8.00mm screw               | [8020.net](https://8020.net/11-5308.html)       | 48       | $0.51            | $24.48            |              |
| M5 T-nut                        | [8020.net](https://8020.net/14122.html)         | 48       | $0.35            | $16.80            |              |
|                                 |                                                 |          | Total            | $216.88           |              |

I also built the same rack (without hardware) using Misumi's 20x20 aluminum in [Tinkercad](https://www.tinkercad.com/) (this is a 3D model, so you should be able to rotate/zoom below). [Here is the STL file](/2025/09/homelab-10-mini-rack-v2/tinkercad-misumi.stl) if you want to download it.

{{< threejs-stl version="0.179.1" id="mini-rackv2" width="600" height="600" color="#a7adb1ff" background="#e9e9e9ff" rotateX="-90" rotateY="0" rotateZ="0" center="true" stl="tinkercad-misumi.stl" >}}

An important note is that not all 20x20 aluminum is the same. In the examples below, both are 20mm on all four sides, but the 8020.net aluminum "slot" opening is only 5.26mm wide, while the Misumi slot is 6mm wide. For example, [these](https://www.amazon.com/uxcell-Interior-Connector-Aluminum-Extrusion/dp/B07VP59DY5) hidden corner brackets didn't fit into the 20x20 aluminum from 8020.net, since the "slot" is 5.26mm, not a true 6mm, so keep that in mind.

{{< figure src="20250901_001.jpg" width="50%" loading="lazy" alt="20x20 aluminum" attr="20x20 aluminum from 8020.net" attrlink="https://8020.net/20-2020.html">}}

{{< figure src="20250901_002.jpg" width="50%" loading="lazy" alt="20x20 aluminum" attr="20x20 aluminum from Misumi.com" attrlink="https://us.misumi-ec.com/vona2/detail/110302683830/">}}

# Presenting: The mini-rack, v2

## Pictures

TODO: add pictures here

## Parts

I purchased the 20x20 aluminum from Misumi, since the hardware (e.g., corners, screws, T-nuts, etc...) was too expensive from their catalog.

| Part                            | Link                                                                    | Quantity | Price (per unit) | Total price       | Comments     |
|---------------------------------|-------------------------------------------------------------------------|----------|------------------|-------------------|--------------|
| 20x20 aluminum                  | [Misumi.com](https://us.misumi-ec.com/vona2/detail/110302683830/)       | 4        | $4.90            | $19.60            | Cut to 225mm |
| 20x20 aluminum                  | [Misumi.com](https://us.misumi-ec.com/vona2/detail/110302683830/)       | 4        | $4.90            | $19.60            | Cut to 220mm |
| 20x20 aluminum                  | [Misumi.com](https://us.misumi-ec.com/vona2/detail/110302683830/)       | 4        | $4.90            | $19.60            | Cut to 215mm |
|                                 |                                                                         |          | Total            | $58.80            |              |

I purchased all the hardware from Amazon, since it was much cheaper than anything 8020.net or Misumi had to offer. For some reason, 8020.net doesn't make hidden corner brackets for their 20x20 aluminum, only for larger aluminum profiles. Misumi does make [hidden corner brackets](https://us.misumi-ec.com/vona2/detail/110310741779/?CategorySpec=unitType%3A%3A1%0900000042729%3A%3Ab&Tab=wysiwyg_area_1&curSearch=%7B%22field%22%3A%22%40search%22%2C%22seriesCode%22%3A%22110310741779%22%2C%22innerCode%22%3A%22%22%2C%22sort%22%3A1%2C%22specSortFlag%22%3A0%2C%22allSpecFlag%22%3A0%2C%22page%22%3A1%2C%22pageSize%22%3A%2260%22%2C%22SP100565480%22%3A%22b%22%2C%22jp000191066%22%3A%22mig00000000411894%22%2C%22fixedInfo%22%3A%22innerCode%3AMDMC000009F6CK%7C6%22%7D), but they're really expensive.

| Part                            | Link                                                                                            | Quantity | Price (per unit) | Total price       | Comments        |
|---------------------------------|-------------------------------------------------------------------------------------------------|----------|------------------|-------------------|-----------------|
| M5 spring T-nut (20-pack)       | [Amazon](https://www.amazon.com/uxcell-Elastic-Aluminum-Extrusion-Profile/dp/B07KWV51VG)        | 1        | $9.79            | $9.79             | For the shelves |
| M5 washers (75-pack)            | [Amazon](https://www.amazon.com/uxcell-Stainless-Washers-Thickness-Construction/dp/B0F9KN21P1)  | 1        | $8.07            | $8.07             | For the shelves |
| M5 x 8.00mm hex screw (50-pack) | [Amazon](https://www.amazon.com/Alloy-Steel-Socket-Screws-Black/dp/B015A34BUQ)                  | 1        | $8.89            | $8.89             | For the shelves |
| Hidden corner bracket (10-pack) | [TODO]()                                                                                        | 1        | $9.07            | $                 | For the corners |
| 20x20 endcaps (10-pack)         | [Amazon](https://www.amazon.com/uxcell-Extruded-Aluminum-European-Extrusion/dp/B0DM5Q7FDN)      | 1        | $5.99            | $5.99             |                 |
|                                 |                                                                                                 |          | Total            | $                 |                 |

I also added these 1U parts.

| Part                         | Link                                                                                               | Quantity | Price (per unit) | Total price       | Comments     |
|------------------------------|----------------------------------------------------------------------------------------------------|----------|------------------|-------------------|--------------|
| 1U shelves (2-pack)          | [Amazon](https://www.amazon.com/RackMate-Accessories-Cantilever-Equipment-Rackmate/dp/B0DWMFR111)  | 2        | $36.54           | $73.08            | 4 shelves    |
| 1U patch panel (12-port)     | [Amazon](https://www.amazon.com/NavePoint-12-Port-Modular-Patch-Panel/dp/B0CH1H22VY)               | 1        | $27.59           | $27.59            |              |
| Cat6A couplers (12-pack)     | [Amazon](https://www.amazon.com/trueCABLE-Keystone-Unshielded-Performance-Compliant/dp/B0916BNH9B) | 1        | $22.11           | $22.11            |              |
|                              |                                                                                                    |          | Total            | $122.78           |              |

In total, that's $ in new parts for the rack and hardware.

I also took this opportunity to upgrade from a UniFi [USW-Lite-8-POE](https://store.ui.com/us/en/category/switching-utility/products/usw-lite-8-poe) to a [USW-Lite-16-POE](https://store.ui.com/us/en/category/switching-utility/products/usw-lite-16-poe).

# Conclusion

What would I do differently next time?

First, I would buy a small chop saw. Each cut from 8020.net is $2.87, so that's $34.44 on cuts alone. For the same price, I could buy a [mini cut-off saw](https://www.harborfreight.com/09-amp-2-in-mini-cut-off-saw-70478.html), purchase 20x20 aluminum in bulk from Amazon, then cut it myself.

\-Logan