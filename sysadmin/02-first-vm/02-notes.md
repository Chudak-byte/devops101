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
5.1 
ubuntu@ip-172-31-16-103:~$ echo ok | sudo tee /srv/www/wordpress/health.txt
ok
ubuntu@ip-172-31-16-103:~$ curl -s http://localhost/health.txt
ok
ubuntu@ip-172-31-16-103:~$ curl -i http://localhost/health.txt
HTTP/1.1 200 OK
Date: Thu, 05 Nov 2026 21:51:16 GMT
Server: Apache/2.4.58 (Ubuntu)
Last-Modified: Thu, 05 Nov 2026 21:50:49 GMT
ETag: "3-65f8e7d26c5e4"
Accept-Ranges: bytes
Content-Length: 3
Content-Type: text/plain

ok
ubuntu@ip-172-31-16-103:~$ curl -s -o /dev/null -w '%{http_code}\n' http://localhost/
200
ubuntu@ip-172-31-16-103:~$ curl -v http://localhost/ 2>&1 | head -25
* Host localhost:80 was resolved.
* IPv6: ::1
* IPv4: 127.0.0.1
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0*   Trying [::1]:80...
* Connected to localhost (::1) port 80
> GET / HTTP/1.1
> Host: localhost
> User-Agent: curl/8.5.0
> Accept: */*
>
< HTTP/1.1 200 OK
< Date: Thu, 05 Nov 2026 21:51:38 GMT
< Server: Apache/2.4.58 (Ubuntu)
< Link: <http://ec2-34-228-255-75.compute-1.amazonaws.com/wp-json/>; rel="https://api.w.org/"
< Vary: Accept-Encoding
< Transfer-Encoding: chunked
< Content-Type: text/html; charset=UTF-8
<
{ [22611 bytes data]
<!DOCTYPE html>
<html lang="en-US">
<head>
        <meta charset="UTF-8" />
ubuntu@ip-172-31-16-103:~$ curl -s -o /dev/null -w '%{http_code}\n' http://localhost/nope
404
ubuntu@ip-172-31-16-103:~$ curl -i -X POST \
  -d 'comment_post_ID=1&author=you&email=you@example.com&comment=hello+from+curl' \
  http://localhost/wp-comments-post.php
HTTP/1.1 302 Found
Date: Thu, 05 Nov 2026 21:54:24 GMT
Server: Apache/2.4.58 (Ubuntu)
Expires: Wed, 11 Jan 1984 05:00:00 GMT
Cache-Control: no-cache, must-revalidate, max-age=0, no-store, private
Set-Cookie: comment_author_842ad6db0958dc252fb0b142016a1731=%20; expires=Wed, 05 Nov 2025 21:54:24 GMT; Max-Age=0; path=/
Set-Cookie: comment_author_email_842ad6db0958dc252fb0b142016a1731=%20; expires=Wed, 05 Nov 2025 21:54:24 GMT; Max-Age=0; path=/
Set-Cookie: comment_author_url_842ad6db0958dc252fb0b142016a1731=%20; expires=Wed, 05 Nov 2025 21:54:24 GMT; Max-Age=0; path=/
X-Redirect-By: WordPress
Location: http://ec2-34-228-255-75.compute-1.amazonaws.com/2026/11/05/hello-world/?unapproved=2&moderation-hash=4a91bc3233d02ce79cc59a5bde5be0b1#comment-2
Content-Length: 0
Content-Type: text/html; charset=UTF-8
6.1 
ubuntu@ip-172-31-16-103:~$ sudo ss -tulpn
Netid     State      Recv-Q     Send-Q              Local Address:Port            Peer Address:Port     Process
udp       UNCONN     0          0                      127.0.0.54:53                   0.0.0.0:*         users:(("systemd-resolve",pid=346,fd=16))
udp       UNCONN     0          0                   127.0.0.53%lo:53                   0.0.0.0:*         users:(("systemd-resolve",pid=346,fd=14))
udp       UNCONN     0          0              172.31.16.103%ens5:68                   0.0.0.0:*         users:(("systemd-network",pid=482,fd=21))
udp       UNCONN     0          0                       127.0.0.1:323                  0.0.0.0:*         users:(("chronyd",pid=687,fd=5))
udp       UNCONN     0          0                           [::1]:323                     [::]:*         users:(("chronyd",pid=687,fd=6))
tcp       LISTEN     0          4096                      0.0.0.0:22                   0.0.0.0:*         users:(("sshd",pid=973,fd=3),("systemd",pid=1,fd=87))
tcp       LISTEN     0          70                      127.0.0.1:33060                0.0.0.0:*         users:(("mysqld",pid=764,fd=21))
tcp       LISTEN     0          4096                127.0.0.53%lo:53                   0.0.0.0:*         users:(("systemd-resolve",pid=346,fd=15))
tcp       LISTEN     0          4096                   127.0.0.54:53                   0.0.0.0:*         users:(("systemd-resolve",pid=346,fd=17))
tcp       LISTEN     0          151                     127.0.0.1:3306                 0.0.0.0:*         users:(("mysqld",pid=764,fd=23))
tcp       LISTEN     0          4096                         [::]:22                      [::]:*         users:(("sshd",pid=973,fd=4),("systemd",pid=1,fd=88))
tcp       LISTEN     0          511                             *:80                         *:*         users:(("apache2",pid=1244,fd=4),("apache2",pid=1236,fd=4),("apache2",pid=1235,fd=4),("apache2",pid=1234,fd=4),("apache2",pid=1233,fd=4),("apache2",pid=1232,fd=4),("apache2",pid=1230,fd=4))
ubuntu@ip-172-31-16-103:~$ sudo ss -tulpn | grep -E ':80|:3306'
tcp   LISTEN 0      70              127.0.0.1:33060      0.0.0.0:*    users:(("mysqld",pid=764,fd=21))  
tcp   LISTEN 0      151             127.0.0.1:3306       0.0.0.0:*    users:(("mysqld",pid=764,fd=23))  
tcp   LISTEN 0      511                     *:80               *:*    users:(("apache2",pid=1244,fd=4),("apache2",pid=1236,fd=4),("apache2",pid=1235,fd=4),("apache2",pid=1234,fd=4),("apache2",pid=1233,fd=4),("apache2",pid=1232,fd=4),("apache2",pid=1230,fd=4))
ubuntu@ip-172-31-16-103:~$ curl -s -o /dev/null -w '%{http_code}\n' http://127.0.0.1/health.txt
200
ubuntu@ip-172-31-16-103:~$ nc -zv 127.0.0.1 3306
Connection to 127.0.0.1 3306 port [tcp/mysql] succeeded!
7.1
У першому випадку Apache слухає порт 80 і сам дає відповідь, але веб сервер не може дістатися до бази,а WordPress виконується всередині apache.
У другому випадку на порту 80 не слухає ні один сервіс, тому TCP-з'єднання відхиляється, і порт 80 мертвий.
8. Бюджет прив'язав до алертів та сюди закину скріни.