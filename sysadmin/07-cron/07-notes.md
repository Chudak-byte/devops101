1) 
vagrant@wp-app:~$ curl -s -o /dev/null -w '%{http_code}\n' http://localhost/wp-login.php
200
vagrant@wp-app:~$ sudo /usr/local/bin/backup-app.sh; echo "exit_code=$?"
2026-11-25 12:08:12 OK: backup completed stamp=2026-11-25-1207 files=wordpress-2026-11-25-1207.tar.gz,wordpress-2026-11-25-1207.sql.gz
exit_code=0
vagrant@wp-app:~$ sudo ls -la /backups/
total 69580
drwx------  2 root root     4096 Nov 25 12:08 .
drwxr-xr-x 25 root root     4096 Nov 25 11:54 ..
-rw-------  1 root root      463 Nov 25 11:54 wordpress-2026-11-25-1154.sql.gz
-rw-------  1 root root 35602932 Nov 25 11:54 wordpress-2026-11-25-1154.tar.gz
-rw-------  1 root root    21724 Nov 25 12:08 wordpress-2026-11-25-1207.sql.gz
-rw-------  1 root root 35604686 Nov 25 12:08 wordpress-2026-11-25-1207.tar.gz

vagrant@wp-app:~$ sudo /usr/local/bin/backup-app.sh; echo "exit_code=$?"
2026-11-25 11:54:42 ERROR: backup file missing or too small: /backups/wordpress-2026-11-25-1210.sql.gz
exit_code=1

2) 
# systemd timers
vagrant@wp-app:/etc/systemd/system$ systemctl list-timers backup-app.timer 
NEXT                        LEFT LAST PASSED UNIT             ACTIVATES         
Thu 2026-11-26 02:04:30 UTC  13h -         - backup-app.timer backup-app.service

1 timers listed.
Pass --all to see loaded but inactive timers, too.
vagrant@wp-app:/etc/systemd/system$ journalctl -u backup-app.service -n 5 --no-pager
Nov 25 12:22:35 wp-app systemd[1]: Starting backup-app.service - Backup Worpdress...
Nov 25 12:22:42 wp-app backup-app.sh[18307]: 2026-11-25 12:22:42 OK: backup completed stamp=2026-11-25-1222 files=wordpress-2026-11-25-1222.tar.gz,wordpress-2026-11-25-1222.sql.gz
Nov 25 12:22:42 wp-app systemd[1]: backup-app.service: Deactivated successfully.
Nov 25 12:22:42 wp-app systemd[1]: Finished backup-app.service - Backup Worpdress.
Nov 25 12:22:42 wp-app systemd[1]: backup-app.service: Consumed 4.721s CPU time.

