1) 
ubuntu@ip-172-31-16-103:~$ sudo parted $DISK print
Model: Amazon Elastic Block Store (nvme)
Disk /dev/nvme1n1: 2147MB
Sector size (logical/physical): 512B/512B
Partition Table: gpt
Disk Flags: 

Number  Start   End     Size    File system  Name  Flags
 1      1049kB  1074MB  1073MB  xfs          data
 2      1074MB  2146MB  1073MB               lvm   lvm

Command (m for help): p
Disk /dev/nvme1n1: 2 GiB, 2147483648 bytes, 4194304 sectors
Disk model: Amazon Elastic Block Store              
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: gpt
Disk identifier: AD014120-4240-49CA-8057-D6BAEE58614C

Device         Start     End Sectors  Size Type
/dev/nvme1n1p1  2048 2097151 2095104 1023M Linux filesystem
/dev/nvme1n1p2 2097152 4192255 2095104 1023M Linux LVM

ubuntu@ip-172-31-16-103:~$ sudo blkid ${DISK}${P}1

/dev/nvme1n1p1: UUID="5dd80712-ad4b-4b25-afc1-a17dee880618" BLOCK_SIZE="512" TYPE="xfs" PARTLABEL="data" PARTUUID="83fddffd-4a92-458a-b1d2-8d08b55b0871"

2) 
ubuntu@ip-172-31-16-103:~$ sudo pvs && sudo vgs && sudo lvs && lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINTS && findmnt /srv/data
  PV             VG    Fmt  Attr PSize    PFree  
  /dev/nvme1n1p2 labvg lvm2 a--  1020.00m 620.00m
  VG    #PV #LV #SN Attr   VSize    VFree  
  labvg   1   1   0 wz--n- 1020.00m 620.00m
  LV      VG    Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  appdata labvg -wi-ao---- 400.00m                                                    
NAME               SIZE TYPE FSTYPE      MOUNTPOINTS
loop0             28.4M loop squashfs    /snap/amazon-ssm-agent/13349
loop1               74M loop squashfs    /snap/core22/2955
loop2             44.7M loop squashfs    /snap/snapd/28254
loop3             32.5M loop squashfs    /snap/snapd/28332
nvme0n1              8G disk             
├─nvme0n1p1          7G part ext4        /srv/flaskapp/data
│                                        /
├─nvme0n1p14         4M part             
├─nvme0n1p15       106M part vfat        /boot/efi
└─nvme0n1p16       913M part ext4        /boot
nvme1n1              2G disk             
├─nvme1n1p1       1023M part xfs         
└─nvme1n1p2       1023M part LVM2_member 
  └─labvg-appdata  400M lvm  ext4        /srv/data
TARGET    SOURCE                    FSTYPE OPTIONS
/srv/data /dev/mapper/labvg-appdata ext4   rw,relatime

3) 
ubuntu@ip-172-31-16-103:~$ df -h /srv/data
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/labvg-appdata  359M  1.6M  329M   1% /srv/data

ubuntu@ip-172-31-16-103:~$ sudo vgs
  VG    #PV #LV #SN Attr   VSize    VFree   
  labvg   1   1   0 wz--n- 1020.00m 620.00m
ubuntu@ip-172-31-16-103:~$ df -h /srv/data
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/labvg-appdata  359M  1.6M  329M   1% /srv/data

ubuntu@ip-172-31-16-103:~$ df -h /srv/data
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/labvg-appdata  359M  1.6M  329M   1% /srv/data

ubuntu@ip-172-31-16-103:~$ sudo resize2fs /dev/labvg/appdata
resize2fs 1.47.0 (5-Feb-2023)
Filesystem at /dev/labvg/appdata is mounted on /srv/data; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 1
The filesystem on /dev/labvg/appdata is now 204800 (4k) blocks long.

ubuntu@ip-172-31-16-103:~$ df -h /srv/data
Filesystem                 Size  Used Avail Use% Mounted on
/dev/mapper/labvg-appdata  740M  1.6M  702M   1% /srv/data

ubuntu@ip-172-31-16-103:~$ sudo vgs  
  VG    #PV #LV #SN Attr   VSize  VFree
  labvg   1   1   0 wz--n- <2.00g 1.21g

