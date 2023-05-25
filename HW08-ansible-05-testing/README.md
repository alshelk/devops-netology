# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule: `pip3 install "molecule==3.5.2"`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos_7` внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу.

<details>
<summary>

</summary>

```bash
$ molecule test -s centos_7
INFO     centos_7 scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/vagrant/.cache/ansible-compat/7e099f/modules:/home/vagrant/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/vagrant/.cache/ansible-compat/7e099f/collections:/home/vagrant/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/vagrant/.cache/ansible-compat/7e099f/roles:/home/vagrant/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Inventory /netology_data/HW08-ansible-04-role/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-04-role/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-04-role/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > dependency
INFO     Running from /netology_data/HW08-ansible-04-role/playbook/roles/clickhouse : ansible-galaxy collection install -vvv community.docker:>=1.9.1
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Inventory /netology_data/HW08-ansible-04-role/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-04-role/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-04-role/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > lint
COMMAND: yamllint .
ansible-lint
flake8

/bin/bash: yamllint: command not found
/bin/bash: line 2: flake8: command not found
CRITICAL Lint failed with error code 127
WARNING  An error occurred during the test sequence action: 'lint'. Cleaning up.
INFO     Inventory /netology_data/HW08-ansible-04-role/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-04-role/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-04-role/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Inventory /netology_data/HW08-ansible-04-role/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-04-role/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-04-role/playbook/roles/clickhouse/molecule/centos_7/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/clickhouse/centos_7/inventory/host_vars
INFO     Running centos_7 > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos_7)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos_7)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```

</details>

2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.



```yaml
$ molecule init scenario --driver-name docker
INFO     Initializing new scenario default...
INFO     Initialized scenario in /netology_data/HW08-ansible-05-testing/vector-role/molecule/default successfully.
```


</details>



3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.

<details>
<summary>

</summary>

