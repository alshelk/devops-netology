# Домашнее задание к занятию 4 «Работа с roles»

## Подготовка к выполнению

1. * Необязательно. Познакомьтесь с [LightHouse](https://youtu.be/ymlrNlaHzIY?t=929).
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю на GitHub.

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.11.0"
       name: clickhouse 
   ```


[requirements.yml](playbook%2Frequirements.yml):

```bash
$ cat requirements.yml 
---
- src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
  scm: git
  version: "1.11.0"
  name: clickhouse
```


2. При помощи `ansible-galaxy` скачайте себе эту роль.


```bash
$ ansible-galaxy install -r requirements.yml -p roles
Starting galaxy role install process
- extracting clickhouse to /netology_data/HW08-ansible-04-role/playbook/roles/clickhouse
- clickhouse (1.11.0) was installed successfully
$ ls roles/
clickhouse

```

3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.

```bash
$ ansible-galaxy role init vector-role
- Role vector-role was created successfully
$ ls
playbook  README.md  terraform  vector-role

```

[vector-role](vector-role)

4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`.


[vector-role/tasks/main.yml](vector-role%2Ftasks%2Fmain.yml):

```yaml
---
- block:
  - name: Create temp directory
    ansible.builtin.file:
      path: "{{ temp_dir }}"
      state: directory
  - name: Get vector distrib
    ansible.builtin.get_url:
      url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-x86_64-unknown-linux-musl.tar.gz"
      dest: "{{ temp_dir }}/vector-{{ vector_version }}.tar.gz"
  - name: Create root directory
    ansible.builtin.file:
      path: "{{ temp_dir }}/vector-{{ vector_version }}"
      state: directory
  - name: Extract vector
    ansible.builtin.unarchive:
      src: "{{ temp_dir }}/vector-{{ vector_version }}.tar.gz"
      dest: "{{ temp_dir }}/vector-{{ vector_version }}/"
      extra_opts: [--strip-components=2]
      remote_src: yes
    when: not ansible_check_mode
- block:
  - name: Copy vector to bin with owner and permissions
    ansible.builtin.copy:
      src: "{{ temp_dir }}/vector-{{ vector_version }}/bin/vector"
      dest: /usr/bin/vector
      mode: '0755'
      remote_src: true
    when: not ansible_check_mode
  - name: Configure vector.service from template
    ansible.builtin.template:
      src: vector.service.j2
      dest: /etc/systemd/system/vector.service
      mode: 0644
    tags:
      - vector_service
  - name: create config dir for vector
    ansible.builtin.file:
      path: "{{ vector_config_dir }}"
      state: directory
      mode: 0644
  - name: Configure vector from template
    ansible.builtin.template:
      src: vector.yml.j2
      dest: "{{ vector_config_dir }}/vector.yml"
      mode: 0644
  - name: Create data directory
    ansible.builtin.file:
      path: "{{ vector_config.data_dir }}"
      state: directory
  become: true
  notify: restarted vector service
- name: Flush handlers
  meta: flush_handlers
```

[vector-role/default/main.yml](vector-role%2Fdefaults%2Fmain.yml):

```yaml
---
vector_version: "0.29.1"
ip_clickhouse: 127.0.0.1
port_clickhouse: 8123
vector_config:
  data_dir: /var/lib/vector
  sources:
    sample_file:
      type: file
      read_from: beginning
      ignore_older_secs: 600
      include:
        - /var/log/**/*.log
    vector_log:
      type: internal_logs
  sinks:
    to_clickhouse:
      type: clickhouse
      inputs:
        - sample_file
      endpoint: http://{{ ip_clickhouse }}:{{ port_clickhouse }}
      database: logs
      table: local_log
      skip_unknown_fields: true
      compression: gzip
```

[vector-role/vars/main.yml](vector-role%2Fvars%2Fmain.yml):

```yaml
---
# vars file for vector-role
vector_config_dir: "/etc/vector"
temp_dir: "/tmp/vector"

```

5. Перенести нужные шаблоны конфигов в `templates`.

[vector-role/templates](vector-role%2Ftemplates):

```bash
$ ls vector-role/templates/
vector.service.j2  vector.yml.j2
```

6. Опишите в `README.md` обе роли и их параметры.



- vector-role устанавливает Vector с возможностью указания версии. Так же, возможно указать 
ip адрес и порт где слушает clickhouse. Или же полностью прописать конфиг.


[vector-role/README.md](vector-role%2FREADME.md):

```text
Vector
=========

This role install Vector

Role Variables
--------------

|vars| description                       | default   |
|------|-----------------------------------|-----------|
| vector_version | Version of Vector to install      | 0.29.1    |
| ip_clickhouse | Ip address of deployed clickhouse | 127.0.0.1 |
| port_clickhouse | Connection port to clickhouse     | 8123      |
| vector_config | Vector config file in yaml format |       |




Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:


- name: Vector role 
  hosts: servers
  vars:
    vector_version: "0.29.1"
    vector_config:
      data_dir: /var/lib/vector
      sources:
        sample_file:
          type: file
          read_from: beginning
          ignore_older_secs: 600
          include:
            - /var/log/**/*.log
        vector_log:
          type: internal_logs
      sinks:
        to_clickhouse:
          type: clickhouse
          inputs:
            - sample_file
          endpoint: http://127.0.0.1:8123
          database: logs
          table: local_log
          skip_unknown_fields: true
          compression: gzip
  roles:
    - role: vector


License
-------

MIT

Author Information
------------------

Aleksey Shelkovin


```


- Роль clickhouse устанавливает Clickhouse. Ее параметры подробно описаны в [README.md](https://github.com/AlexeySetevoi/ansible-clickhouse/blob/master/README.md)
который прилагается к роли. Если вкратце, то возможно указать версию, порты и ip адрес, которые слушает
clickhouse, создать собственный profile, создать пользователей, управлять квотами, создавать базы и словари.

7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.

- [lighthouse-role](lighthouse-role):

```bash
$ cat ../lighthouse-role/tasks/main.yml 
---
- block:
  - name: Get lighthouse from git
    ansible.builtin.git:
      repo: 'https://github.com/VKCOM/lighthouse.git'
      dest: "{{ lighthouse_home_dir }}"
    when: not ansible_check_mode
  - name: Configure nginx for lighthouse
    ansible.builtin.template:
      src: lighthouse.conf.j2
      dest: "{{ nginx_config_dir }}/conf.d/default.conf"
  become: true
  notify: restarted nginx service
- name: Flush handlers
  meta: flush_handlers
  
$ cat ../lighthouse-role/defaults/main.yml 
---
lighthouse_home_dir: "/usr/share/nginx/html/lighthouse"

$ cat ../lighthouse-role/templates/lighthouse.conf.j2 
server {
    listen       80;
    server_name  localhost;

    location / {
        root   {{ lighthouse_home_dir }};
        index  index.html index.htm;
    }

    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

}



```

[lighthouse-role/README.md](lighthouse-role%2FREADME.md)


- [nginx-role](nginx-role):

```bash
$ cat ../nginx-role/tasks/main.yml 
---
# tasks file for nginx-role
- block:
  - name: add repo nginx
    ansible.builtin.copy:
      dest: /etc/yum.repos.d/nginx.repo
      mode: '0755'
      content: |
        [nginx]
        name=nginx repo
        baseurl=https://nginx.org/packages/centos/$releasever/$basearch/
        gpgcheck=0
        enabled=1
  - name: install nginx
    ansible.builtin.yum:
      name: nginx
      state: latest
      update_cache: yes
    when: not ansible_check_mode
  - name: Configure nginx from template
    ansible.builtin.template:
      src: nginx.conf.j2
      dest: "{{ nginx_config_dir }}/conf.d/default.conf"
  become: true
  notify: restarted nginx service
- name: Flush handlers
  meta: flush_handlers

$ cat ../nginx-role/vars/main.yml 
---
# vars file for nginx-role
nginx_config_dir: "/etc/nginx"


```

[nginx-role/README.md](nginx-role%2FREADME.md)

8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---