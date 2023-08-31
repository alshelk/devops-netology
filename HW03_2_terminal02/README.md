# Домашнее задание к занятию "3.2. Работа в терминале. Лекция 2"

### 1. Какого типа команда cd? Попробуйте объяснить, почему она именно такого типа: опишите ход своих мыслей, если считаете, что она могла бы быть другого типа.

    $ type cd
    cd is a shell builtin 

    т.е. cd является встроенной функцией оболочки. Она запускается в текущей оболочке для 
    смены каталогов, внутри запущенной сессии. Если бы вызывалась внешняя команда, то 
    она должна была быть выполнена в новой сессии и после ее выполнения произойдет закрытие
    сессии. Таким образом в текущей сессии рабочий каталог не изменится. 

    cd так же может быть двоичным файлом, например в FreeBSD:
    $ whereis cd
    cd: /usr/bin/cd /usr/share/man/man1/cd.1.gz
    Так же в OS X и Linux семейства Red Hat (возможно и в других ОС). Это связано с требованием POSIX
    что бы все встроенные команды вызывались командами семейства exec. (Ну по крайней мере я так это понял)
    И вот тут как раз отлично вписывается поведение запуска внешней команды cd которая сделает переход
    во вновь открытой для выполнения скрипта сессии, выполнит необходимые действия и когда сессия 
    закроется мы останемся в том каталоге в котором были до начала выполнения скрипта.



### 2. Какая альтернатива без pipe команде grep <some_string> <some_file> | wc -l?

    vagrant@vagrant:~$ grep Successfully /var/log/dmesg | wc -l
    4
    vagrant@vagrant:~$ grep -c Successfully /var/log/dmesg 
    4

***Ознакомьтесь с документом о других подобных некорректных вариантах использования pipe.***
    
    ознакомился

### 3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

    ответ systemd
    
    $ ps -p 1 -o comm=
    systemd

    хотя $ps -p 1 -u выдает
    USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
    root           1  0.0  1.2 168772 12892 ?        Ss   07:53   0:05 /sbin/init
    
    но /sbin/init всего лишь ссылка на systemd
    $ ls -la /sbin/init 
    lrwxrwxrwx 1 root root 20 Apr 21  2022 /sbin/init -> /lib/systemd/systemd

    $ pstree -p
    systemd(1)─┬─ModemManager(705)─┬─{ModemManager}(721)
               │                   └─{ModemManager}(726)
    ....

    раньше действительно init был родителем всех процессов но в 2010е годы он был заменен на systemd

    

### 4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?

    ответ:
    ls % 2>/dev/pts/X

    Первая сессия:
    vagrant@vagrant:~$ ls -l /proc/$$/fd/{0,1,2}
        lrwx------ 1 vagrant vagrant 64 Nov 17 19:55 /proc/2779/fd/0 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Nov 17 19:55 /proc/2779/fd/1 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Nov 17 19:55 /proc/2779/fd/2 -> /dev/pts/0
    vagrant@vagrant:~$ who
        vagrant  pts/0        2022-11-17 19:55 (10.0.2.2)
        vagrant  pts/2        2022-11-17 20:23 (10.0.2.2)
    vagrant@vagrant:~$ ls % 2>/dev/pts/2
    vagrant@vagrant:~$ 

    Вторая сессия:
    vagrant@vagrant:~$ ls -l /proc/$$/fd/{0,1,2}
        lrwx------ 1 vagrant vagrant 64 Nov 17 20:23 /proc/3050/fd/0 -> /dev/pts/2
        lrwx------ 1 vagrant vagrant 64 Nov 17 20:23 /proc/3050/fd/1 -> /dev/pts/2
        lrwx------ 1 vagrant vagrant 64 Nov 17 20:23 /proc/3050/fd/2 -> /dev/pts/2
    vagrant@vagrant:~$ ls: cannot access '%': No such file or directory


    


### 5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.

    $ echo 'test line' > testfile
    $ sed 's/test/new/'<testfile 1>newfile
    $ ls
        newfile  testfile
    $ cat newfile 
        new line
    $ cat testfile 
        test line

 

### 6. Получится ли, находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

    Да получится, но при обычном перенаправлении данные будут видны только в tty
    ---------------
    $ tty
    /dev/tty3
    $ Test from pty to tty
    ---------------
    $ tty
    /dev/pts/3
    $ echo Test from pty to tty >/dev/tty3
    $
    ---------------

    но можно воспользоваться командой tee что бы получить вывод сразу в tty и pty:
    echo Test from pty to tty | tee /dev/tty3 /dev/pts/1


### 7. Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?

    Команда "bash 5>&1" создаст файловый дескриптор 5 и направит вывод в то же место, куда направляется
    стандартный вывод файлового дескриптора 1 (stdout)
    $ ls -l /proc/$$/fd
        total 0
        lrwx------ 1 vagrant vagrant 64 Nov 17 20:45 0 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Nov 17 20:45 1 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Nov 17 20:45 2 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Nov 17 20:45 255 -> /dev/pts/0
        lrwx------ 1 vagrant vagrant 64 Nov 17 20:45 5 -> /dev/pts/0


    Команда выведет в активную сессию слово "netology", т.к. ранее был создан дескриптор 5 с перенаправлением
    вывода в терминал, в который был направлен вывод команды echo, а тот в свою очередь направит этот 
    вывод в терминал.
    $ echo netology > /proc/$$/fd/5
        netology



