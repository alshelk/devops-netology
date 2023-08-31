#!/usr/bin/env python3

import requests
import socket
import time
import json

services = {"drive.google.com": "0.0.0.0", "mail.google.com": "0.0.0.0", "google.com": "0.0.0.0"}


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
