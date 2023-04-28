# Домашнее задание к занятию 2 «Работа с Playbook»

## Подготовка к выполнению

1. * Необязательно. Изучите, что такое [ClickHouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [Vector](https://www.youtube.com/watch?v=CgEhyffisLY).
2. Создайте свой публичный репозиторий на GitHub с произвольным именем или используйте старый.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

## Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.

[prod.tftpl](terraform%2Fprod.tftpl):

```bash
$ cat ../terraform/prod.tftpl 
---
clickhouse:
  hosts:
    clickhouse-01:
      ansible_host: ${webservers}
      ansible_user: ${user}
vector:
  hosts:
    vector-01:
      ansible_host: ${webservers}
      ansible_user: ${user}
```

[invent_ansible.tf](terraform%2Finvent_ansible.tf):
```bash
$ cat ../terraform/invent_ansible.tf 

resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/prod.tftpl",
    { webservers = yandex_compute_instance.platform.network_interface[0].nat_ip_address,
      user = var.vm_metadata.ssh-user }
  )

  filename = "${abspath(path.module)}/../playbook/inventory/prod.yml"
}

```


2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev).


[playbook](playbook)


3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.

```yaml
- name: Install Vector manual
  hosts: vector
  handlers:
    - name: restarted vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: restarted
  tasks:
    - block:
      - name: Get vector distrib
        ansible.builtin.get_url:
          url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-x86_64-unknown-linux-musl.tar.gz"
          dest: "{{ home_dir }}/vector-{{ vector_version }}.tar.gz"
      - name: Create root directory
        ansible.builtin.file:
          path: "{{ home_dir }}/vector-{{ vector_version }}"
          state: directory
      - name: Extract vector
        ansible.builtin.unarchive:
          src: "{{ home_dir }}/vector-{{ vector_version }}.tar.gz"
          dest: "{{ home_dir }}/vector-{{ vector_version }}/"
          extra_opts: [--strip-components=2]
          remote_src: yes
    - block:
      - name: Copy vector to bin with owner and permissions
        ansible.builtin.copy:
          src: "{{ home_dir }}/vector-{{ vector_version }}/bin/vector"
          dest: /usr/bin/vector
          mode: '0755'
          remote_src: true
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

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```bash
$ ansible-lint site.yml 
[204] Lines should be no longer than 160 chars
../playbook/site.yml:38
      ansible.builtin.command: "clickhouse-client -q 'create table logs.local_log (file String, hostname String, message String, timestamp DateTime) Engine=Log;'"

$ ansible-lint site.yml 
$

```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

```bash
$ ansible-playbook -i inventory/prod.yml site.yml --check

PLAY [Install Clickhouse] ********************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
The authenticity of host '51.250.15.79 (51.250.15.79)' can't be established.
ECDSA key fingerprint is SHA256:EzlunMSA88N3QgmHsRRhTm6u/+wbl2R5LQdAvU/VJFc.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ****************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ****************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] ***********************************************************************************************************************************************************
fatal: [clickhouse-01]: FAILED! => {"changed": false, "msg": "No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system", "rc": 127, "results": ["No RPM file matching 'clickhouse-common-static-22.3.3.44.rpm' found on system"]}

PLAY RECAP ***********************************************************************************************************************************************************************************
clickhouse-01              : ok=2    changed=1    unreachable=0    failed=1    skipped=0    rescued=1    ignored=0   

```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

```bash
$ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] ********************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ****************************************************************************************************************************************************************
changed: [clickhouse-01] => (item=clickhouse-client)
changed: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "item": "clickhouse-common-static", "msg": "Request failed", "response": "HTTP Error 404: Not Found", "status_code": 404, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ****************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Install clickhouse packages] ***********************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Flush handlers] ************************************************************************************************************************************************************************

RUNNING HANDLER [Start clickhouse service] ***************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create database] ***********************************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Create table] **************************************************************************************************************************************************************************
changed: [clickhouse-01]

