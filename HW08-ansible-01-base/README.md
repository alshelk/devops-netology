# Домашнее задание к занятию 1 «Введение в Ansible»

## Подготовка к выполнению

1. Установите Ansible версии 2.10 или выше.
2. Создайте свой публичный репозиторий на GitHub с произвольным именем.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.

```bash
$ ansible-playbook -i inventory/test.yml site.yml 

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ***********************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

```text
some_fact = 12
```

2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.

[examp.yml](playbook%2Fgroup_vars%2Fall%2Fexamp.yml)

```bash
$ cat group_vars/all/examp.yml 
---
  #some_fact: 12
  some_fact: "all default fact"
```

```bash
$ ansible-playbook -i inventory/test.yml site.yml 

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

```bash
$ docker ps
CONTAINER ID   IMAGE                 COMMAND       CREATED         STATUS                  PORTS     NAMES
d1a8d738a523   pycontribs/centos:7   "/bin/bash"   1 second ago    Up Less than a second             centos7
9e251105c38e   pycontribs/ubuntu     "/bin/bash"   2 seconds ago   Up 1 second                       ubuntu

```

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

```bash
$ ansible-playbook -i inventory/prod.yml site.yml 

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

```text
centos7:
some_fact = "el"

ubuntu:
some_fact = "deb"

```


5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.


deb:
[examp.yml](playbook%2Fgroup_vars%2Fdeb%2Fexamp.yml)

el:
[examp.yml](playbook%2Fgroup_vars%2Fel%2Fexamp.yml)

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

```bash
$ ansible-playbook -i inventory/prod.yml site.yml 

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
```

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

```bash
vagrant@vm1:/netology_data/HW08-ansible-01-base/playbook$ ansible-vault encrypt group_vars/deb/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
vagrant@vm1:/netology_data/HW08-ansible-01-base/playbook$ ansible-vault encrypt group_vars/el/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
vagrant@vm1:/netology_data/HW08-ansible-01-base/playbook$ cat group_vars/deb/examp.yml 
$ANSIBLE_VAULT;1.1;AES256
33623931323665313464336463353135393034333930646132613835396135656232613339666634
3633366463356334656134626532623637636665306334340a383239363931303861353066623566
38353562396436353362333362623838366339633732613662316437616463366461366666663435
3131363838343034640a306239383034333430653638376565666536386166306561383934616533
37313430613136343034303161376333663765386331653934356632663935666661356163666638
65356236656130343837336335353763356437326132346664326637343563613330373361333038
363463323635346137356533383937643037
vagrant@vm1:/netology_data/HW08-ansible-01-base/playbook$ cat group_vars/el/examp.yml 
$ANSIBLE_VAULT;1.1;AES256
37633062636635636665323364363864656531383236343832346132396132633431656662663334
3931663666653262653339643164336137393939383934640a326534313566346536333632633932
37666166643361396332373566306336353434303833386530643164363565303632343530353331
3665383230656131310a383436373632653764663438353166663961396335376162626631613334
36356539353964643537666566353032666234303463306339636663363365643039363262333335
32643966393539363338366464383961633961346664336635333131366461623634613634336433
643635313566333435396531326162303634

```

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

```bash
$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

```bash
$ ansible-doc -t connection -l
[WARNING]: Collection ibm.qradar does not support Ansible version 2.12.10
[WARNING]: Collection splunk.es does not support Ansible version 2.12.10
[DEPRECATION WARNING]: ansible.netcommon.napalm has been deprecated. See the plugin documentation for more details. This feature will be removed from ansible.netcommon in a release after 
2022-06-01. Deprecation warnings can be disabled by setting deprecation_warnings=False in ansible.cfg.
ansible.netcommon.httpapi      Use httpapi to run command on network appliances                                                                                                          
ansible.netcommon.libssh       (Tech preview) Run tasks using libssh for ssh connection                                                                                                  
ansible.netcommon.napalm       Provides persistent connection using NAPALM                                                                                                               
ansible.netcommon.netconf      Provides a persistent connection using the netconf protocol                                                                                               
ansible.netcommon.network_cli  Use network_cli to run command on network appliances                                                                                                      
ansible.netcommon.persistent   Use a persistent unix socket for connection                                                                                                               
community.aws.aws_ssm          execute via AWS Systems Manager                                                                                                                           
community.docker.docker        Run tasks in docker containers                                                                                                                            
community.docker.docker_api    Run tasks in docker containers                                                                                                                            
community.docker.nsenter       execute on host running controller container                                                                                                              
community.general.chroot       Interact with local chroot                                                                                                                                
community.general.funcd        Use funcd to connect to target                                                                                                                            
community.general.iocage       Run tasks in iocage jails                                                                                                                                 
community.general.jail         Run tasks in jails                                                                                                                                        
community.general.lxc          Run tasks in lxc containers via lxc python library                                                                                                        
community.general.lxd          Run tasks in lxc containers via lxc CLI                                                                                                                   
community.general.qubes        Interact with an existing QubesOS AppVM                                                                                                                   
community.general.saltstack    Allow ansible to piggyback on salt minions                                                                                                                
community.general.zone         Run tasks in a zone instance                                                                                                                              
community.libvirt.libvirt_lxc  Run tasks in lxc containers via libvirt                                                                                                                   
community.libvirt.libvirt_qemu Run tasks on libvirt/qemu virtual machines                                                                                                                
community.okd.oc               Execute tasks in pods running on OpenShift                                                                                                                
community.vmware.vmware_tools  Execute tasks inside a VM via VMware Tools                                                                                                                
community.zabbix.httpapi       Use httpapi to run command on network appliances                                                                                                          
containers.podman.buildah      Interact with an existing buildah container                                                                                                               
containers.podman.podman       Interact with an existing podman container                                                                                                                
kubernetes.core.kubectl        Execute tasks in pods running on Kubernetes                                                                                                               
local                          execute on controller                                                                                                                                     
paramiko_ssh                   Run tasks via python ssh (paramiko)                                                                                                                       
psrp                           Run tasks over Microsoft PowerShell Remoting Protocol                                                                                                     
ssh                            connect via SSH client binary                                                                                                                             
winrm                          Run tasks over Microsoft's WinRM                      
```

