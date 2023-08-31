# Домашнее задание к занятию "3.5. Файловые системы"

### 1. Узнайте о sparse (разряженных) файлах.

    Разрежённый файл (англ. sparse file) — файл, в котором последовательности нулевых байтов
    заменены на информацию об этих последовательностях (список дыр).

### 2. Могут ли файлы, являющиеся жесткой ссылкой на один объект, иметь разные права доступа и владельца? Почему?

    vagrant@vagrant:~/TEST$ ln newfile link_newfile
    vagrant@vagrant:~/TEST$ ll | grep newfile 
    -rw-r--r-- 2 vagrant vagrant    8 Nov 29 21:52 link_newfile
    -rw-r--r-- 2 vagrant vagrant    8 Nov 29 21:52 newfile
    vagrant@vagrant:~/TEST$ ls -li 
    total 8
    1324503 -rw-r--r-- 2 vagrant vagrant 8 Nov 29 21:52 link_newfile
    1324503 -rw-r--r-- 2 vagrant vagrant 8 Nov 29 21:52 newfile
    vagrant@vagrant:~/TEST$ find . -xdev -samefile newfile 
    ./link_newfile
    ./newfile
    vagrant@vagrant:~/TEST$ chmod 666 link_newfile 
    vagrant@vagrant:~/TEST$ ls -li
    total 8
    1324503 -rw-rw-rw- 2 vagrant vagrant 8 Nov 29 21:52 link_newfile
    1324503 -rw-rw-rw- 2 vagrant vagrant 8 Nov 29 21:52 newfile
    vagrant@vagrant:~/TEST$ sudo chown :root newfile 
    vagrant@vagrant:~/TEST$ ls -li
    total 8
    1324503 -rw-rw-rw- 2 vagrant root 8 Nov 29 21:52 link_newfile
    1324503 -rw-rw-rw- 2 vagrant root 8 Nov 29 21:52 newfile

    
    Жесткая ссылка - это отдельный файл, но ведет он к одному участку жесткого диска, где
    находятся данные файла. Значит жесткая ссылка имеет один и тот же идентификатор, что и исходный файл.
    Это видно выше. Inod является как идентификатором файла, так и тем что содержит в себе
    информацию о файле, такую как принадлежность к группе/владельцу и права доступа. По этому
    жесткая ссылка может иметь только те же права, что и основной файл.

### 3. Сделайте vagrant destroy на имеющийся инстанс Ubuntu. Замените содержимое Vagrantfile следующим:

    path_to_disk_folder = './disks'
    
    host_params = {
        'disk_size' => 2560,
        'disks'=>[1, 2],
        'cpus'=>2,
        'memory'=>2048,
        'hostname'=>'sysadm-fs',
        'vm_name'=>'sysadm-fs'
    }
    Vagrant.configure("2") do |config|
        config.vm.box = "bento/ubuntu-20.04"
        config.vm.hostname=host_params['hostname']
        config.vm.provider :virtualbox do |v|
    
            v.name=host_params['vm_name']
            v.cpus=host_params['cpus']
            v.memory=host_params['memory']
    
            host_params['disks'].each do |disk|
                file_to_disk=path_to_disk_folder+'/disk'+disk.to_s+'.vdi'
                unless File.exist?(file_to_disk)
                    v.customize ['createmedium', '--filename', file_to_disk, '--size', host_params['disk_size']]
                end
                v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', disk.to_s, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
            end
        end
        config.vm.network "private_network", type: "dhcp"
    end
***Данная конфигурация создаст новую виртуальную машину с двумя дополнительными неразмеченными дисками по 2.5 Гб.***

---
    vagrant@sysadm-fs:~$ sudo fdisk -l | grep sd
    Disk /dev/sda: 64 GiB, 68719476736 bytes, 134217728 sectors
    /dev/sda1     2048      4095      2048    1M BIOS boot
    /dev/sda2     4096   3149823   3145728  1.5G Linux filesystem
    /dev/sda3  3149824 134215679 131065856 62.5G Linux filesystem
    Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors


