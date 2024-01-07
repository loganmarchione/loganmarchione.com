---
title: "My experience replacing the Steam Deck SSD"
date: "2023-01-17"
author: "Logan Marchione"
categories:
  - "oc"
  - "gaming"
  - "linux"
  - "pc-hardware"
cover:
    image: "/assets/featured/featured_steam_deck.svg"
    alt: "featured image"
    relative: false
---

# Update: 2024-01-12

I couldn't resist the lure of the [Steam Deck OLED](https://www.steamdeck.com/en/oled). I purchased the 512GB model (the same size as my Steam Deck LCD upgraded Kioxia BG4 drive) and used it for a few weeks before purchasing a 1TB Kioxia BG4. Hindsight being 20/20, I should have just purchased the 1TB Steam Deck OLED directly from Valve, since the difference between the 512GB and 1TB model was only $100, and I spent much that on the aftermarket 1TB Kioxia BG4. :man_shrugging:

| Make            | Model                       | Link                                                                                                                                                                     | Watts | PCIe Spec | Price         | Comments                                            |
|-----------------|-----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----------|---------------|-----------------------------------------------------|
| Kioxia          | BG4 KBG40ZNS1T02            | [Here](https://www.kioxia.com/content/dam/kioxia/shared/business/ssd/client-ssd/asset/productbrief/cSSD-BG4-product-brief.pdf)                                           | 3.7W  | Gen3 x4   | ~$100         | Not sold to retail customers, will need to use eBay |

I specifically chose the Kioxia BG4 again because it is PCIe Gen3 x4, which is what the Steam Deck supports. A Gen4 x4 SSD wouldn't be any faster because it's limited by the Gen3 x4 slot in the Steam Deck. In addition, I was worried about a Gen4 x4 SSD consuming more power. As it stands, the 1TB Kioxia BG4 only consumes 1.12A (because `A = 3.7W/3.3V`), while both the 1TB Kioxia BG5 and BG6 consume 1.30A (because `A = 4.3W/3.3V`).

Here is the Steam Deck's 1TB storage (after the upgrade)

{{< img src="20240106_001.jpg" alt="steam deck 1tb storage" >}}

# Update: 2023-08-28

I've been using the Kioxia BG4 for over six months now without any issues. In that time, the Steam Deck has become much more popular (so popular that some of these SSDs are marketed as "Steam Deck upgrade kits"). I don't have a need to upgrade my Kioxia BG4 (yet), but you may want to consider these newer models as well.

| Make            | Model                       | Link                                                                                                                                                                     | Watts | PCIe Spec | Price         | Comments                                            |
|-----------------|-----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----------|---------------|-----------------------------------------------------|
| Corsair         | MP600 Mini (1TB)            | [Here](https://www.corsair.com/us/en/p/data-storage/cssd-f1000gbmp600mn/mp600-mini-1tb-gen4-pcie-x4-nvme-m-2-2230-ssd-cssd-f1000gbmp600mn)                               | 4.3W  | Gen4 x4   | $94.99        |                                                     |
| Inland          | TN446 (1TB)                 | [Here](https://www.microcenter.com/product/663766/inland-tn446-1tb-3d-tlc-nand-pcie-gen-4-x4-nvme-m2-2230-internal-ssd-compatible-with-steam-deck)                       | 4.0W  | Gen4 x4   | $109.99       | This appears to be an updated version of the TN436  |
| Team Group      | MP44S (1TB)                 | [Here](https://www.teamgroupinc.com/en/product/mp44s)                                                                                                                    | ???   | Gen4 x4   | $77.99        | Unable to find watts or amps usage                  |
| Kioxia          | BG6 (1TB)                   | [Here](https://americas.kioxia.com/en-us/business/news/2023/memory-20230522-1.html)                                                                                      | 4.3W  | Gen4 x4   | ???           | This was just announced in May 2023                 |

# TL;DR

You can purchase a large SSD for way less than Valve is charging and it's easy to replace the SSD in your Steam Deck.

| Item            | Price | | Item             | Price |
|-----------------|-------|-|------------------|-------|
| 64GB Steam Deck | $399  | | 512GB Steam Deck | $649  |
| 512GB NVMe SSD  | $65   | |                  |       |
| Total           | $464  | |                  | $649  |

# Introduction

I wanted to pick up a [Steam Deck](https://www.steamdeck.com/en/) and was stuck on what model to purchase. The only difference between models (besides an etched glass display and a Steam Community profile bundle) is the size of the internal storage.

- $399 - 64 GB eMMC
- $529 - 256 GB NVMe SSD
- $649 - 512 GB NVMe SSD

Every Steam Deck has a microSD card slot, so one would be tempted to purchase the 64GB Steam Deck and use a 1TB microSD card for games. While that would work, there are two small hiccups to be aware of:

1. The microSD card is significantly slower than any other kind of internal storage (eMMC or NVMe).
1. Steam needs space for the [shader cache](https://www.gamersdirector.com/steam/what-is-steam-deck-shader-pre-caching/), but this space can only be on the internal storage, not the microSD card (there are hacks to move the shader cache to the microSD card, but performance is terrible). This means that a 64GB eMMC module can quickly fill up not with games, but with shader caches from the games. Obviously, the larger the game, the larger the shader cache required.

Because of this, I wanted at least a 256GB SSD, but didn't want to pay the storage premium that Valve was charging.

- A 256GB Steam Deck is a $130 upgrade from the base model, when a 256GB SSD itself can be bought online for $50
- A 512GB Steam Deck is a $250 upgrade from the base model, when a 512GB SSD itself can be bought online for $100

The internal storage in the Steam Deck is socketed using a M.2 slot, and the SSD inside is a regular 2230 drive (see below). Why not purchase the cheapest Steam Deck, open it, and replace the SSD? If you look around online, this is exactly what a ton of people have done.

{{< img src="20230106_001.jpg" alt="steam deck m.2 slot" >}}

In a demo video, Valve explicitly [warned users](https://www.youtube.com/watch?v=Dxnr2FAADAs&t=197s) to not upgrade the SSD, lest they hurt themselves or damage the Steam Deck, but this should be an easy swap.

![meme](/assets/memes/jennifer_lawrence_ok_thumbs_up.gif)

# SSDs

## Stock SSDs

Every Steam Deck has a microSD card slot. This slot is nice for expandable storage, but it's significantly slower than any other kind of internal storage (eMMC or NVMe).

{{< img src="20230106_003.jpg" alt="micro sd card" >}}

Aside from the microSD card slot, there are three [base storage options](https://www.steamdeck.com/en/tech):

- 64 GB eMMC (PCIe Gen 2 x1)
- 256 GB NVMe SSD (PCIe Gen 3 x4 or PCIe Gen 3 x2)
- 512 GB high-speed NVMe SSD (PCIe Gen 3 x4 or PCIe Gen 3 x2)

The first option is an eMMC module on a carrier board that fits into a M.2 NVMe slot (eMMC is about half-as-fast as a SATA SSD).

{{< figure src="20230106_002.png" width="100%" alt="steam deck emmc module" attr="Image from The Big Tech Question" attrlink="https://bigtechquestion.com/2022/05/31/hardware/upgrade-ssd-steam-deck/">}}

The next two options are both NVMe SSDs, but I'm unable to tell if one is faster than the other (besides the larger drive being slightly faster because it's larger). While the SSD is PCIe Gen3 on both the 256GB and 512GB models, Valve warns:

> Some 256GB and 512GB models ship with a PCIe Gen 3 x2 SSD. In our testing, we did not see any impact to gaming performance between x2 and x4

To me, that says that the drives between the 256GB and 512GB models are the same, other than storage capacity.

For reference, below are some real-world examples of 64GB, 256GB, and 512GB drives found in Steam Deck hardware. Note that this is not an exhaustive list of makes/models.

Foresee FE2H0M064G-B5X10
- https://www.reddit.com/r/SteamDeck/comments/wbtcv2/brand_of_stock_internal_64gb_steam_deck_drive/
- https://www.reddit.com/r/gadgets/comments/vjxuqk/comment/idphmzq/
- https://www.reddit.com/r/SteamDeck/comments/zo5lqm/comment/j0mu861/

Kingston 256GB Gen3 x4 OM3PDP3256B-A01
- https://www.reddit.com/r/SteamDeck/comments/xrafko/comment/iqz91kc/
- https://www.reddit.com/r/SteamDeck/comments/wm6zve/comment/ijxmm3z/
- https://www.reddit.com/r/SteamDeck/comments/wm6zve/comment/ijxlrcj/

Kingston 512GB Gen3 x4 OM3PDP3512B-A01
- https://www.reddit.com/r/SteamDeck/comments/w5guzg/comment/ih88sll/
- https://www.reddit.com/r/SteamDeck/comments/sol79s/comment/hw9svat/
- https://www.reddit.com/r/SteamDeck/comments/tb6f0f/comment/i059wap/
- https://www.reddit.com/r/SteamDeck/comments/snxwbs/you_can_get_the_512gb_ssd_the_steam_deck_uses_for/

## Power usage

Before we continue, we need a quick refresher in how electricity works. In the example below, I was always taught to circle the measurement you want, and then you'll get the formula for the other two measurements.

{{< img src="20230106_004.png" alt="watts amps volts triangle" >}}

For example:

- `W = A*V`
- `A = W/V`
- `V = W/A`

The stock Steam Deck SSDs have been specifically chosen to pull as few amps as possible. Amps are like the "rate" of electric flow per unit of time. So, in the case of a battery-powered device (like the Steam Deck), more amps equal faster battery usage (as well as more waste heat generated). 

From the examples above, and through searching Reddit and Twitter, I've seen Valve use SSDs ranging from 1A (3.3W) to 2A (6.6W). In my search for SSDs, I was trying to keep it as close to the low-end (1A) as possible, since a higher-draw SSD would drain more battery and produce more waste heat. Also, keep in mind that a larger capacity drive has more flash chips (e.g., 1TB vs 512GB), which require more power.

This is also why Valve [warns against](https://twitter.com/lawrenceyang/status/1540809830000013313) putting 2242 SSDs into the Steam Deck, since the 2242 form-factor draws more power and produces more heat than the Steam Deck is designed to handle. Though, that doesn't stop [some people](https://twitter.com/TheSmcelrea/status/1539296261613944833). Hell, if you like to live dangerously, you can even buy a 2280 M.2 SSD and physically cut it down to 2230, as [this person did](https://www.reddit.com/r/SteamDeck/comments/ubylwl/samsung_pm991a_cut_to_fit/). I obviously do not recommend either of these options (neither does Valve).


## Replacement SSDs

Because M.2 2230 SSDs are not commonly sold to retail customers (e.g., most PCs use 2280), there are only a few retail sources, with the rest being sourced from used parts on eBay. That being said, here are the requirements for a replacement SSD:
- M.2 2230 NVMe (not SATA)
- single-sided (e.g., only has chips on one side of the drive, otherwise it won't fit)
- 3.3V (this is a M.2 standard)
- 2A max power draw (manufacturers will often give measurments in watts, so you'll have to convert using `A = W/V`)
- keep in mind that the M.2 slot is limited to PCIe Gen3 x4 (so a PCIe Gen4 drive is overkill)

Below are some SSDs I found in my searching. All of these are 512GB, except the Inland, which only comes in a 1TB version. I also stumbled upon a much more [extensive post](https://dancharblog.wordpress.com/2020/03/19/upgrade-sl3-or-spx-to-1tb/) about replacement SSDs, so be sure to check that out for even more options.



| Make            | Model                       | Link                                                                                                                                                                     | Watts | PCIe Spec | Price         | Comments                                            |
|-----------------|-----------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------|-----------|---------------|-----------------------------------------------------|
| Sabrent         | Rocket SB-2130-512          | [Here](https://sabrent.com/products/sb-2130-512)                                                                                                                         | 4.0W  | Gen4 x4   | $89.99        | This was just released in December 2022             |
| Inland          | TN436                       | [Here](https://www.microcenter.com/product/649991/inland-tn436-1tb-3d-tlc-nand-pcie-gen-4-x4-nvme-m2-2230-internal-ssd-compatible-with-microsoft-surface-and-steam-deck) | 4.0W  | Gen4 x4   | $139.99       | 1TB only, in-store only                             |
| Kioxia          | BG5 KBG50ZNS512G            | [Here](https://americas.kioxia.com/en-us/business/ssd/client-ssd/bg5.html)                                                                                               | 4.1W  | Gen4 x4   | ~$80          | Not sold to retail customers, will need to use eBay |
| Western Digital | SN740 SDDPTQD-512G          | [Here](https://www.westerndigital.com/products/internal-drives/pc-sn740-ssd#SDDPTQD-512G)                                                                                | 5.0W  | Gen4 x4   | ~$80          | Not sold to retail customers, will need to use eBay |
| Kioxia          | BG4 KBG40ZNS512G            | [Here](https://americas.kioxia.com/en-us/business/ssd/client-ssd/bg4.html)                                                                                               | 3.5W  | Gen3 x4   | ~$70          | Not sold to retail customers, will need to use eBay |
| SK Hynix        | BC711 HFM512GD3GX013N       | [Here](https://product.skhynix.com/products/ssd/cssd/pc711.go)                                                                                                           | 3.5W  | Gen3 x4   | ~$65          | Not sold to retail customers, will need to use eBay |
| Samsung         | PM991A MZ9LQ512HBLU         | ???                                                                                                                                                                      | 4.6W  | Gen3 x4   | ~$60          | Not sold to retail customers, will need to use eBay |
| Western Digital | SN530 SDBPTPZ-512G          | [Here](https://www.westerndigital.com/products/internal-drives/pc-sn530-ssd#SDBPTPZ-512G)                                                                                | ???   | Gen3 x4   | ~$60          | Not sold to retail customers, will need to use eBay |

I ended up purchasing a Kioxia BG4 KBG40ZNS512G for $65. On paper, it had the lowest power draw (1.06A because `A = 3.5W/3.3V`). Hopefully this will net the longest battery life.


Maybe I'm old, but I couldn't believe how small this thing was! :exploding_head:

{{< img src="20230117_002.jpeg" alt="kioxia KBG40ZNS512G" >}}

{{< img src="20230117_003.jpeg" alt="kioxia KBG40ZNS512G" >}}

The eBay seller was [XPC Technologies](https://www.ebay.com/str/xpctechnologies) and true to their listing, it had less than 7 power-on-hours.

```
SMART/Health Information (NVMe Log 0x02)
Critical Warning:                   0x00
Temperature:                        32 Celsius
Available Spare:                    100%
Available Spare Threshold:          50%
Percentage Used:                    0%
Data Units Read:                    243,326 [124 GB]
Data Units Written:                 280,808 [143 GB]
Host Read Commands:                 2,480,922
Host Write Commands:                2,089,440
Controller Busy Time:               10
Power Cycles:                       19
Power On Hours:                     4
Unsafe Shutdowns:                   8
Media and Data Integrity Errors:    0
Error Information Log Entries:      0
Warning  Comp. Temperature Time:    0
Critical Comp. Temperature Time:    0
Temperature Sensor 1:               32 Celsius
```

# Replacement

The replacement process is pretty easy if you've ever built a PC before.

## Parts

You'll need a few parts to get started:

1. A large, clean, metal-free work surface
1. The replacement SSD
1. A [USB-C flash drive](https://www.bhphotovideo.com/c/product/1547784-REG/sandisk_sdddc4_032g_a46_ultra_dual_drive_luxe.html) that is preinstalled with the SteamOS [recovery image](https://help.steampowered.com/en/faqs/view/1b71-edf2-eb6d-2bb3)
1. Some plastic spreaders to open the case (I like [this](https://www.ifixit.com/products/prying-and-opening-tool-assortment) pack)
1. A small screwdriver kit (I like [this](https://www.ifixit.com/products/mako-driver-kit-64-precision-bits) kit)
1. Optional - A set of tweezers (like [this](https://www.ifixit.com/products/nylon-tipped-tweezers))


## Procedure

I won't rewrite iFixit's [excellent guide](https://www.ifixit.com/Guide/Steam+Deck+SSD+Replacement/148989), but between that and Valve's [teardown video](https://www.youtube.com/watch?v=Dxnr2FAADAs), you should have no problems doing the replacement.

My tips are:

- Remove the microSD card before opening the case (otherwise you'll break your card)
- Put your Steam Deck into [battery storage mode](https://www.ifixit.com/Guide/How+to+Enable+Battery+Storage+Mode/149962) before opening it up (FYI you'll need to plug in the power adapter to get it out of this mode when you're done)
- Place the Steam Deck screen-down in its case so that you're not putting pressure on the joysticks during the disassembly
- Don't replace the SSD until you **disconnect the battery**
- After the battery is disconnected, push the power button a few times to discharge any remaining electricity
- Don't damage the foil wrap around the SSD, you'll need to reuse it
- When replacing the screws in the plastic back, turn them counter-clockwise until they click into place, then turn clockwise (this will prevent you from cross-threading them)

{{< img src="20230117_004.jpeg" alt="steam deck back off" >}}

{{< img src="20230117_005.jpeg" alt="steam deck back off" >}}

{{< img src="20230117_006.jpeg" alt="steam deck back off" >}}

After you're done, you'll have a blank SSD in the Steam Deck, so you'll have to use a different computer to burn the SteamOS [recovery image](https://help.steampowered.com/en/faqs/view/1b71-edf2-eb6d-2bb3) to a USB flash drive, then boot the Steam Deck off the flash drive in order to reinstall SteamOS.

After that, you should be able to boot your Steam Deck and see the expanded storage. A couple more notes:

- My replacement SSD didn't show up in the Steam Deck BIOS (and the eBay seller specifically listed that it wouldn't)
- When I reinstalled SteamOS, none of the controls worked (face buttons, joysticks, triggers, etc...) except for the touchscreen. After an update to the latest SteamOS, everything worked again.
- The update got stuck on "Installing" for 10+ minutes. When I forced a power-off and restarted it, a different screen came up and it worked. :man_shrugging:

## Before/after

Here is the Steam Deck's 64GB storage (before the upgrade)

{{< img src="20230117_001.jpg" alt="steam deck 64gb storage" >}}

Here is the Steam Deck's 512GB storage (after the upgrade)

{{< img src="20230117_007.jpg" alt="steam deck 512gb storage" >}}

I didn't run any before/after benchmarks on the SSDs, those are easy enough to find [online](https://www.reddit.com/r/SteamDeck/comments/x0wdd8/disk_benchmarks_results_emmc_vs_nvme_vs_microsdxc/). Maybe it's confirmation bias, but the Steam Deck _feels_ snappier in the menus and loading games.

# Conclusion

Thanks to Lord Gaben and Valve for designing such a powerful product, but more importantly, allowing tinkerers to be able to fix and upgrade it without jumping through hoops. This is your right to repair in action.

{{< figure src="/assets/memes/gabe_newell_jesus.jpg" width="50%" alt="gabe newell jesus" attr="Gabe Newell Portrait by freddre" attrlink="https://www.deviantart.com/freddre/art/Gabe-Newell-Portrait-288307422">}}

\-Logan