```bash
$ ansible-doc -t connection local
> ANSIBLE.BUILTIN.LOCAL    (/usr/lib/python3/dist-packages/ansible/plugins/connection/local.py)

        This connection plugin allows ansible to execute tasks on the Ansible 'controller' instead of on a remote host.

ADDED IN: historical

OPTIONS (= is mandatory):

- pipelining
        Pipelining reduces the number of connection operations required to execute a module on the remote server, by executing many Ansible modules
        without actual file transfers.
        This can result in a very significant performance improvement when enabled.
        However this can conflict with privilege escalation (become). For example, when using sudo operations you must first disable 'requiretty' in the
        sudoers file for the target hosts, which is why this feature is disabled by default.
        [Default: ANSIBLE_PIPELINING]
        set_via:
          env:
          - name: ANSIBLE_PIPELINING
          ini:
          - key: pipelining
            section: defaults
          vars:
          - name: ansible_pipelining
        
        type: boolean


NOTES:
      * The remote user is ignored, the user with which the ansible CLI was executed is used instead.


AUTHOR: ansible (@core)

NAME: local

```

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

```bash
$ cat inventory/prod.yml 
---
  el:
    hosts:
      centos7:
        ansible_connection: docker
  deb:
    hosts:
      ubuntu:
        ansible_connection: docker
  local:
    hosts:
      localhost:
        ansible_connection: local
```

[prod.yml](playbook%2Finventory%2Fprod.yml)

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

```bash
$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

[playbook](playbook)


## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

```bash
vagrant@vm1:/netology_data/HW08-ansible-01-base/playbook_optional$ ansible-vault decrypt group_vars/deb/examp.yml
Vault password: 
Decryption successful
vagrant@vm1:/netology_data/HW08-ansible-01-base/playbook_optional$ ansible-vault decrypt group_vars/el/examp.yml
Vault password: 
Decryption successful
vagrant@vm1:/netology_data/HW08-ansible-01-base/playbook_optional$ cat group_vars/deb/examp.yml
---
  some_fact: "deb default fact"
vagrant@vm1:/netology_data/HW08-ansible-01-base/playbook_optional$ cat group_vars/el/examp.yml
---
  some_fact: "el default fact"

```

2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

```bash
$ ansible-vault encrypt_string
New Vault password: 
Confirm New Vault password: 
Reading plaintext input from stdin. (ctrl-d to end input, twice if your content does not already have a newline)
PaSSw0rd
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          35613961366461626165303663613762633065343966623064633866613931623535346664363639
          6439613161343839353139336633613539353135613534630a343033613731633332343337666635
          65653164303935346335346339623438353135653131653137663135346161663335303434346361
          3433323866613437640a356431663538633434646639626432663636363164353962666439353766
          6237
Encryption successful

```

```bash
$ cat group_vars/all/examp.yml 
---
  some_fact: !vault |
          $ANSIBLE_VAULT;1.1;AES256
          35613961366461626165303663613762633065343966623064633866613931623535346664363639
          6439613161343839353139336633613539353135613534630a343033613731633332343337666635
          65653164303935346335346339623438353135653131653137663135346161663335303434346361
          3433323866613437640a356431663538633434646639626432663636363164353962666439353766
          6237
