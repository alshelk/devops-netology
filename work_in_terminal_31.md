# Домашнее задание к занятию "3.1. Работа в терминале. Лекция 1"

### 1. С помощью базового файла конфигурации запустите Ubuntu 20.04 в VirtualBox посредством Vagrant:

    $ vagrant ssh
    Welcome to Ubuntu 20.04.4 LTS (GNU/Linux 5.4.0-110-generic x86_64)

     * Documentation:  https://help.ubuntu.com
     * Management:     https://landscape.canonical.com
     * Support:        https://ubuntu.com/advantage

      System information as of Tue 15 Nov 2022 07:50:33 PM UTC

      System load:  0.0                Processes:             117
      Usage of /:   11.9% of 30.63GB   Users logged in:       0
      Memory usage: 21%                IPv4 address for eth0: 10.0.2.15
      Swap usage:   0%


    This system is built by the Bento project by Chef Software
    More information can be found at https://github.com/chef/bento
    Last login: Tue Nov 15 18:43:26 2022 from 10.0.2.2


### 2. Ознакомьтесь с графическим интерфейсом VirtualBox, посмотрите как выглядит виртуальная машина, которую создал для вас Vagrant, какие аппаратные ресурсы ей выделены. Какие ресурсы выделены по-умолчанию?

    Виртуальная машина по умолчанию получила имя vagrant_default_(два набора цифр)

    Ей было выделено:
    - 1024 Мб оперативки
    - 2 процессора
    - vmdk диск на 64 Гб
    - видео память 4 Мб
    - примонтирована общая папка 
    - создана виртуальная сеть  

    подключиться к машине можно через vagrant ssh или по localhost:2222

### 3. Ознакомьтесь с возможностями конфигурации VirtualBox через Vagrantfile: документация. Как добавить оперативной памяти или ресурсов процессора виртуальной машине?

    Для изменения параметров виртуальной машины, в Vagrantfile нужно добавить следующую запись:

    config.vm.provider "virtualbox" do |vb|
      # Этот параметр позволит настроить память на виртуальной машине:
      vb.memory = "1024"

      # А этот указать количеств процессоров:
      v.cpus = 2
    end



### 4. Команда vagrant ssh из директории, в которой содержится Vagrantfile, позволит вам оказаться внутри виртуальной машины без каких-либо дополнительных настроек. Попрактикуйтесь в выполнении обсуждаемых команд в терминале Ubuntu.
    
    vagrant@vagrant:~$ history 
    1  exit
    2  man bash
    3  exit
    4  history
    5  echo Hello world
    6  echo $USER
    7  $SHELL --version
    8  new_variable=new_text
    9  read var1 var1
    10  echo new_variable
    11  new_variable
    12  echo $new_variable
    13  echo $var
    14  echo $var1
    15  read var1 var2
    16  echo $var1 $var2
    17  history
    18  whoami
    19  env
    20  pwd
    21  cd /home/vagrant/
    22  ls -la
    23  history 
    24  head /var/log/dmesg
    25  tail /var/log/dmesg
    26  less /var/log/dmesg
    27  cat /var/log/dmesg | grep OS
    28  grep -r 46 /var/log/dmesg
    29  grep -r :46: /var/log/dmesg
    30  ls
    31  mkdir test
    32  touch test/test.file
    33  mv test test2
    34  rm -r test2
    35  ls
    36  mkdir test
    37  rm test
    38  rm -r test
    39  history 


### 5. Ознакомьтесь с разделами man bash, почитайте о настройках самого bash:
***какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?***
    
    Переменная HISTSIZE
    Manual page bash(1) line 658
    vagrant@vagrant:~$ echo $HISTSIZE
    1000

***что делает директива ignoreboth в bash?***
    
    
    ignoreboth - директива переменной HISTCONTROL и является сокращение для ignorespace и 
        ignoredups. Т.е. строки начинающиеся с символа пробела не сохраняются в списке 
        истории и строки дублирующие предыдущую запись тоже не сохраняются в истории.

### 6. В каких сценариях использования применимы скобки {} и на какой строчке man bash это описано?

    {}:
    зарезервированное слово (Manual page bash(1) line 127/3554 4%), 
    список (Manual page bash(1) line 212/3554),
    ограничение тела функции (Manual page bash(1) line 316/3554),
    используется в условных циклах и операторах, в массивах (Manual page bash(1) line 796/3554 25%)
    

### 7. С учётом ответа на предыдущий вопрос, как создать однократным вызовом touch 100000 файлов? Получится ли аналогичным образом создать 300000? Если нет, то почему?

    touch file{1..100000} 
    но если сделать имя файла длиннее, или увеличить количество файлов то появится ошибка: 
        
    -bash: /usr/bin/touch: Argument list too long
    
    это значит что была превышена максимальная длина строки:
    
    $ getconf ARG_MAX
    2097152

    но можно обойти ограничение например так 

    echo f{1..300000} | xargs -n 100000 touch


### 8. В man bash поищите по /\\[\\[. Что делает конструкция [[ -d /tmp ]]

    Manual page bash(1) line 1415
    CONDITIONAL EXPRESSIONS
    
    [[ -d /tmp ]] аналогично команде (test -d /tmp) проверяет существование директории /tmp

    ДОПОЛНЕНИЕ!!!
    условие вернет истину (True) в случае bash  - True = 0 (или -1). Это связано с тем что успешное 
    выполнение приложения ничего не возвращает, а если выполнение завершилось ошибкой, то
    возвращает номер ошибки больше 0.

    

### 9. Сделайте так, чтобы в выводе команды type -a bash первым стояла запись с нестандартным путем, например bash is ... Используйте знания о просмотре существующих и создании новых переменных окружения, обратите внимание на переменную окружения PATH

***bash is /tmp/new_path_directory/bash***

***bash is /usr/local/bin/bash***

***bash is /bin/bash***

***(прочие строки могут отличаться содержимым и порядком) В качестве ответа приведите команды, которые позволили вам добиться указанного вывода или соответствующие скриншоты.***

    vagrant@vagrant:~/temp$ type -a bash
        bash is /usr/bin/bash
        bash is /bin/bash
    vagrant@vagrant:~/temp$ echo $PATH
        /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
    vagrant@vagrant:~/temp$ mkdir /tmp/new_path_directory
    vagrant@vagrant:~/temp$ cp /bin/bash /tmp/new_path_directory/
    vagrant@vagrant:~/temp$ export PATH=/tmp/new_path_directory:$PATH
    vagrant@vagrant:~/temp$ echo $PATH
        /tmp/new_path_directory:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
    vagrant@vagrant:~/temp$ type -a bash
        bash is /tmp/new_path_directory/bash
        bash is /usr/bin/bash
        bash is /bin/bash


### 10. Чем отличается планирование команд с помощью batch и at?

    взято из man at:

    at - выполняет команду в указанное время

    batch - выполняет команды, когда позволяют уровни загрузки системы; другими словами,
    когда среднее значение нагрузки падает ниже 1.5 или значения, указанного при вызове atd

### 11. Завершите работу виртуальной машины чтобы не расходовать ресурсы компьютера и/или батарею ноутбука.
    
    vagrant halt