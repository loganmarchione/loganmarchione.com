---
title: "Homelab 10\" mini-rack shelves"
date: "2022-09-16"
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

:warning: WARNING :warning:

- This is an image-heavy post (I have lazy-loading enabled, so images should only load as you scroll)
- I know that the [imperial system](https://en.wikipedia.org/wiki/Imperial_units) of units is inferior to the metric system, but these are 10-inch racks, not 254mm racks :man_shrugging:
- For my measurements, I've converted fractions (8-11/16) to decimals (8.6875)

For the past year-and-a-half, my network stack has lived in my [10-inch mini-rack](/2021/01/homelab-10-mini-rack) (not on my countertop, obviously).

{{< img src="20220915_002.jpeg" alt="mini-rack" >}}

{{< img src="20220915_003.jpeg" alt="mini-rack" >}}

{{< img src="20220915_001.jpeg" alt="mini-rack" >}}

I only had one complaint about my setup. Can you spot it below?

{{< img src="20220915_004.jpeg" alt="mini-rack" >}}

Each shelf has a lip on the front and back that bends downward (for structural stability), but this takes away from usable height of the shelf. While the ears of the shelf are 1U in height (1.75-inches), there is less than 1.50-inches of usable shelf height to work with. I could load taller items into the shelf, but they would need to be loaded in from the back (to get around the lip).

{{< img src="20220915_005.jpeg" alt="mini-rack" >}}

My [Netgear switch](https://www.netgear.com/business/wired/switches/plus/gs108pe/) fit in this space, but I was looking to replace it with a [UniFi Switch Lite 16 PoE](https://store.ui.com/collections/unifi-network-switching/products/usw-lite-16-poe), which is 1.72-inches tall.

{{< img src="20220830_004.png" alt="resume snippet" >}}

# Rack standards

## 19-inch racks

[19-inch racks](https://en.wikipedia.org/wiki/19-inch_rack) are the most common. They measure:
* 19-inches wide (including the ears)
* 18-5/16 (18.3125) inches center-to-center on post holes
* 17-3/4 (17.75) inches opening width between posts

{{< figure src="20220830_003.png" alt="rack width measurements" attr="Image (with misspelling) from PureStorage" attrlink="https://www.purestorage.com/nl/knowledge/definitive-guide-to-19-inch-server-rack-sizes.html">}}

## 10-inch racks

The 10-inch rack (aka "half-rack") [isn't a standard](http://rtsound.net/half-rack-compatible-equipment/) (that I could find). Instead, it's more like a general consensus (kind of like we've unofficially settled on [two sizes of toilet seat lid](https://www.toiletseats.com/education-and-inspiration/articles/how-to-measure-a-toilet-seat/)). As such, all equipment advertised as 10-inches or half-rack *might* not be compatible.

{{< figure src="20220830_002.png" alt="half-rack measurements" attr="Image from Wikipedia" attrlink="https://en.wikipedia.org/wiki/19-inch_rack#10-inch_rack">}}

10-inch racks are much more common outside the US (I'm not sure why). There are tons of companies selling 10-inch racks and accessories outside the US.

* [Cablematic](https://cablematic.com/en/products/category/10-rack-rackmatic/) (Spain)
* [NetwerkKabel](https://www.netwerkkabel.eu/en/server-cabinets/10-inch-products/) (Netherlands)
* [ServerRack24](https://www.serverrack24.com/server-racks/10-inch-patch-rack-products/) (Netherlands)
* [RackMagic](https://www.rack-magic.com/epages/10067278.sf/sec611a42c355/?ObjectPath=/Shops/10067278/Categories/%2219%22%22%20Racks%22/10_Schraenke__Zubehoer) (Germany)
* [Intellinet](https://intellinetnetwork.eu/search?q=10%22&type=product) (Germany)
* [Conrad](https://www.conrad.com/o/10-it-system-cabinet-accessories-0415200) (Germany - reseller)
* [CommsOnline](https://commsonline.co.uk/search?type=product&q=10+inch*) (UK)
* [DataCabinetsDirect](https://datacabinetsdirect.co.uk/soho-10-inch-data-network-rack-cabinets.html) (UK)
* [Network-Cabs](https://www.network-cabs.co.uk/cabinets-enclosures/10-soho-mini-cabinet) (UK)
* [All Metal Parts](https://www.allmetalparts.co.uk/55-5-inch-av-half-rack-system) (UK)
* [Rack Store Online](https://www.rackstore.online/collections/10-inch-soho-accessoires) (UK)
* [DigitX](https://www.digitx.it/reparto/cat1-Armadi_Rack_10_Pollici/) (Italy)
* [Techly](https://www.techly.com/networking/rack-cabinets-and-accessories/wall-cabinets-10-inches.html) (Italy)
* [Telrex](https://www.telephonewreckers.com.au/server-racks/10-inch-cabinets/) (Australia)
* [CableHUB](https://cablehub.com.au/collections/10-mini-cabinet) (Australia)

Inside the US, however, the only 10-inch racks and accessories I could find were specifically for audio/video applications, so I'm assuming that form-factor is more popular in the audio/video space (again, I'm not sure why). But, because it's a niche product segment, the prices were higher than I expected.

* [Full Compass](https://www.fullcompass.com/searchresults.php?search_simple=true&txtAll=half+rack)
* [Legrand AV (Middle Atlantic)](https://www.legrandav.com/search#q=half-rack&sort=relevancy&numberOfResults=20)
* [Vintage King](https://vintageking.com/catalogsearch/result/?q=half-rack)
* [Sweetwater](https://www.sweetwater.com/store/search.php?s=half+rack)
* [Lowell](https://www.lowellmfg.com/product-category/racks-enclosures/half-width-racks/half-width-racks-accessories-lowell-manufacturing/)
* [Odyssey](https://www.odysseygear.com/?s=half+rack&post_type=product)

# Shelves

I spent way too much time looking at industrial catalogs, obscure websites, and non-English marketplaces (e.g., Alibaba, AliExpress, etc...).

![meme](/assets/memes/pepe_silvia.jpg)

I was able to find a few shelves on Amazon and eBay. I tried to only purchase shelves with reasonable shipping costs (e.g., not paying $100 to ship a $30 metal shelf across an ocean). I purchased three shelves (plus the original shelf with the metal lip).

| Brand           | Part Number         | Purchase location                                                        | Price (USD)                          | Price (USD) shipping | Shipping time     | Usable height (in.) | Usable width (in.) | Usable depth (in.) | Center-to-center width (in.) |
|-----------------|---------------------|--------------------------------------------------------------------------|--------------------------------------|----------------------|-------------------|---------------------|--------------------|--------------------|------------------------------|
| Digitus         | DN-10-TRAY-1-B      | [eBay](https://www.ebay.com/itm/295163651736)                            | $24.20                               | $8.19                | 18 days (from IT) | 1.625               | 8.25               | 5.8125             | 9.3125                       |
| Digitus         | DN-10-TRAY-2-B      | [Amazon](https://www.amazon.com/dp/B08XJXKX4R)                           | $28.62                               | Free                 | 10 days (from UK) | 1.6875              | 8.375              | 7.6875             | 9.3125                       |
| Middle Atlantic | HR-UMS1-5.5         | [eBay](https://www.ebay.com/itm/195155991454)                            | $39.99                               | Free                 | 3 days (from US)  | 1.6875              | 8.6875             | 5.5                | 9.6875                       |
| Intellinet      | 714839              | [Amazon](https://www.amazon.com/dp/B078WCBFFM)                           | $15.95 (at time of purchase in 2021) | Free                 | 9 days (from UK)  | 1.375               | 8.5                | 5.8125             | 9.375                        |

# Comparison

Below are pictures, in the same order as above.

## Digitus DN-10-TRAY-1-B

{{< img src="20220915_007.jpeg" alt="shelf" >}}

{{< img src="20220915_008.jpeg" alt="shelf" >}}

## Digitus DN-10-TRAY-2-B

Note that the lip bends upwards (it is .3125-inches tall). This is the deepest shelf. The ears are not bent metal, but are instead welded on, which makes this the most narrow shelf.

{{< img src="20220915_009.jpeg" alt="shelf" >}}

{{< img src="20220915_010.jpeg" alt="shelf" >}}

## Middle Atlantic HR-UMS1-5.5

This was "new" on eBay and arrived bent in half (hence, why it appears not perfectly flat). Also, the center-to-center width of the post holes was *slightly* wider than the others (by .375-inches total), so I had to loosen all the cage nuts to allow the rack to expand slightly.

{{< img src="20220915_011.jpeg" alt="shelf" >}}

{{< img src="20220915_012.jpeg" alt="shelf" >}}

## Intellinet 714839

One of the original shelves I purchased in 2021. The lip that I hate.

{{< img src="20220915_013.jpeg" alt="shelf" >}}

{{< img src="20220915_014.jpeg" alt="shelf" >}}

# Conclusion

If you want one of these and you're in Europe, lucky you. If you're in the US, your best bet is to scour eBay and Amazon for the phrase "half-rack" and find options with low/free shipping. Other than that, you can overpay for new audio/video equipment. I've installed the Middle Atlantic HR-UMS1-5.5, which gives me exactly 1.75-inches to use. I will probably keep my hodgepodge of different shelves as-is for now.

{{< img src="20220915_006.jpeg" alt="mini-rack" >}}

\-Logan