# Домашнее задание к занятию «Установка Kubernetes»

### Цель задания

Установить кластер K8s.

### Чеклист готовности к домашнему заданию

1. Развёрнутые ВМ с ОС Ubuntu 20.04-lts.


### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция по установке kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/).
2. [Документация kubespray](https://kubespray.io/).

-----

### Задание 1. Установить кластер k8s с 1 master node

1. Подготовка работы кластера из 5 нод: 1 мастер и 4 рабочие ноды.
2. В качестве CRI — containerd.
3. Запуск etcd производить на мастере.
4. Способ установки выбрать самостоятельно.

<details>
<summary>
Ответ

</summary>

---

<details>
<summary>
Kubespray
</summary>

Подготовка ВМ:

[terraform](terraform)

```bash
vagrant@vm1:/netology_data/HW14-k8s-02-install/terraform$ yc compute instance list
+----------------------+-------------------------+---------------+---------+-----------------+-------------+
|          ID          |          NAME           |    ZONE ID    | STATUS  |   EXTERNAL IP   | INTERNAL IP |
+----------------------+-------------------------+---------------+---------+-----------------+-------------+
| fhm1uj9idueton76gsc7 | worker-node-kubespray-3 | ru-central1-a | RUNNING | 158.160.125.178 | 10.0.1.12   |
| fhm6jdm97n1i5g8mtk8u | worker-node-kubespray-2 | ru-central1-a | RUNNING | 158.160.114.212 | 10.0.1.32   |
| fhmg6rn2eginome00lku | worker-node-kubespray-1 | ru-central1-a | RUNNING | 158.160.41.191  | 10.0.1.21   |
| fhmjvcgddr46sn1r5eaa | master-node-kubespray-1 | ru-central1-a | RUNNING | 158.160.100.110 | 10.0.1.38   |
| fhmpga4c40jafg1116gk | worker-node-kubespray-4 | ru-central1-a | RUNNING | 158.160.98.195  | 10.0.1.20   |
+----------------------+-------------------------+---------------+---------+-----------------+-------------+

```

Подготовка ВМ. Ставим git, python3.9, pip3.9

```bash
ubuntu@master-node-kubespray-1:~$ sudo apt install git
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  git-man libcurl3-gnutls liberror-perl libgdbm-compat4 libperl5.30 patch perl perl-modules-5.30
Suggested packages:
  git-daemon-run | git-daemon-sysvinit git-doc git-el git-email git-gui gitk gitweb git-cvs git-mediawiki git-svn diffutils-doc perl-doc libterm-readline-gnu-perl
  | libterm-readline-perl-perl make libb-debug-perl liblocale-codes-perl
The following NEW packages will be installed:
  git git-man libcurl3-gnutls liberror-perl libgdbm-compat4 libperl5.30 patch perl perl-modules-5.30
0 upgraded, 9 newly installed, 0 to remove and 0 not upgraded.
Need to get 12.8 MB of archives.
After this operation, 85.9 MB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 perl-modules-5.30 all 5.30.0-9ubuntu0.4 [2,739 kB]
Get:2 http://mirror.yandex.ru/ubuntu focal/main amd64 libgdbm-compat4 amd64 1.18.1-5 [6,244 B]
Get:3 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 libperl5.30 amd64 5.30.0-9ubuntu0.4 [3,959 kB]
Get:4 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 perl amd64 5.30.0-9ubuntu0.4 [224 kB]
Get:5 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 libcurl3-gnutls amd64 7.68.0-1ubuntu2.20 [233 kB]
Get:6 http://mirror.yandex.ru/ubuntu focal/main amd64 liberror-perl all 0.17029-1 [26.5 kB]
Get:7 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 git-man all 1:2.25.1-1ubuntu3.11 [887 kB]
Get:8 http://mirror.yandex.ru/ubuntu focal-updates/main amd64 git amd64 1:2.25.1-1ubuntu3.11 [4,605 kB]
Get:9 http://mirror.yandex.ru/ubuntu focal/main amd64 patch amd64 2.7.6-6 [105 kB]
Fetched 12.8 MB in 0s (51.3 MB/s)
Selecting previously unselected package perl-modules-5.30.
(Reading database ... 102614 files and directories currently installed.)
Preparing to unpack .../0-perl-modules-5.30_5.30.0-9ubuntu0.4_all.deb ...
Unpacking perl-modules-5.30 (5.30.0-9ubuntu0.4) ...
Selecting previously unselected package libgdbm-compat4:amd64.
Preparing to unpack .../1-libgdbm-compat4_1.18.1-5_amd64.deb ...
Unpacking libgdbm-compat4:amd64 (1.18.1-5) ...
Selecting previously unselected package libperl5.30:amd64.
Preparing to unpack .../2-libperl5.30_5.30.0-9ubuntu0.4_amd64.deb ...
Unpacking libperl5.30:amd64 (5.30.0-9ubuntu0.4) ...
Selecting previously unselected package perl.
Preparing to unpack .../3-perl_5.30.0-9ubuntu0.4_amd64.deb ...
Unpacking perl (5.30.0-9ubuntu0.4) ...
Selecting previously unselected package libcurl3-gnutls:amd64.
Preparing to unpack .../4-libcurl3-gnutls_7.68.0-1ubuntu2.20_amd64.deb ...
Unpacking libcurl3-gnutls:amd64 (7.68.0-1ubuntu2.20) ...
Selecting previously unselected package liberror-perl.
Preparing to unpack .../5-liberror-perl_0.17029-1_all.deb ...
Unpacking liberror-perl (0.17029-1) ...
Selecting previously unselected package git-man.
Preparing to unpack .../6-git-man_1%3a2.25.1-1ubuntu3.11_all.deb ...
Unpacking git-man (1:2.25.1-1ubuntu3.11) ...
Selecting previously unselected package git.
Preparing to unpack .../7-git_1%3a2.25.1-1ubuntu3.11_amd64.deb ...
Unpacking git (1:2.25.1-1ubuntu3.11) ...
Selecting previously unselected package patch.
Preparing to unpack .../8-patch_2.7.6-6_amd64.deb ...
Unpacking patch (2.7.6-6) ...
Setting up perl-modules-5.30 (5.30.0-9ubuntu0.4) ...
Setting up libcurl3-gnutls:amd64 (7.68.0-1ubuntu2.20) ...
Setting up patch (2.7.6-6) ...
Setting up libgdbm-compat4:amd64 (1.18.1-5) ...
Setting up libperl5.30:amd64 (5.30.0-9ubuntu0.4) ...
Setting up git-man (1:2.25.1-1ubuntu3.11) ...
Setting up perl (5.30.0-9ubuntu0.4) ...
Setting up liberror-perl (0.17029-1) ...
Setting up git (1:2.25.1-1ubuntu3.11) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for libc-bin (2.31-0ubuntu9.12) ...
ubuntu@master-node-kubespray-1:~$ git clone https://github.com/kubernetes-sigs/kubespray
Cloning into 'kubespray'...
remote: Enumerating objects: 71578, done.
remote: Counting objects: 100% (80/80), done.
remote: Compressing objects: 100% (71/71), done.
remote: Total 71578 (delta 28), reused 39 (delta 7), pack-reused 71498
Receiving objects: 100% (71578/71578), 22.62 MiB | 17.20 MiB/s, done.
Resolving deltas: 100% (40194/40194), done.

ubuntu@master-node-kubespray-1:~$ sudo apt install python3.9
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following additional packages will be installed:
  libpython3.9-minimal libpython3.9-stdlib python3.9-minimal
Suggested packages:
  python3.9-venv python3.9-doc binutils binfmt-support
The following NEW packages will be installed:
  libpython3.9-minimal libpython3.9-stdlib python3.9 python3.9-minimal
0 upgraded, 4 newly installed, 0 to remove and 0 not upgraded.
Need to get 4,979 kB of archives.
After this operation, 19.9 MB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://mirror.yandex.ru/ubuntu focal-updates/universe amd64 libpython3.9-minimal amd64 3.9.5-3ubuntu0~20.04.1 [756 kB]
Get:2 http://mirror.yandex.ru/ubuntu focal-updates/universe amd64 python3.9-minimal amd64 3.9.5-3ubuntu0~20.04.1 [2,022 kB]
Get:3 http://mirror.yandex.ru/ubuntu focal-updates/universe amd64 libpython3.9-stdlib amd64 3.9.5-3ubuntu0~20.04.1 [1,778 kB]
Get:4 http://mirror.yandex.ru/ubuntu focal-updates/universe amd64 python3.9 amd64 3.9.5-3ubuntu0~20.04.1 [423 kB]
Fetched 4,979 kB in 0s (13.0 MB/s) 
Selecting previously unselected package libpython3.9-minimal:amd64.
(Reading database ... 105509 files and directories currently installed.)
Preparing to unpack .../libpython3.9-minimal_3.9.5-3ubuntu0~20.04.1_amd64.deb ...
Unpacking libpython3.9-minimal:amd64 (3.9.5-3ubuntu0~20.04.1) ...
Selecting previously unselected package python3.9-minimal.
Preparing to unpack .../python3.9-minimal_3.9.5-3ubuntu0~20.04.1_amd64.deb ...
Unpacking python3.9-minimal (3.9.5-3ubuntu0~20.04.1) ...
Selecting previously unselected package libpython3.9-stdlib:amd64.
Preparing to unpack .../libpython3.9-stdlib_3.9.5-3ubuntu0~20.04.1_amd64.deb ...
Unpacking libpython3.9-stdlib:amd64 (3.9.5-3ubuntu0~20.04.1) ...
Selecting previously unselected package python3.9.
Preparing to unpack .../python3.9_3.9.5-3ubuntu0~20.04.1_amd64.deb ...
Unpacking python3.9 (3.9.5-3ubuntu0~20.04.1) ...
Setting up libpython3.9-minimal:amd64 (3.9.5-3ubuntu0~20.04.1) ...
Setting up python3.9-minimal (3.9.5-3ubuntu0~20.04.1) ...
Setting up libpython3.9-stdlib:amd64 (3.9.5-3ubuntu0~20.04.1) ...
Setting up python3.9 (3.9.5-3ubuntu0~20.04.1) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for mime-support (3.64ubuntu1) ...

ubuntu@master-node-kubespray-1:~$ curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 2570k  100 2570k    0     0  5576k      0 --:--:-- --:--:-- --:--:-- 5576k
ubuntu@master-node-kubespray-1:~$ sudo python3.9 get-pip.py
Collecting pip
  Downloading pip-23.3.1-py3-none-any.whl.metadata (3.5 kB)
Collecting wheel
  Downloading wheel-0.41.3-py3-none-any.whl.metadata (2.2 kB)
Downloading pip-23.3.1-py3-none-any.whl (2.1 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.1/2.1 MB 6.1 MB/s eta 0:00:00
Downloading wheel-0.41.3-py3-none-any.whl (65 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 65.8/65.8 kB 524.6 kB/s eta 0:00:00
Installing collected packages: wheel, pip
Successfully installed pip-23.3.1 wheel-0.41.3
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv

ubuntu@master-node-kubespray-1:~$ export PATH=~/.local/bin/:$PATH

```

Ставим зависимости из requirements и создаем hosts.yaml

```bash
ubuntu@master-node-kubespray-1:~/kubespray$ sudo pip3 install -r requirements.txt
Collecting ansible==8.5.0 (from -r requirements.txt (line 1))
  Downloading ansible-8.5.0-py3-none-any.whl.metadata (7.9 kB)
Collecting cryptography==41.0.4 (from -r requirements.txt (line 2))
  Downloading cryptography-41.0.4-cp37-abi3-manylinux_2_28_x86_64.whl.metadata (5.2 kB)
Collecting jinja2==3.1.2 (from -r requirements.txt (line 3))
  Downloading Jinja2-3.1.2-py3-none-any.whl (133 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 133.1/133.1 kB 928.4 kB/s eta 0:00:00
Collecting jmespath==1.0.1 (from -r requirements.txt (line 4))
  Downloading jmespath-1.0.1-py3-none-any.whl (20 kB)
Collecting MarkupSafe==2.1.3 (from -r requirements.txt (line 5))
  Downloading MarkupSafe-2.1.3-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (3.0 kB)
Collecting netaddr==0.9.0 (from -r requirements.txt (line 6))
  Downloading netaddr-0.9.0-py3-none-any.whl.metadata (5.1 kB)
Collecting pbr==5.11.1 (from -r requirements.txt (line 7))
  Downloading pbr-5.11.1-py2.py3-none-any.whl (112 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 112.7/112.7 kB 2.7 MB/s eta 0:00:00
Collecting ruamel.yaml==0.17.35 (from -r requirements.txt (line 8))
  Downloading ruamel.yaml-0.17.35-py3-none-any.whl.metadata (18 kB)
Collecting ruamel.yaml.clib==0.2.8 (from -r requirements.txt (line 9))
  Downloading ruamel.yaml.clib-0.2.8-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.whl.metadata (2.2 kB)
Collecting ansible-core~=2.15.5 (from ansible==8.5.0->-r requirements.txt (line 1))
  Downloading ansible_core-2.15.6-py3-none-any.whl.metadata (7.0 kB)
Collecting cffi>=1.12 (from cryptography==41.0.4->-r requirements.txt (line 2))
  Downloading cffi-1.16.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl.metadata (1.5 kB)
Requirement already satisfied: PyYAML>=5.1 in /usr/lib/python3/dist-packages (from ansible-core~=2.15.5->ansible==8.5.0->-r requirements.txt (line 1)) (5.3.1)
Collecting packaging (from ansible-core~=2.15.5->ansible==8.5.0->-r requirements.txt (line 1))
  Downloading packaging-23.2-py3-none-any.whl.metadata (3.2 kB)
Collecting resolvelib<1.1.0,>=0.5.3 (from ansible-core~=2.15.5->ansible==8.5.0->-r requirements.txt (line 1))
  Downloading resolvelib-1.0.1-py2.py3-none-any.whl (17 kB)
Collecting importlib-resources<5.1,>=5.0 (from ansible-core~=2.15.5->ansible==8.5.0->-r requirements.txt (line 1))
  Downloading importlib_resources-5.0.7-py3-none-any.whl (24 kB)
Collecting pycparser (from cffi>=1.12->cryptography==41.0.4->-r requirements.txt (line 2))
  Downloading pycparser-2.21-py2.py3-none-any.whl (118 kB)
     ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 118.7/118.7 kB 2.4 MB/s eta 0:00:00
Downloading ansible-8.5.0-py3-none-any.whl (47.5 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 47.5/47.5 MB 17.3 MB/s eta 0:00:00
Downloading cryptography-41.0.4-cp37-abi3-manylinux_2_28_x86_64.whl (4.4 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 4.4/4.4 MB 31.5 MB/s eta 0:00:00
Downloading MarkupSafe-2.1.3-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (25 kB)
Downloading netaddr-0.9.0-py3-none-any.whl (2.2 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.2/2.2 MB 14.3 MB/s eta 0:00:00
Downloading ruamel.yaml-0.17.35-py3-none-any.whl (112 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 112.9/112.9 kB 2.8 MB/s eta 0:00:00
Downloading ruamel.yaml.clib-0.2.8-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.whl (562 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 562.1/562.1 kB 19.9 MB/s eta 0:00:00
Downloading ansible_core-2.15.6-py3-none-any.whl (2.2 MB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 2.2/2.2 MB 12.8 MB/s eta 0:00:00
Downloading cffi-1.16.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (443 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 443.4/443.4 kB 10.4 MB/s eta 0:00:00
Downloading packaging-23.2-py3-none-any.whl (53 kB)
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━ 53.0/53.0 kB 1.5 MB/s eta 0:00:00
Installing collected packages: resolvelib, netaddr, ruamel.yaml.clib, pycparser, pbr, packaging, MarkupSafe, jmespath, importlib-resources, ruamel.yaml, jinja2, cffi, cryptography, ansible-core, ansible
  Attempting uninstall: MarkupSafe
    Found existing installation: MarkupSafe 1.1.0
    Uninstalling MarkupSafe-1.1.0:
      Successfully uninstalled MarkupSafe-1.1.0
  Attempting uninstall: jinja2
    Found existing installation: Jinja2 2.10.1
    Uninstalling Jinja2-2.10.1:
      Successfully uninstalled Jinja2-2.10.1
  Attempting uninstall: cryptography
    Found existing installation: cryptography 2.8
    Uninstalling cryptography-2.8:
      Successfully uninstalled cryptography-2.8
Successfully installed MarkupSafe-2.1.3 ansible-8.5.0 ansible-core-2.15.6 cffi-1.16.0 cryptography-41.0.4 importlib-resources-5.0.7 jinja2-3.1.2 jmespath-1.0.1 netaddr-0.9.0 packaging-23.2 pbr-5.11.1 pycparser-2.21 resolvelib-1.0.1 ruamel.yaml-0.17.35 ruamel.yaml.clib-0.2.8
WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv

ubuntu@master-node-kubespray-1:~/kubespray$ cp -rfp inventory/sample inventory/mycluster

ubuntu@master-node-kubespray-1:~/kubespray$ declare -a IPS=(10.0.1.38, 10.0.1.21, 10.0.1.32, 10.0.1.12, 10.0.1.20)

ubuntu@master-node-kubespray-1:~/kubespray$ CONFIG_FILE=inventory/mycluster/hosts.yaml python3.9 contrib/inventory_builder/inventory.py ${IPS[@]}
DEBUG: Adding group all
DEBUG: Adding group kube_control_plane
DEBUG: Adding group kube_node
DEBUG: Adding group etcd
DEBUG: Adding group k8s_cluster
DEBUG: Adding group calico_rr
DEBUG: adding host node1 to group all
DEBUG: adding host node2 to group all
DEBUG: adding host node3 to group all
DEBUG: adding host node4 to group all
DEBUG: adding host node5 to group all
DEBUG: adding host node1 to group etcd
DEBUG: adding host node2 to group etcd
DEBUG: adding host node3 to group etcd
DEBUG: adding host node1 to group kube_control_plane
DEBUG: adding host node2 to group kube_control_plane
DEBUG: adding host node1 to group kube_node
DEBUG: adding host node2 to group kube_node
DEBUG: adding host node3 to group kube_node
DEBUG: adding host node4 to group kube_node
DEBUG: adding host node5 to group kube_node


```

Приводим hosts.yaml в соответсвие с заданием. 1 мастер и 4 рабочие ноды, etcd запускаем на мастере:

```yaml
all:
  hosts:
    node1:
      ansible_host: '10.0.1.38'
      ip: 10.0.1.38
      access_ip: '10.0.1.38'
    node2:
      ansible_host: '10.0.1.21'
      ip: 10.0.1.21
      access_ip: '10.0.1.21'
    node3:
      ansible_host: '10.0.1.32'
      ip: 10.0.1.32
      access_ip: '10.0.1.32'
    node4:
      ansible_host: '10.0.1.12'
      ip: 10.0.1.12
      access_ip: '10.0.1.12'
    node5:
      ansible_host: 10.0.1.20
      ip: 10.0.1.20
      access_ip: 10.0.1.20
  children:
    kube_control_plane:
      hosts:
        node1:
    kube_node:
      hosts:
        node2:
        node3:
        node4:
        node5:
    etcd:
      hosts:
        node1:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}

```

запускаем playbook:

```bash
ubuntu@node1:~/kubespray$ ansible-playbook -i inventory/mycluster/hosts.yaml cluster.yml -b -v
Using /home/ubuntu/kubespray/ansible.cfg as config file
[WARNING]: Skipping callback plugin 'ara_default', unable to load

PLAY [Check Ansible version] *****************************************************************************************************************************************************************
Thursday 16 November 2023  11:02:28 +0000 (0:00:00.080)       0:00:00.080 ***** 

TASK [Check 2.15.5 <= Ansible version < 2.17.0] **********************************************************************************************************************************************
ok: [localhost] => {
    "changed": false,
    "msg": "All assertions passed"
}
Thursday 16 November 2023  11:02:28 +0000 (0:00:00.186)       0:00:00.267 ***** 

TASK [Check that python netaddr is installed] ************************************************************************************************************************************************
ok: [localhost] => {
    "changed": false,
    "msg": "All assertions passed"
}
Thursday 16 November 2023  11:02:29 +0000 (0:00:00.150)       0:00:00.417 ***** 

TASK [Check that jinja is not too old (install via pip)] *************************************************************************************************************************************
ok: [localhost] => {
    "changed": false,
    "msg": "All assertions passed"

...

TASK [network_plugin/calico : Get current calico version] ************************************************************************************************************************************
ok: [node1] => {"changed": false, "cmd": "set -o pipefail && /usr/local/bin/calicoctl.sh version | grep 'Client Version:' | awk '{ print $3}'", "delta": "0:00:00.151023", "end": "2023-11-16 11:28:28.197779", "msg": "", "rc": 0, "start": "2023-11-16 11:28:28.046756", "stderr": "", "stderr_lines": [], "stdout": "v3.26.3", "stdout_lines": ["v3.26.3"]}
Thursday 16 November 2023  11:28:28 +0000 (0:00:00.594)       0:25:59.625 ***** 

TASK [network_plugin/calico : Assert that current calico version is enough for upgrade] ******************************************************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Thursday 16 November 2023  11:28:28 +0000 (0:00:00.148)       0:25:59.773 ***** 
Thursday 16 November 2023  11:28:28 +0000 (0:00:00.094)       0:25:59.868 ***** 
Thursday 16 November 2023  11:28:28 +0000 (0:00:00.090)       0:25:59.959 ***** 

TASK [network_plugin/calico : Check vars defined correctly] **********************************************************************************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Thursday 16 November 2023  11:28:28 +0000 (0:00:00.112)       0:26:00.071 ***** 

TASK [network_plugin/calico : Check calico network backend defined correctly] ****************************************************************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Thursday 16 November 2023  11:28:28 +0000 (0:00:00.109)       0:26:00.181 ***** 

TASK [network_plugin/calico : Check ipip and vxlan mode defined correctly] *******************************************************************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Thursday 16 November 2023  11:28:28 +0000 (0:00:00.131)       0:26:00.313 ***** 
Thursday 16 November 2023  11:28:29 +0000 (0:00:00.103)       0:26:00.416 ***** 

TASK [network_plugin/calico : Check ipip and vxlan mode if simultaneously enabled] ***********************************************************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Thursday 16 November 2023  11:28:29 +0000 (0:00:00.166)       0:26:00.582 ***** 

TASK [network_plugin/calico : Get Calico default-pool configuration] *************************************************************************************************************************
ok: [node1] => {"changed": false, "cmd": ["/usr/local/bin/calicoctl.sh", "get", "ipPool", "default-pool", "-o", "json"], "delta": "0:00:00.138613", "end": "2023-11-16 11:28:29.769427", "failed_when_result": false, "msg": "", "rc": 0, "start": "2023-11-16 11:28:29.630814", "stderr": "", "stderr_lines": [], "stdout": "{\n  \"kind\": \"IPPool\",\n  \"apiVersion\": \"projectcalico.org/v3\",\n  \"metadata\": {\n    \"name\": \"default-pool\",\n    \"uid\": \"0418c11c-2511-46cf-9929-07c6712c8036\",\n    \"resourceVersion\": \"820\",\n    \"creationTimestamp\": \"2023-11-16T11:23:49Z\"\n  },\n  \"spec\": {\n    \"cidr\": \"10.233.64.0/18\",\n    \"vxlanMode\": \"Always\",\n    \"ipipMode\": \"Never\",\n    \"natOutgoing\": true,\n    \"blockSize\": 26,\n    \"nodeSelector\": \"all()\",\n    \"allowedUses\": [\n      \"Workload\",\n      \"Tunnel\"\n    ]\n  }\n}", "stdout_lines": ["{", "  \"kind\": \"IPPool\",", "  \"apiVersion\": \"projectcalico.org/v3\",", "  \"metadata\": {", "    \"name\": \"default-pool\",", "    \"uid\": \"0418c11c-2511-46cf-9929-07c6712c8036\",", "    \"resourceVersion\": \"820\",", "    \"creationTimestamp\": \"2023-11-16T11:23:49Z\"", "  },", "  \"spec\": {", "    \"cidr\": \"10.233.64.0/18\",", "    \"vxlanMode\": \"Always\",", "    \"ipipMode\": \"Never\",", "    \"natOutgoing\": true,", "    \"blockSize\": 26,", "    \"nodeSelector\": \"all()\",", "    \"allowedUses\": [", "      \"Workload\",", "      \"Tunnel\"", "    ]", "  }", "}"]}
Thursday 16 November 2023  11:28:29 +0000 (0:00:00.573)       0:26:01.156 ***** 

TASK [network_plugin/calico : Set calico_pool_conf] ******************************************************************************************************************************************
ok: [node1] => {"ansible_facts": {"calico_pool_conf": {"apiVersion": "projectcalico.org/v3", "kind": "IPPool", "metadata": {"creationTimestamp": "2023-11-16T11:23:49Z", "name": "default-pool", "resourceVersion": "820", "uid": "0418c11c-2511-46cf-9929-07c6712c8036"}, "spec": {"allowedUses": ["Workload", "Tunnel"], "blockSize": 26, "cidr": "10.233.64.0/18", "ipipMode": "Never", "natOutgoing": true, "nodeSelector": "all()", "vxlanMode": "Always"}}}, "changed": false}
Thursday 16 November 2023  11:28:29 +0000 (0:00:00.108)       0:26:01.265 ***** 

TASK [network_plugin/calico : Check if inventory match current cluster configuration] ********************************************************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Thursday 16 November 2023  11:28:30 +0000 (0:00:00.287)       0:26:01.552 ***** 
Thursday 16 November 2023  11:28:30 +0000 (0:00:00.098)       0:26:01.651 ***** 
Thursday 16 November 2023  11:28:30 +0000 (0:00:00.082)       0:26:01.733 ***** 

PLAY RECAP ***********************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
node1                      : ok=741  changed=127  unreachable=0    failed=0    skipped=1300 rescued=0    ignored=8   
node2                      : ok=507  changed=76   unreachable=0    failed=0    skipped=797  rescued=0    ignored=1   
node3                      : ok=507  changed=76   unreachable=0    failed=0    skipped=796  rescued=0    ignored=1   
node4                      : ok=507  changed=76   unreachable=0    failed=0    skipped=796  rescued=0    ignored=1   
node5                      : ok=507  changed=76   unreachable=0    failed=0    skipped=796  rescued=0    ignored=1   

Thursday 16 November 2023  11:28:30 +0000 (0:00:00.469)       0:26:02.203 ***** 
=============================================================================== 
download : Download_file | Download item --------------------------------------------------------------------------------------------------------------------------------------------- 68.20s
kubernetes/preinstall : Install packages requirements -------------------------------------------------------------------------------------------------------------------------------- 48.64s
network_plugin/calico : Wait for calico kubeconfig to be created --------------------------------------------------------------------------------------------------------------------- 42.86s
kubernetes/preinstall : Preinstall | wait for the apiserver to be running ------------------------------------------------------------------------------------------------------------ 40.94s
kubernetes/control-plane : Kubeadm | Initialize first master ------------------------------------------------------------------------------------------------------------------------- 37.97s
download : Download_file | Download item --------------------------------------------------------------------------------------------------------------------------------------------- 36.06s
container-engine/containerd : Download_file | Download item -------------------------------------------------------------------------------------------------------------------------- 20.65s
container-engine/nerdctl : Download_file | Download item ----------------------------------------------------------------------------------------------------------------------------- 19.96s
container-engine/crictl : Download_file | Download item ------------------------------------------------------------------------------------------------------------------------------ 19.60s
container-engine/runc : Download_file | Download item -------------------------------------------------------------------------------------------------------------------------------- 19.48s
kubernetes/kubeadm : Join to cluster ------------------------------------------------------------------------------------------------------------------------------------------------- 18.27s
container-engine/crictl : Extract_file | Unpacking archive --------------------------------------------------------------------------------------------------------------------------- 16.67s
download : Download_container | Download image if required --------------------------------------------------------------------------------------------------------------------------- 13.84s
kubernetes-apps/ansible : Kubernetes Apps | Start Resources -------------------------------------------------------------------------------------------------------------------------- 13.75s
container-engine/nerdctl : Extract_file | Unpacking archive -------------------------------------------------------------------------------------------------------------------------- 13.72s
download : Download_container | Download image if required --------------------------------------------------------------------------------------------------------------------------- 13.53s
download : Download_container | Download image if required --------------------------------------------------------------------------------------------------------------------------- 12.33s
container-engine/containerd : Download_file | Validate mirrors ----------------------------------------------------------------------------------------------------------------------- 12.06s
container-engine/crictl : Download_file | Validate mirrors --------------------------------------------------------------------------------------------------------------------------- 11.73s
container-engine/runc : Download_file | Validate mirrors ----------------------------------------------------------------------------------------------------------------------------- 11.63s
ubuntu@node1:~/kubespray$ 

```

```bash
ubuntu@node1:~$ sudo kubectl get nodes
NAME    STATUS   ROLES           AGE   VERSION
node1   Ready    control-plane   47m   v1.28.3
node2   Ready    <none>          46m   v1.28.3
node3   Ready    <none>          46m   v1.28.3
node4   Ready    <none>          46m   v1.28.3
node5   Ready    <none>          46m   v1.28.3

ubuntu@node1:~$ sudo kubectl get pods -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS      AGE
kube-system   calico-kube-controllers-5fcbbfb4cb-kt4ll   1/1     Running   0             44m
kube-system   calico-node-5c6gs                          1/1     Running   0             46m
kube-system   calico-node-8jp2s                          1/1     Running   0             46m
kube-system   calico-node-ktl9d                          1/1     Running   0             46m
kube-system   calico-node-p5g2j                          1/1     Running   0             46m
kube-system   calico-node-qkgbr                          1/1     Running   0             46m
kube-system   coredns-77f7cc69db-2whvf                   1/1     Running   0             44m
kube-system   coredns-77f7cc69db-hqwh6                   1/1     Running   0             43m
kube-system   dns-autoscaler-8576bb9f5b-jjnrq            1/1     Running   0             44m
kube-system   kube-apiserver-node1                       1/1     Running   2 (42m ago)   48m
kube-system   kube-controller-manager-node1              1/1     Running   3 (42m ago)   48m
kube-system   kube-proxy-8h2xr                           1/1     Running   0             47m
kube-system   kube-proxy-9xhgn                           1/1     Running   0             47m
kube-system   kube-proxy-np945                           1/1     Running   0             47m
kube-system   kube-proxy-nxj27                           1/1     Running   0             47m
kube-system   kube-proxy-vbqw2                           1/1     Running   0             47m
kube-system   kube-scheduler-node1                       1/1     Running   2 (42m ago)   48m
kube-system   nginx-proxy-node2                          1/1     Running   0             47m
kube-system   nginx-proxy-node3                          1/1     Running   0             47m
kube-system   nginx-proxy-node4                          1/1     Running   0             47m
kube-system   nginx-proxy-node5                          1/1     Running   0             47m
kube-system   nodelocaldns-2hm4z                         1/1     Running   0             43m
kube-system   nodelocaldns-bnfnc                         1/1     Running   0             43m
kube-system   nodelocaldns-dvbng                         1/1     Running   0             43m
kube-system   nodelocaldns-qq69f                         1/1     Running   0             43m
kube-system   nodelocaldns-s2jmv                         1/1     Running   0             43m

ubuntu@node1:~$ systemctl status etcd
● etcd.service - etcd
     Loaded: loaded (/etc/systemd/system/etcd.service; enabled; vendor preset: enabled)
     Active: active (running) since Thu 2023-11-16 11:19:55 UTC; 51min ago
   Main PID: 27235 (etcd)
      Tasks: 10 (limit: 2293)
     Memory: 88.9M
     CGroup: /system.slice/etcd.service
             └─27235 /usr/local/bin/etcd

Nov 16 12:10:05 node1 etcd[27235]: {"level":"warn","ts":"2023-11-16T12:10:05.338144Z","caller":"v3rpc/interceptor.go:197","msg":"request stats","start time":"2023-11-16T12:10:05.000742Z","t>
Nov 16 12:10:05 node1 etcd[27235]: {"level":"warn","ts":"2023-11-16T12:10:05.337596Z","caller":"etcdserver/util.go:170","msg":"apply request took too long","took":"330.8313ms","expected-dur>
Nov 16 12:10:05 node1 etcd[27235]: {"level":"info","ts":"2023-11-16T12:10:05.343216Z","caller":"traceutil/trace.go:171","msg":"trace[776389728] range","detail":"{range_begin:/registry/event>
Nov 16 12:10:05 node1 etcd[27235]: {"level":"warn","ts":"2023-11-16T12:10:05.343334Z","caller":"v3rpc/interceptor.go:197","msg":"request stats","start time":"2023-11-16T12:10:05.006697Z","t>
Nov 16 12:10:25 node1 etcd[27235]: {"level":"info","ts":"2023-11-16T12:10:25.906567Z","caller":"traceutil/trace.go:171","msg":"trace[1338379542] transaction","detail":"{read_only:false; res>
Nov 16 12:10:25 node1 etcd[27235]: {"level":"info","ts":"2023-11-16T12:10:25.926314Z","caller":"traceutil/trace.go:171","msg":"trace[1943447211] transaction","detail":"{read_only:false; res>
Nov 16 12:10:30 node1 etcd[27235]: {"level":"info","ts":"2023-11-16T12:10:30.748096Z","caller":"traceutil/trace.go:171","msg":"trace[898036153] transaction","detail":"{read_only:false; resp>
Nov 16 12:10:31 node1 etcd[27235]: {"level":"warn","ts":"2023-11-16T12:10:31.148263Z","caller":"etcdserver/util.go:170","msg":"apply request took too long","took":"232.939901ms","expected-d>
Nov 16 12:10:31 node1 etcd[27235]: {"level":"info","ts":"2023-11-16T12:10:31.148377Z","caller":"traceutil/trace.go:171","msg":"trace[1900040992] range","detail":"{range_begin:/registry/leas>
Nov 16 12:10:33 node1 etcd[27235]: {"level":"info","ts":"2023-11-16T12:10:33.506697Z","caller":"traceutil/trace.go:171","msg":"trace[190156834] transaction","detail":"{read_only:false; resp>
ubuntu@node2:~$ systemctl status etcd
Unit etcd.service could not be found.

ubuntu@node1:~/kubespray/inventory/mycluster/group_vars/k8s_cluster$ cat k8s-cluster.yml | grep containerd
## docker for docker, crio for cri-o and containerd for containerd.
## Default: containerd
container_manager: containerd

```

</details>

<details>
<summary>
kubeadm
</summary>

Подготавливаем vm для установки k8s

```bash
vagrant@vm1:/netology_data/HW14-k8s-02-install/terraform$ yc compute instance list
+----------------------+-----------------------+---------------+---------+-----------------+-------------+
|          ID          |         NAME          |    ZONE ID    | STATUS  |   EXTERNAL IP   | INTERNAL IP |
+----------------------+-----------------------+---------------+---------+-----------------+-------------+
| fhm3diot7i7e96e10upg | worker-node-kubeadm-4 | ru-central1-a | RUNNING | 158.160.125.171 | 10.0.1.31   |
| fhmh72q4j6faj4fvmesm | worker-node-kubeadm-3 | ru-central1-a | RUNNING | 158.160.108.58  | 10.0.1.11   |
| fhmi45v20hdpd9vcc10a | master-node-kubeadm-1 | ru-central1-a | RUNNING | 51.250.83.228   | 10.0.1.13   |
| fhmifbnc1qoq5jjqpio9 | worker-node-kubeadm-1 | ru-central1-a | RUNNING | 158.160.123.174 | 10.0.1.12   |
| fhmnm6akrvasjtvp9rll | worker-node-kubeadm-2 | ru-central1-a | RUNNING | 158.160.61.52   | 10.0.1.29   |
+----------------------+-----------------------+---------------+---------+-----------------+-------------+

```

```bash
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sudo mkdir -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl containerd
sudo apt-mark hold kubelet kubeadm kubectl

sudo modprobe  br_netfilter
sudo /bin/su -c "echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf"
sudo /bin/su -c "echo 'net.bridge.bridge-nf-call-iptables=1' >> /etc/sysctl.conf"
sudo /bin/su -c "echo 'net.bridge.bridge-nf-call-arptables=1' >> /etc/sysctl.conf"
sudo /bin/su -c "echo 'net.bridge.bridge-nf-call-ip6tables=1' >> /etc/sysctl.conf"
sudo sysctl -p /etc/sysctl.conf
```

Инициируем kubeadm 

```bash
vagrant@vm1:/netology_data/HW14-k8s-02-install/terraform$ ssh ubuntu@51.250.83.228
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-166-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.3 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

Last login: Thu Nov 23 11:11:58 2023 from 213.208.164.178
ubuntu@master-node-kubeadm-1:~$ sudo kubeadm init --apiserver-advertise-address=10.0.1.13 --pod-network-cidr 10.244.0.0/16 --apiserver-cert-extra-sans=51.250.83.228
[init] Using Kubernetes version: v1.28.4
[preflight] Running pre-flight checks
[preflight] Pulling images required for setting up a Kubernetes cluster
[preflight] This might take a minute or two, depending on the speed of your internet connection
[preflight] You can also perform this action in beforehand using 'kubeadm config images pull'
W1123 11:14:51.764864    2686 checks.go:835] detected that the sandbox image "registry.k8s.io/pause:3.8" of the container runtime is inconsistent with that used by kubeadm. It is recommended that using "registry.k8s.io/pause:3.9" as the CRI sandbox image.
[certs] Using certificateDir folder "/etc/kubernetes/pki"
[certs] Generating "ca" certificate and key
[certs] Generating "apiserver" certificate and key
[certs] apiserver serving cert is signed for DNS names [kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local master-node-kubeadm-1] and IPs [10.96.0.1 10.0.1.13 51.250.83.228]
[certs] Generating "apiserver-kubelet-client" certificate and key
[certs] Generating "front-proxy-ca" certificate and key
[certs] Generating "front-proxy-client" certificate and key
[certs] Generating "etcd/ca" certificate and key
[certs] Generating "etcd/server" certificate and key
[certs] etcd/server serving cert is signed for DNS names [localhost master-node-kubeadm-1] and IPs [10.0.1.13 127.0.0.1 ::1]
[certs] Generating "etcd/peer" certificate and key
[certs] etcd/peer serving cert is signed for DNS names [localhost master-node-kubeadm-1] and IPs [10.0.1.13 127.0.0.1 ::1]
[certs] Generating "etcd/healthcheck-client" certificate and key
[certs] Generating "apiserver-etcd-client" certificate and key
[certs] Generating "sa" key and public key
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
[etcd] Creating static Pod manifest for local etcd in "/etc/kubernetes/manifests"
[control-plane] Using manifest folder "/etc/kubernetes/manifests"
[control-plane] Creating static Pod manifest for "kube-apiserver"
[control-plane] Creating static Pod manifest for "kube-controller-manager"
[control-plane] Creating static Pod manifest for "kube-scheduler"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Starting the kubelet
[wait-control-plane] Waiting for the kubelet to boot up the control plane as static Pods from directory "/etc/kubernetes/manifests". This can take up to 4m0s
[apiclient] All control plane components are healthy after 17.504521 seconds
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upload-certs] Skipping phase. Please see --upload-certs
[mark-control-plane] Marking the node master-node-kubeadm-1 as control-plane by adding the labels: [node-role.kubernetes.io/control-plane node.kubernetes.io/exclude-from-external-load-balancers]
[mark-control-plane] Marking the node master-node-kubeadm-1 as control-plane by adding the taints [node-role.kubernetes.io/control-plane:NoSchedule]
[bootstrap-token] Using token: zwpwzz.1b9a6fly3jl9fhvw
[bootstrap-token] Configuring bootstrap tokens, cluster-info ConfigMap, RBAC Roles
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[bootstrap-token] Creating the "cluster-info" ConfigMap in the "kube-public" namespace
[kubelet-finalize] Updating "/etc/kubernetes/kubelet.conf" to point to a rotatable kubelet client certificate and key
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

Alternatively, if you are the root user, you can run:

  export KUBECONFIG=/etc/kubernetes/admin.conf

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.0.1.13:6443 --token zwpwzz.1b9a6fly3jl9fhvw \
	--discovery-token-ca-cert-hash sha256:98efe10b6ca209ca3f64f1197dfb0d70db1b2513280f201ee8455342328aae97 

ubuntu@master-node-kubeadm-1:~$ mkdir -p $HOME/.kube
ubuntu@master-node-kubeadm-1:~$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
ubuntu@master-node-kubeadm-1:~$ sudo chown $(id -u):$(id -g) $HOME/.kube/config

ubuntu@master-node-kubeadm-1:~$ kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
namespace/kube-flannel created
serviceaccount/flannel created
clusterrole.rbac.authorization.k8s.io/flannel created
clusterrolebinding.rbac.authorization.k8s.io/flannel created
configmap/kube-flannel-cfg created
daemonset.apps/kube-flannel-ds created

```

Присоединяем остальные ноды:

```bash
vagrant@vm1:/netology_data/HW14-k8s-02-install/terraform$ ssh ubuntu@158.160.123.174
The authenticity of host '158.160.123.174 (158.160.123.174)' can't be established.
ECDSA key fingerprint is SHA256:uQsEPrMNlJiA2IeGUPIrF8ThTcvnBLGJOGPalBLd9sA.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '158.160.123.174' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-166-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.3 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

Last login: Thu Nov 23 09:15:54 2023 from 213.208.164.178

ubuntu@worker-node-kubeadm-1:~$ sudo kubeadm join 10.0.1.13:6443 --token zwpwzz.1b9a6fly3jl9fhvw --discovery-token-ca-cert-hash sha256:98efe10b6ca209ca3f64f1197dfb0d70db1b2513280f201ee8455342328aae97
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

ubuntu@worker-node-kubeadm-1:~$ exit
logout
Connection to 158.160.123.174 closed.
vagrant@vm1:/netology_data/HW14-k8s-02-install/terraform$ ssh ubuntu@158.160.61.52
The authenticity of host '158.160.61.52 (158.160.61.52)' can't be established.
ECDSA key fingerprint is SHA256:R3dFsh65l8X+UY/P7cvwZ03OSfqdVnc1agJhkY7XTAc.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '158.160.61.52' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-166-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.3 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

Last login: Thu Nov 23 09:15:54 2023 from 213.208.164.178
ubuntu@worker-node-kubeadm-2:~$ sudo kubeadm join 10.0.1.13:6443 --token zwpwzz.1b9a6fly3jl9fhvw --discovery-token-ca-cert-hash sha256:98efe10b6ca209ca3f64f1197dfb0d70db1b2513280f201ee8455342328aae97
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

ubuntu@worker-node-kubeadm-2:~$ exit
logout
Connection to 158.160.61.52 closed.
vagrant@vm1:/netology_data/HW14-k8s-02-install/terraform$ ssh ubuntu@158.160.108.58
The authenticity of host '158.160.108.58 (158.160.108.58)' can't be established.
ECDSA key fingerprint is SHA256:rV8g6aTPHaKKYAEJgDK6W4XmT+GQygQjc7kg6Komthw.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '158.160.108.58' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-166-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.3 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

Last login: Thu Nov 23 09:16:10 2023 from 213.208.164.178
ubuntu@worker-node-kubeadm-3:~$ sudo kubeadm join 10.0.1.13:6443 --token zwpwzz.1b9a6fly3jl9fhvw --discovery-token-ca-cert-hash sha256:98efe10b6ca209ca3f64f1197dfb0d70db1b2513280f201ee8455342328aae97
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

ubuntu@worker-node-kubeadm-3:~$ exit
logout
Connection to 158.160.108.58 closed.
vagrant@vm1:/netology_data/HW14-k8s-02-install/terraform$ ssh ubuntu@158.160.125.171
The authenticity of host '158.160.125.171 (158.160.125.171)' can't be established.
ECDSA key fingerprint is SHA256:r4lDtMIrCzaM03KfVhJ5lxrtMIoFoAs6Zr/dwOR73ac.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '158.160.125.171' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-166-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.3 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

Last login: Thu Nov 23 09:16:33 2023 from 213.208.164.178
ubuntu@worker-node-kubeadm-4:~$ sudo kubeadm join 10.0.1.13:6443 --token zwpwzz.1b9a6fly3jl9fhvw --discovery-token-ca-cert-hash sha256:98efe10b6ca209ca3f64f1197dfb0d70db1b2513280f201ee8455342328aae97
[preflight] Running pre-flight checks
[preflight] Reading configuration from the cluster...
[preflight] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubelet-start] Writing kubelet environment file with flags to file "/var/lib/kubelet/kubeadm-flags.env"
[kubelet-start] Starting the kubelet
[kubelet-start] Waiting for the kubelet to perform the TLS Bootstrap...

This node has joined the cluster:
* Certificate signing request was sent to apiserver and a response was received.
* The Kubelet was informed of the new secure connection details.

Run 'kubectl get nodes' on the control-plane to see this node join the cluster.

ubuntu@worker-node-kubeadm-4:~$
```

Смотрим ноды:

```bash
ubuntu@master-node-kubeadm-1:~$ kubectl get nodes
NAME                    STATUS   ROLES           AGE   VERSION
master-node-kubeadm-1   Ready    control-plane   23m   v1.28.4
worker-node-kubeadm-1   Ready    <none>          16m   v1.28.4
worker-node-kubeadm-2   Ready    <none>          15m   v1.28.4
worker-node-kubeadm-3   Ready    <none>          15m   v1.28.4
worker-node-kubeadm-4   Ready    <none>          15m   v1.28.4

ubuntu@master-node-kubeadm-1:~$ kubectl get pod -A
NAMESPACE      NAME                                            READY   STATUS    RESTARTS   AGE
kube-flannel   kube-flannel-ds-lzdqh                           1/1     Running   0          2m3s
kube-flannel   kube-flannel-ds-n9h57                           1/1     Running   0          2m3s
kube-flannel   kube-flannel-ds-nhs78                           1/1     Running   0          2m3s
kube-flannel   kube-flannel-ds-s8xlr                           1/1     Running   0          2m3s
kube-flannel   kube-flannel-ds-trfvn                           1/1     Running   0          2m3s
kube-system    coredns-5dd5756b68-4zzmd                        1/1     Running   0          24m
kube-system    coredns-5dd5756b68-rqxq6                        1/1     Running   0          24m
kube-system    etcd-master-node-kubeadm-1                      1/1     Running   0          24m
kube-system    kube-apiserver-master-node-kubeadm-1            1/1     Running   0          24m
kube-system    kube-controller-manager-master-node-kubeadm-1   1/1     Running   0          24m
kube-system    kube-proxy-7b44j                                1/1     Running   0          16m
kube-system    kube-proxy-kxw2n                                1/1     Running   0          17m
kube-system    kube-proxy-rhqfj                                1/1     Running   0          16m
kube-system    kube-proxy-trskx                                1/1     Running   0          16m
kube-system    kube-proxy-vwbbw                                1/1     Running   0          24m
kube-system    kube-scheduler-master-node-kubeadm-1            1/1     Running   0          24m

```

</details>

---

</details>

## Дополнительные задания (со звёздочкой)

**Настоятельно рекомендуем выполнять все задания под звёздочкой.** Их выполнение поможет глубже разобраться в материале.   
Задания под звёздочкой необязательные к выполнению и не повлияют на получение зачёта по этому домашнему заданию. 

------
### Задание 2*. Установить HA кластер

1. Установить кластер в режиме HA.
2. Использовать нечётное количество Master-node.
3. Для cluster ip использовать keepalived или другой способ.

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl get nodes`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.