# Домашнее задание к занятию "3.7. Компьютерные сети.Лекция 2"

### 1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

    Linux:

    $ ip -br link
    lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
    eth0             UP             08:00:27:a2:6b:fd <BROADCAST,MULTICAST,UP,LOWER_UP>

    $ ls /sys/class/net
    eth0  lo

    Windows:

    >netsh interface show interface

    Состояние адм.  Состояние     Тип              Имя интерфейса
    ---------------------------------------------------------------------
    Разрешен       Подключен      Выделенный       Ethernet0

    >ipconfig | find "Адаптер"
    Адаптер Ethernet Ethernet0:

    или зайти в "Панель управления\Сеть и Интернет\Сетевые подключения"

    или в "Диспетчер устройств - Сетевые адаптеры"

### 2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

    Протоколы для распознования соседа по сетевому интерфейсу:
    LLDP, NDP и множество других протоколов, таких как CDP, EDP, MNDP...
    
    В Linux для этих целей есть пакет lldpd.

    $ sudo lldpctl
    -------------------------------------------------------------------------------
    LLDP neighbors:
    -------------------------------------------------------------------------------
    Interface:    enp6s0, via: LLDP, RID: 1, Time: 0 day, 00:00:04
      Chassis:     
        ChassisID:    mac 00:00:00:00:00:00
        SysName:      MikroTik
        SysDescr:     MikroTik RouterOS ---
        MgmtIP:       192.168.88.1
        MgmtIface:    2
        Capability:   Bridge, on
        Capability:   Router, on
      Port:        
        PortID:       ifname bridgeLan/ether2
        TTL:          120
    -------------------------------------------------------------------------------


### 3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

    Технология разделяющая коммутатор на несколько виртуальных сетей называется VLAN (Virtual Local 
    Area Network)

    Пакет в Linux называется так же: vlan.
    Vlan можно создавать при помощи устаревшей команды vconfig или при помощи ip или же установить 
    net-tools и воспользоваться ifconfig 

    Примеры:
    $ sudo vconfig add eth0 222
    Warning: vconfig is deprecated and might be removed in the future, please migrate to 
    ip(route2) as soon as possible!
    $ ip add 
    ...
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        link/ether 08:00:27:a2:6b:fd brd ff:ff:ff:ff:ff:ff
        inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
           valid_lft 79826sec preferred_lft 79826sec
        inet6 fe80::a00:27ff:fea2:6bfd/64 scope link 
           valid_lft forever preferred_lft forever
    3: eth0.222@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
        link/ether 08:00:27:a2:6b:fd brd ff:ff:ff:ff:ff:ff

    $ sudo ip link add link eth0 name eth0.223 type vlan id 223
    $ ip addr | grep eth0
    2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic eth0
    3: eth0.222@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
    4: eth0.223@eth0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000

    $ sudo ip addr add 10.0.222.1/24 dev eth0.222
    $ sudo ip link set up eth0.222
    $ ip add show eth0.222
    3: eth0.222@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group 
    default qlen 1000
        link/ether 08:00:27:a2:6b:fd brd ff:ff:ff:ff:ff:ff
        inet 10.0.222.1/24 scope global eth0.222
           valid_lft forever preferred_lft forever
        inet6 fe80::a00:27ff:fea2:6bfd/64 scope link 
           valid_lft forever preferred_lft forever

    Все выше сделанные настройки будут потеряны после перезагрузки, для того что бы они сохранились
    внесем изменения в netplan добавив туда настройки нашего vlan:

    $ cat /etc/netplan/01-netcfg.yaml 
    network:
      version: 2
      ethernets:
        eth0:
          dhcp4: true
      vlans:
        eth0.222:
          id: 222
          link: eth0
          addresses: [10.0.222.2/24]
    
    применим изменения в netplan
    $ sudo netplan apply
    $ ip a show eth0.222
    3: eth0.222@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether 08:00:27:a2:6b:fd brd ff:ff:ff:ff:ff:ff
        inet 10.0.222.2/24 brd 10.0.222.255 scope global eth0.222
           valid_lft forever preferred_lft forever
        inet6 fe80::a00:27ff:fea2:6bfd/64 scope link 
           valid_lft forever preferred_lft forever

    проверяем
    $ sudo reboot
    Connection to 127.0.0.1 closed by remote host.
    $ ip a s eth0.222
    3: eth0.222@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether 08:00:27:a2:6b:fd brd ff:ff:ff:ff:ff:ff
        inet 10.0.222.2/24 brd 10.0.222.255 scope global eth0.222
           valid_lft forever preferred_lft forever
        inet6 fe80::a00:27ff:fea2:6bfd/64 scope link 
           valid_lft forever preferred_lft forever



### 4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

    

5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

*В качестве решения ответьте на вопросы и опишите, каким образом эти ответы были получены*

---

## Задание для самостоятельной отработки* (необязательно к выполнению)

 8. Установите эмулятор EVE-ng.
 
 [Инструкция по установке](https://github.com/svmyasnikov/eve-ng)

 Выполните задания на lldp, vlan, bonding в эмуляторе EVE-ng. 