### 4. Используя fdisk, разбейте первый диск на 2 раздела: 2 Гб, оставшееся пространство.

    vagrant@sysadm-fs:~$ sudo fdisk -l /dev/sdb
    Disk /dev/sdb: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK   
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: gpt
    Disk identifier: AA07F4A1-1A00-AD4C-A288-3C8209F380D3
    
    Device       Start     End Sectors  Size Type
    /dev/sdb1     2048 4196351 4194304    2G Linux filesystem
    /dev/sdb2  4196352 5242846 1046495  511M Linux filesystem


### 5. Используя sfdisk, перенесите данную таблицу разделов на второй диск.

    vagrant@sysadm-fs:~$ sudo sfdisk -d /dev/sdb > part.sdb
    vagrant@sysadm-fs:~$ sudo sfdisk /dev/sdc < part.sdb

    
    vagrant@sysadm-fs:~$ sudo fdisk -l /dev/sdc
    Disk /dev/sdc: 2.51 GiB, 2684354560 bytes, 5242880 sectors
    Disk model: VBOX HARDDISK   
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 512 bytes
    Disklabel type: gpt
    Disk identifier: AA07F4A1-1A00-AD4C-A288-3C8209F380D3
    
    Device       Start     End Sectors  Size Type
    /dev/sdc1     2048 4196351 4194304    2G Linux filesystem
    /dev/sdc2  4196352 5242846 1046495  511M Linux filesystem


### 6. Соберите mdadm RAID1 на паре разделов 2 Гб.

    vagrant@sysadm-fs:~$ sudo mdadm --create --verbose /dev/md1 --level=1 --raid-devices=2 /dev/sdb1 /dev/sdc1
    mdadm: Note: this array has metadata at the start and
        may not be suitable as a boot device.  If you plan to
        store '/boot' on this device please ensure that
        your boot-loader understands md/v1.x metadata, or use
        --metadata=0.90
    mdadm: size set to 2094080K
    Continue creating array? y
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md1 started.
    vagrant@sysadm-fs:~$ cat /proc/mdstat 
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
    md1 : active raid1 sdc1[1] sdb1[0]
          2094080 blocks super 1.2 [2/2] [UU]


### 7. Соберите mdadm RAID0 на второй паре маленьких разделов.

    vagrant@sysadm-fs:~$ sudo mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/sdb2 /dev/sdc2
    mdadm: chunk size defaults to 512K
    mdadm: Defaulting to version 1.2 metadata
    mdadm: array /dev/md0 started.
    vagrant@sysadm-fs:~$ cat /proc/mdstat 
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
    md0 : active raid0 sdc2[1] sdb2[0]
          1041408 blocks super 1.2 512k chunks
          
    md1 : active raid1 sdc1[1] sdb1[0]
          2094080 blocks super 1.2 [2/2] [UU]


### 8. Создайте 2 независимых PV на получившихся md-устройствах.

    vagrant@sysadm-fs:~$ sudo pvcreate /dev/md0 /dev/md1
      Physical volume "/dev/md0" successfully created.
      Physical volume "/dev/md1" successfully created.
    vagrant@sysadm-fs:~$ sudo pvscan 
      PV /dev/sda3   VG ubuntu-vg       lvm2 [<62.50 GiB / 31.25 GiB free]
      PV /dev/md0                       lvm2 [1017.00 MiB]
      PV /dev/md1                       lvm2 [<2.00 GiB]
      Total: 3 [<65.49 GiB] / in use: 1 [<62.50 GiB] / in no VG: 2 [2.99 GiB]

### 9. Создайте общую volume-group на этих двух PV.

    vagrant@sysadm-fs:~$ sudo vgcreate vol_grp /dev/md0 /dev/md1
      Volume group "vol_grp" successfully created
    vagrant@sysadm-fs:~$ sudo vgdisplay 
      ...
      --- Volume group ---
      VG Name               vol_grp
      ...

