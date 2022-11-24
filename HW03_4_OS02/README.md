# Домашнее задание к занятию "3.4. Операционные системы. Лекция 2"

### 1. На лекции мы познакомились с node_exporter. В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой unit-файл для node_exporter:

- поместите его в автозагрузку,
- предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на systemctl cat cron),
- удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.


    создаем unit-файл: sudo systemctl edit --full --force node_exporter.service
    
    $ sudo systemctl cat node_exporter
    # /etc/systemd/system/node_exporter.service
    [Unit]
    Description=Node Exporter
    [Service]
    ExecStart=/usr/local/bin/node_exporter
    [Install]
    WantedBy=multi-user.target

    добавляем его в автозагрузку:
    $ sudo systemctl enable node_exporter
    Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service → /etc/systemd/system/node_exporter.service.

    делаем возможность опций через внешний файл добавив 'EnvironmentFile=-/etc/default/node_exporter'
    в unit-фаил в секцию [Service]:

    $ sudo systemctl cat  node_exporter.service
    # /etc/systemd/system/node_exporter.service
    [Unit]
    Description=Node Exporter
    [Service]
    EnvironmentFile=-/etc/default/node_exporter
    ExecStart=/usr/local/bin/node_exporter
    [Install]
    WantedBy=multi-user.target

    Проверяем запуск и остановку сервиса:
    vagrant@vagrant:~$ sudo systemctl start node_exporter.service
    vagrant@vagrant:~$ sudo systemctl status node_exporter.service
    ● node_exporter.service - Prometheus Node Exporter
         Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
         Active: active (running) since Thu 2022-11-24 14:51:17 UTC; 3s ago

    agrant@vagrant:~$ sudo systemctl stop node_exporter.service
    vagrant@vagrant:~$ sudo systemctl status node_exporter.service
    ● node_exporter.service - Prometheus Node Exporter
         Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
         Active: inactive (dead) since Thu 2022-11-24 14:51:36 UTC; 1s ago

    vagrant@vagrant:~$ sudo reboot
    Connection to 127.0.0.1 closed by remote host.
    vagrant@vagrant:~$ uptime
     14:54:23 up 1 min,  1 user,  load average: 0.75, 0.33, 0.12
    vagrant@vagrant:~$ sudo systemctl status node_exporter.service
    ● node_exporter.service - Prometheus Node Exporter
         Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
         Active: active (running) since Wed 2022-11-23 01:43:03 UTC; 1 day 13h ago


### 2. Ознакомьтесь с опциями node_exporter и выводом /metrics по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

    CPU:
    node_cpu_seconds_total{cpu="0",mode="idle"} 3069.83
    node_cpu_seconds_total{cpu="0",mode="iowait"} 0.75
node_cpu_seconds_total{cpu="0",mode="irq"} 0
node_cpu_seconds_total{cpu="0",mode="nice"} 0.01
node_cpu_seconds_total{cpu="0",mode="softirq"} 1.13
node_cpu_seconds_total{cpu="0",mode="steal"} 0
node_cpu_seconds_total{cpu="0",mode="system"} 27.64
node_cpu_seconds_total{cpu="0",mode="user"} 19.96
node_cpu_seconds_total{cpu="1",mode="idle"} 3056.41
node_cpu_seconds_total{cpu="1",mode="iowait"} 0.62
node_cpu_seconds_total{cpu="1",mode="irq"} 0
node_cpu_seconds_total{cpu="1",mode="nice"} 0.07
node_cpu_seconds_total{cpu="1",mode="softirq"} 2.24
node_cpu_seconds_total{cpu="1",mode="steal"} 0
node_cpu_seconds_total{cpu="1",mode="system"} 22.9
node_cpu_seconds_total{cpu="1",mode="user"} 16.97


### 3. Установите в свою виртуальную машину Netdata. Воспользуйтесь готовыми пакетами для установки (sudo apt install -y netdata).

***После успешной установки:***

- в конфигурационном файле /etc/netdata/netdata.conf в секции [web] замените значение с localhost на bind to = 0.0.0.0,
- добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте vagrant reload:
config.vm.network "forwarded_port", guest: 19999, host: 19999

***После успешной перезагрузки в браузере на своем ПК (не в виртуальной машине) вы должны суметь зайти на localhost:19999. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.***

### 4. Можно ли по выводу dmesg понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

### 5. Как настроен sysctl fs.nr_open на системе по-умолчанию? Определите, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (ulimit --help)?

### 6. Запустите любой долгоживущий процесс (не ls, который отработает мгновенно, а, например, sleep 1h) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через nsenter. Для простоты работайте в данном задании под root (sudo -i). Под обычным пользователем требуются дополнительные опции (--map-root-user) и т.д.

### 7 Найдите информацию о том, что такое :(){ :|:& };:. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (это важно, поведение в других ОС не проверялось). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов dmesg расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?