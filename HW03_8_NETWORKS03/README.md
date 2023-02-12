# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

## 1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```


    $ curl ident.me
    46.138.169.125

    $ telnet route-views.routeviews.org
    Trying 128.223.51.103...
    Connected to route-views.routeviews.org.
    Escape character is '^]'.
    C
    **********************************************************************
    
                        RouteViews BGP Route Viewer
                        route-views.routeviews.org
    
     route views data is archived on http://archive.routeviews.org
    
     This hardware is part of a grant by the NSF.
     Please contact help@routeviews.org if you have questions, or
     if you wish to contribute your view.
    
     This router has views of full routing tables from several ASes.
     The list of peers is located at http://www.routeviews.org/peers
     in route-views.oregon-ix.net.txt
    
     NOTE: The hardware was upgraded in August 2014.  If you are seeing
     the error message, "no default Kerberos realm", you may want to
     in Mac OS X add "default unset autologin" to your ~/.telnetrc
    
     To login, use the username "rviews".
    
     **********************************************************************
    
    User Access Verification
    
    Username: rviews
    route-views>

    route-views>show ip route 46.138.169.125   
    Routing entry for 46.138.0.0/16
      Known via "bgp 6447", distance 20, metric 0
      Tag 3303, type external
      Last update from 217.192.89.50 2w3d ago
      Routing Descriptor Blocks:
      * 217.192.89.50, from 217.192.89.50, 2w3d ago
          Route metric is 0, traffic share count is 1
          AS Hops 3
          Route tag 3303
          MPLS label: none

    route-views>show bgp 46.138.169.125                
    BGP routing table entry for 46.138.0.0/16, version 2619151801
    Paths: (21 available, best #20, table default)
      Not advertised to any peer
      Refresh Epoch 1
      6939 8359 25513
        64.71.137.241 from 64.71.137.241 (216.218.252.164)
          Origin IGP, localpref 100, valid, external
          path 7FE1CBD4B708 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      3333 8359 25513
        193.0.0.56 from 193.0.0.56 (193.0.0.56)
          Origin IGP, localpref 100, valid, external
          Community: 0:199 8359:100 8359:5500 8359:55277
          path 7FE0F20EA9F8 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      20912 3257 3356 8359 25513
        212.66.96.126 from 212.66.96.126 (212.66.96.126)
          Origin IGP, localpref 100, valid, external
          Community: 3257:8070 3257:30515 3257:50001 3257:53900 3257:53902 20912:65004
          path 7FE115445270 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      19214 3257 3356 8359 25513
        208.74.64.40 from 208.74.64.40 (208.74.64.40)
          Origin IGP, localpref 100, valid, external
          Community: 3257:8108 3257:30048 3257:50002 3257:51200 3257:51203
          path 7FE1CB549588 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      53767 174 174 3356 8359 25513
        162.251.163.2 from 162.251.163.2 (162.251.162.3)
          Origin IGP, localpref 100, valid, external
          Community: 174:21000 174:22013 53767:5000
          path 7FE0E7416408 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      49788 12552 8359 25513
        91.218.184.60 from 91.218.184.60 (91.218.184.60)
          Origin IGP, localpref 100, valid, external
          Community: 12552:12000 12552:12100 12552:12101 12552:22000
          Extended Community: 0x43:100:1
          path 7FE110A06F88 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      3356 8359 25513
        4.68.4.46 from 4.68.4.46 (4.69.184.201)
          Origin IGP, metric 0, localpref 100, valid, external
          Community: 0:199 3356:2 3356:22 3356:100 3356:123 3356:519 3356:903 3356:2094 8359:100 8359:5500 8359:55277
          path 7FE106DFD388 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      3267 8359 25513
        194.85.40.15 from 194.85.40.15 (185.141.126.1)
          Origin IGP, metric 0, localpref 100, valid, external
          path 7FE006A47220 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      3561 3910 3356 8359 25513
        206.24.210.80 from 206.24.210.80 (206.24.210.80)
          Origin IGP, localpref 100, valid, external
          path 7FE04AC25940 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      7018 3356 8359 25513
        12.0.1.63 from 12.0.1.63 (12.0.1.63)
          Origin IGP, localpref 100, valid, external
          Community: 7018:5000 7018:37232
          path 7FE0AF85FF10 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      8283 8359 25513
        94.142.247.3 from 94.142.247.3 (94.142.247.3)
          Origin IGP, metric 0, localpref 100, valid, external
          Community: 0:199 8283:1 8283:101 8359:100 8359:5500 8359:55277
          unknown transitive attribute: flag 0xE0 type 0x20 length 0x24
            value 0000 205B 0000 0000 0000 0001 0000 205B
                  0000 0005 0000 0001 0000 205B 0000 0008
                  0000 001A 
          path 7FE11D04D200 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      57866 3356 8359 25513
        37.139.139.17 from 37.139.139.17 (37.139.139.17)
          Origin IGP, metric 0, localpref 100, valid, external
          Community: 0:199 3356:2 3356:22 3356:100 3356:123 3356:519 3356:903 3356:2094 8359:100 8359:5500 8359:55277 57866:100 65100:3356 65103:1 65104:31
          unknown transitive attribute: flag 0xE0 type 0x20 length 0x30
            value 0000 E20A 0000 0064 0000 0D1C 0000 E20A
                  0000 0065 0000 0064 0000 E20A 0000 0067
                  0000 0001 0000 E20A 0000 0068 0000 001F
                  
          path 7FE13BF04808 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      3549 3356 8359 25513
        208.51.134.254 from 208.51.134.254 (67.16.168.191)
          Origin IGP, metric 0, localpref 100, valid, external
          Community: 0:199 3356:2 3356:22 3356:100 3356:123 3356:519 3356:903 3356:2094 3549:2581 3549:30840 8359:100 8359:5500 8359:55277
          path 7FE08BBF8420 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 2
      2497 8359 25513
        202.232.0.2 from 202.232.0.2 (58.138.96.254)
          Origin IGP, localpref 100, valid, external
          path 7FE12C808870 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      101 3356 8359 25513
        209.124.176.223 from 209.124.176.223 (209.124.176.223)
          Origin IGP, localpref 100, valid, external
          Community: 0:199 101:20100 101:20110 101:22100 3356:2 3356:22 3356:100 3356:123 3356:519 3356:903 3356:2094 8359:100 8359:5500 8359:55277
          Extended Community: RT:101:22100
          path 7FE027DA7E28 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      4901 6079 8359 25513
        162.250.137.254 from 162.250.137.254 (162.250.137.254)
          Origin IGP, localpref 100, valid, external
          Community: 65000:10100 65000:10300 65000:10400
          path 7FE0AB654DE0 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      20130 6939 8359 25513
        140.192.8.16 from 140.192.8.16 (140.192.8.16)
          Origin IGP, localpref 100, valid, external
          path 7FE0D6585B60 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      852 3356 8359 25513
        154.11.12.212 from 154.11.12.212 (96.1.209.43)
          Origin IGP, metric 0, localpref 100, valid, external
          path 7FE12B518748 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      1351 8359 8359 25513
        132.198.255.253 from 132.198.255.253 (132.198.255.253)
          Origin IGP, localpref 100, valid, external
          path 7FE1777032A8 RPKI State not found
          rx pathid: 0, tx pathid: 0
      Refresh Epoch 1
      3303 8359 25513
        217.192.89.50 from 217.192.89.50 (138.187.128.158)
          Origin IGP, localpref 100, valid, external, best
          Community: 0:199 3303:1004 3303:1006 3303:1030 3303:3056 8359:100 8359:5500 8359:55277
          path 7FE011A64CA0 RPKI State not found
          rx pathid: 0, tx pathid: 0x0
      Refresh Epoch 1
      3257 3356 8359 25513
        89.149.178.10 from 89.149.178.10 (213.200.83.26)
          Origin IGP, metric 10, localpref 100, valid, external
          Community: 3257:8794 3257:30043 3257:50001 3257:54900 3257:54901
          path 7FE0F2D53388 RPKI State not found
          rx pathid: 0, tx pathid: 0


## 2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

    $ sudo ip link add dummy0 type dummy
    $ sudo ip addr add 10.2.2.2/32 dev dummy0
    $ sudo ip link set dummy0 up
    $ ip addr show type dummy
    7: dummy0: <BROADCAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
        link/ether 32:b1:e1:bd:39:1b brd ff:ff:ff:ff:ff:ff
        inet 10.2.2.2/32 scope global dummy0
           valid_lft forever preferred_lft forever
        inet6 fe80::30b1:e1ff:febd:391b/64 scope link 
           valid_lft forever preferred_lft forever
    $ sudo ip route add 8.8.8.8/32 via 10.0.2.2
    $ sudo ip route add 8.8.4.4/32 via 10.2.2.2
    $ ip route
    default via 10.0.2.2 dev eth0 proto dhcp src 10.0.2.15 metric 100 
    8.8.4.4 via 10.2.2.2 dev dummy0 
    8.8.8.8 via 10.0.2.2 dev eth0 
    10.0.2.0/24 dev eth0 proto kernel scope link src 10.0.2.15 
    10.0.2.2 dev eth0 proto dhcp scope link src 10.0.2.15 metric 100 
    10.0.222.0/24 dev eth0.222 proto kernel scope link src 10.0.222.2 
    192.168.56.0/24 dev bond0 proto kernel scope link src 192.168.56.4 

    


3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.


    $ sudo ss -tapn
    State    Recv-Q    Send-Q       Local Address:Port       Peer Address:Port    Process                                                  
    LISTEN   0         4096         127.0.0.53%lo:53              0.0.0.0:*        users:(("systemd-resolve",pid=678,fd=13))               
    LISTEN   0         128                0.0.0.0:22              0.0.0.0:*        users:(("sshd",pid=813,fd=3))                           
    ESTAB    0         0                10.0.2.15:22             10.0.2.2:48488    users:(("sshd",pid=1139,fd=4),("sshd",pid=1090,fd=4))   
    LISTEN   0         4096                     *:9100                  *:*        users:(("node_exporter",pid=752,fd=3))                  
    LISTEN   0         128                   [::]:22                 [::]:*        users:(("sshd",pid=813,fd=4))    


    22 порт - sshd 
    53 порт - DNS (systemd-resolver)
    9100 порт - использует node_exporter

4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?


    $ sudo ss -uapn
    State      Recv-Q     Send-Q          Local Address:Port          Peer Address:Port     Process                                        
    UNCONN     0          0               127.0.0.53%lo:53                 0.0.0.0:*         users:(("systemd-resolve",pid=678,fd=12))     
    UNCONN     0          0              10.0.2.15%eth0:68                 0.0.0.0:*         users:(("systemd-network",pid=636,fd=22))

    53 порт - под DNS (systemd-resolve)
    68 порт - DHCP клиент (systemd-network)

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 


*В качестве решения ответьте на вопросы, опишите, каким образом эти ответы были получены и приложите по неоходимости скриншоты*

 ---
 
## Задание для самостоятельной отработки* (необязательно к выполнению)

6. Установите Nginx, настройте в режиме балансировщика TCP или UDP.

7. Установите bird2, настройте динамический протокол маршрутизации RIP.

8. Установите Netbox, создайте несколько IP префиксов, используя curl проверьте работу API.