```bash
$ molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/vagrant/.cache/ansible-compat/f5bcd7/modules:/home/vagrant/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/vagrant/.cache/ansible-compat/f5bcd7/collections:/home/vagrant/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/vagrant/.cache/ansible-compat/f5bcd7/roles:/home/vagrant/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos8)
ok: [localhost] => (item=centos7)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > syntax

playbook: /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/converge.yml
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
ok: [localhost] => (item={'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
ok: [localhost] => (item={'command': '/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
skipping: [localhost] => (item={'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
changed: [localhost] => (item={'command': '/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'diff': [], 'dest': '/home/vagrant/.cache/molecule/vector-role/default/Dockerfile_docker_io_pycontribs_ubuntu_latest', 'src': '/home/vagrant/.ansible/tmp/ansible-tmp-1684851994.8209112-529094-105032627656159/source', 'md5sum': '65034a930f11f9ffec0da1b886389202', 'checksum': 'f1052448f34e5dcbc419949283d4bbdc690f2776', 'changed': True, 'uid': 1000, 'gid': 1000, 'owner': 'vagrant', 'group': 'vagrant', 'mode': '0600', 'state': 'file', 'size': 1320, 'invocation': {'module_args': {'src': '/home/vagrant/.ansible/tmp/ansible-tmp-1684851994.8209112-529094-105032627656159/source', 'dest': '/home/vagrant/.cache/molecule/vector-role/default/Dockerfile_docker_io_pycontribs_ubuntu_latest', 'mode': '0600', 'follow': False, '_original_basename': 'Dockerfile.j2', 'checksum': 'f1052448f34e5dcbc419949283d4bbdc690f2776', 'backup': False, 'force': True, 'unsafe_writes': False, 'content': None, 'validate': None, 'directory_mode': None, 'remote_src': None, 'local_follow': None, 'owner': None, 'group': None, 'seuser': None, 'serole': None, 'selevel': None, 'setype': None, 'attributes': None}}, 'failed': False, 'item': {'command': '/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:7) 
changed: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest)

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
ok: [localhost] => (item={'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
ok: [localhost] => (item={'command': '/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '2045345366.537097', 'results_file': '/home/vagrant/.ansible_async/2045345366.537097', 'changed': True, 'item': {'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item'})
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '101616132891.537125', 'results_file': '/home/vagrant/.ansible_async/101616132891.537125', 'changed': True, 'item': {'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '822730673042.537152', 'results_file': '/home/vagrant/.ansible_async/822730673042.537152', 'changed': True, 'item': {'command': '/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=7    changed=4    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu]
ok: [centos8]
ok: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Create temp directory] *************************************
changed: [centos8]
changed: [ubuntu]
changed: [centos7]

TASK [vector-role : Get vector distrib] ****************************************
changed: [centos7]
changed: [ubuntu]
changed: [centos8]

TASK [vector-role : Create root directory] *************************************
changed: [centos7]
changed: [centos8]
changed: [ubuntu]

TASK [vector-role : Extract vector] ********************************************
changed: [ubuntu]
changed: [centos8]
changed: [centos7]

TASK [vector-role : Copy vector to bin with owner and permissions] *************
changed: [centos7]
changed: [ubuntu]
changed: [centos8]

TASK [vector-role : Configure vector.service from template] ********************
changed: [centos7]
changed: [centos8]
changed: [ubuntu]

TASK [vector-role : create config dir for vector] ******************************
changed: [centos7]
changed: [ubuntu]
changed: [centos8]

TASK [vector-role : Configure vector from template] ****************************
changed: [centos7]
changed: [centos8]
changed: [ubuntu]

TASK [vector-role : Create data directory] *************************************
changed: [centos7]
changed: [ubuntu]
changed: [centos8]

TASK [vector-role : Flush handlers] ********************************************

RUNNING HANDLER [vector-role : restarted vector service] ***********************
changed: [centos8]
changed: [ubuntu]
changed: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=11   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos8                    : ok=11   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=11   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos8]
ok: [ubuntu]
ok: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Create temp directory] *************************************
ok: [centos7]
ok: [ubuntu]
ok: [centos8]

TASK [vector-role : Get vector distrib] ****************************************
ok: [centos7]
ok: [centos8]
ok: [ubuntu]

TASK [vector-role : Create root directory] *************************************
ok: [centos7]
ok: [ubuntu]
ok: [centos8]

TASK [vector-role : Extract vector] ********************************************
ok: [centos8]
ok: [ubuntu]
ok: [centos7]

TASK [vector-role : Copy vector to bin with owner and permissions] *************
ok: [ubuntu]
ok: [centos7]
ok: [centos8]

TASK [vector-role : Configure vector.service from template] ********************
ok: [centos7]
ok: [centos8]
ok: [ubuntu]

TASK [vector-role : create config dir for vector] ******************************
ok: [centos7]
ok: [centos8]
ok: [ubuntu]

TASK [vector-role : Configure vector from template] ****************************
ok: [centos7]
ok: [centos8]
ok: [ubuntu]

TASK [vector-role : Create data directory] *************************************
ok: [centos7]
ok: [ubuntu]
ok: [centos8]

TASK [vector-role : Flush handlers] ********************************************

PLAY RECAP *********************************************************************
centos7                    : ok=10   changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos8                    : ok=10   changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=10   changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [centos8] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [ubuntu] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos8                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```

</details>

4. Добавьте несколько assert в verify.yml-файл для проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.).

<details>
<summary>

</summary>


```yaml
---
# This is an example playbook to execute Ansible tests.

- name: Preparation verify vector centos
  hosts: centos7
  gather_facts: false
  tasks:
    - name: install nc
      become: true
      yum:
        name: nc
        state: present
- name: Preparation verify vector centos
  hosts: centos8
  gather_facts: false
  tasks:
    - name: prepare repo
      shell: sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
    - name: install nc
      become: true
      yum:
        name: nc
        state: present
- name: Preparation verify vector ubuntu
  hosts: deb
  gather_facts: false
  tasks:
    - name: install nc
      become: true
      apt:
        name: netcat
        state: present
- name: Verify vector
  hosts: all
  gather_facts: false
  tasks:
    - name: Show facts available on the system
      ansible.builtin.debug:
        var: ansible_facts.distribution
    - name: validate config vector
      shell: /usr/bin/vector validate --config-yaml /etc/vector/vector.yml
      changed_when: false
    - name: Copy and Execute the script
      script: ../resources/create_message.sh
      register: qwe
      changed_when: false
    - name: check work vector
      slurp:
        src: "/etc/vector/local.log"
      register: mounts
    - name: set correct fact
      set_fact:
        debug_msg: "{{ mounts['content'] | b64decode }}"
    - name: Test message in file
      assert:
        that:
          - "'debug message' in debug_msg.message"
```

</details>

5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.

<details>
<summary>

</summary>

