---
title: "My SG-1100 died"
date: "2019-07-17"
author: "Logan Marchione"
categories: 
  - "cloud-internet"
  - "oc"
  - "router"
cover:
    image: "/assets/featured/featured_generic_thumb_down.svg"
    alt: "featured image"
    relative: false
---

{{< series/pfsense >}}

# Introduction

I recently [wrote about](/2019/06/migrating-away-from-the-ubiquiti-edgerouter-lite/) how I was dropping the Ubiquiti EdgeRouter Lite for a Netgate SG-1100 running pfSense. However, on July 9th (about two weeks after installing my SG-1100) I noticed my internet connection died, and I was unable to ping the router. I used a micro-USB cable to view the console and noticed it was not pulling an IP address from my FiOS ONT.

At first, I thought it was an issue with Verizon, so I opened a ticket and had them reset/reboot my ONT remotely, without resolution. However, I then noticed the device randomly rebooted while I was connected to the console. After it started back up, it rebooted again. Thinking it was not an issue with Verizon, I removed the SG-1100 and replaced it with my EdgeRouter Lite, which immediately pulled an IP and restored my connectivity.

# Netgate's response

I opened a ticket with Netgate and attached my boot log. While I waited, I did some Googling and found [this post](https://forum.netgate.com/topic/144636/sg-1100-intermittent-reboots), where Netgate acknowledged a power problem with the SG-1100. In less than 10 minutes, a support person from Netgate sent me a RMA. However, since this is a hardware issue, I declined a new SG-1100 and requested a refund, which they approved without issue.

To Netgate's credit, they did the right thing here. They publicly disclosed the issue on their forums and immediately offered a replacement device. Again, their support is amazing.

# Back to the ERL

For now, I'm using my EdgeRouter Lite, with the full intent to still move to pfSense (albeit, on new hardware). I declined a new SG-1100, because I'm not sure if the new device will be affected by the same issue. My other choice is install pfSense on an x86 box, as I had [originally planned](/2019/06/migrating-away-from-the-ubiquiti-edgerouter-lite/#hardware). This option, however, does not include Netgate support, which I'd have to do without or purchase separately.

# Boot log

I'm posting this log in the event someone else has this issue and stumbles upon this. Some interesting points from the log:

- Line 22 shows the _Enter an option_ prompt, then the device starts to reboot.
- Lines 76, 79, and 91 show an issue with voltage.
- Line 279 shows that / was not dismounted correctly (from being rebooted).
- Line 338 shows the SG-1100 not pulling an IP from my ONT (not sure if this was a side effect the power issue or not).

The full log from the console connection is below (with line numbers inserted).

```
00000001 FreeBSD/arm64 (pfsense.domain.local) (ttyu0)
00000002 
00000003 Netgate SG-1100 Netgate Device ID: XXXXXXXXXXXXXXXXXXXX
00000004 Serial: XXXXXXXXXXXXX Netgate Crypto ID: XXXXXXXXXXXXXXXXXX
00000005 
00000006 *** Welcome to pfSense 2.4.4-RELEASE-p3 (arm64) on pfsense ***
00000007 
00000008 WAN (wan) -> mvneta0.4090 ->
00000009 LAN (lan) -> mvneta0.4091 -> v4: 10.10.2.1/24
00000010 OPT (opt1) -> mvneta0.4092 ->
00000011 
00000012 0) Logout (SSH only) 9) pfTop
00000013 1) Assign Interfaces 10) Filter Logs
00000014 2) Set interface(s) IP address 11) Restart webConfigurator
00000015 3) Reset webConfigurator password 12) PHP shell + pfSense tools
00000016 4) Reset to factory defaults 13) Update from console
00000017 5) Reboot system 14) Disable Secure Shell (sshd)
00000018 6) Halt system 15) Restore recent configuration
00000019 7) Ping host 16) Restart PHP-FPM
00000020 8) Shell
00000021 
00000022 Enter an option: TIM-1.0
00000023 WTMI-armada-17.10.5-34ce216
00000024 WTMI: system early-init
00000025 SVC REV: 5, CPU VDD voltage: 1.202V
00000026 
00000027 Fill memory before self refresh...done
00000028 
00000029 Now in Self-refresh Mode
00000030 Exited self-refresh ...
00000031 
00000032 
00000033 Self refresh Pass.
00000034 DDR self test mode test done!!
00000035 Vref read training
00000036 ===================
00000037 Final vdac_value 0x0000001F
00000038 
00000039 Vref write training
00000040 ===================
00000041 Final vref_value 0x0000001F
00000042 
00000043 DLL TUNING
00000044 ==============
00000045 DLL 0xc0001050[21:16]: [4,32,1b]
00000046 DLL 0xc0001050[29:24]: [9,2f,1c]
00000047 DLL 0xc0001054[21:16]: [5,32,1b]
00000048 DLL 0xc0001054[29:24]: [a,30,1d]
00000049 DLL 0xc0001074[21:16]: [0,3f,1f]
00000050 DLL 0xc0001074NOTICE: Booting Trusted Firmware
00000051 NOTICE: BL1: v1.3(release):armada-17.10.8:34247e0
00000052 NOTICE: BL1: Built : 16:19:41, Nov 1 2NOTICE: BL2: v1.3(release):armada-17.10.8:34247e0
00000053 NOTICE: BL2: Built : 16:19:45, Nov 1 20NOTICE: BL31: v1.3(release):armada-17.10.8:34247e0
00000054 NOTICE: BL31:
00000055 
00000056 U-Boot 2017.03-armada-17.10.2-g6a6581a-dirty (Nov 01 2018 - 16:04:57 -0300)
00000057 
00000058 Model: Marvell Armada 3720 Community Board ESPRESSOBin
00000059 CPU @ 1200 [MHz]
00000060 L2 @ 800 [MHz]
00000061 TClock @ 200 [MHz]
00000062 DDR @ 750 [MHz]
00000063 DRAM: 1 GiB
00000064 U-Boot DT blob at : 000000003f716298
00000065 Comphy-0: USB3 5 Gbps
00000066 Comphy-1: PEX0 2.5 Gbps
00000067 Comphy-2: SATA0 6 Gbps
00000068 SATA link 0 timeout.
00000069 AHCI 0001.0300 32 slots 1 ports 6 Gbps 0x1 impl SATA mode
00000070 flags: ncq led only pmp fbss pio slum part sxs
00000071 PCIE-0: Link down
00000072 MMC: sdhci@d0000: 0, sdhci@d8000: 1
00000073 SF: Detected mx25u3235f with page size 256 Bytes, erase size 64 KiB, total 4 MiB
00000074 Net: eth0: neta@30000 [PRIME]
00000075 Hit any key to stop autoboot: 0
00000076 Card did not respond to voltage select!
00000077 mmc_init: -95, time 41
00000078 ** Bad device mmc 0 **
00000079 Card did not respond to voltage select!
00000080 mmc_init: -95, time 23
00000081 ** Bad device mmc 0 **
00000082 ## Starting EFI application at 05000000 ...
00000083 efi_load_pe: Invalid DOS Signature
00000084 ## Application terminated, r = -2
00000085 sdhci_transfer_data: Error detected in status(0x408000)!
00000086 reading efi/boot/bootaa64.efi
00000087 393216 bytes read in 31 ms (12.1 MiB/s)
00000088 reading armada-3720-sg1100.dtb
00000089 13772 bytes read in 12 ms (1.1 MiB/s)
00000090 ## Starting EFI application at 05000000 ...
00000091 Card did not respond to voltage select!
00000092 mmc_init: -95, time 23
00000093 Scanning disk sdhci@d8000.blk...
00000094 Found 4 disks
00000095 
00000096 
00000097 
00000098 
00000099 
00000100 
00000101 
00000102 
00000103 
00000104 
00000105 
00000106 
00000107 
00000108 
00000109 
00000110 
00000111 
00000112 
00000113 
00000114 
00000115 
00000116 
00000117 
00000118 
00000119 
00000120 
00000121 
00000122 
00000123 
00000124 
00000125 
00000126 
00000127 
00000128 
00000129 
00000130 
00000131 
00000132 
00000133 
00000134 
00000135 
00000136 
00000137 
00000138 
00000139 
00000140 
00000141 >> FreeBSD EFI boot block
00000142 Loader path: /boot/loader.efi
00000143 
00000144 Initializing modules: ZFS UFS
00000145 Probing 4 block devices......* done
00000146 ZFS found no pools
00000147 UFS found 1 partition
00000148 command args: -S115200
00000149 
00000150 Consoles: EFI console
00000151 Command line arguments: loader.efi -S115200
00000152 Image base: 0x3c595008
00000153 EFI version: 2.05
00000154 EFI Firmware: Das U-boot (rev 0.00)
00000155 
00000156 FreeBSD/arm64 EFI loader, Revision 1.1
00000157 (Thu Oct 4 10:04:04 EDT 2018 root@buildbot2.nyi.netgate.com)
00000158 BootCurrent: 0000
00000159 BootOrder: 03e8 0000[*] 0000[*] 0000[*] 03e8 0000[*] 0000[*] 0000[*] 5170 3f71 0000[*] 0000[*] 30d4 0000[*] 0000[*] 0000[*] 5190 3f71 0000[*] 0000[*] 1158 3ff8 0000[*] 0000[*] 51c0 3f71 0000[*] 0000[*] 853c 3ff7 0000[*] 0000[*] 0000[*] 0000[*] 0000[*] 0000[*] 0004 0000[*] 0000[*] 0000[*] 35b8 3ffa 0000[*] 0000[*] 0001 0000[*] 0000[*] 0000[*] 42d0 3ff7 0000[*] 0000[*] 0000[*] 0000[*] 0000[*] 0000[*] 5200 3f71 0000[*] 0000[*] 853c 3ff7 0000[*] 0000[*] 4260 3f7a 0000[*] 0000[*] 0004 0000[*] 0000[*] 0000[*] 35b8 3ffa 0000[*] 0000[*] 0001 0000[*] 0000[*] 0000[*] 42d0 3ff7 0000[*] 0000[*] f000 3c52 0000[*] 0000[*] 4260 3f7a 0000[*] 0000[*] 080c 3ff6 0000[*] 0000[*] 5310 3f71 0000[*] 0000[*]
00000160 Setting currdev to disk0p3:
00000161 Loading /boot/defaults/loader.conf
00000162 /boot/kernel/kernel text=0x9802a8 data=0x877c70+0x3c7a14 syms=[0x8+0x116bf8+0x8+0xf0f51]
00000163 |
00000164 Hit [Enter] to boot immediately, or any other key for command prompt.
00000165 Booting [/boot/kernel/kernel]...
00000166 Using DTB provided by EFI at 0x7ffb000.
00000167 Copyright (c) 1992-2018 The FreeBSD Project.
00000168 Copyright (c) 1979, 1980, 1983, 1986, 1988, 1989, 1991, 1992, 1993, 1994
00000169 The Regents of the University of California. All rights reserved.
00000170 FreeBSD is a registered trademark of The FreeBSD Foundation.
00000171 FreeBSD 11.2-RELEASE-p10 #21 10fea60fdde(factory-RELENG_2_4_4): Thu May 16 06:26:11 EDT 2019
00000172 root@buildbot1-nyi.netgate.com:/build/factory-crossbuild-244/obj/aarch64/upm8hD25/arm64.aarch64/build/factory-crossbuild-244/pfSense/tmp/FreeBSD-src/sys/pfSense arm64
00000173 FreeBSD clang version 6.0.0 (tags/RELEASE_600/final 326565) (based on LLVM 6.0.0)
00000174 VT: init without driver.
00000175 Starting CPU 1 (1)
00000176 FreeBSD/SMP: Multiprocessor System Detected: 2 CPUs
00000177 random: entropy device external interface
00000178 ipw_bss: You need to read the LICENSE file in /usr/share/doc/legal/intel_ipw.LICENSE.
00000179 ipw_bss: If you agree with the license, set legal.intel_ipw.license_ack=1 in /boot/loader.conf.
00000180 module_register_init: MOD_LOAD (ipw_bss_fw, 0xffff00000016bec0, 0) error 1
00000181 ipw_ibss: You need to read the LICENSE file in /usr/share/doc/legal/intel_ipw.LICENSE.
00000182 ipw_ibss: If you agree with the license, set legal.intel_ipw.license_ack=1 in /boot/loader.conf.
00000183 module_register_init: MOD_LOAD (ipw_ibss_fw, 0xffff00000016bf6c, 0) error 1
00000184 ipw_monitor: You need to read the LICENSE file in /usr/share/doc/legal/intel_ipw.LICENSE.
00000185 ipw_monitor: If you agree with the license, set legal.intel_ipw.license_ack=1 in /boot/loader.conf.
00000186 module_register_init: MOD_LOAD (ipw_monitor_fw, 0xffff00000016c018, 0) error 1
00000187 iwi_bss: You need to read the LICENSE file in /usr/share/doc/legal/intel_iwi.LICENSE.
00000188 iwi_bss: If you agree with the license, set legal.intel_iwi.license_ack=1 in /boot/loader.conf.
00000189 module_register_init: MOD_LOAD (iwi_bss_fw, 0xffff00000016c0c4, 0) error 1
00000190 iwi_ibss: You need to read the LICENSE file in /usr/share/doc/legal/intel_iwi.LICENSE.
00000191 iwi_ibss: If you agree with the license, set legal.intel_iwi.license_ack=1 in /boot/loader.conf.
00000192 module_register_init: MOD_LOAD (iwi_ibss_fw, 0xffff00000016c170, 0) error 1
00000193 iwi_monitor: You need to read the LICENSE file in /usr/share/doc/legal/intel_iwi.LICENSE.
00000194 iwi_monitor: If you agree with the license, set legal.intel_iwi.license_ack=1 in /boot/loader.conf.
00000195 module_register_init: MOD_LOAD (iwi_monitor_fw, 0xffff00000016c21c, 0) error 1
00000196 wlan: mac acl policy registered
00000197 kbd0 at kbdmux0
00000198 ofwbus0: <Open Firmware Device Tree>
00000199 simplebus0: <Flattened device tree simple bus> on ofwbus0
00000200 simplebus1: <Flattened device tree simple bus> on simplebus0
00000201 psci0: <ARM Power State Co-ordination Interface Driver> on ofwbus0
00000202 gic0: <ARM Generic Interrupt Controller v3.0> mem 0x1d00000-0x1d0ffff,0x1d40000-0x1d7ffff,0x1d80000-0x1d81fff,0x1d90000-0x1d91fff,0x1da0000-0x1dbffff irq 27 on simplebus1
00000203 generic_timer0: <ARMv8 Generic Timer> irq 0,1,2,3 on ofwbus0
00000204 Timecounter "ARM MPCore Timecounter" frequency 12500000 Hz quality 1000
00000205 Event timer "ARM MPCore Eventtimer" frequency 12500000 Hz quality 1000
00000206 cpulist0: <Open Firmware CPU Group> on ofwbus0
00000207 cpu0: <Open Firmware CPU> on cpulist0
00000208 cpu1: <Open Firmware CPU> on cpulist0
00000209 pmu0: <Performance Monitoring Unit> irq 4 on ofwbus0
00000210 spi0: <Armada 37x0 SPI controller> mem 0x10600-0x10fff irq 6 on simplebus1
00000211 iichb0: <Marvell Armada 37x0 IIC controller> mem 0x11000-0x11023 irq 7 on simplebus1
00000212 iicbus0: <OFW I2C bus> on iichb0
00000213 iic0: <I2C generic I/O> on iicbus0
00000214 uart0: <Marvell Armada 3700 UART> mem 0x12000-0x121ff irq 9,10,11 on simplebus1
00000215 uart0: console (115200,n,8,1)
00000216 pinctl0: <Armada 37x0 North Bridge pinctl Controller> mem 0x13800-0x138ff,0x13c00-0x13c1f on simplebus1
00000217 gpio0: <Armada 37x0 GPIO Controller> on pinctl0
00000218 gpiobus0: <OFW GPIO bus> on gpio0
00000219 gpioc0: <GPIO controller> on gpio0
00000220 pinctl1: <Armada 37x0 South Bridge pinctl Controller> mem 0x18800-0x188ff,0x18c00-0x18c1f on simplebus1
00000221 gpio1: <Armada 37x0 GPIO Controller> on pinctl1
00000222 gpiobus1: <OFW GPIO bus> on gpio1
00000223 gpioc1: <GPIO controller> on gpio1
00000224 mvneta0: <NETA controller> mem 0x30000-0x33fff irq 14 on simplebus1
00000225 mvneta0: version is 10
00000226 mvneta0: Ethernet address: f0:ad:4e:0a:9e:98
00000227 mdio0: <MDIO> on mvneta0
00000228 e6000sw: readreg timeout
00000229 e6000sw0: Unrecognized device, id 0xfff0.
00000230 e6000sw: readreg timeout
00000231 e6000sw0: Unrecognized device, id 0xfff0.
00000232 xhci0: <Marvell Integrated USB 3.0 controller> mem 0x58000-0x5bfff irq 16 on simplebus1
00000233 xhci0: 32 bytes context size, 32-bit DMA
00000234 usbus0 on xhci0
00000235 ehci0: <Marvell Integrated USB 2.0 controller> mem 0x5e000-0x5ffff irq 17 on simplebus1
00000236 usbus1: EHCI version 1.0
00000237 usbus1 on ehci0
00000238 sdhci_xenon0: <Armada Xenon SDHCI controller> mem 0xd0000-0xd02ff,0x1e808-0x1e80b irq 24 on simplebus1
00000239 mmc0: <MMC/SD bus> on sdhci_xenon0
00000240 sdhci_xenon1: <Armada Xenon SDHCI controller> mem 0xd8000-0xd82ff,0x17808-0x1780b irq 25 on simplebus1
00000241 mmc1: <MMC/SD bus> on sdhci_xenon1
00000242 ahci0: <AHCI SATA controller> mem 0xe0000-0xe1fff irq 26 on simplebus1
00000243 ahci0: AHCI v1.30 with 1 6Gbps ports, Port Multiplier supported with FBS
00000244 ahcich0: <AHCI channel> at channel 0 on ahci0
00000245 gpioled0: <GPIO LEDs> on ofwbus0
00000246 cryptosoft0: <software crypto>
00000247 Timecounters tick every 1.000 msec
00000248 mvneta0: link state changed to UP
00000249 spibus0: <OFW SPI bus> on spi0
00000250 mx25l0: <M25Pxx Flash Family> at cs 0 mode 0 on spibus0
00000251 mx25l0: device type mx25u3235f, size 4096K in 64 sectors of 64K, erase size 4K
00000252 usbus0: 5.0Gbps Super Speed USB v3.0
00000253 usbus1: 480Mbps High Speed USB v2.0
00000254 ugen0.1: <Marvell XHCI root HUB> at usbus0
00000255 uhub0: <Marvell XHCI root HUB, class 9/0, rev 3.00/1.00, addr 1> on usbus0
00000256 ugen1.1: <Marvell EHCI root HUB> at usbus1
00000257 uhub1: <Marvell EHCI root HUB, class 9/0, rev 2.00/1.00, addr 1> on usbus1
00000258 mmc0: No compatible cards found on bus
00000259 mmcsd0: 8GB <MMCHC M8G1GC 0.3 SN F49C4805 MFG 07/2013 by 21 0x0000> at mmc1 50.0MHz/4bit/65535-block
00000260 mmcsd0boot0: 4MB partion 1 at mmcsd0
00000261 mmcsd0boot1: 4MB partion 2 at mmcsd0
00000262 mmcsd0rpmb: 524kB partion 3 at mmcsd0
00000263 uhub0: 2 ports with 2 removable, self powered
00000264 uhub1: 1 port with 1 removable, self powered
00000265 Release APs
00000266 CPU 0: ARM Cortex-A53 r0p4 affinity: 0
00000267 Instruction Set Attributes 0 = <AES+PMULL,SHA1,SHA2,CRC32>
00000268 Instruction Set Attributes 1 = <0>
00000269 Processor Features 0 = <GIC,AdvSIMD,Float,EL3 32,EL2 32,EL1 32,EL0 32>
00000270 Processor Features 1 = <0>
00000271 Memory Model Features 0 = <4k Granule,64k Granule,MixedEndian,S/NS Mem,16bit ASID,1TB PA>
00000272 Memory Model Features 1 = <>
00000273 Debug Features 0 = <2 CTX Breakpoints,4 Watchpoints,6 Breakpoints,PMUv3,Debug v8>
00000274 Debug Features 1 = <0>
00000275 Auxiliary Features 0 = <0>
00000276 Auxiliary Features 1 = <0>
00000277 CPU 1: ARM Cortex-A53 r0p4 affinity: 1
00000278 Trying to mount root from ufs:/dev/ufsid/5c11689b7c8fb123 [rw,noatime]...
00000279 WARNING: / was not properly dismounted
00000280 Warning: no time-of-day clock registered, system time will not be set accurately
00000281 Configuring crash dumps...
00000282 dumpon: /dev/label/swap*: No such file or directory
00000283 Unable to specify /dev/label/swap* as a dump device.
00000284 No suitable dump device was found.
00000285 ** SU+J Recovering /dev/ufsid/5c11689b7c8fb123
00000286 ** Reading 11730944 byte journal from inode 4.
00000287 ** Building recovery table.
00000288 ** Resolving unreferenced inode list.
00000289 ** Processing journal entries.
00000290 ** 288 journal records in 38912 bytes for 23.68% utilization
00000291 ** Freed 1 inodes (0 dirs) 4 blocks, and 0 frags.
00000292 
00000293 ***** FILE SYSTEM MARKED CLEAN *****
00000294 Filesystems are clean, continuing...
00000295 Mounting filesystems...
00000296 random: unblocking device.
00000297 
00000298         __
00000299  _ __  / _|___  ___ _ __  ___  ___
00000300 | '_ \| |_/ __|/ _ \ '_ \/ __|/ _ \
00000301 | |_) | _ \__ \  __/ | | \__ \ __/
00000302 | .__/|_| |___/\___|_| |_|___/\___|
00000303 |_|
00000304 
00000305 
00000306 Welcome to pfSense 2.4.4-RELEASE (Patch 3)...
00000307 
00000308 ...ELF ldconfig path: /lib /usr/lib /usr/lib/compat /usr/local/lib /usr/local/lib/ipsec /usr/local/lib/perl5/5.26/mach/CORE
00000309 done.
00000310 >>> Removing vital flag from lang/php72... done.
00000311 External config loader 1.0 is now starting... mmcsd0s1 mmcsd0s2 mmcsd0s3
00000312 Launching the init system......... done.
00000313 Initializing.................. done.
00000314 Starting device manager (devd)...done.
00000315 Loading configuration......done.
00000316 Updating configuration...done.
00000317 Checking config backups consistency.................................done.
00000318 Setting up extended sysctls...done.
00000319 Setting timezone...done.
00000320 Configuring loopback interface...done.
00000321 Starting syslog...done.
00000322 Starting Secure Shell Services...done.
00000323 Configuring switch...done.
00000324 Setting up interfaces microcode...done.
00000325 Configuring loopback interface...done.
00000326 Creating wireless clone interfaces...done.
00000327 Configuring LAGG interfaces...done.
00000328 Configuring VLAN interfaces...done.
00000329 Configuring QinQ interfaces...done.
00000330 Configuring IPsec VTI interfaces...done.
00000331 Configuring WAN interface...done.
00000332 Configuring LAN interface...done.
00000333 Configuring CARP settings...done.
00000334 Syncing OpenVPN settings...done.
00000335 Configuring firewall......done.
00000336 Starting PFLOG...done.
00000337 Setting up gateway monitors...done.
00000338 Setting up static routes...route: writing to routing socket: Network is unreachable
00000339 route: route has not been found
00000340 done.
00000341 Setting up DNSs...
00000342 Starting DNS Resolver...done.
00000343 Synchronizing user settings...done.
00000344 Starting webConfigurator...done.
00000345 Configuring CRON...done.
00000346 Starting NTP time client...done.
00000347 Starting DHCP service...done.
00000348 Configuring firewall......done.
00000349 Generating RRD graphs...done.
00000350 Starting syslog...done.
00000351 Starting CRON... done.
00000352 Starting package acme...done.
00000353 pfSense 2.4.4-RELEASE (Patch 3) arm64 Thu May 16 06:01:19 EDT 2019
00000354 Bootup complete
00000355 
00000356 FreeBSD/arm64 (pfsense.domain.local) (ttyu0)
00000357 
00000358 Netgate SG-1100 Netgate Device ID: XXXXXXXXXXXXXXXXXXXX
00000359 Serial: XXXXXXXXXXXXX Netgate Crypto ID: XXXXXXXXXXXXXXXXXX
00000360 
00000361 *** Welcome to pfSense 2.4.4-RELEASE-p3 (arm64) on pfsense ***
00000362 
00000363 WAN (wan) -> mvneta0.4090 ->
00000364 LAN (lan) -> mvneta0.4091 -> v4: 10.10.2.1/24
00000365 OPT (opt1) -> mvneta0.4092 ->
00000366 
00000367 0) Logout (SSH only) 9) pfTop
00000368 1) Assign Interfaces 10) Filter Logs
00000369 2) Set interface(s) IP address 11) Restart webConfigurator
00000370 3) Reset webConfigurator password 12) PHP shell + pfSense tools
00000371 4) Reset to factory defaults 13) Update from console
00000372 5) Reboot system 14) Disable Secure Shell (sshd)
00000373 6) Halt system 15) Restore recent configuration
00000374 7) Ping host 16) Restart PHP-FPM
00000375 8) Shell
00000376 
00000377 Enter an option:
```

\-Logan

# Comments

[Old comments from WordPress](/2019/07/my-sg-1100-died/comments.txt)