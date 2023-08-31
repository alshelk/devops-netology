# Домашнее задание к занятию 3 «Использование Yandex Cloud»

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.
2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.

[site.yml](playbook%2Fsite.yml):

```yaml
- name: Install lighthouse
  hosts: lighthouse
  tags: lighthouse
  handlers:
    - name: restarted nginx service
      become: true
      ansible.builtin.service:
        name: nginx
        state: restarted
  tasks:
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
          name:
            - nginx
            - git
          state: latest
          update_cache: yes
      - name: Get lighthouse from git
        ansible.builtin.git:
          repo: 'https://github.com/VKCOM/lighthouse.git'
          dest: "{{ lighthouse_home_dir }}"
      - name: Configure nginx from template
        ansible.builtin.template:
          src: lighthouse.conf.j2
          dest: "{{ nginx_config_dir }}/conf.d/default.conf"
      become: true
      notify: restarted nginx service
    - name: Flush handlers
      meta: flush_handlers
```

4. Подготовьте свой inventory-файл `prod.yml`.

[prod.tftpl](terraform%2Fprod.tftpl):

```yaml
---

%{~ for i in webservers ~}

${i["name"]}:
  hosts:
    ${i["name"]}-01:
      ansible_host: ${i["network_interface"][0]["nat_ip_address"]}
      ansible_user: ${user}
%{~ endfor ~}
```

[invent_ansible.tf](terraform%2Finvent_ansible.tf):

```terraform
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/prod.tftpl",
    { webservers = [ for i in yandex_compute_instance.test : i],
      user = var.vm_metadata.ssh-user }
  )

  filename = "${abspath(path.module)}/../playbook/inventory/prod.yml"
}

```

5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

```bash
$ ansible-lint site.yml
[201] Trailing whitespace
site.yml:119
        ansible.builtin.copy:       

$ ansible-lint site.yml
$
```

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

```bash
$ ansible-playbook -i inventory/prod.yml  site.yml --check

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
skipping: [clickhouse-01]

TASK [Open connection in local network] ******************************************************************************************************************************************************
changed: [clickhouse-01]

TASK [Flush handlers] ************************************************************************************************************************************************************************

RUNNING HANDLER [Start clickhouse service] ***************************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [Create database] ***********************************************************************************************************************************************************************
skipping: [clickhouse-01]

TASK [Create table] **************************************************************************************************************************************************************************
skipping: [clickhouse-01]

PLAY [Install Vector manual] *****************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [vector-01]

TASK [Get vector distrib] ********************************************************************************************************************************************************************
changed: [vector-01]

TASK [Create root directory] *****************************************************************************************************************************************************************
changed: [vector-01]

TASK [Extract vector] ************************************************************************************************************************************************************************
skipping: [vector-01]

TASK [Copy vector to bin with owner and permissions] *****************************************************************************************************************************************
skipping: [vector-01]

TASK [Configure vector.service from template] ************************************************************************************************************************************************
changed: [vector-01]

TASK [create config dir for vector] **********************************************************************************************************************************************************
changed: [vector-01]

TASK [Configure vector from template] ********************************************************************************************************************************************************
changed: [vector-01]

TASK [Create data directory] *****************************************************************************************************************************************************************
changed: [vector-01]

TASK [Flush handlers] ************************************************************************************************************************************************************************

RUNNING HANDLER [restarted vector service] ***************************************************************************************************************************************************
skipping: [vector-01]

PLAY [Install lighthouse] ********************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [add repo nginx] ************************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [install nginx and git] *****************************************************************************************************************************************************************
skipping: [lighthouse-01]

TASK [Get lighthouse from git] ***************************************************************************************************************************************************************
skipping: [lighthouse-01]

TASK [Configure nginx from template] *********************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Flush handlers] ************************************************************************************************************************************************************************

RUNNING HANDLER [restarted nginx service] ****************************************************************************************************************************************************
skipping: [lighthouse-01]

PLAY RECAP ***********************************************************************************************************************************************************************************
clickhouse-01              : ok=3    changed=2    unreachable=0    failed=0    skipped=4    rescued=1    ignored=0   
lighthouse-01              : ok=3    changed=2    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   
vector-01                  : ok=7    changed=6    unreachable=0    failed=0    skipped=3    rescued=0    ignored=0   

```

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

```bash
$ ansible-playbook -i inventory/prod.yml  site.yml --diff

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

TASK [Open connection in local network] ******************************************************************************************************************************************************
--- before: /etc/clickhouse-server/config.xml
+++ after: /home/vagrant/.ansible/tmp/ansible-local-702703th6yp27/tmpctjie6mf/clickhouse.config.j2
@@ -180,7 +180,9 @@
 
 
     <!-- Same for hosts without support for IPv6: -->
-    <!-- <listen_host>0.0.0.0</listen_host> -->
+    <listen_host>10.0.1.28</listen_host>
+    <listen_host>localhost</listen_host>
+    
 
     <!-- Default values - try listen localhost on IPv4 and IPv6. -->
     <!--
@@ -367,7 +369,7 @@
 
     <!-- Path to temporary data for processing hard queries. -->
     <tmp_path>/var/lib/clickhouse/tmp/</tmp_path>
-    
+
     <!-- Disable AuthType plaintext_password and no_password for ACL. -->
     <!-- <allow_plaintext_password>0</allow_plaintext_password> -->
     <!-- <allow_no_password>0</allow_no_password> -->`

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
+++ after: /home/vagrant/.ansible/tmp/ansible-local-702703th6yp27/tmp4uuavwkg/vector.service.j2
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
+++ after: /home/vagrant/.ansible/tmp/ansible-local-702703th6yp27/tmpj9wnlqk4/vector.yml.j2
@@ -0,0 +1,21 @@
+---
+data_dir: /var/lib/vector
+sinks:
+    to_clickhouse:
+        compression: gzip
+        database: logs
+        endpoint: http://10.0.1.28:8123
+        inputs:
+        - sample_file
+        skip_unknown_fields: true
+        table: local_log
+        type: clickhouse
+sources:
+    sample_file:
+        ignore_older_secs: 600
+        include:
+        - /var/log/**/*.log
+        read_from: beginning
+        type: file
+    vector_log:
+        type: internal_logs

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

