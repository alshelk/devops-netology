#!/usr/bin/env python3

import json
import time
import datetime as dt
import os

def meminfo():
    mem = {}
    res = {}
    f = open('/proc/meminfo', 'r')
    lines = f.readlines()
    f.close()
    for line in lines:
        if len(line) < 2:
            continue
        name = line.split(':')[0]
        value = line.split(':')[1].split()[0]
        mem[name] = float(value)
    # Посчитаем используемую память
    mem['MemUsed'] = mem['MemTotal'] - mem['MemFree'] - mem['Buffers'] - mem['Cached']
    #собираем результат
    res['percent'] = int(round(mem['MemUsed'] / mem['MemTotal'] * 100))
    res['used'] = round(mem['MemUsed'] / (1024 * 1024), 2)
    res['MemTotal'] = round(mem['MemTotal'] / (1024 * 1024), 2)
    res['Buffers'] = round(mem['Buffers'] / (1024 * 1024), 2)
    return res

def loadavg():
    res = {}
    f = open("/proc/loadavg")
    lst = f.read().split()
    f.close()
    res['lavg_1']=lst[0]
    res['lavg_5']=lst[1]
    res['lavg_15']=lst[2]
    res['nr']=lst[3]
    prosess_list = res['nr'].split('/')
    res['running_prosess']=prosess_list[0]
    res['total_prosess']=prosess_list[1]
    res['last_pid']=lst[4]
    return res

def disk_size():
    hd={}
    res = {}
    disk = os.statvfs('/')
    hd['available'] = float(disk.f_bsize * disk.f_bavail)
    hd['capacity'] = float(disk.f_bsize * disk.f_blocks)
    hd['used'] = float((disk.f_blocks - disk.f_bfree) * disk.f_frsize)
    # собираем результат
    res['used'] = round(hd['used'] / (1024 * 1024 * 1024), 2)
    res['capacity'] = round(hd['capacity'] / (1024 * 1024 * 1024), 2)
    res['available'] = res['capacity'] - res['used']
    res['percent'] = int(round(float(res['used']) / res['capacity'] * 100))
    return res

def net_stat():
    res = {}
    f = open("/proc/net/dev")
    lines = f.readlines()
    f.close
    for line in lines[2:]:
        line = line.split(":")
        eth_name = line[0].strip()
        if eth_name != 'lo':
            net_data = {}
            net_data['received'] = round(float(line[1].split()[0]) / (1024.0 * 1024.0),2)
            net_data['transmited'] = round(float(line[1].split()[8]) / (1024.0 * 1024.0),2)
            res[eth_name] = net_data
    return res


pathlog = '/var/log/'

t = time.time()

data = {"timestamp": t}
data['memory'] = meminfo()
data['cpu'] = loadavg()
data['hd'] = disk_size()
data['net'] = net_stat()


# print(data)

with open(pathlog + dt.datetime.utcfromtimestamp(t).strftime("%y-%m-%d") + '-awesome-monitoring.log', 'a', encoding='utf-8') as f:
    json.dump(data, f, ensure_ascii=False, indent=None)
    f.write('\n')