### 8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty?
***Напоминаем: по умолчанию через pipe передается только stdout команды слева от | на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.***

    $ (ls ; ls $) 6>&2 2>&1 1>&6 | grep access -c
    file  temp
    1


    

### 9. Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?
    
    Выведет переменные окружения, аналогичный по содержанию вывод можно получить выполнив команду env

### 10. Используя man, опишите что доступно по адресам /proc/<PID>/cmdline, /proc/<PID>/exe.

    /proc/<PID>/cmdline - Это доступный только для чтения файл, который содержит полную командную
    строку для процесса, кроме процессов зомби. В последнем случае (т.е. для процессов зомби),
    в файле ничего нет: это значит, что чтение этого файла вернет 0 символов. Аргументы командной 
    строки отображаются в этом файле как набор строк разделенных нулевыми байтами ('\0'), 
    с нулевым байтом после последней строки.

    /proc/<PID>/exe - В Linux 2.2 и позднее, этот файл является символической ссылкой содержащей 
    путь к выполняемой команде. Эта ссылка может быть разыменована; попытка открыть его откроет 
    исполняемы файл...
    

### 11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo.

    sse4_2

    $ cat /proc/cpuinfo  | grep sse
        flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 
        clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology 
        nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic 
        popcnt aes xsave avx rdrand hypervisor lahf_lm pti fsgsbase md_clear flush_l1d
        flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 
        clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology 
        nonstop_tsc cpuid tsc_known_freq pni pclmulqdq ssse3 cx16 pcid sse4_1 sse4_2 x2apic 
        popcnt aes xsave avx rdrand hypervisor lahf_lm pti fsgsbase md_clear flush_l1d        

### 12. При открытии нового окна терминала и vagrant ssh создается новая сессия и выделяется pty. Это можно подтвердить командой tty, которая упоминалась в лекции 3.2.
***Однако:***

*vagrant@netology1:~$ ssh localhost 'tty'*

*not a tty*

***Почитайте, почему так происходит, и как изменить поведение.***

    это происходит потому, что мы пытаемся выполнить команду tty в неинтерактивном режиме. В таком
    режиме ssh работает без выделения tty. Флаг -t и -tt можно использовать для переопределения 
    этого поведения для неинтерактивного режима.
    
    man ssh
    ...
    -t      Force pseudo-terminal allocation.  This can be used to execute arbitrary screen-based
             programs on a remote machine, which can be very useful, e.g. when implementing menu 
             services.  Multiple -t options force tty allocation, even if ssh has no local tty.
    ...

    vagrant@vagrant:~$ ssh localhost -t 'tty'
    vagrant@localhost's password: 
    /dev/pts/1
    Connection to localhost closed.


### 13. Бывает, что есть необходимость переместить запущенный процесс из одной сессии в другую. Попробуйте сделать это, воспользовавшись reptyr. Например, так можно перенести в screen процесс, который вы запустили по ошибке в обычной SSH-сессии.

    запускаем
    $ top

    top - 21:54:02 up  3:14,  1 user,  load average: 0.03, 0.03, 0.01
    Tasks: 105 total,   1 running, 104 sleeping,   0 stopped,   0 zombie
    %Cpu(s):  0.2 us,  0.0 sy,  0.0 ni, 99.7 id,  0.0 wa,  0.0 hi,  0.2 si,  0.0 st
    MiB Mem :    976.6 total,    381.0 free,    137.1 used,    458.5 buff/cache
    MiB Swap:   1953.0 total,   1953.0 free,      0.0 used.    697.4 avail Mem 

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND                                                         
    2511 root      20   0       0      0      0 I   0.3   0.0   0:00.16 kworker/u4:1-events_power_efficient                             
    2557 vagrant   20   0    9232   3888   3244 R   0.3   0.4   0:00.06 top                                                             
    
    переводим top в фоновый режим
    ^Z 

    $ bg
    [1]+ top &
    $ jobs -l
    [1]+  2557 Stopped (signal)        top

    отключаем top от текущего родителя
    $ disown top
    -bash: warning: deleting stopped job 1 with process group 2557
    $ tty
    /dev/pts/0
    $ ps -a | grep top
    2557 pts/0    00:00:00 top
    
    запускаем screen
    $ screen
    $ reptyr 2557
    
    получаем top в новой сессии
    
    $ ps -aux | grep top
    vagrant     2557  0.0  0.3   9232  3952 pts/2    Ss+  21:53   0:00 top
    vagrant     2576  0.0  0.0      0     0 pts/0    Z    22:02   0:00 [top] <defunct>
    vagrant     2581  0.0  0.0   6300   720 pts/0    S+   22:03   0:00 grep --color=auto top

    
### 14. *sudo echo string > /root/new_file* не даст выполнить перенаправление под обычным пользователем, так как перенаправлением занимается процесс shell'а, который запущен без sudo под вашим пользователем. Для решения данной проблемы можно использовать конструкцию echo string | sudo tee /root/new_file. Узнайте? что делает команда tee и почему в отличие от sudo echo команда с sudo tee будет работать.

    man tee
        tee - read from standard input and write to standard output and files (читает стандартный 
        вход и пишет в стандартный выход или файлы)
        
    sudo tee - будет работать, т.к. программа для записи будет запущенна с правами суперпользователя