4) 
touch: cannot touch '/mnt/small/f2000': No space left on device
ubuntu@ip-172-31-16-103:~$ df -h /mnt/small && df -ih /mnt/small
Filesystem      Size  Used Avail Use% Mounted on
/dev/nvme1n1p1 1005M   24K  938M   1% /mnt/small
Filesystem     Inodes IUsed IFree IUse% Mounted on
/dev/nvme1n1p1    128   128     0  100% /mnt/small

5) 
ubuntu@ip-172-31-16-103:~$ [ -d /sys/firmware/efi ] && echo "UEFI" || echo "BIOS/legacy"
UEFI
ubuntu@ip-172-31-16-103:~$ sudo efibootmgr -v 2>/dev/null  
BootCurrent: 0002
Timeout: 0 seconds
BootOrder: 0002,0000,0001,0003
Boot0000* UiApp FvVol(7cb8bdc9-f8eb-4f34-aaea-3ee4af6516a1)/FvFile(462caa21-7614-4503-836e-8ab6f4662331)
      dp: 04 07 14 00 c9 bd b8 7c eb f8 34 4f aa ea 3e e4 af 65 16 a1 / 04 06 14 00 21 aa 2c 46 14 76 03 45 83 6e 8a b6 f4 66 23 31 / 7f ff 04 00
Boot0001* UEFI Amazon Elastic Block Store vol0d7750a59f5a303cc 1        PciRoot(0x0)/Pci(0x4,0x0)/NVMe(0x1,00-00-00-00-00-00-00-00){auto_created_boot_option}
      dp: 02 01 0c 00 d0 41 03 0a 00 00 00 00 / 01 01 06 00 00 04 / 03 17 10 00 01 00 00 00 00 00 00 00 00 00 00 00 / 7f ff 04 00
    data: 4e ac 08 81 11 9f 59 4d 85 0e e2 1a 52 2c 59 b2
Boot0002* Ubuntu        HD(15,GPT,aa200780-34c9-4188-b41d-b00a57f53d46,0x2800,0x35000)/File(\EFI\ubuntu\shimx64.efi)
      dp: 04 01 2a 00 0f 00 00 00 00 28 00 00 00 00 00 00 00 50 03 00 00 00 00 00 80 07 20 aa c9 34 88 41 b4 1d b0 0a 57 f5 3d 46 02 02 / 04 04 34 00 5c 00 45 00 46 00 49 00 5c 00 75 00 62 00 75 00 6e 00 74 00 75 00 5c 00 73 00 68 00 69 00 6d 00 78 00 36 00 34 00 2e 00 65 00 66 00 69 00 00 00 / 7f ff 04 00
Boot0003* UEFI Amazon Elastic Block Store vol06c665594711ebf81 1        PciRoot(0x0)/Pci(0x1f,0x0)/NVMe(0x1,00-00-00-00-00-00-00-00){auto_created_boot_option}
      dp: 02 01 0c 00 d0 41 03 0a 00 00 00 00 / 01 01 06 00 00 1f / 03 17 10 00 01 00 00 00 00 00 00 00 00 00 00 00 / 7f ff 04 00
    data: 4e ac 08 81 11 9f 59 4d 85 0e e2 1a 52 2c 59 b2
ubuntu@ip-172-31-16-103:~$ lsblk -o NAME,SIZE,FSTYPE,PARTTYPENAME,MOUNTPOINTS
NAME               SIZE FSTYPE      PARTTYPENAME        MOUNTPOINTS
loop0             28.4M squashfs                        /snap/amazon-ssm-agent/13349
loop1               74M squashfs                        /snap/core22/2955
loop2             44.7M squashfs                        /snap/snapd/28254
loop3             32.5M squashfs                        /snap/snapd/28332
nvme0n1              8G                                 
├─nvme0n1p1          7G ext4        Linux filesystem    /srv/flaskapp/data
│                                                       /
├─nvme0n1p14         4M             BIOS boot           
├─nvme0n1p15       106M vfat        EFI System          /boot/efi
└─nvme0n1p16       913M ext4        Linux extended boot /boot
nvme1n1              3G                                 
├─nvme1n1p1       1023M ext4        Linux filesystem    /mnt/small
└─nvme1n1p2          2G LVM2_member Linux LVM           
  └─labvg-appdata  800M ext4                            /srv/data
