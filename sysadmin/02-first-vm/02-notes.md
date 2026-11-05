1.1 
ubuntu@ip-172-31-16-103:~$ ./passport.sh
 Static hostname: ip-172-31-16-103
       Icon name: computer-vm
         Chassis: vm 🖴
      Machine ID: ec2f32b86b1d26655123d52283ccf74f
         Boot ID: 9503d16d227b47edbb03cc68c118f55a
  Virtualization: amazon
Operating System: Ubuntu 24.04.5 LTS
          Kernel: Linux 7.0.0-1014-aws
    Architecture: x86-64
 Hardware Vendor: Amazon EC2
  Hardware Model: t3.micro
Firmware Version: 1.0
   Firmware Date: Mon 2017-10-16
    Firmware Age: 9y 2w 6d
PRETTY_NAME="Ubuntu 24.04.5 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.5 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo
Linux ip-172-31-16-103 7.0.0-1014-aws #14~24.04.1-Ubuntu SMP PREEMPT Fri Sep 18 21:24:59 UTC 2026 x86_64 x86_64 x86_64 GNU/Linux
ubuntu
uid=1000(ubuntu) gid=1000(ubuntu) groups=1000(ubuntu),4(adm),24(cdrom),27(sudo),30(dip),33(www-data),105(lxd)
2
               total        used        free      shared  buff/cache   available
Mem:           909Mi       704Mi        44Mi        30Mi       296Mi       204Mi
Swap:             0B          0B          0B
Filesystem      Size  Used Avail Use% Mounted on
/dev/root       6.8G  3.2G  3.6G  47% /
lo               UNKNOWN        127.0.0.1/8 ::1/128
ens5             UP             172.31.16.103/20 metric 100 fe80::8ff:d2ff:fe36:7c5f/64
 16:32:09 up  1:03,  1 user,  load average: 0.00, 0.00, 0.00
1.2
    /etc - системні файлики та конфіги
    /var/log - логи усіх сервісів та системи
    /home - особисті файли користувача
    /srv - директорія для зберігання данних чи конфігурацій сайту
    /usr/bin - виконувані файли та скрипти 
    /tmp - директорія для тимчасових записів
1.3
    Машинка з родини Debian оприділив через одну з перших команд "apt update" так як на rhell "dnf update"
2.1 
    grep -Z виводить нульовий байт замість звичайного символу
    df -x дозволяє виключити тип файла які вкажемо після флагу
    htop --tree відкриває інтерактивне дерево процесів
3.1 apt update оновлює локальні списки пакетів і показує що
    змінилось а apt upgrade оновлює систему
3.2 ubuntu@ip-172-31-16-103:~$ tree -L 2 /srv
    /srv
    └── www
        └── wordpress

    3 directories, 0 files
4.1 ubuntu@ip-172-31-16-103:~$ sudo apache2ctl configtest                 
    Syntax OK
    ubuntu@ip-172-31-16-103:~$ sudo systemctl reload apache2
    ubuntu@ip-172-31-16-103:~$ diff /etc/apache2/sites-available/wordpress.conf.bak /etc/apache2/sites-available/wordpress.conf
    0a1,3
    >
    > #anekdot
    >

