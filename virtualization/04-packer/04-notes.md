3. ==> xops-ubuntu.vagrant.ubuntu: Running provisioner: shell...
    xops-ubuntu.vagrant.ubuntu: Provisioner startup command:
    xops-ubuntu.vagrant.ubuntu: Connected to SSH!
    xops-ubuntu.vagrant.ubuntu: Running: inline script
    xops-ubuntu.vagrant.ubuntu: git version 2.43.0
    xops-ubuntu.vagrant.ubuntu: curl 8.5.0
    xops-ubuntu.vagrant.ubuntu: htop 3.3.0
    xops-ubuntu.vagrant.ubuntu: nginx version: nginx/1.24.0
    xops-ubuntu.vagrant.ubuntu: /tmp/packer-shell-validation.sh: line 6: [ -f /etc/xops-image ]: No such file or directory
==> xops-ubuntu.vagrant.ubuntu: Error executing script: Non-zero exit status: 1
==> xops-ubuntu.vagrant.ubuntu: Halting VM...
==> xops-ubuntu.vagrant.ubuntu: Destroying VM...
Build 'xops-ubuntu.vagrant.ubuntu' errored after 5 minutes 40 seconds.

==> Some builds didn't complete and clean up activities were to run.
--> xops-ubuntu.vagrant.ubuntu: Error executing script: Non-zero exit status: 1

==> Builds finished. The artifacts of successful builds are:

4. Provisioning під час завантаження (Vagrant + shell-скрипт щоразу:
Час: 1 хвилина 41 секунда (101.4 секунди).   
Суть: ПЗ встановлюється з нуля на кожне нове завантаження віртуальної машини.
Запечено Packer-ом (Packer + локальний білд артефакту):
Час: 5 хвилин 40 секунд (виконується одноразово під час збірки образу).   
Суть: Попереднє створення готового образу, завдяки чому подальші запуски проходять миттєво.

Щоб запікання образу окупало час збірки, потрібно виконати 4 запуски віртуальної машини. Арифметика така: збірка Packer триває 340 секунд (5 хвилин 40 секунд), а одне завантаження звичайним провізінінгом — 101.4 секунди. Розподіливши час збірки на час одного завантаження (340/101.4=3.3), отримуємо, що починаючи з 4-го запуск економія часу на кожному старті перекриває витрати на одноразову збірку.

5. Коротко для своїх, якщо знаєш Vagrant, але з Packer не працював:

Що робить Packer? Це прога для створення готових образів віртуалок. Vagrant щоразу при запуску бере голу систему і наново ставить весь софт. А Packer робить це заздалегідь — збирає все в один готовий образ, щоб потім все піднімалося за секунди.
Що таке golden image? Це базовий, повністю перевірений еталонний образ, у який уже запечено все необхідне. Вантажиш його — і машинка готова відразу.
Коли не треба заморочуватись з пакуванням? По-перше, якщо код або конфіг міняються кожні п'ять хвилин — витратиш більше часу на постійні перезбірки, простіше залишити звичайний провізінінг через Vagrant. По-друге, якщо проект оновлюється раз на рік — налаштовувати цілу систему збірки просто немає сенсу.