ubuntu@ip-172-31-16-103:~$ sudo grep -E "^menuentry" /boot/grub/grub.cfg | head
menuentry 'Ubuntu' --class ubuntu --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple-afecc200-1c2c-4b95-9d5d-427fd2ae7e07' {
ubuntu@ip-172-31-16-103:~$ cat /etc/default/grub
# If you change this file, run 'update-grub' afterwards to update
# /boot/grub/grub.cfg.
# For full documentation of the options in this file, see:
#   info -f grub -n 'Simple configuration'

GRUB_DEFAULT=0
GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=0
GRUB_DISTRIBUTOR=`( . /etc/os-release; echo ${NAME:-Ubuntu} ) 2>/dev/null || echo Ubuntu`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX=""

# If your computer has multiple operating systems installed, then you
# probably want to run os-prober. However, if your computer is a host
# for guest OSes installed via LVM or raw disk devices, running
# os-prober can cause damage to those guest OSes as it mounts
# filesystems to look for things.
#GRUB_DISABLE_OS_PROBER=false

# Uncomment to enable BadRAM filtering, modify to suit your needs
# This works with Linux (no patch required) and with any kernel that obtains
# the memory map information from GRUB (GNU Mach, kernel of FreeBSD ...)
#GRUB_BADRAM="0x01234567,0xfefefefe,0x89abcdef,0xefefefef"

# Uncomment to disable graphical terminal
#GRUB_TERMINAL=console

# The resolution used on graphical terminal
# note that you can use only modes which your graphic card supports via VBE
# you can see them in real GRUB with the command `vbeinfo'
#GRUB_GFXMODE=640x480

# Uncomment if you don't want GRUB to pass "root=UUID=xxx" parameter to Linux
#GRUB_DISABLE_LINUX_UUID=true

# Uncomment to disable generation of recovery mode menu entries
#GRUB_DISABLE_RECOVERY="true"

# Uncomment to get a beep at grub start
#GRUB_INIT_TUNE="480 440 1"
ubuntu@ip-172-31-16-103:~$ cat /proc/cmdline                             
BOOT_IMAGE=/vmlinuz-7.0.0-1017-aws root=PARTUUID=0842eb86-93ae-41a3-b758-d47b97627586 ro console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295 panic=-1
ubuntu@ip-172-31-16-103:~$ uname -r ; ls -l /boot/vmlinuz-* /boot/initrd.img-*
7.0.0-1017-aws
-rw-r--r-- 1 root root 65160019 Oct 17 10:09 /boot/initrd.img-7.0.0-1014-aws
-rw-r--r-- 1 root root 65187713 Nov 13 09:12 /boot/initrd.img-7.0.0-1017-aws
-rw------- 1 root root 16984456 Sep 18 17:40 /boot/vmlinuz-7.0.0-1014-aws
-rw------- 1 root root 17000840 Oct 29 15:16 /boot/vmlinuz-7.0.0-1017-aws
ubuntu@ip-172-31-16-103:~$ lsinitramfs /boot/initrd.img-$(uname -r) | head -30
.
kernel
kernel/x86
kernel/x86/microcode
kernel/x86/microcode/AuthenticAMD.bin
kernel
kernel/x86
kernel/x86/microcode
kernel/x86/microcode/.enuineIntel.align.0123456789abc
kernel/x86/microcode/GenuineIntel.bin
.
usr
usr/lib
usr/lib/modules
usr/lib/modules/7.0.0-1017-aws
usr/lib/modules/7.0.0-1017-aws/kernel
usr/lib/modules/7.0.0-1017-aws/kernel/arch
usr/lib/modules/7.0.0-1017-aws/kernel/arch/x86
usr/lib/modules/7.0.0-1017-aws/kernel/arch/x86/crypto
usr/lib/modules/7.0.0-1017-aws/kernel/arch/x86/crypto/aegis128-aesni.ko.zst
usr/lib/modules/7.0.0-1017-aws/kernel/arch/x86/crypto/aesni-intel.ko.zst
usr/lib/modules/7.0.0-1017-aws/kernel/arch/x86/crypto/aria-aesni-avx-x86_64.ko.zst
usr/lib/modules/7.0.0-1017-aws/kernel/arch/x86/crypto/aria-aesni-avx2-x86_64.ko.zst
usr/lib/modules/7.0.0-1017-aws/kernel/arch/x86/crypto/aria-gfni-avx512-x86_64.ko.zst
usr/lib/modules/7.0.0-1017-aws/kernel/arch/x86/crypto/blowfish-x86_64.ko.zst
usr/lib/modules/7.0.0-1017-aws/kernel/arch/x86/crypto/camellia-aesni-avx-x86_64.ko.zst
usr/lib/modules/7.0.0-1017-aws/kernel/arch/x86/crypto/camellia-aesni-avx2.ko.zst
usr/lib/modules/7.0.0-1017-aws/kernel/arch/x86/crypto/camellia-x86_64.ko.zst
usr/lib/modules/7.0.0-1017-aws/kernel/arch/x86/crypto/cast5-avx-x86_64.ko.zst
usr/lib/modules/7.0.0-1017-aws/kernel/arch/x86/crypto/cast6-avx-x86_64.ko.zst
ubuntu@ip-172-31-16-103:~$ systemd-analyze
Startup finished in 989ms (kernel) + 11.195s (userspace) = 12.185s 
graphical.target reached after 10.254s in userspace.
ubuntu@ip-172-31-16-103:~$ systemd-analyze critical-chain
The time when unit became active or started is printed after the "@" character.
The time the unit took to start is printed after the "+" character.

