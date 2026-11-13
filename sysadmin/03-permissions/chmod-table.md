Приватний ключ SSH читання лише для власника 400 r--------
Вебсторінка - власник пише всі читають 644 rw-r--r--
Скрипт - власник виконує, група читає й виконує, інші нічого 750 rwxr-x---
Директорія, до якої може заходити лише власник 700 drwx------
Конфіг застосунку з паролем до БД - власник і група читають, інші нічого 440 r--r-----
ubuntu@ip-172-31-16-103:~$ cd ~/umask-lab
ubuntu@ip-172-31-16-103:~/umask-lab$ touch drill.txt
ubuntu@ip-172-31-16-103:~/umask-lab$ chmod 640 drill.txt        && stat -c '%a %A %n' drill.txt
640 -rw-r----- drill.txt
ubuntu@ip-172-31-16-103:~/umask-lab$ chmod u=rw,g=r,o= drill.txt && stat -c '%a %A %n' drill.txt 
640 -rw-r----- drill.txt