PLAY [Install Vector manual] *****************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] ********************************************************************************************************************************************************************
changed: [vector-01]

TASK [Create root directory] *****************************************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/home/centos/vector-0.29.1",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector-01]

TASK [Extract vector] ************************************************************************************************************************************************************************
changed: [vector-01]

TASK [Copy vector to bin with owner and permissions] *****************************************************************************************************************************************
changed: [vector-01]

TASK [Configure vector.service from template] ************************************************************************************************************************************************
--- before
+++ after: /home/vagrant/.ansible/tmp/ansible-local-58234653dop4b/tmpeygmahli/vector.service.j2
@@ -0,0 +1,22 @@
+[Unit]
+Description=Vector Service
+Documentation=https://vector.dev
+After=network-online.target
+Requires=network-online.target
+
+[Service]
+User=root
+Group=root
+ExecStartPre=/usr/bin/vector validate --config-yaml /etc/vector/vector.yml
+ExecStart=/usr/bin/vector --config-yaml /etc/vector/vector.yml
+ExecReload=/usr/bin/vector validate --config-yaml /etc/vector/vector.yml
+ExecReload=/bin/kill -HUP $MAINPID
+Restart=always
+AmbientCapabilities=CAP_NET_BIND_SERVICE
+EnvironmentFile=-/etc/default/vector
+# Since systemd 229, should be in [Unit] but in order to support systemd <229,
+# it is also supported to have it here.
+StartLimitInterval=10
+StartLimitBurst=5
+[Install]
+WantedBy=multi-user.target

changed: [vector-01]

