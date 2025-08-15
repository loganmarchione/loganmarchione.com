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

# Introduction

I've been using my home-made [mini-rack](/2021/01/homelab-10-mini-rack/) for a few years now. While it's not the prettiest thing in the world, it works.

{{< img src="20220915_001.jpeg" alt="mini-rack" >}}

However, mini-racks have come a long way since then. DeskPi has their [wildly popular RackMate line](https://deskpi.com/collections/deskpi-rack-mate) of mini-racks, and Jeff Geerling started [Project MINI RACK](https://mini-rack.jeffgeerling.com/). All of this left my home-made mini-rack feeling a little old.

I only have space for 4U, so a [DeskPi Rack Mate T0](https://deskpi.com/products/deskpi-rackmate-t1-rackmount-10-inch-4u-server-cabinet-for-network-servers-audio-and-video-equipment) would have been perfect. However, there is a problem. My mini-rack sits on a very short shelf, and the RackMate T0 is too tall by about an inch, due to the large aluminum "forehead" at the top of the rack.

{{< figure src="20250814_001.jpg" width="74%" loading="lazy" alt="deskpi rackmate t0" attr="DeskPi RackMate T0 from DeskPi" attrlink="https://deskpi.com/products/deskpi-rackmate-t1-rackmount-10-inch-4u-server-cabinet-for-network-servers-audio-and-video-equipment">}}

So naturally, I over-engineered, and over-paid to build, my own rack 🤷.

# Design

I've been seeing a ton of racks made of extruded aluminum. I guess I'm late on this, but extruded aluminum is apparently very heavily used in the 3D printing world. It's really lightweight, easy to work with, has exact dimensions, and has slots on all four sides to connect pieces, accessories, etc... The different sizes are named for their dimensions (below are examples of 20x20mm and 20x40mm).

{{< figure src="20250814_002.jpg" width="25%" loading="lazy" alt="20x20 aluminum" attr="20x20 aluminum from 8020.net" attrlink="https://8020.net/20-2020.html">}}

{{< figure src="20250814_003.jpg" width="25%" loading="lazy" alt="20x40 aluminum" attr="20x40 aluminum from 8020.net" attrlink="https://8020.net/20-2040.html">}}

From what I can tell, [8020.net](https://8020.net) is the biggest and/or most popular distributor, though you can get this stuff cheap on Amazon and AliExpress. What's nice is that since aluminum is a relatively soft metal, you can cut it with a bandsaw or chop saw. I don't have one of those, but 8020.net will cut it for you (for a small fee).

I decided on 20x20 aluminum rails. It's relatively small, but I have seen rails as small as 15x15 or 10x10. For me, buying everything from 8020.net was the easiest, and 20x20 is the smallest size they have.

Also, 8020.net has a 3D builder called [IdeaBuilder](https://ideabuilder.io/) that lets you model almost anything in their catalog in 3D. You can save your model to the cloud or a local file, and then upload the Bill of Materials (BoM) to their site to get a list of all the parts you need. Below is what I built in just a few minutes in IdeaBuilder.

{{< img src="20250814_004.png" alt="IdeaBuilder" >}}

I was able to export some images from IdeaBuilder to get a 3D view of my mini-rack, as well as an x-ray view showing the connectors.

{{< img src="20250814_005.png" alt="mini-rack v2" >}}

{{< img src="20250814_006.png" alt="mini-rack v2 connectors" >}}

If you're interested, here is the JSON file that you can upload to IdeaBuilder to get started.

[Link to JSON file](/2025/09/homelab-10-mini-rack-v2/v2.json)

# Presenting: The mini-rack, v2

As I [discussed in the past](/2022/09/homelab-10-mini-rack-shelves/#10-inch-racks), there is no standard for mini-racks. They're generally half the size of a 19-inch rack, which would put them at 9.5-inches, but people actually refer to them as 10-inch racks, or half-racks.

## Pictures

TODO: add pictures here

## Parts

Below are the parts that are part of the IdeaBuilder 3D design.

| Part                         | Link                                            | Quantity | Price (per unit) | Total price       | Comments     |
|------------------------------|-------------------------------------------------|----------|------------------|-------------------|--------------|
| 20x20 aluminum               | [8020.net](https://8020.net/20-2020.html)       | 4        | $5.16            | $20.64            | Cut to 220mm |
| 20x20 aluminum               | [8020.net](https://8020.net/20-2020.html)       | 8        | $5.21            | $41.68            | Cut to 225mm |
| 2-hole corner bracket        | [8020.net](https://8020.net/20-4119.html)       | 24       | $4.45            | $106.80           |              |
| M5 x 8.00mm screw            | [8020.net](https://8020.net/11-5308.html)       | 48       | $0.51            | $24.48            |              |
| M5 T-nut                     | [8020.net](https://8020.net/14122.html)         | 48       | $0.35            | $16.80            |              |

I also added some other parts that I wasn't able to model in IdeaBuilder. These are going to be used to secure the shelves (in-place of [traditional rack rails](https://www.penn-elcom.com/us/4u-rack-rail-with-full-holes-0-08in-thick-r0863-2mm-04)).

| Part                         | Link                                            | Quantity | Price (per unit) | Total price       | Comments     |
|------------------------------|-------------------------------------------------|----------|------------------|-------------------|--------------|
| M5 T-nut (25-pack)           | [8020.net](https://8020.net/13084.html)         | 1        | $46.50           | $46.50            |              |
| M5 x 10.00mm screw (25-pack) | [8020.net](https://8020.net/11-5510.html)       | 1        | $12.75           | $12.75            |              |

I also had these parts laying around from previous rack builds, but I'm adding them here for transparency.

| Part                         | Link                                                                                       | Quantity | Price (per unit) | Total price       | Comments     |
|------------------------------|--------------------------------------------------------------------------------------------|----------|------------------|-------------------|--------------|
| 1U shelves (2-pack)          | [DeskPi](https://deskpi.com/products/deskpi)                                               | 2        | $38.98           | $77.96            |              |
| 1U patch panel (12-port)     | [Amazon](https://www.amazon.com/uxcell-12-Port-Keystone-Rackmount-Shielded/dp/B0744XHTK3)  | 1        | $25.39           | $25.39            |              |

So in total, it's $269.65 for the rack with hardware, $103.35 for the shelves and patch panel (which I already had), which comes out to $373.00.

There are definitely cheaper ways to do this. For example, each cut is $2.87, so I'm already spending $34.44 on cuts because I don't have a saw. It would have also been way cheaper to buy the aluminum on Amazon (but I'd also need to cut it myself).

# Conclusion



\-Logan