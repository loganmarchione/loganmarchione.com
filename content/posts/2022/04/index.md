---
title: "Impressions from a first-time Mac user"
date: "2022-04-11"
author: "Logan Marchione"
categories:
  - "oc"
  - "mac-hardware"
cover:
    image: "/assets/featured/featured_generic_thumb_down.svg"
    alt: "featured image"
    relative: false
---

# Update: 2022-04-12

I posted this article to [that orange site](https://news.ycombinator.com/item?id=30993350) and it blew up more than I expected. I reached #3 of the front page (screenshot below) and am officially on the top 10 list for [2022-04-11](https://news.ycombinator.com/front?day=2022-04-11). When I [migrated from WordPress to Hugo](/2021/02/migrating-from-wordpress-to-hugo/#things-im-losing), I lost comments on this blog, but the HackerNews post has some really good discussion and recommendations that I highly encourage you to check out.

{{< img src="20220411_001.png" alt="hackernews" >}}

# TL;DR

⚠️ Warning Apple fanboys: this is a rant ⚠️

Hardware = Good

Software = Bad

# Introduction

I recently started a new job where my employer provided me with a brand-new [2021 16‑inch MacBook Pro](https://support.apple.com/kb/SP858). A little background on me: I've been using Windows and Linux my entire professional life, I have been daily-driving various Linux desktops at home for 10+ years, all of my servers run Linux, but I have _never_ used a Mac in my life. These are my impressions of using a Mac for the first time.

For reference, below are the specs of the machine I am using:
- 2021 16‑inch MacBook Pro
- Apple M1 Pro (8 performance cores and 2 efficiency cores)
- 16GB memory
- 512GB SSD
- macOS Monterey
- I'm using this Macbook almost exclusively with the lid closed, with a USB-C adapter to connect my keyboard/mouse/monitor.

# The Good

## Hardware build quality

This machine is _insanely_ well-built. In fact, I have probably never owned anything this well-built. Holding it in your hands feels like holding a solid piece of aluminum, there isn't a millimeter of flex. There isn't a single imperfection on the finish. The indentation where you put your finger to open the lid is so well machined that the edges are actually sharp. Closing the lid feels like closing the door of a German car. The display is bright and vibrant with very deep blacks. The M1 Pro chip sips power when asleep, but can handle anything I ask of it.

## Battery life

Does this machine actually have a battery, or there some sort of magic [arc reactor](https://marvel.fandom.com/wiki/Arc_Reactor) inside? Seriously, the battery on this thing lasts forver, whether I'm doing work, or if the lid is closed and it's sleeping. I can easily get through an 8-10hr day with no problems.

## BSD base

I won't claim to be a Unix or BSD historian, but I do know that macOS is based on [Darwin](https://en.wikipedia.org/wiki/Darwin_(operating_system)), which itself is based on [BSD](https://en.wikipedia.org/wiki/Berkeley_Software_Distribution). While macOS isn't POSIX-certified, it is [Single Unix Specification](https://en.wikipedia.org/wiki/Single_UNIX_Specification) UNIX 03 [registered and compliant](https://www.opengroup.org/openbrand/register/). This means if you're comfortable with a Linux command line, you'll probably be just fine for about 95% of your tasks.

# The Medicore

## Connectivity

Apple decided to grace the 2021 Macbook Pro with ports that any PC laptop user has had for years (HDMI?! SD card reader?! gasp!). 

That being said, MagSafe is a _genius_ idea. It should be a standard (like USB-C) on every laptop in existence. I know USB-C is supposed to be "one cable to rule them all", but anyone who has tripped over their power cord while charging knows what I'm talking about.

Speaking of USB-C, if you're buying a Macbook Pro, think about picking up a Thunderbolt or USB-C hub/dock/adapter. There are zero USB-A ports on the Macbook Pro. I can almost guarantee that you don't have a USB-C flash drive, but you probably have ten USB-A flash drives laying around. What about your wired keyboard, webcam, USB DAC, or USB chargers? I bet they're all USB-A. The dongle meme ([one](https://www.reddit.com/r/ProgrammerHumor/comments/ayqfqp/app_developers_smh/), [two](https://www.reddit.com/r/funny/comments/5a6lbd/it_just_works_apple/), [three](https://www.reddit.com/r/applesucks/comments/bbjbiw/applejust_use_dongles/), [four](https://twitter.com/dbreunig/status/792034409788518401), [five](https://www.reddit.com/r/applesucks/comments/js2ubv/they_get_you_every_time/)) is overplayed at this point, but it's not wrong.

## Expansion

With the new M1 Macs, the CPU, memory, and storage are all unified, meaning they are soldered together and cannot be upgraded. However, the trade off is that because everything is so tightly coupled, you get better speeds than you would from traditional components that communicate over a slower bus. Also, because Thunderbolt 4 has so much bandwidth (up to 40Gb/s), you really aren't limited to what you can plug in (as long as it's over Thunderbolt).

# The Bad

## macOS window management

There is no other way to say this: window management is painful on macOS.

### Snapping

I'm accustomed to virtual desktops on both Windows and Linux, so it was nice to see that on macOS. However, multi-tasking within the same virtual desktop (i.e., having multiple windows open side-by-side) is awful. Windows and Linux both have what I would call "sane" window snapping ([shown here](https://evanston.zendesk.com/hc/article_attachments/360081086334/Gif__12_.gif)), where you drag the window to the left or right edge of the desktop to snap left or right. You can even do this with [three](https://evanston.zendesk.com/hc/article_attachments/360081086394/Gif__13_.gif) or [four](https://evanston.zendesk.com/hc/article_attachments/360082201533/Gif__14_.gif) windows.

On the other hand, macOS has a weird snapping implementation where you need to click and hold the green "zoom" button, then choose to "tile" left or right. But, once you pick another window to fill the other half, both of those windows (together as one) move to their own virtual desktop. I want them split on my current desktop, not on a separate desktop.

Also, unlike Windows or Linux, you can't "maximize" a window using the green "zoom" button, it will only make the current window fullscreen (and again, on its own desktop). Confusingly, you need to again click and hold the green "zoom" button, then choose "Zoom". Apple calls the green button "zoom" [in their documentation](https://developer.apple.com/design/human-interface-guidelines/macos/windows-and-views/window-anatomy#title-bar), but its default function is fullscreen, not zoom.

For all the Apple fanboys screaming "There's an app for that!", I hear you, but remember, this is a _work_ machine and I need to get everything I install blessed by IT security. Easy for large applications like Slack or Chrome, but harder for the small tools that only fix my niche issues (I've already found [Rectangle](https://rectangleapp.com/), [BetterSnapTool](https://folivora.ai/bettersnaptool), and [Magnet](https://magnet.crowdcafe.com/)).

### Command+Tab

If you want to switch between windows, you can use Command (⌘)+Tab (the equivalent is Alt+Tab on Windows). If you open two of the same window (e.g., two Chrome windows), they appear as one in the dock. However, when you press Command (⌘)+Tab, this will only show one entry for Chrome, even though you have two windows of Chrome open. Selecting Chrome via Command (⌘)+Tab will then show both Chrome windows, but make you move your mouse (or press Command+`) to select the Chrome window you want to work in. Why the extra step? Just show me both windows in Command (⌘)+Tab.

I found [this flowchart](https://wanderingstan.com/wp-content/uploads/2009/07/alt-tab-flowcharts-labeled-2.png) showing the window switching workflow, which I thought was pretty hilarious. Again, I found [AltTab](https://github.com/lwouis/alt-tab-macos) to fix this, but can't install it due to policy.

# The Undecided

## External peripherals

I'm using my Macbook with a USB-C adapter so that I can use my PC keyboard/mouse/monitor. However, that keyboard doesn't have the Option (⌥) or Command (⌘) keys like on my Macbook. This makes using keyboard shortcuts difficult due to the keys being switched, but I don't blame Apple for this. I tried changing the modifier keys in System Preferences-->Keyboard, but that broke other keyboard shortcuts.

Two-finger scrolling on the trackpad is like scrolling on your phone (what Apple calls "natural"). However, plugging in a mouse with a scroll wheel means the scroll wheel is "backward". Thankfully, I was able to download [Logitech's Options](https://www.logitech.com/en-us/software/options.html) software to reverse this.

## Package management

Coming from a Linux background, I'm spoiled by Linux package managers. Not trying to start a package management flame war, but apt/yum/pacman are all better than anything Microsoft or Apple provide (which is nothing). [Homebrew](https://brew.sh/) is a lifesaver on macOS and is the only thing not making me pull my hair out.

# Conclusion

While the hardware is great, I'd give anything to replace macOS with Linux (or even Windows). Unfortunately, this is a work machine, and I don't have that option, so I need to make due with what I've been provided.

Are some of my criticisms due to my lack of knowledge about macOS? Almost definitely. Will I eventually become accustomed to macOS? Almost definitely.

The entire design of macOS feels like the Gnome desktop: you use what they give you, how they give it to you, using their workflows, barely customizing anything. Apple products are supposed to be revered the world over as the pinnacle of design, used by artists, engineers, professionals, and creators. Why do I feel like there are training wheels on a machine I use for productivity? Not that I had any plans on it, but after this experience, I would personally never purchase a macOS product.

\-Logan

---------

My website is an independent blog and has not been authorized, sponsored, or otherwise approved by Apple Inc. 

Apple, Mac, Macbook, Macbook Pro, and macOS are trademarks of Apple Inc., registered in the U.S. and other countries and regions.