# cron
vagrant@wp-app:~$ sudo journalctl -u cron --since "3 min ago" -n 10
Nov 25 12:15:01 wp-app CRON[18052]: pam_unix(cron:session): session opened for user root(uid=0) >
Nov 25 12:15:01 wp-app CRON[18053]: (root) CMD (command -v debian-sa1 > /dev/null && debian-sa1 >
Nov 25 12:15:01 wp-app CRON[18052]: pam_unix(cron:session): session closed for user root
Nov 25 12:17:01 wp-app cron[769]: (root) RELOAD (crontabs/root)
Nov 25 12:17:01 wp-app CRON[18067]: pam_unix(cron:session): session opened for user root(uid=0) >
Nov 25 12:17:01 wp-app CRON[18068]: pam_unix(cron:session): session opened for user root(uid=0) >
Nov 25 12:17:01 wp-app CRON[18069]: (root) CMD (/usr/local/bin/backup-app.sh >> /var/log/backup->
Nov 25 12:17:01 wp-app CRON[18070]: (root) CMD (cd / && run-parts --report /etc/cron.hourly)
Nov 25 12:17:01 wp-app CRON[18067]: pam_unix(cron:session): session closed for user root

3) 
vagrant@wp-app:~$ diff -u <(env | sort) <(sudo sort /tmp/cron-env.txt) || true
--- /dev/fd/63  2026-11-25 12:28:09.873450679 +0000
+++ /dev/fd/62  2026-11-25 12:28:09.880454179 +0000
@@ -1,23 +1,6 @@
-DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus
-HOME=/home/vagrant
+HOME=/root
 LANG=en_US.UTF-8
-LESSCLOSE=/usr/bin/lesspipe %s %s
-LESSOPEN=| /usr/bin/lesspipe %s
-LOGNAME=vagrant
-LS_COLORS=rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:
-OLDPWD=/etc/systemd/system
-PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
-PWD=/home/vagrant
-SHELL=/bin/bash
-SHLVL=1
-SSH_CLIENT=10.0.2.2 55250 22
-SSH_CONNECTION=10.0.2.2 55250 10.0.2.15 22
-SSH_TTY=/dev/pts/0
-TERM=xterm-256color
-USER=vagrant
-_=/usr/bin/env
-XDG_DATA_DIRS=/usr/local/share:/usr/share:/var/lib/snapd/desktop
-XDG_RUNTIME_DIR=/run/user/1000
-XDG_SESSION_CLASS=user
-XDG_SESSION_ID=46
-XDG_SESSION_TYPE=tty
+LOGNAME=root
+PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
+PWD=/root
+SHELL=/bin/sh
vagrant@wp-app:~$ sudo cat /tmp/cron-env.txt 
HOME=/root
LOGNAME=root
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
LANG=en_US.UTF-8
SHELL=/bin/sh
PWD=/root

4) 
-rw-------  1 vagrant vagrant    21724 Nov 25 12:32 wordpress-2026-11-25-1232.sql.gz
-rw-------  1 vagrant vagrant 35604686 Nov 25 12:32 wordpress-2026-11-25-1232.tar.gz
-rw-------  1 vagrant vagrant    21725 Nov 25 12:33 wordpress-2026-11-25-1233.sql.gz
-rw-------  1 vagrant vagrant 35604686 Nov 25 12:33 wordpress-2026-11-25-1233.tar.gz
-rw-------  1 vagrant vagrant    21725 Nov 25 12:34 wordpress-2026-11-25-1234.sql.gz
-rw-------  1 vagrant vagrant 35604686 Nov 25 12:34 wordpress-2026-11-25-1234.tar.gz
vagrant@backup-target:~$ 

5) 
vagrant@wp-app:~$ STAMP="2026-11-25-1232"
vagrant@wp-app:~$ echo "$STAMP"
2026-11-25-1232
vagrant@wp-app:~$ sudo mysql -e "DROP DATABASE wordpress"
vagrant@wp-app:~$ curl -s -o /dev/null -w '%{http_code}\n' http://localhost/wp-login.php
500
vagrant@wp-app:~$ sudo mysql -e "CREATE DATABASE wordpress"
vagrant@wp-app:~$ sudo gunzip -c "/backups/wordpress-${STAMP}.sql.gz" | sudo mysql wordpress
vagrant@wp-app:~$ curl -s -o /dev/null -w '%{http_code}\n' http://localhost/wp-login.php
200
vagrant@wp-app:~$ sudo mv /srv/www/wordpress /srv/www/wordpress.broken
vagrant@wp-app:~$ sudo tar -xzf "/backups/wordpress-${STAMP}.tar.gz" -C /srv/www
vagrant@wp-app:~$ ls -l /srv/www/wordpress/wp-config.php
-rw-r----- 1 www-data www-data 3523 Nov 25 10:36 /srv/www/wordpress/wp-config.php
vagrant@wp-app:~$ curl -s -o /dev/null -w '%{http_code}\n' http://localhost/wp-login.php
200
vagrant@wp-app:~$ sudo rm -rf /srv/www/wordpress.broken

6) 
Для цієї задачі постійного резервного копіювання я б обрав systemd.timer так це є зручніше та простіше у використанні, та відразу має лог, для перегляду усіх дій та помилок. А crontab використав би для простих не критичних однорядкових завдань.