### 10. Создайте LV размером 100 Мб, указав его расположение на PV с RAID0.

    vagrant@sysadm-fs:~$ sudo lvcreate -L 100M vol_grp /dev/md0
      Logical volume "lvol0" created.
    vagrant@sysadm-fs:~$ sudo vgs
      VG        #PV #LV #SN Attr   VSize   VFree 
      ubuntu-vg   1   1   0 wz--n- <62.50g 31.25g
      vol_grp     2   1   0 wz--n-  <2.99g  2.89g
    vagrant@sysadm-fs:~$ sudo lvs
      LV        VG        Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
      ubuntu-lv ubuntu-vg -wi-ao---- <31.25g                                                    
      lvol0     vol_grp   -wi-a----- 100.00m

### 11. Создайте mkfs.ext4 ФС на получившемся LV.

    vagrant@sysadm-fs:~$  sudo mkfs.ext4 /dev/vol_grp/lvol0 
    mke2fs 1.45.5 (07-Jan-2020)
    Creating filesystem with 25600 4k blocks and 25600 inodes
    
    Allocating group tables: done                            
    Writing inode tables: done                            
    Creating journal (1024 blocks): done
    Writing superblocks and filesystem accounting information: done


### 12. Смонтируйте этот раздел в любую директорию, например, /tmp/new.

    vagrant@sysadm-fs:~$ sudo mount /dev/vol_grp/lvol0 /tmp/new
    vagrant@sysadm-fs:~$ df -h | grep lvol0
    /dev/mapper/vol_grp-lvol0           93M   72K   86M   1% /tmp/new


### 13. Поместите туда тестовый файл, например wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz.

    vagrant@sysadm-fs:~$ sudo chown vagrant:vagrant /tmp/new/
    vagrant@sysadm-fs:~$ wget https://mirror.yandex.ru/ubuntu/ls-lR.gz -O /tmp/new/test.gz
    --2022-11-30 10:32:22--  https://mirror.yandex.ru/ubuntu/ls-lR.gz
    Resolving mirror.yandex.ru (mirror.yandex.ru)... 213.180.204.183, 2a02:6b8::183
    Connecting to mirror.yandex.ru (mirror.yandex.ru)|213.180.204.183|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 23668389 (23M) [application/octet-stream]
    Saving to: ‘/tmp/new/test.gz’
    
    /tmp/new/test.gz                  100%[============================================================>]  22.57M  4.38MB/s    in 5.3s    
    
    2022-11-30 10:32:27 (4.28 MB/s) - ‘/tmp/new/test.gz’ saved [23668389/23668389]
    vagrant@sysadm-fs:~$ ls /tmp/new/
    lost+found  test.gz


### 14. Прикрепите вывод lsblk.

    vagrant@sysadm-fs:~$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 61.9M  1 loop  /snap/core20/1328
    loop1                       7:1    0 67.2M  1 loop  /snap/lxd/21835
    loop3                       7:3    0 63.2M  1 loop  /snap/core20/1695
    loop4                       7:4    0 49.6M  1 loop  /snap/snapd/17883
    loop5                       7:5    0 91.8M  1 loop  /snap/lxd/23991
    sda                         8:0    0   64G  0 disk  
    ├─sda1                      8:1    0    1M  0 part  
    ├─sda2                      8:2    0  1.5G  0 part  /boot
    └─sda3                      8:3    0 62.5G  0 part  
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk  
    ├─sdb1                      8:17   0    2G  0 part  
    │ └─md1                     9:1    0    2G  0 raid1 
    └─sdb2                      8:18   0  511M  0 part  
      └─md0                     9:0    0 1017M  0 raid0 
        └─vol_grp-lvol0       253:1    0  100M  0 lvm   /tmp/new
    sdc                         8:32   0  2.5G  0 disk  
    ├─sdc1                      8:33   0    2G  0 part  
    │ └─md1                     9:1    0    2G  0 raid1 
    └─sdc2                      8:34   0  511M  0 part  
      └─md0                     9:0    0 1017M  0 raid0 
        └─vol_grp-lvol0       253:1    0  100M  0 lvm   /tmp/new