TASK [create config dir for vector] **********************************************************************************************************************************************************
--- before
+++ after
@@ -1,5 +1,5 @@
 {
-    "mode": "0755",
+    "mode": "0644",
     "path": "/etc/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector-01]

TASK [Configure vector from template] ********************************************************************************************************************************************************
--- before
+++ after: /home/vagrant/.ansible/tmp/ansible-local-58234653dop4b/tmpvbgy8xb9/vector.yml.j2
@@ -0,0 +1,19 @@
+---
+data_dir: /var/lib/vector
+sinks:
+    to_clickhouse:
+        compression: gzip
+        database: logs
+        endpoint: http://localhost:8123
+        inputs:
+        - sample_file
+        skip_unknown_fields: true
+        table: local_log
+        type: clickhouse
+sources:
+    sample_file:
+        ignore_older_secs: 600
+        include:
+        - /var/log/*.log
+        read_from: beginning
+        type: file

changed: [vector-01]

TASK [Create data directory] *****************************************************************************************************************************************************************
--- before
+++ after
@@ -1,4 +1,4 @@
 {
     "path": "/var/lib/vector",
-    "state": "absent"
+    "state": "directory"
 }

changed: [vector-01]

TASK [Flush handlers] ************************************************************************************************************************************************************************

RUNNING HANDLER [restarted vector service] ***************************************************************************************************************************************************
changed: [vector-01]

PLAY RECAP ***********************************************************************************************************************************************************************************
clickhouse-01              : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=10   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   


```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```bash
$ ansible-playbook -i inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] ********************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ****************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 1000, "group": "centos", "item": "clickhouse-common-static", "mode": "0664", "msg": "Request failed", "owner": "centos", "response": "HTTP Error 404: Not Found", "secontext": "unconfined_u:object_r:user_home_t:s0", "size": 246310036, "state": "file", "status_code": 404, "uid": 1000, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ****************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] ***********************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] ************************************************************************************************************************************************************************

TASK [Create database] ***********************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Create table] **************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install Vector manual] *****************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] ********************************************************************************************************************************************************************
ok: [vector-01]

TASK [Create root directory] *****************************************************************************************************************************************************************
ok: [vector-01]

TASK [Extract vector] ************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Copy vector to bin with owner and permissions] *****************************************************************************************************************************************
ok: [vector-01]

TASK [Configure vector.service from template] ************************************************************************************************************************************************
ok: [vector-01]

TASK [create config dir for vector] **********************************************************************************************************************************************************
ok: [vector-01]

TASK [Configure vector from template] ********************************************************************************************************************************************************
ok: [vector-01]

TASK [Create data directory] *****************************************************************************************************************************************************************
ok: [vector-01]

TASK [Flush handlers] ************************************************************************************************************************************************************************

PLAY RECAP ***********************************************************************************************************************************************************************************
clickhouse-01              : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=9    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

```yaml
---
# Play устанавливающий Clickhouse на хостах clickhouse
- name: Install Clickhouse
  hosts: clickhouse
# Обработчик событий перезапускающий clichouse-server
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
# блок скачивающий clickhouse указанной версии и оф. сайта
    - block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm"
            dest: "./clickhouse-common-static-{{ clickhouse_version }}.rpm"
# Таска устанавливающая пакеты clickhouse, после выполнения которой запускается handler с перезапуском clickhouse-server
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service
    - name: Flush handlers
      meta: flush_handlers
# Создаем базу logs в clickhouse
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0
# Создаем таблицу local_log
    - name: Create table
      ansible.builtin.command: "clickhouse-client -q 'create table logs.local_log
        (file String, hostname String, message String, timestamp DateTime) Engine=Log;'"
      register: create_table
      failed_when: create_table.rc != 0 and create_table.rc !=57
      changed_when: create_table.rc == 0
# Play устанавливающий Vector на хостах vector
- name: Install Vector manual
  hosts: vector
# Обработчик событий перезапускающий vector
  handlers:
    - name: restarted vector service
      become: true
      ansible.builtin.service:
        name: vector
        state: restarted
  tasks:
# Блок загрузки и распаковки архива vector указанной версии
    - block:
      - name: Get vector distrib
        ansible.builtin.get_url:
          url: "https://packages.timber.io/vector/{{ vector_version }}/vector-{{ vector_version }}-x86_64-unknown-linux-musl.tar.gz"
          dest: "{{ home_dir }}/vector-{{ vector_version }}.tar.gz"
      - name: Create root directory
        ansible.builtin.file:
          path: "{{ home_dir }}/vector-{{ vector_version }}"
          state: directory
      - name: Extract vector
        ansible.builtin.unarchive:
          src: "{{ home_dir }}/vector-{{ vector_version }}.tar.gz"
          dest: "{{ home_dir }}/vector-{{ vector_version }}/"
          extra_opts: [--strip-components=2]
          remote_src: yes
# Блок установки vector который будет запущен с повышением прав до root (become: true) и после него будет выполнен handler запуска vector
    - block:
# Копируем бинарник vector в /usr/bin/ и даем права на исполнение
      - name: Copy vector to bin with owner and permissions
        ansible.builtin.copy:
          src: "{{ home_dir }}/vector-{{ vector_version }}/bin/vector"
          dest: /usr/bin/vector
          mode: '0755'
          remote_src: true
# Создаем vector.service из шаблона и указываем tag vector_service для отдельного запуска при тестировании
      - name: Configure vector.service from template
        ansible.builtin.template:
          src: vector.service.j2
          dest: /etc/systemd/system/vector.service
          mode: 0644
        tags:
          - vector_service
# Создаем директорию для конфигов vector
      - name: create config dir for vector
        ansible.builtin.file:
          path: "{{ vector_config_dir }}"
          state: directory
          mode: 0644
# Создаем конфиг vector из шаблона
      - name: Configure vector from template
        ansible.builtin.template:
          src: vector.yml.j2
          dest: "{{ vector_config_dir }}/vector.yml"
          mode: 0644
# создаем директорию data для vector
      - name: Create data directory
        ansible.builtin.file:
          path: "{{ vector_config.data_dir }}"
          state: directory
      become: true
      notify: restarted vector service
    - name: Flush handlers
      meta: flush_handlers

```

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---
