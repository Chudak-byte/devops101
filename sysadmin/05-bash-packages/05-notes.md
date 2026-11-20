1) 
The following packages have unmet dependencies:
 apache2 : Depends: apache2-bin (= 2.4.58-1ubuntu8) but 2.4.58-1ubuntu8.8 is to be installed
           Depends: apache2-data (= 2.4.58-1ubuntu8) but 2.4.58-1ubuntu8.8 is to be installed
           Depends: apache2-utils (= 2.4.58-1ubuntu8) but 2.4.58-1ubuntu8.8 is to be installed
           Recommends: ssl-cert but it is not going to be installed
E: Unable to correct problems, you have held broken packages.
vagrant@vagrant:~$ apt-cache show apache2=$V | grep '^Depends'

Depends: apache2-bin (= 2.4.58-1ubuntu8), apache2-data (= 2.4.58-1ubuntu8), apache2-utils (= 2.4.58-1ubuntu8), media-types, perl:any, procps
vagrant@vagrant:~$ dpkg -l apache2
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name           Version         Architecture Description
+++-==============-===============-============-=================================
ii  apache2        2.4.58-1ubuntu8 amd64        Apache HTTP Server

2) 
The following packages have been kept back:
  apache2 apache2-bin apache2-data apache2-utils
vagrant@vagrant:~$ sudo apt install --only-upgrade apache2  # held deps: "Unable to correct problems, you have held broken packages"

Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Some packages could not be installed. This may mean that you have
requested an impossible situation or if you are using the unstable
distribution that some required packages have not yet been created
or been moved out of Incoming.
The following information may help to resolve the situation:

The following packages have unmet dependencies:
 apache2 : Depends: apache2-bin (= 2.4.58-1ubuntu8.19) but 2.4.58-1ubuntu8 is to be installed
           Depends: apache2-data (= 2.4.58-1ubuntu8.19) but 2.4.58-1ubuntu8 is to be installed
           Depends: apache2-utils (= 2.4.58-1ubuntu8.19) but 2.4.58-1ubuntu8 is to be installed
E: Unable to correct problems, you have held broken packages.

vagrant@vagrant:~$ apache2 -v                             # the noble-updates version again
Server version: Apache/2.4.58 (Ubuntu)
Server built:   2026-11-12T12:58:56

vagrant@vagrant:~$ cat /etc/apt/sources.list.d/hashicorp.list 
deb [arch=amd64 signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com noble main

vagrant@vagrant:~$ cat /etc/apt/sources.list.d/hashicorp.sources 
Types: deb
URIs: https://apt.releases.hashicorp.com
Suites: noble
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/hashicorp-archive-keyring.gpg

vagrant@vagrant:~$ sudo apt update
Hit:1 https://apt.releases.hashicorp.com noble InRelease
Hit:2 http://us.archive.ubuntu.com/ubuntu noble InRelease
Hit:3 http://security.ubuntu.com/ubuntu noble-security InRelease
Hit:4 http://us.archive.ubuntu.com/ubuntu noble-updates InRelease
Hit:5 http://us.archive.ubuntu.com/ubuntu noble-backports InRelease
Err:1 https://apt.releases.hashicorp.com noble InRelease
  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY FC9CA96ACA026560
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
242 packages can be upgraded. Run 'apt list --upgradable' to see them.
W: An error occurred during the signature verification. The repository is not updated and the previous index files will be used. GPG error: https://apt.releases.hashicorp.com noble InRelease: The following signatures couldn't be verified because the public key is not available: NO_PUBKEY FC9CA96ACA026560
W: Failed to fetch https://apt.releases.hashicorp.com/dists/noble/InRelease  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY FC9CA96ACA026560
W: Some index files failed to download. They have been ignored, or old ones used instead.

4) 
vagrant@vagrant:/tmp$ sha256sum --ignore-missing -c sha256sum.txt 
jq-linux-amd64: OK

vagrant@vagrant:/tmp$ sha256sum --ignore-missing -c sha256sum.txt   
jq-linux-amd64: FAILED
sha256sum: WARNING: 1 computed checksum did NOT match
sha256sum: sha256sum.txt: no file was verified

vagrant@vagrant:/tmp$ type -a jq
jq is /usr/local/bin/jq
jq is /usr/bin/jq
jq is /bin/jq