graphical.target @10.254s
└─multi-user.target @10.252s
  └─mysql.service @6.468s +3.781s
    └─basic.target @6.337s
      └─sockets.target @6.336s
        └─snapd.socket @6.319s +15ms
          └─sysinit.target @6.294s
            └─cloud-init.service @5.716s +572ms
              └─cloud-init-local.service @2.147s +3.494s
                └─systemd-remount-fs.service @945ms +147ms
                  └─systemd-fsck-root.service @830ms +83ms
                    └─systemd-journald.socket @678ms
                      └─-.mount @593ms
                        └─-.slice @593ms
ubuntu@ip-172-31-16-103:~$ systemd-analyze blame | head -10
3.781s mysql.service
3.494s cloud-init-local.service
2.982s fwupd-refresh.service
2.633s cloud-config.service
2.171s snapd.seeded.service
2.049s snapd.apparmor.service
1.902s snapd.service
1.645s ec2-instance-connect-harvest-hostkeys.service
1.306s rsyslog.service
1.255s udisks2.service
ubuntu@ip-172-31-16-103:~$ systemctl get-default
graphical.target
ubuntu@ip-172-31-16-103:~$ journalctl -b | head -40

Nov 14 16:32:58 ip-172-31-16-103 kernel: Linux version 7.0.0-1017-aws (buildd@lcy02-amd64-087) (x86_64-linux-gnu-gcc-13 (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0, GNU ld (GNU Binutils for Ubuntu) 2.42) #18~24.04.1-Ubuntu SMP PREEMPT Thu Oct 29 17:57:24 UTC 2026 (Ubuntu 7.0.0-1017.18~24.04.1-aws 7.0.14)
Nov 14 16:32:58 ip-172-31-16-103 kernel: Command line: BOOT_IMAGE=/vmlinuz-7.0.0-1017-aws root=PARTUUID=0842eb86-93ae-41a3-b758-d47b97627586 ro console=tty1 console=ttyS0 nvme_core.io_timeout=4294967295 panic=-1
Nov 14 16:32:58 ip-172-31-16-103 kernel: KERNEL supported cpus:
Nov 14 16:32:58 ip-172-31-16-103 kernel:   Intel GenuineIntel
Nov 14 16:32:58 ip-172-31-16-103 kernel:   AMD AuthenticAMD
Nov 14 16:32:58 ip-172-31-16-103 kernel:   Hygon HygonGenuine
Nov 14 16:32:58 ip-172-31-16-103 kernel:   Centaur CentaurHauls
Nov 14 16:32:58 ip-172-31-16-103 kernel:   zhaoxin   Shanghai  
Nov 14 16:32:58 ip-172-31-16-103 kernel: BIOS-provided physical RAM map:
Nov 14 16:32:58 ip-172-31-16-103 kernel: BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff]  System RAM
Nov 14 16:32:58 ip-172-31-16-103 kernel: BIOS-e820: [gap 0x00000000000a0000-0x00000000000fffff]
Nov 14 16:32:58 ip-172-31-16-103 kernel: BIOS-e820: [mem 0x0000000000100000-0x00000000390cdfff]  System RAM
Nov 14 16:32:58 ip-172-31-16-103 kernel: BIOS-e820: [mem 0x00000000390ce000-0x000000003934dfff]  device reserved
Nov 14 16:32:58 ip-172-31-16-103 kernel: BIOS-e820: [mem 0x000000003934e000-0x000000003935dfff]  ACPI data
Nov 14 16:32:58 ip-172-31-16-103 kernel: BIOS-e820: [mem 0x000000003935e000-0x00000000393ddfff]  ACPI NVS
Nov 14 16:32:58 ip-172-31-16-103 kernel: BIOS-e820: [mem 0x00000000393de000-0x000000003d37bfff]  System RAM
Nov 14 16:32:58 ip-172-31-16-103 kernel: BIOS-e820: [mem 0x000000003d37c000-0x000000003d3fffff]  device reserved
Nov 14 16:32:58 ip-172-31-16-103 kernel: NX (Execute Disable) protection: active
Nov 14 16:32:58 ip-172-31-16-103 kernel: APIC: Static calls initialized
Nov 14 16:32:58 ip-172-31-16-103 kernel: efi: EFI v2.7 by EDK II
Nov 14 16:32:58 ip-172-31-16-103 kernel: efi: SMBIOS=0x3926a000 ACPI=0x3935d000 ACPI 2.0=0x3935d014 MEMATTR=0x3776e018 MOKvar=0x39259000 INITRD=0x36d75a18 
Nov 14 16:32:58 ip-172-31-16-103 kernel: SMBIOS 2.7 present.
Nov 14 16:32:58 ip-172-31-16-103 kernel: DMI: Amazon EC2 t3.micro/, BIOS 1.0 10/16/2017
Nov 14 16:32:58 ip-172-31-16-103 kernel: DMI: Memory slots populated: 1/1
Nov 14 16:32:58 ip-172-31-16-103 kernel: secureboot: Secure boot disabled
Nov 14 16:32:58 ip-172-31-16-103 kernel: Hypervisor detected: KVM
Nov 14 16:32:58 ip-172-31-16-103 kernel: last_pfn = 0x3d37c max_arch_pfn = 0x400000000
Nov 14 16:32:58 ip-172-31-16-103 kernel: kvm-clock: Using msrs 4b564d01 and 4b564d00
Nov 14 16:32:58 ip-172-31-16-103 kernel: kvm-clock: using sched offset of 1669863480 cycles
Nov 14 16:32:58 ip-172-31-16-103 kernel: clocksource: kvm-clock: mask: 0xffffffffffffffff max_cycles: 0x1cd42e4dffb, max_idle_ns: 881590591483 ns
Nov 14 16:32:58 ip-172-31-16-103 kernel: tsc: Detected 2499.998 MHz processor
Nov 14 16:32:58 ip-172-31-16-103 kernel: e820: update [mem 0x00000000-0x00000fff] System RAM ==> device reserved
Nov 14 16:32:58 ip-172-31-16-103 kernel: e820: remove [mem 0x000a0000-0x000fffff] System RAM
Nov 14 16:32:58 ip-172-31-16-103 kernel: last_pfn = 0x3d37c max_arch_pfn = 0x400000000
Nov 14 16:32:58 ip-172-31-16-103 kernel: MTRR map: 4 entries (2 fixed + 2 variable; max 18), built from 8 variable MTRRs
Nov 14 16:32:58 ip-172-31-16-103 kernel: x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC- WT  
Nov 14 16:32:58 ip-172-31-16-103 kernel: Using GB pages for direct mapping
Nov 14 16:32:58 ip-172-31-16-103 kernel: secureboot: Secure boot disabled
Nov 14 16:32:58 ip-172-31-16-103 kernel: RAMDISK: [mem 0x31916000-0x3277dfff]
Nov 14 16:32:58 ip-172-31-16-103 kernel: ACPI: Early table checksum verification disabled

'Після запуску машинки, вона завантажується на рівні материнки тобто UEFI і шукає та знаходить завантажувальний розділ на диску, далі спрацьовує меню завантаження GRUB яке запускає ядро лінукс, і після цього уже стартує системний менеджер systemd який вмикає усі процеси та приводить файлики системні в порядок запускає фонові процеси та відкриває вікно входу для юзера'