PLAY [Install lighthouse] ********************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [add repo nginx] ************************************************************************************************************************************************************************
--- before
+++ after: /home/vagrant/.ansible/tmp/ansible-local-702703th6yp27/tmpn57sw2qa
@@ -0,0 +1,5 @@
+[nginx]
+name=nginx repo
+baseurl=https://nginx.org/packages/centos/$releasever/$basearch/
+gpgcheck=0
+enabled=1

changed: [lighthouse-01]

TASK [install nginx and git] *****************************************************************************************************************************************************************
changed: [lighthouse-01]

TASK [Get lighthouse from git] ***************************************************************************************************************************************************************
>> Newly checked out d701335c25cd1bb9b5155711190bad8ab852c2ce
changed: [lighthouse-01]

TASK [Configure nginx from template] *********************************************************************************************************************************************************
--- before: /etc/nginx/conf.d/default.conf
+++ after: /home/vagrant/.ansible/tmp/ansible-local-702703th6yp27/tmpq5vl08jk/lighthouse.conf.j2
@@ -5,7 +5,7 @@
     #access_log  /var/log/nginx/host.access.log  main;
 
     location / {
-        root   /usr/share/nginx/html;
+        root   /usr/share/nginx/html/lighthouse;
         index  index.html index.htm;
     }
 
@@ -41,4 +41,3 @@
     #    deny  all;
     #}
 }
-

changed: [lighthouse-01]

TASK [Flush handlers] ************************************************************************************************************************************************************************

RUNNING HANDLER [restarted nginx service] ****************************************************************************************************************************************************
changed: [lighthouse-01]

PLAY RECAP ***********************************************************************************************************************************************************************************
clickhouse-01              : ok=7    changed=6    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=6    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=10   changed=9    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

```bash
$ ansible-playbook -i inventory/prod.yml  site.yml --diff

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

TASK [Open connection in local network] ******************************************************************************************************************************************************
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

PLAY [Install lighthouse] ********************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [add repo nginx] ************************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [install nginx and git] *****************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Get lighthouse from git] ***************************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Configure nginx from template] *********************************************************************************************************************************************************
ok: [lighthouse-01]

TASK [Flush handlers] ************************************************************************************************************************************************************************

PLAY RECAP ***********************************************************************************************************************************************************************************
clickhouse-01              : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
lighthouse-01              : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
vector-01                  : ok=9    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.

[site.yml](playbook%2Fsite.yml):

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
      when: not ansible_check_mode
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
      when: not ansible_check_mode
    - name: Open connection in local network
      become: true
      ansible.builtin.template:
          src: clickhouse.config.j2
          dest: /etc/clickhouse-server/config.xml
          mode: 0400
          owner: clickhouse
          group: clickhouse
      notify: Start clickhouse service
    - name: Flush handlers
      meta: flush_handlers
# Создаем базу logs в clickhouse
    - name: Create database
      ansible.builtin.command: "clickhouse-client -q 'create database logs;'"
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0
      when: not ansible_check_mode
# Создаем таблицу local_log
    - name: Create table
      ansible.builtin.command: "clickhouse-client -q 'create table logs.local_log
        (file String, hostname String, message String, timestamp DateTime) Engine=Log;'"
      register: create_table
      failed_when: create_table.rc != 0 and create_table.rc !=57
      changed_when: create_table.rc == 0
      when: not ansible_check_mode
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
      when: not ansible_check_mode
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
        when: not ansible_check_mode
# Блок установки vector который будет запущен с повышением прав до root (become: true) и после него будет выполнен handler запуска vector
    - block:
# Копируем бинарник vector в /usr/bin/ и даем права на исполнение
      - name: Copy vector to bin with owner and permissions
        ansible.builtin.copy:
          src: "{{ home_dir }}/vector-{{ vector_version }}/bin/vector"
          dest: /usr/bin/vector
          mode: '0755'
          remote_src: true
        when: not ansible_check_mode  
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
# Play устанавливающий lighthouse на хостах lighthouse c тегом lighthiouse для отдельного запуска
- name: Install lighthouse
  hosts: lighthouse
  tags: lighthouse
# Обработчик событий перезапускающий nginx
  handlers:
    - name: restarted nginx service
      become: true
      ansible.builtin.service:
        name: nginx
        state: restarted
      when: not ansible_check_mode
  tasks:
    - block:
# добавляем репозиторий для установки nginx
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
# ставим nginx и git
      - name: install nginx and git
        ansible.builtin.yum:
          name:
            - nginx
            - git
          state: latest
          update_cache: yes
        when: not ansible_check_mode
# качаем lighthouse с github
      - name: Get lighthouse from git
        ansible.builtin.git:
          repo: 'https://github.com/VKCOM/lighthouse.git'
          dest: "{{ lighthouse_home_dir }}"
        when: not ansible_check_mode
# создаем конфиг nginx для lighthouse из шаблона
      - name: Configure nginx from template
        ansible.builtin.template:
          src: lighthouse.conf.j2
          dest: "{{ nginx_config_dir }}/conf.d/default.conf"
      become: true
      notify: restarted nginx service
    - name: Flush handlers
      meta: flush_handlers


# параметр not ansible_check_mode - говорит не запускать задачу в режиме проверки
```

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---