5) 
2 це потік помилок 1 це звичайний вивід а амперсанд з одиницею означає що помилки треба відправити туди ж куди йде звичайний вивід   У другій команді знак більше без цифри перенаправляє тільки звичайний вивід у файл а помилки залишаються на екрані бо повідомлення про неіснуючий сервіс це помилка вона йде у другий потік і тому потрапляє в термінал 

6) 
vagrant@vagrant:~$ alias ll
alias ll='ls -alh'
vagrant@vagrant:~$ ll
total 48K
drwxr-x--- 4 vagrant vagrant 4.0K Nov 20 18:18 .
drwxr-xr-x 3 root    root    4.0K Oct 23  2025 ..
-rw-r--r-- 1 vagrant vagrant  220 Mar 31  2024 .bash_logout
-rw-r--r-- 1 vagrant vagrant 4.0K Nov 20 18:18 .bashrc
drwx------ 2 vagrant vagrant 4.0K Oct 23  2025 .cache
-rw-rw-r-- 1 vagrant vagrant    0 Nov 20 17:34 errors.txt
-rw------- 1 vagrant vagrant   20 Nov 20 10:38 .lesshst
-rw-r--r-- 1 vagrant vagrant  807 Mar 31  2024 .profile
-rw-r--r-- 1 root    root    7.5K Nov 20 10:02 setup-wordpress.sh
drwx------ 2 vagrant vagrant 4.0K Nov 19 08:40 .ssh
-rw-r--r-- 1 vagrant vagrant    0 Oct 23  2025 .sudo_as_admin_successful
-rw-r--r-- 1 vagrant vagrant    5 Oct 23  2025 .vbox_version
-rw-rw-r-- 1 vagrant vagrant  216 Nov 20 11:16 .wget-hsts
vagrant@vagrant:~$ ports
Netid           State            Recv-Q           Send-Q                      Local Address:Port                       Peer Address:Port           Process                                                                                                                                            
udp             UNCONN           0                0                              127.0.0.54:53                              0.0.0.0:*               users:(("systemd-resolve",pid=15552,fd=16))                                                                                                       
udp             UNCONN           0                0                           127.0.0.53%lo:53                              0.0.0.0:*               users:(("systemd-resolve",pid=15552,fd=14))                                                                                                       
udp             UNCONN           0                0                          10.0.2.15%eth0:68                              0.0.0.0:*               users:(("systemd-network",pid=15581,fd=25))                                                                                                       
tcp             LISTEN           0                70                              127.0.0.1:33060                           0.0.0.0:*               users:(("mysqld",pid=13402,fd=21))                                                                                                                
tcp             LISTEN           0                151                             127.0.0.1:3306                            0.0.0.0:*               users:(("mysqld",pid=13402,fd=26))                                                                                                                
tcp             LISTEN           0                4096                        127.0.0.53%lo:53                              0.0.0.0:*               users:(("systemd-resolve",pid=15552,fd=15))                                                                                                       
tcp             LISTEN           0                4096                              0.0.0.0:22                              0.0.0.0:*               users:(("sshd",pid=15560,fd=3),("systemd",pid=1,fd=121))                                                                                          
tcp             LISTEN           0                4096                           127.0.0.54:53                              0.0.0.0:*               users:(("systemd-resolve",pid=15552,fd=17))                                                                                                       
tcp             LISTEN           0                511                                     *:80                                    *:*               users:(("apache2",pid=18913,fd=4),("apache2",pid=18840,fd=4),("apache2",pid=18839,fd=4),("apache2",pid=18823,fd=4),("apache2",pid=18822,fd=4),("apache2",pid=18821,fd=4),("apache2",pid=18814,fd=4))
tcp             LISTEN           0                4096                                 [::]:22                                 [::]:*               users:(("sshd",pid=15560,fd=4),("systemd",pid=1,fd=123))                                                                                          
vagrant@vagrant:~$ wplog 
==> /var/log/apache2/other_vhosts_access.log <==
127.0.1.1:80 ::1 - - [20/Nov/2026:11:58:09 +0000] "GET /does-not-exist-11 HTTP/1.1" 404 432 "-" "curl/8.5.0"
127.0.1.1:80 ::1 - - [20/Nov/2026:11:58:09 +0000] "GET /does-not-exist-12 HTTP/1.1" 404 432 "-" "curl/8.5.0"
127.0.1.1:80 ::1 - - [20/Nov/2026:11:58:09 +0000] "GET /does-not-exist-13 HTTP/1.1" 404 432 "-" "curl/8.5.0"
127.0.1.1:80 ::1 - - [20/Nov/2026:11:58:09 +0000] "GET /does-not-exist-14 HTTP/1.1" 404 432 "-" "curl/8.5.0"
127.0.1.1:80 ::1 - - [20/Nov/2026:11:58:09 +0000] "GET /does-not-exist-15 HTTP/1.1" 404 432 "-" "curl/8.5.0"
127.0.1.1:80 ::1 - - [20/Nov/2026:11:58:16 +0000] "GET / HTTP/1.1" 301 222 "-" "curl/8.5.0"
127.0.1.1:80 ::1 - - [20/Nov/2026:11:58:22 +0000] "GET / HTTP/1.1" 301 222 "-" "curl/8.5.0"
127.0.1.1:80 ::1 - - [20/Nov/2026:11:59:48 +0000] "GET / HTTP/1.1" 301 222 "-" "curl/8.5.0"
127.0.1.1:80 10.0.2.2 - - [20/Nov/2026:12:00:05 +0000] "GET / HTTP/1.1" 200 12237 "-" "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/157.0.0.0 Safari/537.36"
127.0.1.1:80 10.0.2.2 - - [20/Nov/2026:12:00:57 +0000] "-" 408 0 "-" "-"

