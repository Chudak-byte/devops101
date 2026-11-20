=== 1. Загальна кількість запитів ===
101 /var/log/apache2/other_vhosts_access.log
=== 2. Кількість 404 ===
16
=== 3. Топ-5 шляхів ===
     43 /wp-login.php
      6 /
      3 *
      1 /wp-includes/js/zxcvbn.min.js
      1 /wp-includes/js/zxcvbn-async.min.js?ver=1.0
=== 4. Змінені за 24 год у /var/log ===
/var/log/apache2/other_vhosts_access.log
/var/log/apache2/error.log
/var/log/wtmp
/var/log/apt/history.log
/var/log/apt/term.log
/var/log/apt/eipp.log.xz
/var/log/lastlog
/var/log/dpkg.log
/var/log/sysstat/sar19
/var/log/sysstat/sa19
/var/log/sysstat/sa20
/var/log/ubuntu-advantage-apt-hook.log
/var/log/journal/ce545ece38364e63b4c19cad6816e42a/system.journal
/var/log/journal/ce545ece38364e63b4c19cad6816e42a/user-1000.journal
/var/log/auth.log
/var/log/kern.log
/var/log/mysql/error.log
/var/log/syslog
=== 5. Файли > 1MB у /var/log (найбільші першими) ===
-rw-r-----+ 1 root systemd-journal 8.0M Oct 23  2025 /var/log/journal/2f2241f6028f410ba0d2f39d94aaaf47/user-1000.journal
-rw-r-----+ 1 root systemd-journal 8.0M Oct 23  2025 /var/log/journal/2f2241f6028f410ba0d2f39d94aaaf47/system.journal
-rw-r-----+ 1 root systemd-journal 8.0M Nov 20 17:42 /var/log/journal/ce545ece38364e63b4c19cad6816e42a/user-1000.journal
-rw-r-----+ 1 root systemd-journal 8.0M Nov 20 17:40 /var/log/journal/ce545ece38364e63b4c19cad6816e42a/system.journal
=== 6. Згадки wordpress у /etc ===
/etc/apache2/sites-available/wordpress.conf
=== 7a. Кількість рядків з error у error.log ===
0
=== 7b. journalctl apache2 (остання година) ===
-- No entries --