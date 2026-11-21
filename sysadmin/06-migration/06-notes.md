1) 
ubuntu@ip-172-31-16-103:~$ ls -la ~/.ssh/
total 36
drwx------ 2 ubuntu ubuntu 4096 Nov 21 16:50 .
drwxr-x--- 6 ubuntu ubuntu 4096 Nov 21 17:00 ..
-rw------- 1 ubuntu ubuntu  399 Nov  4 14:00 authorized_keys
-rw------- 1 ubuntu ubuntu 3389 Nov 21 16:26 id_rsa
-rw-r----- 1 ubuntu ubuntu  749 Nov 21 16:26 id_rsa.pub
-rw------- 1 ubuntu ubuntu  978 Nov 21 16:28 known_hosts
-rw-r----- 1 ubuntu ubuntu  142 Nov 21 16:16 known_hosts.old
-rw------- 1 ubuntu ubuntu  419 Nov 21 17:24 migration
-rw-r----- 1 ubuntu ubuntu  111 Nov 21 17:24 migration.pub

ubuntu@ip-172-31-16-103:~$ export TARGET=172.31.20.76 && echo "USER=$USER TARGET=$TARGET" && ssh -i ~/.ssh/migration "$USER@$TARGE
T" 'hostname'
USER=ubuntu TARGET=172.31.20.76
ip-172-31-20-76

2) 
### Заміри часу (`scp` vs `rsync`)

| Запуск | Реальний час (`real`) | Передано даних |
| :--- | :--- | :--- |
| `scp` (перша передача) | `0.571s` | ~34 МБ (увесь файл) |
| `rsync` (перша передача) | `0.708s` | 35,602,495 байтів (увесь файл) |
| `rsync` (повторний запуск без змін) | `1.121s` | 77 байтів (лише перевірка/метадані) |

scp - обрав би для передачі одного невеликого файлика одноразово
rsync - другий раз передача зайняла менше часу тому що він не передавав повністю весь файл ззаново так як команда виконується ідемпотентно, він перевірив тільки метаданні і додатково час на з'єднаннян по ssh.

3) 
ubuntu@ip-172-31-20-76:~$ sha256sum -c /tmp/app-migration.sha256      
sha256sum: /tmp/app-migration.sha256: No such file or directory
ubuntu@ip-172-31-20-76:~$ tar -tzf /tmp/app-migration.tar.gz > /dev/null; echo "tar exit: $?"


gzip: stdin: unexpected end of file
tar: Child returned status 1
tar: Error is not recoverable: exiting now
tar exit: 2

ubuntu@ip-172-31-20-76:~$ sha256sum -c /tmp/app-migration.sha256
/tmp/app-migration.tar.gz: OK

4) 
ubuntu@ip-172-31-20-76:~$ T=http://ec2-3-94-146-136.compute-1.amazonaws.com
ubuntu@ip-172-31-20-76:~$ curl -fsS -o /dev/null -w '%{http_code} %{time_total}s\n' $T/wp-login.php 
200 1.595310s
ubuntu@ip-172-31-20-76:~$ curl -sS -o /dev/null -w '%{http_code} redirect=%{redirect_url}\n' $T/     
200 redirect=
ubuntu@ip-172-31-20-76:~$ curl -sI $T/ | grep -i '^location:'   # empty is good
ubuntu@ip-172-31-20-76:~$ curl -sL -o /dev/null -w '%{url_effective}\n' $T/

http://ec2-3-94-146-136.compute-1.amazonaws.com/

5) 
1.Вікно простою: десь 4–5 хв — за моїми замірами дамп БД зайняв 30 s, передача архіву ~0.57–0.71 s, перевірка входу у WordPress 1.595 s, плюс запас на перевірки 180–240 s (і час на імпорт БД). У цей час сайт лежить і не проходять ніякі записи/пости/коментарі, бо сервіс зупинений.
2.Точка заморозки: зупиняю записи на старій машині перед фінальним дампом MySQL і збором налаштувань/файлів WordPress, після попереднього прогріву через `rsync`. Ріжу записи зупинкою вебсервера/PHP на старій машині, наприклад `sudo systemctl stop apache2`.
3.Перемикання: переводжу трафік на нову машину (`ec2-3-94-146-136.compute-1.amazonaws.com` / `172.31.20.76`) через DNS / Elastic IP / проксі nginx (що саме у вас налаштовано). Поширення займає від кількох секунд для IP/проксі до TTL DNS-запису.
4.Ворота перевірки: поки не пройдуть перевірки на новій машині, вважаю що ще не готово:
`sha256sum -c /tmp/app-migration.sha256`
`tar -tzf /tmp/app-migration.tar.gz > /dev/null; echo "tar exit: $?"`
`sudo mysql -u root -e "USE wordpress; SHOW TABLES;" | head`
і перевіряю що WordPress відповідає (`200` на `/wp-login.php` і `/`, без редиректу в нікуди).
5.Відкат: якщо о 02:40 на новій машині щось не так (біла сторінка, криві налаштування, биті дані) — повертаю трафік назад на стару і запускаю сервіс (`sudo systemctl start apache2`). Це займе десь 3–5 хв. Усе що встигли записати у WordPress після точки заморозки до відкату — пропаде.
6.Точка неповернення: настає коли на новій машині вже пішли реальні нові записи користувачів у базу/сайт і ми закріпились на ній. Після цього простий відкат на старий дамп уже не буде чистим — втратяться свіжі записи або доведеться розгрібати зміни вручну.

6) 
ubuntu@ip-172-31-16-103:~$ ssh -i ~/.ssh/migration $USER@$TARGET 'ls -la ~/wp-mirror/stray-on-target.txt'
ls: cannot access '/home/ubuntu/wp-mirror/stray-on-target.txt': No such file or directory

ubuntu@ip-172-31-16-103:~$ rsync -avz --delete --exclude wp-config.php -e "ssh -i ~/.ssh/migration" \
  /srv/www/wordpress/ $USER@$TARGET:/home/$USER/wp-mirror/
sending incremental file list
deleting stray-on-target.txt
./

sent 128,713 bytes  received 540 bytes  86,168.67 bytes/sec
total size is 110,135,580  speedup is 852.09

ubuntu@ip-172-31-16-103:~$ rsync -avzn --delete --exclude wp-config.php -e "ssh -i ~/.ssh/migration" \
  /srv/www/wordpress/ $USER@$TARGET:/home/$USER/wp-mirror/
sending incremental file list

sent 128,702 bytes  received 506 bytes  86,138.67 bytes/sec
total size is 110,135,580  speedup is 852.39 (DRY RUN)

7) 
ubuntu@ip-172-31-16-103:~$ sha256sum /tmp/from-s3.tar.gz

1cd83902217237e869e53408b3133bac2d3af43e8bd0ef5f269f3c89c941be1e  /tmp/from-s3.tar.gz Таке ж як і узавданні '3'