```bash
$ molecule test
INFO     default scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/home/vagrant/.cache/ansible-compat/f5bcd7/modules:/home/vagrant/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/home/vagrant/.cache/ansible-compat/f5bcd7/collections:/home/vagrant/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/home/vagrant/.cache/ansible-compat/f5bcd7/roles:/home/vagrant/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > lint
INFO     Lint is disabled.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > destroy
INFO     Sanity checks: 'docker'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
ok: [localhost] => (item=centos8)
ok: [localhost] => (item=centos7)
ok: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=1    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > syntax

playbook: /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/converge.yml
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > create

PLAY [Create] ******************************************************************

TASK [Log into a Docker registry] **********************************************
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost] => (item=None) 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item={'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
ok: [localhost] => (item={'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
ok: [localhost] => (item={'command': '/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item={'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
skipping: [localhost] => (item={'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
changed: [localhost] => (item={'command': '/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

TASK [Discover local Docker images] ********************************************
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item', 'i': 0, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'changed': False, 'skipped': True, 'skip_reason': 'Conditional result was False', 'item': {'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item', 'i': 1, 'ansible_index_var': 'i'})
ok: [localhost] => (item={'diff': [], 'dest': '/home/vagrant/.cache/molecule/vector-role/default/Dockerfile_docker_io_pycontribs_ubuntu_latest', 'src': '/home/vagrant/.ansible/tmp/ansible-tmp-1685013891.9296525-981596-82172195115297/source', 'md5sum': '65034a930f11f9ffec0da1b886389202', 'checksum': 'f1052448f34e5dcbc419949283d4bbdc690f2776', 'changed': True, 'uid': 1000, 'gid': 1000, 'owner': 'vagrant', 'group': 'vagrant', 'mode': '0600', 'state': 'file', 'size': 1320, 'invocation': {'module_args': {'src': '/home/vagrant/.ansible/tmp/ansible-tmp-1685013891.9296525-981596-82172195115297/source', 'dest': '/home/vagrant/.cache/molecule/vector-role/default/Dockerfile_docker_io_pycontribs_ubuntu_latest', 'mode': '0600', 'follow': False, '_original_basename': 'Dockerfile.j2', 'checksum': 'f1052448f34e5dcbc419949283d4bbdc690f2776', 'backup': False, 'force': True, 'unsafe_writes': False, 'content': None, 'validate': None, 'directory_mode': None, 'remote_src': None, 'local_follow': None, 'owner': None, 'group': None, 'seuser': None, 'serole': None, 'selevel': None, 'setype': None, 'attributes': None}}, 'failed': False, 'item': {'command': '/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item', 'i': 2, 'ansible_index_var': 'i'})

TASK [Build an Ansible compatible image (new)] *********************************
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:8) 
skipping: [localhost] => (item=molecule_local/docker.io/pycontribs/centos:7) 
ok: [localhost] => (item=molecule_local/docker.io/pycontribs/ubuntu:latest)

TASK [Create docker network(s)] ************************************************

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item={'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
ok: [localhost] => (item={'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})
ok: [localhost] => (item={'command': '/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']})

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '670789110002.981815', 'results_file': '/home/vagrant/.ansible_async/670789110002.981815', 'changed': True, 'item': {'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:8', 'name': 'centos8', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item'})
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '310692179629.981843', 'results_file': '/home/vagrant/.ansible_async/310692179629.981843', 'changed': True, 'item': {'command': '/sbin/init', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True, 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item'})
FAILED - RETRYING: [localhost]: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': '285431903892.981882', 'results_file': '/home/vagrant/.ansible_async/285431903892.981882', 'changed': True, 'item': {'command': '/sbin/init', 'dockerfile': '../resources/Dockerfile.j2', 'image': 'docker.io/pycontribs/ubuntu:latest', 'name': 'ubuntu', 'privileged': True, 'volumes': ['/sys/fs/cgroup:/sys/fs/cgroup']}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=7    changed=3    unreachable=0    failed=0    skipped=2    rescued=0    ignored=0

INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [ubuntu]
ok: [centos8]
ok: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Create temp directory] *************************************
changed: [centos8]
changed: [centos7]
changed: [ubuntu]

TASK [vector-role : Get vector distrib] ****************************************
changed: [centos7]
changed: [ubuntu]
changed: [centos8]

TASK [vector-role : Create root directory] *************************************
changed: [centos7]
changed: [centos8]
changed: [ubuntu]

TASK [vector-role : Extract vector] ********************************************
changed: [ubuntu]
changed: [centos8]
changed: [centos7]

TASK [vector-role : Copy vector to bin with owner and permissions] *************
changed: [centos7]
changed: [ubuntu]
changed: [centos8]

TASK [vector-role : Configure vector.service from template] ********************
changed: [centos7]
changed: [ubuntu]
changed: [centos8]

TASK [vector-role : create config dir for vector] ******************************
changed: [centos7]
changed: [ubuntu]
changed: [centos8]

TASK [vector-role : Configure vector from template] ****************************
changed: [centos7]
changed: [ubuntu]
changed: [centos8]

TASK [vector-role : Create data directory] *************************************
changed: [centos7]
changed: [ubuntu]
changed: [centos8]

TASK [vector-role : Flush handlers] ********************************************

RUNNING HANDLER [vector-role : restarted vector service] ***********************
changed: [centos8]
changed: [ubuntu]
changed: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=11   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos8                    : ok=11   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=11   changed=10   unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > idempotence

PLAY [Converge] ****************************************************************

TASK [Include vector-role] *****************************************************

TASK [vector-role : Create temp directory] *************************************
ok: [centos8]
ok: [ubuntu]
ok: [centos7]

TASK [vector-role : Get vector distrib] ****************************************
ok: [centos7]
ok: [ubuntu]
ok: [centos8]

TASK [vector-role : Create root directory] *************************************
ok: [centos7]
ok: [centos8]
ok: [ubuntu]

TASK [vector-role : Extract vector] ********************************************
ok: [ubuntu]
ok: [centos8]
ok: [centos7]

TASK [vector-role : Copy vector to bin with owner and permissions] *************
ok: [ubuntu]
ok: [centos7]
ok: [centos8]

TASK [vector-role : Configure vector.service from template] ********************
ok: [centos7]
ok: [ubuntu]
ok: [centos8]

TASK [vector-role : create config dir for vector] ******************************
ok: [centos7]
ok: [centos8]
ok: [ubuntu]

TASK [vector-role : Configure vector from template] ****************************
ok: [centos7]
ok: [centos8]
ok: [ubuntu]

TASK [vector-role : Create data directory] *************************************
ok: [centos7]
ok: [ubuntu]
ok: [centos8]

TASK [vector-role : Flush handlers] ********************************************

PLAY RECAP *********************************************************************
centos7                    : ok=9    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos8                    : ok=9    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=9    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > verify
INFO     Running Ansible Verifier

PLAY [Preparation verify vector centos] ****************************************

TASK [install nc] **************************************************************
ok: [centos7]

PLAY [Preparation verify vector centos] ****************************************

TASK [prepare repo] ************************************************************
changed: [centos8]

TASK [install nc] **************************************************************
changed: [centos8]

PLAY [Preparation verify vector ubuntu] ****************************************

TASK [install nc] **************************************************************
changed: [ubuntu]

PLAY [Verify vector] ***********************************************************

TASK [Show facts available on the system] **************************************
ok: [centos7] => {
    "ansible_facts.distribution": "CentOS"
}
ok: [centos8] => {
    "ansible_facts.distribution": "CentOS"
}
ok: [ubuntu] => {
    "ansible_facts.distribution": "Ubuntu"
}

TASK [validate config vector] **************************************************
ok: [centos8]
ok: [ubuntu]
ok: [centos7]

TASK [Copy and Execute the script] *********************************************
ok: [centos7]
ok: [centos8]
ok: [ubuntu]

TASK [check work vector] *******************************************************
ok: [ubuntu]
ok: [centos8]
ok: [centos7]

TASK [set correct fact] ********************************************************
ok: [centos7]
ok: [centos8]
ok: [ubuntu]

TASK [Test message in file] ****************************************************
ok: [centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [centos8] => {
    "changed": false,
    "msg": "All assertions passed"
}
ok: [ubuntu] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos7                    : ok=7    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
centos8                    : ok=8    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
ubuntu                     : ok=7    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/hosts.yml linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/hosts
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/group_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/group_vars
INFO     Inventory /netology_data/HW08-ansible-05-testing/vector-role/molecule/default/../resources/inventory/host_vars/ linked to /home/vagrant/.cache/molecule/vector-role/default/inventory/host_vars
INFO     Running default > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item=centos8)
changed: [localhost] => (item=centos7)
changed: [localhost] => (item=ubuntu)

TASK [Delete docker networks(s)] ***********************************************

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory

```

</details>

5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.


[vector-role:1.1.0](https://github.com/alshelk/ansible-role-vector/tree/1.1.0)

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---