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

    Типы агрегации:
    - статический
    - динамический

    $ modinfo bonding
    ...
    parm:           mode:Mode of operation; 0 for balance-rr, 1 for active-backup, 
        2 for balance-xor, 3 for broadcast, 4 for 802.3ad, 5 for balance-tlb, 
        6 for balance-alb (charp)
    ...

    Опции для балансировки:
    mode=0 (balance-rr)
    Этот режим используется по-умолчанию, если в настройках не указано другое. balance-rr 
    обеспечивает балансировку нагрузки и отказоустойчивость. В данном режиме пакеты 
    отправляются "по кругу" от первого интерфейса к последнему и сначала. Если выходит 
    из строя один из интерфейсов, пакеты отправляются на остальные оставшиеся. При 
    подключении портов к разным коммутаторам, требует их настройки.
    
    mode=1 (active-backup)
    При active-backup один интерфейс работает в активном режиме, остальные в ожидающем. 
    Если активный падает, управление передается одному из ожидающих. Не требует поддержки 
    данной функциональности от коммутатора.
    
    mode=2 (balance-xor)
    Передача пакетов распределяется между объединенными интерфейсами по формуле 
    ((MAC-адрес источника) XOR (MAC-адрес получателя)) % число интерфейсов. Один и 
    тот же интерфейс работает с определённым получателем. Режим даёт балансировку 
    нагрузки и отказоустойчивость.
    
    mode=3 (broadcast)
    Происходит передача во все объединенные интерфейсы, обеспечивая отказоустойчивость.
    
    mode=4 (802.3ad)
    Это динамическое объединение портов. В данном режиме можно получить значительное 
    увеличение пропускной способности как входящего так и исходящего трафика, 
    используя все объединенные интерфейсы. Требует поддержки режима от коммутатора, 
    а так же (иногда) дополнительную настройку коммутатора.
    
    mode=5 (balance-tlb)
    Адаптивная балансировка нагрузки. При balance-tlb входящий трафик получается 
    только активным интерфейсом, исходящий - распределяется в зависимости от текущей 
    загрузки каждого интерфейса. Обеспечивается отказоустойчивость и распределение  
    нагрузки исходящего трафика. Не требует специальной поддержки коммутатора.
    
    mode=6 (balance-alb)
    Адаптивная балансировка нагрузки (более совершенная). Обеспечивает балансировку 
    нагрузки как исходящего (TLB, transmit load balancing), так и входящего трафика 
    (для IPv4 через ARP). Не требует специальной поддержки коммутатором, но требует 
    возможности изменять MAC-адрес устройства.

    Пример конфига:
    $ cat /etc/netplan/01-netcfg.yaml 
    network:
      version: 2
      ethernets:
        eth0:
          dhcp4: true
        eth1:
          dhcp4: no
        eth2: 
          dhcp4: no
      vlans:
        eth0.222:
          id: 222
          link: eth0
          addresses: [10.0.222.2/24]
      bonds:
        bond0:
          addresses: [192.168.56.4/24]
          interfaces: [eth1, eth2]
          parameters:
            mode: balance-rr

    $ sudo netplan apply
    $ ip a show bond0
    5: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether 7e:db:18:c7:ba:ce brd ff:ff:ff:ff:ff:ff
        inet 192.168.56.4/24 brd 192.168.56.255 scope global bond0
           valid_lft forever preferred_lft forever
        inet6 fe80::7cdb:18ff:fec7:bace/64 scope link 
           valid_lft forever preferred_lft forever
    

    

### 5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

    В сети с маской /29 - 8 ip адресов из них первый это адрес сети, последний - широковещательный.
    По этому для хостов можно использовать только 6.
    $ ipcalc -n -b 192.168.1.50/29
    Address:   192.168.1.50         
    Netmask:   255.255.255.248 = 29 
    Wildcard:  0.0.0.7              
    =>
    Network:   192.168.1.48/29      
    HostMin:   192.168.1.49         
    HostMax:   192.168.1.54         
    Broadcast: 192.168.1.55         
    Hosts/Net: 6                     Class C, Private Internet


    Из сети с маской 24 можно получить 32 подсети с маской 29 
    $ ipcalc -b 192.168.1.0/24 -c 29 | tail -n 2
    Subnets:   32
    Hosts:     192

    Примеры /29 подсетей внутри сети 10.10.10.0/24:

    Network:   10.10.10.240/29      
    HostMin:   10.10.10.241         
    HostMax:   10.10.10.246         
    Broadcast: 10.10.10.247         
    Hosts/Net: 6 

    Network:   10.10.10.216/29      
    HostMin:   10.10.10.217         
    HostMax:   10.10.10.222         
    Broadcast: 10.10.10.223    
    Hosts/Net: 6 
    
    Network:   10.10.10.104/29      
    HostMin:   10.10.10.105         
    HostMax:   10.10.10.110         
    Broadcast: 10.10.10.111         
    Hosts/Net: 6 
    
    Network:   10.10.10.56/29       
    HostMin:   10.10.10.57          
    HostMax:   10.10.10.62          
    Broadcast: 10.10.10.63          
    Hosts/Net: 6 


### 6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

    Частные IP допустимо взять из сети 100.64.0.0/10, например из расчета 40-50 хостов 
    на подсеть подойдет следующая:

    Netmask:   255.255.255.192 = 26 
    Network:   10.64.0.0/26         
    HostMin:   10.64.0.1            
    HostMax:   10.64.0.62           
    Broadcast: 10.64.0.63           
    Hosts/Net: 62

### 7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

    проверка ARP таблицы
    Linux:
    $ arp -n
    Address                  HWtype  HWaddress           Flags Mask            Iface
    10.0.2.3                 ether   52:54:00:12:35:03   C                     eth0
    10.0.2.2                 ether   52:54:00:12:35:02   C                     eth0

    $ ip neighbor
    10.0.2.3 dev eth0 lladdr 52:54:00:12:35:03 STALE
    10.0.2.2 dev eth0 lladdr 52:54:00:12:35:02 REACHABLE

    Windows:
    >arp -a
    
    Интерфейс: 192.168.1.104 --- 0x4
      адрес в Интернете      Физический адрес      Тип
      192.168.0.10          52-54-00-12-35-11     динамический
      192.168.0.1           52-54-00-12-35-12     динамический
      192.168.0.255         ff-ff-ff-ff-ff-ff     статический
      ...

    Чистим ARP кеш
    Linux:
    ip neigh flush all
    
    Windows:
    arp -d *

    Удаляем 1 ip
    Linux
    arp -d "IP"
    или
    ip neigh del "IP" dev "имя интерфейса"

    Windows:
    arp -d "IP"

---

## Задание для самостоятельной отработки* (необязательно к выполнению)

 8. Установите эмулятор EVE-ng.
 
 [Инструкция по установке](https://github.com/svmyasnikov/eve-ng)

 Выполните задания на lldp, vlan, bonding в эмуляторе EVE-ng. 