==> /var/log/apache2/error.log <==
[Fri Nov 20 10:03:10.158771 2026] [core:notice] [pid 15453] AH00094: Command line: '/usr/sbin/apache2'
[Fri Nov 20 10:15:27.555176 2026] [mpm_prefork:notice] [pid 15453] AH00170: caught SIGWINCH, shutting down gracefully
[Fri Nov 20 10:15:27.801391 2026] [mpm_prefork:notice] [pid 18121] AH00163: Apache/2.4.58 (Ubuntu) configured -- resuming normal operations
[Fri Nov 20 10:15:27.801437 2026] [core:notice] [pid 18121] AH00094: Command line: '/usr/sbin/apache2'
[Fri Nov 20 10:18:50.188303 2026] [mpm_prefork:notice] [pid 18121] AH00170: caught SIGWINCH, shutting down gracefully
[Fri Nov 20 10:18:50.525259 2026] [mpm_prefork:notice] [pid 18251] AH00163: Apache/2.4.58 (Ubuntu) configured -- resuming normal operations
[Fri Nov 20 10:18:50.525309 2026] [core:notice] [pid 18251] AH00094: Command line: '/usr/sbin/apache2'
[Fri Nov 20 10:26:36.954988 2026] [mpm_prefork:notice] [pid 18251] AH00170: caught SIGWINCH, shutting down gracefully
[Fri Nov 20 10:26:37.554730 2026] [mpm_prefork:notice] [pid 18814] AH00163: Apache/2.4.58 (Ubuntu) configured -- resuming normal operations
[Fri Nov 20 10:26:37.554777 2026] [core:notice] [pid 18814] AH00094: Command line: '/usr/sbin/apache2'

7) 
vagrant@vagrant:~$ man 1 find |grep mtime
              Measure times (for -amin, -atime, -cmin, -ctime, -mmin, and -mtime) from the beginning of today rather than from  24  hours  ago.
vagrant@vagrant:~$ man 5 sources.list |grep "arch="
           deb [ arch=amd64,armel ] http://deb.debian.org/debian bookworm main
hold
           hold is used to mark a package as held back, which will prevent the package from being automatically installed, upgraded or removed.
auto
           auto is used to mark a package as being automatically installed, which will cause the package to be removed when no more manually
           installed packages depend on this package.

vagrant@vagrant:~$ apropos checksum
btrfs-scrub (8)      - scrub btrfs filesystem, verify block checksums
cksum (1)            - compute and verify file checksums
innochecksum (1)     - offline InnoDB file checksum utility
shasum (1)           - Print or Check SHA Checksums
sum (1)              - checksum and count the blocks in a file
tc-csum (8)          - checksum update action

SIGINT       P1990      Term    Interrupt from keyboard
2q

8) 
Я відкрив конфіг через vim з плюсом щоб одразу потрапити в кінець файлу натиснув I для переходу в режим вставки вставив заздалегідь скопійовані команди через Ctrl Shift V натиснув Esc і вийшов зі збереженням змін через двокрапку x після чого оновив конфігурацію командою source