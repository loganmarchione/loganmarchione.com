---
title: "Homelab 10\" mini-rack v2"
date: "2025-09-25"
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

{{< img src="20250925_005.jpeg" alt="mini-rack assembled" >}}

# Introduction

:warning: WARNING :warning:

- This is an image-heavy post (I have lazy-loading enabled, so images should only load as you scroll)
- This post has embedded 3D models (if you have WebGL enabled), so they might take a few seconds to load
- The 3D models are available to download, but they're only accurate to the nearest whole millimeter

I've been using my home-made [mini-rack](/2021/01/homelab-10-mini-rack/) for a few years now. My main complaint is that the shelves *themselves* are the horizontal structure on the front face of the unit. If I start removing them, the unit flexes. Also, the whole thing is kind of "wobbly".

{{< img src="20220915_001.jpeg" alt="mini-rack" >}}

However, mini-racks have come a long way since then. DeskPi has their [wildly popular RackMate line](https://deskpi.com/collections/deskpi-rack-mate) of mini-racks, and Jeff Geerling started [Project MINI RACK](https://mini-rack.jeffgeerling.com/). All of this left my home-made mini-rack feeling a little old.

I only have space for 4U, so a [DeskPi Rack Mate T0](https://deskpi.com/products/deskpi-rackmate-t1-rackmount-10-inch-4u-server-cabinet-for-network-servers-audio-and-video-equipment) would have been perfect. However, my mini-rack sits on a very short shelf, and the RackMate T0 is too tall by about an inch, due to the large aluminum "forehead" at the top of the rack.

{{< figure src="20250814_001.jpg" width="74%" loading="lazy" alt="deskpi rackmate t0" attr="DeskPi RackMate T0 from DeskPi" attrlink="https://deskpi.com/products/deskpi-rackmate-t1-rackmount-10-inch-4u-server-cabinet-for-network-servers-audio-and-video-equipment">}}

So naturally, I over-engineered (and over-paid for), my own rack 🤷.

# Standards

As I [discussed in the past](/2022/09/homelab-10-mini-rack-shelves/#10-inch-racks), there is no standard for mini-racks. They're generally half the size of a 19-inch rack, which would put them at 9.5-inches, but people actually refer to them as 10-inch racks, or half-racks.

Also, in my last post, I said:

> I know that the [imperial system](https://en.wikipedia.org/wiki/Imperial_units) of units is inferior to the metric system, but these are 10-inch racks, not 254mm racks :man_shrugging:

Well, I'm eating my words now. Because of the small dimensions I'm working with, I decided to do all of my measurements in millimeters. With that said, the holes on the [shelves](https://www.amazon.com/RackMate-Accessories-Cantilever-Equipment-Rackmate/dp/B0DWMFR111) I'm using are 237mm center-to-center, and 1U is 45mm tall, so that was my basis for the mini-rack.

# Design

I've been seeing a ton of racks made of extruded aluminum. I guess I'm late to this, but extruded aluminum is like Lego for adults. It's really lightweight, easy to work with, has exact dimensions, and has slots on all four sides to connect pieces, accessories, etc... The different sizes are named for their dimensions (below are examples of 20x20mm and 20x40mm, respectively).

{{< figure src="20250814_002.jpg" width="25%" loading="lazy" alt="20x20 aluminum" attr="20x20 aluminum from 8020.net" attrlink="https://8020.net/20-2020.html">}}

{{< figure src="20250814_003.jpg" width="25%" loading="lazy" alt="20x40 aluminum" attr="20x40 aluminum from 8020.net" attrlink="https://8020.net/20-2040.html">}}

I decided on 20x20 aluminum rails, since they are the smallest size that still has lots of third-party parts available (but I have seen rails as small as 15x15mm or 10x10mm). I decided to mount the shelves directly to the aluminum rails (in-place of [traditional rack rails](https://www.penn-elcom.com/us/4u-rack-rail-with-full-holes-0-08in-thick-r0863-2mm-04)).

From what I can tell, [8020.net](https://8020.net) and [Misumi](https://us.misumi-ec.com/) are the biggest and/or most popular distributors, though you can also get this stuff cheap on Amazon and AliExpress. What's nice is that since aluminum is a relatively soft metal, you can cut it with a bandsaw or chop saw. I don't have one of those, but both 8020.net and Misumi will cut it for you (for a small fee).

Both 8020.net and Misumi have 3D building tools (and they both let you download 3D models of their products for use in other tools). 8020.net has the browser-based [IdeaBuilder](https://ideabuilder.io/) that lets you model *almost* anything in their catalog, while Misumi has [Frames](https://us.misumi-ec.com/service/promotion/frames/) (I wasn't able to use this because it is Windows-only). In IdeaBuilder, you can save your model to the cloud or a local file, and then upload the Bill of Materials (BoM) to your cart to get a list of all the parts you need. Below is what I built in just a few minutes in IdeaBuilder. If you're interested, [here is the JSON file](/2025/09/homelab-10-mini-rack-v2/v2.json) of the model below that you can upload to IdeaBuilder to get started (this was not my final design/dimensions).

{{< img src="20250814_004.png" alt="IdeaBuilder" >}}

An important note is that not all 20x20 aluminum is the same. In the examples below, both are 20mm on all four sides, but the 8020.net aluminum "slot" opening is only 5.26mm wide, while the Misumi slot is 6mm wide. For example, [these](https://www.amazon.com/uxcell-Interior-Connector-Aluminum-Extrusion/dp/B07VP59DY5) hidden corner brackets didn't fit into the 20x20 aluminum from 8020.net, since the "slot" is 5.26mm, not a full 6mm. Because of that, I went with Misumi rails, since they have a wider slot, which would accept more third-party parts.

{{< figure src="20250901_001.jpg" width="50%" loading="lazy" alt="20x20 aluminum" attr="20x20 aluminum from 8020.net" attrlink="https://8020.net/20-2020.html">}}

{{< figure src="20250901_002.jpg" width="50%" loading="lazy" alt="20x20 aluminum" attr="20x20 aluminum from Misumi.com" attrlink="https://us.misumi-ec.com/vona2/detail/110302683830/">}}

## 3D model

I've been meaning to learn some basic 3D modeling, so this was a good excuse. I didn't need anything complicated like [Autodesk Fusion360](https://www.autodesk.com/products/fusion-360/personal) or [FreeCAD](https://www.freecad.org/). However, an Autodesk product called [Tinkercad](https://www.tinkercad.com/) fit the bill perfectly. The learning curve was very easy and they have great [tutorials](https://www.tinkercad.com/learn) to get you started.

I built the new rack (without hardware) using Misumi's 20x20 aluminum in Tinkercad (this is a 3D model, so you should be able to rotate/zoom below). The Tinkercad link is [here](https://www.tinkercad.com/things/jxaDc5besOI-mini-rack-v2), and the STL file is [here](/2025/09/homelab-10-mini-rack-v2/tinkercad-misumi_rack_v2.stl) if you want to download it. To save weight and make the rack shorter, I removed the two top cross-bars at the front and back (since the rack is only 4U, I don't need that much structural stability).

{{< threejs-stl
    version="0.179.1"
    id="mini-rackv2"
    width="600"
    height="600"
    color="#b5b899ff"
    background="#e9e9e9ff"
    rotateX="-90"
    rotateY="0"
    rotateZ="0"
    center="true"
    showEdges="true"
    edgeColor="#000000ff"
    edgeThreshold="5"
    stl="tinkercad-misumi_rack_v2.stl" >}}

For the next two items, there was no pre-existing model to import, so I had to break out the calipers and create these by hand. They're not perfect, everything is only accurate to the nearest whole millimeter.

I modeled the shelves I was going to use (Tinkercad link [here](https://www.tinkercad.com/things/37CqfJjxWGh-deskpi-rackmate-10-inch-1u-rack-shelf), STL file [here](/2025/09/homelab-10-mini-rack-v2/tinkercad_deskpi_rackmate_1u_shelf.stl)).

{{< threejs-stl
    version="0.179.1"
    id="1u shelf"
    width="600"
    height="600"
    color="#b5b899ff"
    background="#e9e9e9ff"
    rotateX="-90"
    rotateY="0"
    rotateZ="0"
    center="true"
    showEdges="true"
    edgeColor="#000000ff"
    edgeThreshold="5"
    stl="tinkercad_deskpi_rackmate_1u_shelf.stl" >}}

I also modeled the patch panel (Tinkercad link [here](https://www.tinkercad.com/things/50AKhJJ7L3K-navepoint-10-inch-1u-12-port-modular-patch-panel), STL file [here](/2025/09/homelab-10-mini-rack-v2/tinkercad_navepoint_1u_patch_panel.stl)).

{{< threejs-stl
    version="0.179.1"
    id="1u patch panel"
    width="600"
    height="600"
    color="#b5b899ff"
    background="#e9e9e9ff"
    rotateX="-90"
    rotateY="0"
    rotateZ="0"
    center="true"
    showEdges="true"
    edgeColor="#000000ff"
    edgeThreshold="5"
    stl="tinkercad_navepoint_1u_patch_panel.stl" >}}

This was my final 3D design (without hardware) with the shelves and patch panel assembled.

{{< threejs-stl
    version="0.179.1"
    id="mini-rackv2-assembled"
    width="600"
    height="600"
    color="#b5b899ff"
    background="#e9e9e9ff"
    rotateX="-90"
    rotateY="0"
    rotateZ="0"
    center="true"
    showEdges="true"
    edgeColor="#000000ff"
    edgeThreshold="5"
    stl="tinkercad-misumi_rack_v2_assembled.stl" >}}

Here is the same design, but a screenshot of Tinkercad, so it's easier to see the individual parts.

{{< img src="20250925_001.png" alt="mini-rack assembled 3d view" >}}

# Presenting: The mini-rack, v2

This was the finished product and it fit together like a glove (chef's kiss)!

{{< img src="20250925_002.jpeg" alt="mini-rack assembled" >}}

{{< img src="20250925_003.jpeg" alt="mini-rack assembled" >}}

{{< img src="20250925_004.jpeg" alt="mini-rack assembled" >}}

I had to add an extra set of corner brackets for the top rails, since with only one set, the rails would rotate around the invisible axis that ran through the screws. The second set of brackets locks them in place.

{{< img src="20250925_005.jpeg" alt="mini-rack assembled" >}}

Here is the rack loaded with gear. I purposely made the vertical aluminum pieces a little too tall, to give me some "wiggle room" for taller items to fit on the shelves.

{{< img src="20250925_006.jpeg" alt="mini-rack assembled with gear" >}}

{{< img src="20250925_007.jpeg" alt="mini-rack assembled with gear" >}}

## Parts

I purchased the 20x20 aluminum from Misumi, since they could cut it for me.

| Part                            | Link                                                                                            | Quantity | Price (per unit) | Total price       | Comments                    |
|---------------------------------|-------------------------------------------------------------------------------------------------|----------|------------------|-------------------|-----------------------------|
| 20x20 aluminum                  | [Misumi.com](https://us.misumi-ec.com/vona2/detail/110302683830/)                               | 4        | $4.90            | $19.60            | Cut to 225mm for "depth"    |
| 20x20 aluminum                  | [Misumi.com](https://us.misumi-ec.com/vona2/detail/110302683830/)                               | 4        | $4.90            | $19.60            | Cut to 215mm for "height"   |
| 20x20 aluminum                  | [Misumi.com](https://us.misumi-ec.com/vona2/detail/110302683830/)                               | 4        | $4.90            | $19.60            | Cut to 217mm for "width"    |
| Corner brackets                 | [Misumi.com](https://us.misumi-ec.com/vona2/detail/110300438930/?ProductCode=HBLSS5)            | 16       | $1.43            | $22.88            |                             |
| End caps                        | [Misumi.com](https://us.misumi-ec.com/vona2/detail/110300440510/?ProductCode=HFCL5-2020-B)      | 8        | $2.55            | $20.40            |                             |
|                                 |                                                                                                 |          | Total            | $102.08           |                             |

I purchased almost all of the hardware (e.g., screws, T-nuts, etc...) from Amazon, since it was much cheaper than anything Misumi had to offer. I used hidden corner brackets for the front and back of the rack, since that's where the shelves would load from (regular corner brackets would interfere with the shelves). Misumi makes [hidden corner brackets](https://us.misumi-ec.com/vona2/detail/110310741779/?ProductCode=SH-SHBLBS5), but they're really expensive. Be warned, however, that the hidden corner brackets from Amazon are cast alumium, so they're really not able to take a ton of force.

| Part                            | Link                                                                                            | Quantity | Price (per unit) | Total price       | Comments        |
|---------------------------------|-------------------------------------------------------------------------------------------------|----------|------------------|-------------------|-----------------|
| M5 spring T-nut (20-pack)       | [Amazon](https://www.amazon.com/uxcell-Elastic-Aluminum-Extrusion-Profile/dp/B07KWV51VG)        | 1        | $9.79            | $9.79             | For the shelves |
| M5 washers (75-pack)            | [Amazon](https://www.amazon.com/uxcell-Stainless-Washers-Thickness-Construction/dp/B0F9KN21P1)  | 1        | $8.07            | $8.07             | For the shelves |
| Hidden corner bracket (24-pack) | [Amazon](https://www.amazon.com/L-Shape-Interior-Connector-Aluminum-Extrusion/dp/B0D8LGH99N)    | 1        | $12.99           | $12.99            | For the shelves |
| M5 T-nut (50-pack)              | [Amazon](https://www.amazon.com/uxcell-Nuts-50pcs-Fastener-Extrusion/dp/B0C9QQNBPR)             | 1        | $8.99            | $8.99             |                 |
| M5 x 8.00mm hex screw (50-pack) | [Amazon](https://www.amazon.com/uxcell-M5x8mm-Socket-Button-Screws/dp/B09R3R36BV)               | 1        | $7.79            | $7.79             |                 |
|                                 |                                                                                                 |          | Total            | $47.63            |                 |

I also added these 1U parts.

| Part                         | Link                                                                                               | Quantity | Price (per unit) | Total price       | Comments        |
|------------------------------|----------------------------------------------------------------------------------------------------|----------|------------------|-------------------|-----------------|
| 1U shelves (2-pack)          | [Amazon](https://www.amazon.com/RackMate-Accessories-Cantilever-Equipment-Rackmate/dp/B0DWMFR111)  | 2        | $36.54           | $73.08            | 4 shelves total |
| 1U patch panel (12-port)     | [Amazon](https://www.amazon.com/NavePoint-12-Port-Modular-Patch-Panel/dp/B0CH1H22VY)               | 1        | $27.59           | $27.59            |                 |
| Cat6A couplers (12-pack)     | [Amazon](https://www.amazon.com/trueCABLE-Keystone-Unshielded-Performance-Compliant/dp/B0916BNH9B) | 1        | $22.11           | $22.11            |                 |
|                              |                                                                                                    |          | Total            | $122.78           |                 |

In total, that's $272.49 in new parts for the rack, hardware, shelves, and patch panel. That is more expensive than the [DeskPi Rack Mate T0](https://deskpi.com/products/deskpi-rackmate-t1-rackmount-10-inch-4u-server-cabinet-for-network-servers-audio-and-video-equipment) at $79.99, but this price includes the shelves and patch panel.

# Conclusion

What would I do differently next time?

First, I would buy a small chop saw. Each cut from 8020.net is $2.87, so that's $34.44 on cuts alone. For the same price, I could buy a mini cut-off saw, purchase 20x20 aluminum in bulk from Amazon, then cut it myself.

{{< figure src="20250925_010.jpg" width="50%" loading="lazy" alt="mini cut-off saw" attr="Mini Cut-Off Saw from Harbor Freight" attrlink="https://www.harborfreight.com/09-amp-2-in-mini-cut-off-saw-70478.html">}}


Second, I'd probably use the spring T-nuts everywhere. The little spring-load ball detent holds the nuts in place, so they don't slide around in the rail slots.

{{< figure src="20250925_008.jpg" width="50%" loading="lazy" alt="m5 spring t-nut t0" attr="M5 spring T-nut from Amazon" attrlink="https://www.amazon.com/uxcell-Elastic-Aluminum-Extrusion-Profile/dp/B07KWV51VG">}}

Third, since I purchased four shelves, and the shelf that the rack sits on is open in the back, I would mount an extra shelf on the back of the rack to give me more space for one more item.

{{< img src="20250925_009.png" alt="mini-rack assembled with extra shelf" >}}

Also, if I had more vertical space, I'd stack this thing 12U high 😅.

\-Logan