```

3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

```bash
$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот вариант](https://hub.docker.com/r/pycontribs/fedora).

[prod.yml](playbook_optional%2Finventory%2Fprod.yml)

[examp.yml](playbook_optional%2Fgroup_vars%2Ffedora%2Fexamp.yml)

```bash
$ ansible-playbook -i inventory/prod.yml site.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [localhost]
ok: [fedora_last]
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [fedora_last] => {
    "msg": "Fedora"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora_last] => {
    "msg": "fedora default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP ***********************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora_last                : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

```bash
$ ./run_ansible.sh 
ec3c9de8075cdab71c6cea4e5bc82b277c7104b9b410d32d23572e7900e65847
c6be54b2bf63dcd1548f0525efab379056708ac6cefdd00fa3fa037f3f4203eb
c92ebaa132c6fa2b8b96750d6916b69b31b22632292a13461a60912a8fb61422
CONTAINER ID   IMAGE                 COMMAND       CREATED         STATUS                  PORTS     NAMES
c92ebaa132c6   pycontribs/fedora     "/bin/bash"   1 second ago    Up Less than a second             fedora_last
c6be54b2bf63   pycontribs/centos:7   "/bin/bash"   1 second ago    Up Less than a second             centos7
ec3c9de8075c   pycontribs/ubuntu     "/bin/bash"   2 seconds ago   Up 1 second                       ubuntu

PLAY [Print os facts] *****************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [fedora_last]
ok: [centos7]

TASK [Print OS] ***********************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [fedora_last] => {
    "msg": "Fedora"
}

TASK [Print fact] *********************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [fedora_last] => {
    "msg": "fedora default fact"
}

PLAY RECAP ****************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora_last                : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

ubuntu
centos7
fedora_last
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES

```

[ansible.cfg](playbook_optional%2Fansible.cfg):

```bash
$ cat ansible.cfg 
[defaults]
vault_password_file = ./.vault_pass
```

[run_ansible.sh](playbook_optional%2Frun_ansible.sh):

```bash
$ cat run_ansible.sh 
#!/usr/bin/env bash

function dockerrs {
  declare -A hosts=([fedora_last]=pycontribs/fedora [centos7]=pycontribs/centos:7 [ubuntu]=pycontribs/ubuntu)
  for h in ${!hosts[@]}; do
    if [ "$1" = "run" ]; then
      /usr/bin/docker run --rm -it  -d --name $h ${hosts[$h]}
    else
      /usr/bin/docker stop $h
    fi
  done
}

if [ -n "$1" ]
then
  dockerrs $1
else
  dockerrs run
  /usr/bin/docker ps
  ansible-playbook -i inventory/prod.yml site.yml
  dockerrs stop
fi

/usr/bin/docker ps -a

```

Или например так:

```bash
$ ansible-playbook -i inventory/prod.yml site_run_docker.yml

PLAY [run localhost] ******************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [localhost]

TASK [Run Dockers] ********************************************************************************************************************
changed: [localhost]

TASK [Run Docker debug] ***************************************************************************************************************
ok: [localhost] => {
    "script_output.stdout_lines": [
        "97297c9329937da1bd46a30cbe07311f543806c2a34259560846ed2ffd78b9cb",
        "015f327c69ef9c35087b897d1241bc27c22a88c10804dc9c3967c24ebea62bee",
        "0e216fd131a62aa4e374e0ec999f2710a51451b4e4fa055141e0ba40752bef48",
        "CONTAINER ID   IMAGE                 COMMAND       CREATED         STATUS                  PORTS     NAMES",
        "0e216fd131a6   pycontribs/fedora     \"/bin/bash\"   1 second ago    Up Less than a second             fedora_last",
        "015f327c69ef   pycontribs/centos:7   \"/bin/bash\"   1 second ago    Up Less than a second             centos7",
        "97297c932993   pycontribs/ubuntu     \"/bin/bash\"   2 seconds ago   Up 1 second                       ubuntu"
    ]
}

PLAY [Print os facts] *****************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [fedora_last]
ok: [centos7]

TASK [Print OS] ***********************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [fedora_last] => {
    "msg": "Fedora"
}

TASK [Print fact] *********************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [fedora_last] => {
    "msg": "fedora default fact"
}

PLAY [run localhost end] **************************************************************************************************************

TASK [Gathering Facts] ****************************************************************************************************************
ok: [localhost]

TASK [stop Dockers] *******************************************************************************************************************
changed: [localhost]

TASK [stop Docker debug] **************************************************************************************************************
ok: [localhost] => {
    "script_output.stdout_lines": [
        "ubuntu",
        "centos7",
        "fedora_last",
        "CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES"
    ]
}

PLAY RECAP ****************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora_last                : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=9    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

```

[site_run_docker.yml](playbook_optional%2Fsite_run_docker.yml):

```bash
$ cat site_run_docker.yml 
---
  - name: run localhost
    hosts: localhost
    tasks:
      - name: Run Dockers
        shell: "./run_ansible.sh run"
        register: script_output
      - name: Run Docker debug
        debug: var=script_output.stdout_lines
  - name: Print os facts
    hosts: all
    tasks:
      - name: Print OS
        debug:
          msg: "{{ ansible_distribution }}"
      - name: Print fact
        debug:
          msg: "{{ some_fact }}"
  - name: run localhost end
    hosts: localhost
    tasks:
      - name: stop Dockers
        shell: "./run_ansible.sh stop"
        register: script_output
      - name: stop Docker debug 
        debug: var=script_output.stdout_lines

```

6. Все изменения должны быть зафиксированы и отправлены в ваш личный репозиторий.

[playbook_optional](playbook_optional)

---