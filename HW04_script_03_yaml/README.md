# Домашнее задание к занятию "Языки разметки JSON и YAML"

------

## Задание 1

Мы выгрузили JSON, который получили через API запрос к нашему сервису:

```
    { "info" : "Sample JSON output from our service\t",
        "elements" :[
            { "name" : "first",
            "type" : "server",
            "ip" : 7175 
            }
            { "name" : "second",
            "type" : "proxy",
            "ip : 71.78.22.43
            }
        ]
    }
```
  Нужно найти и исправить все ошибки, которые допускает наш сервис

### Ваш скрипт:
```
{ 
        "info": "Sample JSON output from our service\t",
        "elements": [
            { 
                "name": "first",
                "type": "server",
                "ip": 7175 
            },
            { 
                "name": "second",
                "type": "proxy",
                "ip": "71.78.22.43"
            }
        ]
}
```

---

## Задание 2

В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: `{ "имя сервиса" : "его IP"}`. Формат записи YAML по одному сервису: `- имя сервиса: его IP`. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.

### Ваш скрипт:
```python
#!/usr/bin/env python3

import requests
import socket
import time
import json
import yaml


with open("services.json", "r") as file:
    services = json.load(file)


#with open("services.yaml", "r") as file:
#    services = yaml.safe_load(file)

while True:

    for srvc in services:

        name = next(iter(srvc))

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
        if ip != srvc[name]:
            print('[ERROR] {} IP mismatch: {} {}'.format(name, srvc[name], ip))
            srvc[name] = ip

            with open("services.json", "w") as file:
                json.dump(services, file, indent=4)

            print('New ip was written in file services.json')


            with open("services.yaml", "w") as file:
                yaml.dump(services, file, explicit_start=True, explicit_end=True)
            print('New ip was written in file services.yaml')


        else:
            # выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>.
            print(name+' - '+ip)


    time.sleep(5)
    print()

```

### Вывод скрипта при запуске при тестировании:
```
drive.google.com - 173.194.220.194
mail.google.com - 64.233.161.19
google.com - 173.194.73.113

drive.google.com - 173.194.220.194
mail.google.com - 64.233.161.19
[ERROR] google.com IP mismatch: 173.194.73.113 173.194.222.139
New ip was written in file services.json
New ip was written in file services.yaml

drive.google.com - 173.194.220.194
mail.google.com - 64.233.161.19
google.com - 173.194.222.139
```

### json-файл(ы), который(е) записал ваш скрипт:
```json
[
    {
        "drive.google.com": "173.194.220.194"
    },
    {
        "mail.google.com": "64.233.161.19"
    },
    {
        "google.com": "173.194.222.139"
    }
]
```

### yml-файл(ы), который(е) записал ваш скрипт:
```yaml
---
- drive.google.com: 173.194.220.194
- mail.google.com: 64.233.161.19
- google.com: 173.194.222.139
...
```

---

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
   * Принимать на вход имя файла
   * Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
   * Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
   * Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
   * При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
   * Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

### Ваш скрипт:
```python
#!/usr/bin/env python3

import os
from sys import argv
import json
import yaml

file_formats = ['json', 'yaml', 'yml']

# Принимать на вход имя файла
fname = argv[1]

# Проверять формат исходного файла. Если файл не json или yaml - скрипт должен остановить свою работу
frm = fname[fname.rfind('.')+1:]
path = fname[:fname.rfind('.')+1]
if frm not in file_formats:
    print('File format is wrong! Enter the correct file')
    exit()

# Распознавать какой формат данных в файле.
with open(fname) as f:
    content = f.read()
f_cont = content.strip()
if f_cont[0] == "{" or f_cont[0] == "[":
    if frm != 'json':
        frm = 'json'
        os.rename(fname, path + frm)
        print('File format does not match the specified. This file has been renamed')

# При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
    try:
        j_file = json.loads(f_cont)
    except json.decoder.JSONDecodeError as e:
        print('Error in file {}. {}'.format(path + frm, e))
        print('Correct the errors in the file and try again')
        exit()

# Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
# Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов
    with open(fname[:fname.rfind('.')+1]+"yaml", "w") as f:
        yaml.safe_dump(j_file, f, explicit_start=True, explicit_end=True)

    print('File was reformatted successfully')
else:
    if frm not in file_formats[1:]:
        frm = 'yaml'
        os.rename(fname, fname[:fname.rfind('.') + 1] + frm)
        print('File format does not match the specified. The file has been renamed')

# При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
    try:
        y_file = yaml.safe_load(f_cont)
    except yaml.scanner.ScannerError as e:
        print('Error in file {}. {}'.format(path + frm, e))
        print('Correct the errors in the file and try again')
        exit()

# Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
# Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов
    with open(fname[:fname.rfind('.') + 1] + "json", "w") as f:
        json.dump(y_file, f, indent=2)
    print('File was reformatted successfully')
```

### Пример работы скрипта:
$ ./test.py test.yaml
file format matches the specified
Error in file test.yaml. mapping values are not allowed here
  in "<unicode string>", line 3, column 5:
    - ip: 7175

$ ./test.py test3.json
File format does not match the specified. The file has been renamed
File was reformatted successfully

$ ./test.py test2.yaml
File was reformatted successfully

----