### 15. Протестируйте целостность файла:

    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
---
    протестировано:

    vagrant@sysadm-fs:~$ gzip -t /tmp/new/test.gz
    vagrant@sysadm-fs:~$ echo $?
    0


### 16. Используя pvmove, переместите содержимое PV с RAID0 на RAID1.

    vagrant@sysadm-fs:~$ sudo pvmove -i5 /dev/md0 /dev/md1
      /dev/md0: Moved: 20.00%
      /dev/md0: Moved: 100.00%

    vagrant@sysadm-fs:~$ lsblk
    NAME                      MAJ:MIN RM  SIZE RO TYPE  MOUNTPOINT
    loop0                       7:0    0 61.9M  1 loop  /snap/core20/1328
    loop1                       7:1    0 67.2M  1 loop  /snap/lxd/21835
    loop3                       7:3    0 63.2M  1 loop  /snap/core20/1695
    loop4                       7:4    0 49.6M  1 loop  /snap/snapd/17883
    loop5                       7:5    0 91.8M  1 loop  /snap/lxd/23991
    sda                         8:0    0   64G  0 disk  
    ├─sda1                      8:1    0    1M  0 part  
    ├─sda2                      8:2    0  1.5G  0 part  /boot
    └─sda3                      8:3    0 62.5G  0 part  
      └─ubuntu--vg-ubuntu--lv 253:0    0 31.3G  0 lvm   /
    sdb                         8:16   0  2.5G  0 disk  
    ├─sdb1                      8:17   0    2G  0 part  
    │ └─md1                     9:1    0    2G  0 raid1 
    │   └─vol_grp-lvol0       253:1    0  100M  0 lvm   /tmp/new
    └─sdb2                      8:18   0  511M  0 part  
      └─md0                     9:0    0 1017M  0 raid0 
    sdc                         8:32   0  2.5G  0 disk  
    ├─sdc1                      8:33   0    2G  0 part  
    │ └─md1                     9:1    0    2G  0 raid1 
    │   └─vol_grp-lvol0       253:1    0  100M  0 lvm   /tmp/new
    └─sdc2                      8:34   0  511M  0 part  
      └─md0                     9:0    0 1017M  0 raid0 


### 17. Сделайте --fail на устройство в вашем RAID1 md.

    vagrant@sysadm-fs:~$ sudo mdadm --fail /dev/md1 /dev/sdc1
    mdadm: set /dev/sdc1 faulty in /dev/md1
    vagrant@sysadm-fs:~$ cat /proc/mdstat 
    Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
    md0 : active raid0 sdc2[1] sdb2[0]
          1041408 blocks super 1.2 512k chunks
          
    md1 : active raid1 sdc1[1](F) sdb1[0]
          2094080 blocks super 1.2 [2/1] [U_]
          
    unused devices: <none>


### 18. Подтвердите выводом dmesg, что RAID1 работает в деградированном состоянии.

    vagrant@sysadm-fs:~$ dmesg | tail -n 2
    [50731.254065] md/raid1:md1: Disk failure on sdc1, disabling device.
                   md/raid1:md1: Operation continuing on 1 devices.


### 19. Протестируйте целостность файла, несмотря на "сбойный" диск он должен продолжать быть доступен:

    root@vagrant:~# gzip -t /tmp/new/test.gz
    root@vagrant:~# echo $?
    0
---
    тест успешен:

    vagrant@sysadm-fs:~$ gzip -t /tmp/new/test.gz
    vagrant@sysadm-fs:~$ echo $?
    0


### 20. Погасите тестовый хост, vagrant destroy.

    выполнено