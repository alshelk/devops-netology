# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

------

## Задание 1

Есть скрипт:
```python
#!/usr/bin/env python3
a = 1
b = '2'
c = a + b
```

### Вопросы:

| Вопрос  | Ответ                                                                                                                   |
| ------------- |-------------------------------------------------------------------------------------------------------------------------|
| Какое значение будет присвоено переменной `c`?  | значение не будет присвоенно, т.к. скрипт выдаст ошибку (TypeError: unsupported operand type(s) for +: 'int' and 'str') |
| Как получить для переменной `c` значение 12?  | c = str(a) + b                                                                                                          |
| Как получить для переменной `c` значение 3?  | c = a + int(b)                                                                                                          |

------

## Задание 2

Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. 

Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

```python
#!/usr/bin/env python3

import os

bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(prepare_result)
        break
```

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os

path = '~/netology/sysadm-homeworks/'
bash_command = ["cd "+path, "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '').strip()
        print(path+prepare_result)
```

### Вывод скрипта при запуске при тестировании:
```
~/netology/sysadm-homeworks/HW04_script_01_bash/README.md
~/netology/sysadm-homeworks/HW04_script_02_py/README.md
```

------

## Задание 3

Доработать скрипт выше так, чтобы он не только мог проверять локальный репозиторий в текущей директории, но и умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
from sys import argv

paths = []

if len(argv) == 1:
    print("Directories not defined. Check current directory", end="\n\n")
    paths = ["./"]
else:
    for i in range(1, len(argv)):
        if not os.path.isdir(argv[i]):
            print("Directory \"{}\" doesn't exist".format(argv[i]), end="\n\n")
        else:
            paths.append(argv[i])

if len(paths) == 0:
    print("Directories not defined correctly", end="\n\n")
else:
    git_top_levels = []
    for path in paths:
        git_top_command = ["cd "+path, "git rev-parse --show-toplevel 2>&1"]
        git_temp = os.popen(' && '.join(git_top_command)).read().replace('\n', '/')
        if git_temp.find('fatal') != -1:
            print("In \"{}\" {}".format(path, git_temp.replace('fatal: ','')), end="\n\n")
            continue

        if not git_temp in git_top_levels:
            git_top_levels.append(git_temp)

    for git_top_level in git_top_levels:
        bash_command = ["cd "+git_top_level, "git status"]
        result_os = os.popen(' && '.join(bash_command)).read()
        is_change = False
        for result in result_os.split('\n'):
            if result.find('изменено') != -1:
                prepare_result = result.replace('\tизменено:   ', '').strip()
                print(git_top_level+prepare_result)

```

### Вывод скрипта при запуске при тестировании:
```
------------------------------
Запуск скрипта с параметрами, когда хотя бы один параметр указывает на git репозиторий
------------------------------
$ HW04_script_02_py/test.py ~/netology/sysadm-homeworks/HW04_script_02_py ~/netology ~/32
Directory "/home/vagrant/32" doesn't exist

In "/home/vagrant/netology" не найден git репозиторий (или один из родительских каталогов): .git/

/home/vagrant/netology/sysadm-homeworks/HW04_script_01_bash/README.md
/home/vagrant/netology/sysadm-homeworks/HW04_script_02_py/README.md

------------------------------
Запуск скрипта с параметрами, когда не указан git репозиторий
------------------------------
$ HW04_script_02_py/test.py  ~/32
Directory "/home/vagrant/32" doesn't exist

Directories not defined correctly

------------------------------
Запуск скрипта без параметров
------------------------------
$ HW04_script_02_py/test.py
Directories not defined. Check current directory

/home/vagrant/netology/sysadm-homeworks/HW04_script_01_bash/README.md
/home/vagrant/netology/sysadm-homeworks/HW04_script_02_py/README.md

```

------

## Задание 4

Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. 

Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. 

Мы хотим написать скрипт, который: 
- опрашивает веб-сервисы, 
- получает их IP, 
- выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. 

Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: `drive.google.com`, `mail.google.com`, `google.com`.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import requests
import socket
import time

services = {'drive.google.com':'0.0.0.0', 'mail.google.com':'0.0.0.0', 'google.com/t':'0.0.0.0'}

while True:
    for name in services:

        # опрашивает веб-сервисы
        try:
            response = requests.get('https://'+name).status_code
        except Exception as e:
            print("Connection to {} Error. Technical Details given below.".format(name))
            print(e)
        else:
            if response != 200:
                print('Service {} have been unavailable. Status code: {}'.format(name, response))

        # Получаем ip
        try:
            ip = socket.gethostbyname(name)
        except Exception as e:
            print("Get ip for {} Error (2). Technical Details given below.".format(name))
            print(e)

        # проверка текущего IP сервиса c его IP из предыдущей проверкой
        if ip != services[name]:
            print('[ERROR] {} IP mismatch: {} {}'.format(name, services[name], ip))
            services[name] = ip
        else:
            # выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>.
            print(name+' - '+ip)

    time.sleep(5)
    print()

```

### Вывод скрипта при запуске при тестировании:
```
[ERROR] drive.google.com IP mismatch: 0.0.0.0 74.125.205.194
[ERROR] mail.google.com IP mismatch: 0.0.0.0 209.85.233.19
[ERROR] google.com IP mismatch: 0.0.0.0 142.250.150.113

drive.google.com - 74.125.205.194
[ERROR] mail.google.com IP mismatch: 209.85.233.19 209.85.233.83
[ERROR] google.com IP mismatch: 142.250.150.113 142.250.150.102

drive.google.com - 74.125.205.194
[ERROR] mail.google.com IP mismatch: 209.85.233.83 209.85.233.19
[ERROR] google.com IP mismatch: 142.250.150.102 142.250.150.100

```


```
drive.google.com - 64.233.165.194
[ERROR] mail.google.com IP mismatch: 209.85.233.83 209.85.233.19
Service google.com/t have been unavailable. Status code: 404
Get ip for google.com/t Error (2). Technical Details given below.
[Errno -2] Name or service not known
[ERROR] google.com/t IP mismatch: 209.85.233.83 209.85.233.19
```



------

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз: 
* переносить архив с нашими изменениями с сервера на наш локальный компьютер, 
* формировать новую ветку, 
* коммитить в неё изменения, 
* создавать pull request (PR) 
* и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. 

Мы хотим максимально автоматизировать всю цепочку действий. 
* Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым).
* При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. 
* С директорией локального репозитория можно делать всё, что угодно. 
* Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. 

Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 

### Ваш скрипт:
```python
???
```

### Вывод скрипта при запуске при тестировании:
```
???
```

----
